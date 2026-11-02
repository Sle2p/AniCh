import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  Widget child;
  @override
  double maxExtent;
  @override
  double minExtent;

  final Function(double)? onMaxOffset;
  final Function(double)? onMinOffset;

  CustomSliverPersistentHeaderDelegate(
      {required this.child,
      this.maxExtent = 50,
      this.minExtent = 50,
      this.onMaxOffset,
      this.onMinOffset});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    maxOffset(shrinkOffset / maxExtent);
    maxOffset(shrinkOffset / minExtent);
    return child;
  }

  void maxOffset(double offset) {
    onMaxOffset?.call(offset);
  }

  void minOffset(double offset) {
    onMinOffset?.call(offset);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
