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
    final horizontalInset = wide ? 48.0 : 24.0;
    const toolbarHeight = 64.0;
    final expandedHeight = wide ? 118.0 : 110.0;
    return CustomScrollView(
      key: PageStorageKey(title),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverAppBar(
          primary: false,
          pinned: true,
          automaticallyImplyLeading: false,
          centerTitle: false,
          toolbarHeight: toolbarHeight,
          expandedHeight: expandedHeight,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          leadingWidth: backLabel == null ? 0 : 104,
          leading: backLabel == null
              ? null
              : TextButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 15),
                  label: Text(backLabel!),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                  ),
                ),
          actions: [
            if (trailing != null) ...[
              trailing!,
              SizedBox(width: wide ? 48 : 16),
            ],
          ],
          flexibleSpace: LayoutBuilder(
            builder: (context, constraints) {
              final expanded =
                  ((constraints.maxHeight - toolbarHeight) /
                          (expandedHeight - toolbarHeight))
                      .clamp(0.0, 1.0);
              return Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  horizontalInset * expanded,
                  0,
                  horizontalInset * expanded,
                  16,
                ),
                child: Align(
                  alignment: Alignment.lerp(
                    Alignment.bottomCenter,
                    Alignment.bottomLeft,
                    expanded,
                  )!,
                  child: Transform.scale(
                    scale: 1 + (.7 * expanded),
                    alignment: Alignment.bottomLeft,
                    child: Semantics(
                      header: true,
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -.8,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalInset,
            24,
            horizontalInset,
            wide || backLabel != null ? 40 : 132,
          ),
          sliver: SliverToBoxAdapter(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
            ),
          ),
        ),
      ],
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 18,
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
