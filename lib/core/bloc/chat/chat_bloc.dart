import 'package:moveme/core/base/base_bloc.dart';
import 'package:moveme/core/bloc/app/app_event.dart';
import 'package:moveme/core/service/chat_service.dart';
import 'package:moveme/core/service/push_service.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/model/chat.dart';
import 'package:moveme/model/chat_message.dart';

class ChatBloc extends BaseBloc {
  List<Chat> chats = [];
  Chat conversation = Chat(messages: []);
  var chatService = locator.get<ChatService>();
  var pushService = locator.get<PushService>();
  bool listedAllOldMessages = false;
  bool isLoadingMessages = false;

  ChatBloc() {
    eventBus.on().listen((event) async {
      if (event is AppNewMessageEvent) {
        if (event.pushMessage.type == 'message') {
          if (conversation.id != null && event.pushMessage.id == conversation.id)
            await this.getNewMessages();
          else if (event.pushMessage.isBackground != null && event.pushMessage.isBackground) {
            await this.getChat(event.pushMessage.id, 'none');
          } else
            pushService.showNotification(event.pushMessage);
        }
      }

      if (event is CreateOrOpenNewChatEvent) {
        await this.getChat(event.id, event.type);
      }
    });
  }

  getChat(String id, String type) async {
    try {
      setLoading(true);
      navigationManager.navigateTo('/chat_page').then((value) async => await getChatList());
      conversation = await chatService.createOrGet(id, type);
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  getChatList() async {
    try {
      setLoading(true);
      chats = await chatService.listAll();
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  setConversation(Chat conversation) {
    if (conversation.type == 'ride')
      this.getChat(conversation.ridePassengerId, 'ride');
    else
      this.getChat(conversation.routeId, 'route');
  }

  getOldMessages() {
    if (conversation.messages.isEmpty || isLoadingMessages || listedAllOldMessages) return;
    isLoadingMessages = true;
    notifyListeners();
    chatService
        .getMoreMessages(conversation.id, false, conversation.messages.last.createdAt)
        .then((messages) {
      if (messages.isEmpty) listedAllOldMessages = true;
      conversation.messages.addAll(messages);
      isLoadingMessages = false;
      notifyListeners();
    }).catchError((e) {
      super.onError(e);
      isLoadingMessages = false;
      notifyListeners();
    });
  }

  getNewMessages() async {
    try {
      DateTime firstCreatedAt =
          isNullOrEmpty(conversation.messages) ? DateTime.now() : conversation.messages.first.createdAt;
      var messages = await chatService.getMoreMessages(conversation.id, true, firstCreatedAt);
      if (conversation.messages == null) conversation.messages = [];
      for (var msg in messages) conversation.messages.insert(0, msg);
      notifyListeners();
    } catch (e) {
      super.onError(e);
    }
  }

  chatPageDispose() {
    listedAllOldMessages = false;
    isLoadingMessages = false;
    conversation = Chat(messages: []);
  }

  createMessage(ChatMessage message) async {
    try {
      await chatService.createMessage(message);
    } catch (e) {
      super.onError(e);
    } finally {
      if (isNullOrEmpty(conversation.messages)) {
        var messages = await chatService.getMoreMessages(conversation.id, true,
            DateTime.now().add(Duration(minutes: -10)).toUtc().add(Duration(hours: -3)));
        if (conversation.messages == null) conversation.messages = [];
        for (var msg in messages) conversation.messages.insert(0, msg);
        notifyListeners();
      } else {
        this.getNewMessages();
      }
    }
  }
}
