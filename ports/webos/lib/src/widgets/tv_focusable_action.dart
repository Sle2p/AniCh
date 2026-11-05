import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Adds remote control navigation to an existing pointer-operated control.
/// Nested InkWells keep their pointer handlers, but form one remote focus stop.
class TvFocusableAction extends StatefulWidget {
  const TvFocusableAction({
    super.key,
    required this.child,
    required this.onTap,
    this.onActivate,
    this.autofocus = false,
    this.focusEnabled = true,
    this.label,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  static const isTV = bool.fromEnvironment('ANICH_WEBOS', defaultValue: false);

  final Widget child;
  final VoidCallback onTap;
  final VoidCallback? onActivate;
  final bool autofocus;
  final bool focusEnabled;
  final String? label;
  final BorderRadius borderRadius;

  @override
  State<TvFocusableAction> createState() => _TvFocusableActionState();
}

class _TvFocusableActionState extends State<TvFocusableAction> {
  final FocusNode _focusNode = FocusNode();
  bool _focused = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged(bool focused) {
    setState(() => _focused = focused);
    if (focused) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_focusNode.hasPrimaryFocus) return;
        // Reveal only clipped content. Explicit alignment would recenter even
        // a visible card, then repeat that movement in every outer scrollable.
        // showOnScreen keeps visible cards in place and still reveals an
        // offscreen autofocus target at the nearest edge of its viewport.
        final target = context.findRenderObject();
        if (target == null || !target.attached) return;
        target.showOnScreen(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
        );
      });
    }
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    final key = event.logicalKey;
    final activate =
        key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        key == LogicalKeyboardKey.select ||
        key == LogicalKeyboardKey.space;
    if (activate) {
      // Holding OK must not open the same route repeatedly.
      if (event is KeyDownEvent) (widget.onActivate ?? widget.onTap)();
      return KeyEventResult.handled;
    }
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final direction = <LogicalKeyboardKey, TraversalDirection>{
      LogicalKeyboardKey.arrowUp: TraversalDirection.up,
      LogicalKeyboardKey.arrowDown: TraversalDirection.down,
      LogicalKeyboardKey.arrowLeft: TraversalDirection.left,
      LogicalKeyboardKey.arrowRight: TraversalDirection.right,
    }[key];
    if (direction == null) return KeyEventResult.ignored;
    FocusScope.of(context).focusInDirection(direction);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    if (!TvFocusableAction.isTV) {
      return GestureDetector(onTap: widget.onTap, child: widget.child);
    }
    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      canRequestFocus: widget.focusEnabled,
      skipTraversal: !widget.focusEnabled,
      onFocusChange: _onFocusChanged,
      onKeyEvent: _onKeyEvent,
      child: Semantics(
        label: widget.label,
        button: true,
        focused: _focused,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (widget.focusEnabled) _focusNode.requestFocus();
              widget.onTap();
            },
            child: ExcludeFocus(
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  widget.child,
                  if (_focused)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: widget.borderRadius,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tab controls with one visible remote focus stop per tab on webOS.
class TvTabBar extends StatelessWidget {
  const TvTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.autofocus = false,
    this.tabAlignment = TabAlignment.start,
    this.isScrollable = true,
    this.indicatorSize = TabBarIndicatorSize.label,
    this.dividerColor,
    this.labelPadding,
  });

  final TabController controller;
  final List<Widget> tabs;
  final bool autofocus;
  final TabAlignment tabAlignment;
  final bool isScrollable;
  final TabBarIndicatorSize indicatorSize;
  final Color? dividerColor;
  final EdgeInsetsGeometry? labelPadding;

  @override
  Widget build(BuildContext context) {
    if (!TvFocusableAction.isTV) {
      return TabBar(
        controller: controller,
        tabs: tabs,
        tabAlignment: tabAlignment,
        isScrollable: isScrollable,
        indicatorSize: indicatorSize,
        dividerColor: dividerColor,
        labelPadding: labelPadding,
      );
    }
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(tabs.length, (index) {
            final selected = index == controller.index;
            return TvFocusableAction(
              autofocus: autofocus && selected,
              onTap: () => controller.animateTo(index),
              child: Container(
                constraints: const BoxConstraints(minWidth: 88, minHeight: 40),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                child: DefaultTextStyle.merge(
                  style: TextStyle(
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                  child: tabs[index],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
