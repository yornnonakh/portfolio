import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'glass_background.dart';
import 'theme_toggle_button.dart';

/// Shared spacing and scrolling for primary and pushed pages.
class PageContent extends StatefulWidget {
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
  State<PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<PageContent> {
  double _scrollOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topPadding = MediaQuery.paddingOf(context).top;
    final horizontalInset = wide ? 48.0 : 24.0;
    const toolbarHeight = 64.0;
    final expandedHeight = wide ? 118.0 : 110.0;

    // Top blue glow expanding on scroll/overscroll at top full screen
    final topGlowHeight =
        (180.0 + topPadding - _scrollOffset * 0.9).clamp(0.0, 360.0);
    final topGlowOpacity = _scrollOffset <= 0
        ? 1.0
        : (1.0 - (_scrollOffset / 120.0)).clamp(0.2, 1.0);

    return Stack(
      children: [
        // iOS-style top scroll blue glow spanning full screen edge
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: topGlowHeight,
          child: IgnorePointer(
            child: Opacity(
              opacity: topGlowOpacity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      isDark
                          ? const Color(0xFF0A84FF).withValues(alpha: .45)
                          : const Color(0xFF007AFF).withValues(alpha: .38),
                      isDark
                          ? const Color(0xFF0A84FF).withValues(alpha: .20)
                          : const Color(0xFF007AFF).withValues(alpha: .15),
                      isDark
                          ? const Color(0xFF0A84FF).withValues(alpha: 0)
                          : const Color(0xFF007AFF).withValues(alpha: 0),
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ),
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.axis == Axis.vertical) {
              setState(() {
                _scrollOffset = notification.metrics.pixels;
              });
            }
            return false;
          },
          child: CustomScrollView(
            key: PageStorageKey(widget.title),
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverAppBar(
                primary: true,
                pinned: true,
                automaticallyImplyLeading: false,
                centerTitle: false,
                toolbarHeight: toolbarHeight,
                expandedHeight: expandedHeight,
                elevation: 0,
                scrolledUnderElevation: 0,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                leadingWidth: widget.backLabel == null ? 0 : 104,
                leading: widget.backLabel == null
                    ? null
                    : TextButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 15,
                        ),
                        label: Text(widget.backLabel!),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(left: 12, right: 8),
                        ),
                      ),
                actions: [
                  if (widget.trailing != null) widget.trailing!,
                  const SizedBox(width: 8),
                  const ThemeToggleButton(compact: true),
                  SizedBox(width: wide ? 48 : 16),
                ],
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    final currentExtent =
                        (constraints.maxHeight - topPadding).clamp(
                      toolbarHeight,
                      expandedHeight,
                    );
                    final expanded =
                        ((currentExtent - toolbarHeight) /
                                (expandedHeight - toolbarHeight))
                            .clamp(0.0, 1.0);
                    return Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        horizontalInset * expanded,
                        topPadding,
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
                              widget.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -.8,
                                color: Theme.of(context).colorScheme.onSurface,
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
                  wide || widget.backLabel != null ? 40 : 180,
                ),
                sliver: SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: widget.maxWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: widget.children,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
        child: PageContent(
          title: title,
          backLabel: 'Home',
          maxWidth: 760,
          children: children,
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
                  color: AppColors.textSecondaryFor(
                    Theme.of(context).brightness,
                  ),
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
