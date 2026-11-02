import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xs/src/widgets/multi_sliver_compat/multi_sliver_scroll_controller.dart';

typedef SliverCompatBuilder = Function(BuildContext, SliverCompat);

// ignore: must_be_immutable
class MultiSliverCompatWidget extends StatefulWidget {
  final SliverCompatBuilder childBuilder;
  late final bool isRoot;
  Key? debugKey;

  MultiSliverCompatWidget.asCommon(this.childBuilder,
      {super.key, this.debugKey}) {
    isRoot = false;
  }

  MultiSliverCompatWidget.asRoot(this.childBuilder,
      {super.key, this.debugKey}) {
    isRoot = true;
  }

  @override
  State<MultiSliverCompatWidget> createState() =>
      _MultiSliverCompatWidgetState();
}

typedef MultiSliverCompatDelegate = _MultiSliverCompatWidgetState;

class _MultiSliverCompatWidgetState extends State<MultiSliverCompatWidget> {
  late SliverCompat _sliverCompat;

  @override
  void initState() {
    super.initState();
    _sliverCompat =
        SliverCompat(context, widget.isRoot, debugKey: widget.debugKey);
  }

  @override
  Widget build(BuildContext context) {
    return widget.childBuilder(context, _sliverCompat);
  }

  static SliverCompat ofNotNull(BuildContext context) => context
      .findAncestorStateOfType<MultiSliverCompatDelegate>()!
      ._sliverCompat;
}

class SliverCompat {
  MultiSliverCompatScrollController? _majorScrollController;
  BuildContext buildContext;
  bool isRoot;
  Key? debugKey;

  SliverCompat(this.buildContext, this.isRoot, {this.debugKey});

  final HashMap<Key, MultiSliverCompatScrollController> _scrollPool = HashMap();

  ScrollController generateMajorController() {
    _majorScrollController ??=
        MultiSliverCompatScrollController.major(const Key('Major'), this);
    return _majorScrollController!;
  }

  ScrollController generateMinorController({required Key tag}) {
    if (_scrollPool[tag] != null) {
      return _scrollPool[tag]!;
    }
    MultiSliverCompatScrollController newController =
        MultiSliverCompatScrollController.minor(tag, this);
    _scrollPool[tag] = newController;
    return newController;
  }

  // 接收child提交的滚动量
  double submitUserOffset(
      MultiSliverCompatScrollPosition? submitter, double delta) {
    if (delta < 0) {
      return onScrollToTop(submitter, delta);
    } else {
      return onScrollToBottom(submitter, delta);
    }
  }

  MultiSliverCompatScrollPosition get _majorScrollPosition =>
      (_majorScrollController!.position as MajorScrollPosition);

  double onScrollToTop(
      MultiSliverCompatScrollPosition? submitter, double delta) {
    /// 向外传递
    double remaining = delta;
    if (!isRoot) {
      remaining = MultiSliverCompatDelegate.ofNotNull(buildContext)
          .onChildrenSubmit(delta);
      if (remaining == 0) {
        return 0;
      }
    }
    debugPrint('($debugKey)ToTop 组件间剩余:$remaining');

    /// 内部消化
    remaining = _majorScrollPosition.applyClampedDragUpdate(remaining);
    debugPrint('($debugKey)ToTop major消耗剩余:$remaining');
    if (remaining == 0) {
      return 0;
    }
    remaining = submitter?.applyClampedDragUpdate(remaining) ?? remaining;
    debugPrint('($debugKey)ToTop minor消耗剩余:$remaining,submitter:$submitter');

    return remaining;
  }

  double onScrollToBottom(
      MultiSliverCompatScrollPosition? submitter, double delta) {
    double remaining = delta;

    /// 向外传递
    if (!isRoot) {
      remaining = MultiSliverCompatDelegate.ofNotNull(buildContext)
          .onChildrenSubmit(delta);
      if (remaining == 0) {
        return 0;
      }
    }
    debugPrint('($debugKey)ToBottom 组件间剩余:$remaining');

    /// 内部消化
    remaining = submitter?.applyClampedDragUpdate(remaining) ?? remaining;
    debugPrint('($debugKey)ToBottom major消耗剩余:$remaining');
    if (remaining == 0) {
      return 0;
    }
    remaining = _majorScrollPosition.applyClampedDragUpdate(remaining);
    debugPrint('($debugKey)ToBottom minor消耗剩余:$remaining,submitter:$submitter');

    return remaining;
  }

  double onChildrenSubmit(double delta) {
    debugPrint('($debugKey)Receiver from Another layer 组件间剩余:$delta');
    return submitUserOffset(null, delta);
  }
}
