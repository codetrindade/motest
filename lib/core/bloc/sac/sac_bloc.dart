import 'dart:convert';

import 'package:moveme/core/base/base_bloc.dart';
import 'package:moveme/core/bloc/app/app_data.dart';
import 'package:moveme/core/service/sac_service.dart';
import 'package:moveme/locator.dart';

class SacBloc extends BaseBloc {
  var appData = locator.get<AppData>();
  var service = locator.get<SacService>();

  Future<void> contact(String subject, String detail, String phone, String description) async {
    try {
      setLoading(true);
      var ticket = {
        "request": {
          "priority": "urgent",
          "via": {"channel": "app-cliente"},
          "requester": {"email": appData.user.email, "name": appData.user.name},
          "subject": subject,
          "comment": {"body": detail}
        }
      };

      var result = await service.createTicket(json.encode(ticket));
      if (result) {
        dialogService.showDialog('Sucesso', 'Sua mensagem foi enviada com sucesso.');
        navigationManager.goBack();
      }
    } catch (error) {
      super.onError(error);
    } finally {
      setLoading(false);
    }
  }
}
