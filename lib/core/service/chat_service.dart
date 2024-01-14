import 'package:moveme/core/base/base_service.dart';
import 'package:moveme/core/service/api_service.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/model/chat.dart';
import 'package:moveme/model/chat_message.dart';

class ChatService extends BaseService {
  Api _api;

  ChatService() {
    this._api = locator.get<Api>();
  }

  Future<Chat> createOrGet(String id, String type) async {
    return Chat.fromJson(getResponse(await _api.post('common/chat', '{"id":"$id","type":"$type"}')));
  }

  Future<Chat> createMessage(ChatMessage message) async {
    return Chat.fromJson(getResponse(await _api.post('common/chat/message', message.toString())));
  }

  Future<List<Chat>> listAll() async {
    var data = getResponse(await _api.post('common/chat/all', null));
    return (data as List).map((i) => new Chat.fromJson(i)).toList();
  }

  Future<List<ChatMessage>> getMoreMessages(String id, bool after, DateTime date) async {
    var data = getResponse(await _api.post(
        'common/chat/message/list-more', '{"id":"$id","after":${after.toString()},"date":"${date.toString()}"}'));
    return (data as List).map((i) => new ChatMessage.fromJson(i)).toList();
  }
}
