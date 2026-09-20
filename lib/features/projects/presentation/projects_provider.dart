import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/portfolio.dart';
import '../../../data/portfolio_providers.dart';

final projectFilterProvider =
    NotifierProvider<ProjectFilterController, ProjectCategory>(
      ProjectFilterController.new,
    );

class ProjectFilterController extends Notifier<ProjectCategory> {
  @override
  ProjectCategory build() => ProjectCategory.all;

  void select(ProjectCategory category) => state = category;
}

final filteredProjectsProvider = Provider<List<PortfolioProject>>((ref) {
  final projects = ref.watch(projectsProvider);
  final category = ref.watch(projectFilterProvider);
  return category == ProjectCategory.all
      ? projects
      : projects
            .where((project) => project.category == category)
            .toList(growable: false);
});
