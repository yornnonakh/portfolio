import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/page_content.dart';
import '../../../core/widgets/timeline_card.dart';
import '../../../core/widgets/timeline_entry.dart';
import '../../../data/models/portfolio.dart';
import '../../../data/portfolio_providers.dart';

class ExperienceScreen extends ConsumerWidget {
  const ExperienceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experience = ref.watch(experienceProvider);
    return _AnimatedExperienceTimeline(experience: experience);
  }
}

class _AnimatedExperienceTimeline extends StatefulWidget {
  const _AnimatedExperienceTimeline({required this.experience});

  final List<WorkExperience> experience;

  @override
  State<_AnimatedExperienceTimeline> createState() =>
      _AnimatedExperienceTimelineState();
}

class _AnimatedExperienceTimelineState
    extends State<_AnimatedExperienceTimeline>
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
    if (_reducedMotion) {
      _controller.value = 1;
      _flowController
        ..stop()
        ..value = 0;
    } else if (!_controller.isAnimating && !_controller.isCompleted) {
      _controller.forward();
    }
    if (!_reducedMotion && !_flowController.isAnimating) {
      _flowController.repeat(reverse: true);
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
        final count = widget.experience.length;
        final stagger = count <= 1 ? 0.0 : .18;
        return DetailPage(
          title: 'Experience',
          children: [
            for (var i = 0; i < count; i++)
              _TimelineEntry(
                experience: widget.experience[i],
                index: i,
                count: count,
                progress: _entryProgress(i, stagger),
                flow: _flowController,
              ),
          ],
        );
      },
    );
  }

  double _entryProgress(int index, double stagger) {
    if (_reducedMotion) return 1;
    final start = math.min(index * stagger, .48);
    final end = math.min(start + .58, 1.0);
    final interval = Interval(start, end, curve: Curves.easeOutCubic);
    return interval.transform(_controller.value);
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.experience,
    required this.index,
    required this.count,
    required this.progress,
    required this.flow,
  });
  final WorkExperience experience;
  final int index;
  final int count;
  final double progress;
  final Animation<double> flow;

  @override
  Widget build(BuildContext context) {
    final accent = switch (index % 4) {
      0 => AppColors.primary,
      1 => AppColors.blue,
      2 => AppColors.purple,
      _ => AppColors.coral,
    };
    return TimelineEntry(
      index: index,
      count: count,
      progress: progress,
      flow: flow,
      spacing: 22,
      label: experience.period,
      accent: accent,
      badge: experience.current ? 'ACTIVE' : null,
      child: Opacity(
        opacity: progress,
        child: Transform.translate(
          offset: Offset(0, 14 * (1 - progress)),
          child: TimelineCard(
            accent: accent,
            highlighted: experience.current,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            experience.role,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${experience.company} · ${experience.period}',
                            style: TextStyle(
                              color: accent,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.work_outline_rounded,
                      color: accent.withValues(alpha: .8),
                      size: 21,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  experience.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 18),
                TimelineTags(experience.technologies),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
