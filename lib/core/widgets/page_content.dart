import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'glass_background.dart';

/// Shared spacing and scrolling for primary and pushed pages.
class PageContent extends StatelessWidget {
  const PageContent({
    super.key,
    required this.title,
    required this.children,
    this.trailing,
    this.backLabel,
    this.maxWidth = 1080,
  });

  final String title;
  final List<Widget> children;
  final Widget? trailing;
  final String? backLabel;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    return SingleChildScrollView(
      key: PageStorageKey(title),
      padding: EdgeInsets.fromLTRB(
        wide ? 48 : 24,
        wide ? 34 : 24,
        wide ? 48 : 24,
        wide || backLabel != null ? 40 : 132,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (backLabel != null) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 17,
                    ),
                    label: Text(backLabel!),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 12),
                    trailing!,
                  ],
                ],
              ),
              const SizedBox(height: 28),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassBackground(
        child: SafeArea(
          child: PageContent(
            title: title,
            backLabel: 'Home',
            maxWidth: 760,
            children: children,
          ),
        ),
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          if (action != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.only(left: 12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(action!),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right_rounded, size: 20),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
