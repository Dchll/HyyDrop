import 'package:auto_route/auto_route.dart';
import 'package:hyy_drop/core/router/app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {

  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeShowcaseRoute.page, initial: true),
  ];
}
