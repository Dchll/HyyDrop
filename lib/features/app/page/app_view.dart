import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hyy_drop/features/devices/presentation/devices_page.dart';

@RoutePage()
class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return const DevicesPage();
  }
}
