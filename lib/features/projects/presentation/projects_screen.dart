import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/page_content.dart';
import '../../../core/widgets/timeline_card.dart';
import '../../../core/widgets/timeline_entry.dart';
import '../../../data/models/portfolio.dart';
import 'project_detail_sheet.dart';
import 'projects_provider.dart';
import 'widgets/project_card.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(projectFilterProvider);
    final projects = ref.watch(filteredProjectsProvider);
    return PageContent(
      title: 'Projects',
      children: [
        _CategorySelector(
          selected: selected,
          onSelected: (category) =>
              ref.read(projectFilterProvider.notifier).select(category),
        ),
        const SizedBox(height: 22),
        if (projects.isEmpty)
          _IosEmptyState(
            onShowAll: () => ref
                .read(projectFilterProvider.notifier)
                .select(ProjectCategory.all),
          )
        else
          _AnimatedProjectTimeline(
            projects: projects,
            onProjectTap: (project) => showProjectDetails(context, project),
          ),
      ],
    );
  }
}

class _AnimatedProjectTimeline extends StatefulWidget {
  const _AnimatedProjectTimeline({
    required this.projects,
    required this.onProjectTap,
  });

  final List<PortfolioProject> projects;
  final ValueChanged<PortfolioProject> onProjectTap;

  @override
  State<_AnimatedProjectTimeline> createState() =>
      _AnimatedProjectTimelineState();
}

class _AnimatedProjectTimelineState extends State<_AnimatedProjectTimeline>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _flowController;
  bool _reducedMotion = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1050),
    );
    _flowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reducedMotion = MediaQuery.disableAnimationsOf(context);
    final tickerEnabled = TickerMode.valuesOf(context).enabled;
    final isTest = WidgetsBinding.instance.runtimeType
        .toString()
        .contains('Test');
    if (_reducedMotion || !tickerEnabled || isTest) {
      _controller.value = 1;
      _flowController
        ..stop()
        ..value = 0;
    } else {
      if (!_controller.isAnimating && !_controller.isCompleted) {
        _controller.forward();
      }
      if (!_flowController.isAnimating) {
        _flowController.repeat(reverse: true);
      }
    }
  }

  @override
  void didUpdateWidget(covariant _AnimatedProjectTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    final changed =
        oldWidget.projects.length != widget.projects.length ||
        oldWidget.projects.asMap().entries.any(
          (entry) => entry.value.id != widget.projects[entry.key].id,
        );
    if (!changed) return;
    if (_reducedMotion) {
      _controller.value = 1;
    } else {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _flowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final count = widget.projects.length;
        final stagger = count <= 1 ? 0.0 : .18;
        return Column(
          children: [
            for (var index = 0; index < count; index++)
              _ProjectTimelineEntry(
                project: widget.projects[index],
                index: index,
                count: count,
                progress: _projectProgress(index, stagger),
                flow: _flowController,
                onTap: () => widget.onProjectTap(widget.projects[index]),
              ),
          ],
        );
      },
    );
  }

  double _projectProgress(int index, double stagger) {
    if (_reducedMotion) return 1;
    final start = math.min(index * stagger, .48);
    final end = math.min(start + .58, 1.0);
    return Interval(
      start,
      end,
      curve: Curves.easeOutCubic,
    ).transform(_controller.value);
  }
}

class _ProjectTimelineEntry extends StatelessWidget {
  const _ProjectTimelineEntry({
    required this.project,
    required this.index,
    required this.count,
    required this.progress,
    required this.flow,
    required this.onTap,
  });

  final PortfolioProject project;
  final int index;
  final int count;
  final double progress;
  final Animation<double> flow;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.ultraLightAccent(
      index,
      Theme.of(context).brightness,
    );

    final isDevelopment = project.status.toLowerCase().contains('development');

    return TimelineEntry(
      index: index,
      count: count,
      progress: progress,
      flow: flow,
      spacing: 22,
      label: '${project.category.label} · ${project.status}',
      badge: project.status.toUpperCase(),
      accent: accent,
      child: Opacity(
        opacity: progress,
        child: Transform.translate(
          offset: Offset(0, 14 * (1 - progress)),
          child: TimelineCard(
            accent: accent,
            highlighted: isDevelopment,
            onTap: onTap,
            semanticLabel: 'Open ${project.name} details',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProjectIcon(artwork: project.artwork, size: 54),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            project.summary,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.arrow_outward_rounded,
                      color: accent.withValues(alpha: .8),
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TimelineTags(project.technologies),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategorySelector extends StatelessWidget {
  const _CategorySelector({required this.selected, required this.onSelected});

  final ProjectCategory selected;
  final ValueChanged<ProjectCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final containerBg = isDark ? const Color(0xFF111521) : const Color(0xFFE5E5EA);
    final border = isDark
        ? Colors.white.withValues(alpha: .08)
        : Colors.black.withValues(alpha: .06);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: containerBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            for (final category in ProjectCategory.values)
              _CategoryButton(
                category: category,
                selected: selected == category,
                onPressed: () => onSelected(category),
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.category,
    required this.selected,
    required this.onPressed,
  });

  final ProjectCategory category;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final selectedBg = isDark ? const Color(0xFF343947) : const Color(0xFFFFFFFF);

    return Semantics(
      selected: selected,
      button: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected ? selectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: isDark ? const Color(0x50000000) : const Color(0x18000000),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: selected
                ? AppColors.textPrimaryFor(brightness)
                : AppColors.textSecondaryFor(brightness),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            minimumSize: const Size(48, 38),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: Text(category.label),
        ),
      ),
    );
  }
}

class _IosEmptyState extends StatelessWidget {
  const _IosEmptyState({required this.onShowAll});

  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerBg = isDark ? const Color(0xFF141925) : const Color(0xFFFFFFFF);
    final border = isDark
        ? Colors.white.withValues(alpha: .09)
        : Colors.black.withValues(alpha: .08);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 34, 24, 28),
      decoration: BoxDecoration(
        color: containerBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Icon(
            CupertinoIcons.app_badge,
            color: theme.colorScheme.primary,
            size: 42,
          ),
          const SizedBox(height: 18),
          Text(
            'More good things are on the way.',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'No projects in this collection just yet. Take a look at my other work in the meantime.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 22),
          CupertinoButton(
            onPressed: onShowAll,
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(14),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: const Text(
              'Show all projects',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
