import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MainTab {
  home('Home'),
  project('Project'),
  skill('Skill'),
  contact('Contact');

  const MainTab(this.label);
  final String label;
}

final navigationProvider = NotifierProvider<NavigationController, MainTab>(
  NavigationController.new,
);

class NavigationController extends Notifier<MainTab> {
  @override
  MainTab build() => MainTab.home;

  void select(MainTab tab) => state = tab;
}
