import 'package:moveme/base/base_presenter.dart';
import 'package:moveme/model/address.dart';
import 'package:moveme/service/address_service.dart';
import 'package:moveme/service/injector_service.dart';
import 'package:moveme/view/favorite_places/create_favorite_place_view.dart';

class CreateFavoritePlacePresenter extends BasePresenter {
  CreateFavoritePlaceView _view;
  AddressService _addressService;

  CreateFavoritePlacePresenter(this._view) {
    super.view = _view;
    _addressService = new Injector().addressService;
  }

  void getAutoCompleteResults(Address address) {
    _addressService.getAutoCompleteResults(address)
        .then((data) => _view.onGetAutoCompleteResultsSuccess(data))
        .catchError((error) =>
        super.onError(error, (message) => _view.onError(message)));
  }

  void createFavoritePlace(Address address) {
    _addressService.createFavoritePlace(address)
        .then((data) => _view.onCreateFavoritePlaceSuccess(data))
        .catchError((error) => super.onError(error, (message) => _view.onError(message)));
  }

  void removeAddress(String id) {
    _addressService.removeAddress(id)
        .then((data) => _view.onRemoveSuccess(data))
        .catchError((error) =>
        super.onError(error, (message) => _view.onError(message)));
  }

}