import 'package:moveme/base/base_view.dart';
import 'package:moveme/model/preview.dart';
import 'package:moveme/model/routeobj.dart';

abstract class TripDriversView extends BaseView {
void onGetPreviewSuccess(Preview preview);

void onCreateRouteSuccess(RouteObj route);

void onCreateRouteError(String message);
}