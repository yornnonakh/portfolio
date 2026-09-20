import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/page_content.dart';
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
        Wrap(
          spacing: 9,
          runSpacing: 10,
          children: [
            for (final category in ProjectCategory.values)
              _CategoryButton(
                category: category,
                selected: selected == category,
                onPressed: () =>
                    ref.read(projectFilterProvider.notifier).select(category),
              ),
          ],
        ),
        const SizedBox(height: 22),
        if (projects.isEmpty)
          GlassCard(
            child: Column(
              children: [
                const SizedBox(height: 18),
                const Icon(
                  Icons.code_rounded,
                  color: AppColors.primary,
                  size: 36,
                ),
                const SizedBox(height: 18),
                Text(
                  'More good things are on the way.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                const Text(
                  'No projects in this collection just yet. Take a look at my other work in the meantime.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                GradientButton(
                  label: 'Show all projects',
                  onPressed: () => ref
                      .read(projectFilterProvider.notifier)
                      .select(ProjectCategory.all),
                ),
                const SizedBox(height: 12),
              ],
            ),
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
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _reducedMotion = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reducedMotion = MediaQuery.disableAnimationsOf(context);
    if (_reducedMotion) {
      _controller.value = 1;
    } else if (!_controller.isAnimating && !_controller.isCompleted) {
      _controller.forward();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final stagger = widget.projects.length <= 1 ? 0.0 : .16;
        return Column(
          children: [
            for (var index = 0; index < widget.projects.length; index++)
              _ProjectTimelineEntry(
                project: widget.projects[index],
                last: index == widget.projects.length - 1,
                progress: _projectProgress(index, stagger),
                direction: index.isEven ? 1 : -1,
                onTap: () => widget.onProjectTap(widget.projects[index]),
              ),
          ],
        );
      },
    );
  }

  double _projectProgress(int index, double stagger) {
    if (_reducedMotion) return 1;
    final start = math.min(index * stagger, .42);
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
    required this.last,
    required this.progress,
    required this.direction,
    required this.onTap,
  });

  final PortfolioProject project;
  final bool last;
  final double progress;
  final int direction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 16),
      child: Stack(
        children: [
          if (!last)
            Positioned(
              left: 12.25,
              top: 29,
              bottom: 5,
              width: 1.5,
              child: Align(
                alignment: Alignment.topCenter,
                child: FractionallySizedBox(
                  heightFactor: progress,
                  widthFactor: 1,
                  child: ColoredBox(color: Colors.white.withValues(alpha: .13)),
                ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 26,
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Transform.scale(
                    scale: .78 + (.22 * progress),
                    child: Opacity(
                      opacity: progress,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                          border: Border.all(
                            color: const Color(0xFF294C55),
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(
                                alpha: .28 * progress,
                              ),
                              blurRadius: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Opacity(
                  opacity: progress,
                  child: Transform.translate(
                    offset: Offset(0, direction * 16 * (1 - progress)),
                    child: ProjectCard(
                      project: project,
                      onTap: onTap,
                      revealProgress: progress,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    child: DecoratedBox(
      decoration: BoxDecoration(
        gradient: selected ? AppGradients.primary : null,
        color: selected ? null : Colors.white.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: selected ? Colors.transparent : AppColors.glassBorder,
        ),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: selected ? AppColors.ink : AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          minimumSize: const Size(48, 44),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(category.label),
      ),
    ),
  );
}
