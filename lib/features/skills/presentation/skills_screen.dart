import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/motion/app_motion.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/page_content.dart';
import '../../../core/widgets/staggered_reveal.dart';
import '../../../core/widgets/tag_chip.dart';
import '../../../data/models/portfolio.dart';
import '../../../data/portfolio_providers.dart';

class SkillsScreen extends ConsumerWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skills = ref.watch(skillsProvider);
    final otherSkills = ref.watch(otherSkillsProvider);
    return PageContent(
      title: 'Skills',
      children: [
        StaggeredReveal(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionHeading(title: 'Languages & Frameworks'),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 760 ? 4 : 2;
                const gap = 12.0;
                final width =
                    (constraints.maxWidth - (columns - 1) * gap) / columns;
                return Wrap(
                  spacing: gap,
                  runSpacing: 12,
                  children: [
                    for (var index = 0; index < skills.length; index++)
                      SizedBox(
                        width: width,
                        child: _SkillCard(skill: skills[index], index: index),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 36),
            const SectionHeading(title: 'Also Working With'),
            TagList(otherSkills),
          ],
        ),
      ],
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.skill, required this.index});
  final PortfolioSkill skill;
  final int index;

  @override
  Widget build(BuildContext context) {
    final color = switch (skill.tone) {
      SkillTone.mint => const Color(0xFF30D158),
      SkillTone.violet => const Color(0xFFBF5AF2),
      SkillTone.coral => const Color(0xFFFF9F0A),
      SkillTone.sky => const Color(0xFF64D2FF),
    };
    final percentage = '${(skill.proficiency * 100).round()}%';
    return Semantics(
      label: '${skill.name} proficiency',
      value: percentage,
      excludeSemantics: true,
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .16),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.code_rounded, color: color, size: 22),
            ),
            const SizedBox(height: 28),
            Text(skill.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              percentage,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: _AnimatedSkillProgress(
                value: skill.proficiency,
                color: color,
                index: index,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedSkillProgress extends StatefulWidget {
  const _AnimatedSkillProgress({
    required this.value,
    required this.color,
    required this.index,
  });

  final double value;
  final Color color;
  final int index;

  @override
  State<_AnimatedSkillProgress> createState() => _AnimatedSkillProgressState();
}

class _AnimatedSkillProgressState extends State<_AnimatedSkillProgress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _progress;
  bool _active = false;

  Duration get _totalDuration => Duration(
    milliseconds: AppMotion.skillProgress.inMilliseconds + (widget.index * 60),
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _totalDuration);
    _configureProgress();
  }

  void _configureProgress() {
    final delay = widget.index * 60 / _totalDuration.inMilliseconds;
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Interval(delay.clamp(0, .45), 1, curve: AppMotion.enterCurve),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotion();
  }

  @override
  void didUpdateWidget(covariant _AnimatedSkillProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _controller.duration = _totalDuration;
      _configureProgress();
    }
    if (oldWidget.value != widget.value && _active) {
      _controller.forward(from: 0);
    }
    _syncMotion();
  }

  void _syncMotion() {
    final motionEnabled = AppMotion.enabledOf(context);
    final visible = TickerMode.valuesOf(context).enabled;
    if (!motionEnabled) {
      _controller
        ..stop()
        ..value = 1;
      _active = false;
      return;
    }
    if (!visible) {
      _controller
        ..stop()
        ..value = 0;
      _active = false;
      return;
    }
    if (!_active) _controller.forward(from: 0);
    _active = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progress,
      builder: (context, child) => LinearProgressIndicator(
        value: widget.value * _progress.value,
        minHeight: 4,
        color: widget.color,
        backgroundColor: Colors.white.withValues(alpha: .08),
      ),
    );
  }
}
