import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/link_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/tag_chip.dart';
import '../../../data/models/portfolio.dart';
import '../../main/presentation/navigation_provider.dart';
import 'widgets/project_card.dart';

Future<void> showProjectDetails(
  BuildContext context,
  PortfolioProject project,
) {
  final theme = Theme.of(context);
  final brightness = theme.brightness;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.surfaceFor(brightness),
    barrierColor: Colors.black.withValues(alpha: .65),
    showDragHandle: true,
    constraints: const BoxConstraints(maxWidth: 640),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (_) => _ProjectDetails(project: project),
  );
}

class _ProjectDetails extends ConsumerWidget {
  const _ProjectDetails({required this.project});
  final PortfolioProject project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        26,
        0,
        26,
        28 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ProjectIcon(artwork: project.artwork, size: 60),
              const Spacer(),
              IconButton(
                tooltip: 'Close project details',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(project.name, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 6),
          Text(
            '${project.category.label} · ${project.status}',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 18),
          Text(
            project.description,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          TagList(project.technologies, compact: true),
          const SizedBox(height: 28),
          Text(
            'Thoughtfully built',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 14),
          for (final feature in project.features)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Icon(
                      Icons.check_circle_outline_rounded,
                      size: 18,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 14),
          if (project.url != null) ...[
            GradientButton(
              label: 'Visit project',
              icon: Icons.north_east_rounded,
              onPressed: () =>
                  openPortfolioLink(context, ref, Uri.parse(project.url!)),
            ),
            const SizedBox(height: 12),
          ],
          GradientButton(
            label: 'Discuss a similar project',
            icon: Icons.arrow_forward_rounded,
            outlined: project.url != null,
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(navigationProvider.notifier).select(MainTab.contact);
            },
          ),
        ],
      ),
    );
  }
}
