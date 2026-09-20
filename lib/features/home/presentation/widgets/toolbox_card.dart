import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../data/portfolio_providers.dart';

class ToolboxCard extends ConsumerWidget {
  const ToolboxCard({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skills = ref
        .watch(skillsProvider)
        .where((skill) => skill.name == 'Flutter' || skill.name == 'Riverpod')
        .toList();
    return GlassCard(
      padding: EdgeInsets.all(compact ? 12 : 18),
      borderRadius: compact ? 17 : 22,
      child: Column(
        children: [
          for (var i = 0; i < skills.length; i++) ...[
            if (i > 0) SizedBox(height: compact ? 10 : 16),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(compact ? 6 : 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .07),
                    borderRadius: BorderRadius.circular(compact ? 8 : 10),
                  ),
                  child: Icon(
                    i == 0 ? Icons.code_rounded : Icons.hub_outlined,
                    color: AppColors.primary,
                    size: compact ? 14 : 18,
                  ),
                ),
                SizedBox(width: compact ? 8 : 12),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            skills[i].name,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: compact ? 13 : 14,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${(skills[i].proficiency * 100).round()}%',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(height: compact ? 5 : 7),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: SizedBox(
                          height: compact ? 3 : 4,
                          child: LayoutBuilder(
                            builder: (context, constraints) => Stack(
                              children: [
                                Container(
                                  color: Colors.white.withValues(alpha: .09),
                                ),
                                Container(
                                  width:
                                      constraints.maxWidth *
                                      skills[i].proficiency,
                                  decoration: const BoxDecoration(
                                    gradient: AppGradients.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
