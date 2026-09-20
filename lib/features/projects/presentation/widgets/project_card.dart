import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/reveal_text.dart';
import '../../../../core/widgets/tag_chip.dart';
import '../../../../data/models/portfolio.dart';

class ProjectIcon extends StatelessWidget {
  const ProjectIcon({super.key, required this.artwork, this.size = 56});
  final ProjectArtwork artwork;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      gradient: artwork == ProjectArtwork.notes
          ? AppGradients.mint
          : AppGradients.violet,
      borderRadius: BorderRadius.circular(size * .3),
    ),
    child: Icon(
      artwork == ProjectArtwork.notes
          ? CupertinoIcons.layers
          : CupertinoIcons.square_grid_2x2,
      color: AppColors.ink,
      size: size * .4,
    ),
  );
}

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    this.compact = false,
    this.revealProgress,
  });
  final PortfolioProject project;
  final VoidCallback onTap;
  final bool compact;
  final double? revealProgress;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      semanticLabel: 'View ${project.name} details',
      padding: EdgeInsets.all(compact ? 17 : 20),
      child: compact
          ? Row(
              children: [
                ProjectIcon(artwork: project.artwork, size: 52),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        project.summary,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 23,
                  color: AppColors.textSecondary,
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ProjectIcon(artwork: project.artwork),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TagChip(project.status, compact: true),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                revealProgress == null
                    ? Text(
                        project.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      )
                    : RevealText(
                        text: project.name,
                        progress: revealProgress!,
                        style: Theme.of(context).textTheme.titleLarge!,
                      ),
                const SizedBox(height: 5),
                Text(
                  '${project.description.split('. ').first}.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 18),
                TagList(project.technologies, compact: true),
              ],
            ),
    );
  }
}
