import 'package:moveme/base/base_http.dart';
import 'package:moveme/model/payment.dart';
import 'package:moveme/model/response_server.dart';

class ConfigService extends HttpBase {
  ConfigService(String token) : super(token);

  Future<List<Payment>> listPayments() async {
    return await get('common/payments')
        .then((data) => (data as List).map((i) => Payment.fromJson(i)).toList());
  }

  Future<ResponseServer> contact(subject, detail, phone, description) async {
    return await post('contact',
        '{"subject":"$subject","detail":"$detail","phone":"$phone","description":"$description"}')
        .then((map) => ResponseServer.fromJson(map));
  }
}