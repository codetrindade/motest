import 'package:moveme/base/base_view.dart';
import 'package:moveme/model/ride.dart';

abstract class AvailableTransportsView extends BaseView {
  void onListTransportsSuccess(List<Ride> result);
}