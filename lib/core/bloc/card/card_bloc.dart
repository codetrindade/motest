import 'package:moveme/core/base/app_exception.dart';
import 'package:moveme/core/base/base_bloc.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/model/card/card.dart';
import 'package:moveme/core/service/card_service.dart';
import 'package:juno_direct_checkout/juno_direct_checkout.dart';
import 'package:moveme/settings.dart';

class CardBloc extends BaseBloc {
  var paymentService = locator.get<CardService>();

  List<CardData> listCard = new List(0);

  Future<void> initialize() async {
    try {
      setLoading(true);
      listCard = await paymentService.listCard();
    } catch (error) {
      super.onError(error);
    } finally {
      setLoading(false);
    }
  }

  Future<void> addCard(CardData model) async {
    try {
      setLoading(true);
      await JunoDirectCheckout.init({"prod": Settings.junoProd, "public_token": Settings.junoKey});

      model.cardNumber = model.cardNumber.replaceAll(' ', '');

      try {
        model.cardToken = await JunoDirectCheckout.getCardHash({
          "prod": Settings.junoProd,
          "public_token": Settings.junoKey,
          "cardNumber": model.cardNumber,
          "holderName": model.holderName,
          "securityCode": model.cardCvv,
          "expirationMonth": model.cardValidate.split('/')[0],
          "expirationYear": model.cardValidate.split('/')[1]
        });
      } catch (ex) {
        throw new AppException(
            message: 'Não foi possível cadastrar seu cartão. Verifique os dados do seu cartão.', code: 400);
      }

      //print(token);
      model.cardNumber = model.cardNumber.substring(0, 4) + '****' + model.cardNumber.substring(12, 16);
      model.cardCvv = '';

      await paymentService.addCard(model);
      dialogService.showDialog('Sucesso', 'Cartão cadastrado com Sucesso.');
      navigationManager.goBack(param: true);
    } catch (error) {
      super.onError(error);
    } finally {
      setLoading(false);
    }
  }

  Future<CardData> getAddressByZipCode(String zipCode) async {
    try {
      if (zipCode.length != 9) {
        dialogService.showDialog('Atenção', 'Digite o CEP corretamente');
        return null;
      }
      setLoading(true);
      var a = await paymentService.getAddress(zipCode);
      setLoading(false);
      return a;
    } catch (error) {
      onError(error);
      return null;
    }
  }

  Future<void> removeCard(String id) async {
    try {
      setLoading(true);
      await paymentService.removeCard(id);
      await initialize();
    } catch (error) {
      super.onError(error);
    } finally {
      setLoading(false);
    }
  }
}
