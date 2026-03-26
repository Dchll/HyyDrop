import 'package:auto_route/auto_route.dart';
import 'package:hyy_drop/core/router/app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: AppView.page, initial: true),
    AutoRoute(page: DevicesRoute.page),
    AutoRoute(page: LiveUpdateRoute.page),
    AutoRoute(page: SettingsRoute.page),
    AutoRoute(page: SettingsAboutRoute.page),
    AutoRoute(page: SettingsPackageInfoRoute.page),
    AutoRoute(page: SettingsDeviceInfoRoute.page),
  ];
}
