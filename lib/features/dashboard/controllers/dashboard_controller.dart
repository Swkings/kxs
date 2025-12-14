import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_controller.g.dart';

enum DashboardTab {
  overview,
  pods,
  services,
  deployments,
  nodes,
  terminal,
}

@riverpod
class DashboardController extends _$DashboardController {
  @override
  DashboardTab build() {
    return DashboardTab.overview;
  }

  void setTab(DashboardTab tab) {
    state = tab;
  }
}
