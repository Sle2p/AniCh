import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'danmaku_controller.dart';
import 'danmaku_geometry.dart';
import 'danmaku_stroke_text.dart';
import 'models/danmaku_item.dart';
import 'models/danmaku_option.dart';
import 'transition/position_item_view.dart';
import 'transition/scroll_item_view.dart';

class DanmakuView extends StatefulWidget {
  final Function(DanmakuController) createdController;
  final DanmakuOption option;
  final Function(bool)? statusChanged;
  const DanmakuView(
      {super.key,
      required this.createdController,
      required this.option,
      this.statusChanged});

  @override
  State<DanmakuView> createState() => _DanmakuViewState();
}

class _DanmakuViewState extends State<DanmakuView> {
  final Stopwatch _clock = Stopwatch();
  double get _runTime =>
      _clock.elapsedMicroseconds / Duration.microsecondsPerSecond;
  late final DanmakuController _controller;
  late DanmakuOption _option;
  final Map<String, Widget> _scrollWidgets = {};
  final Map<String, Widget> _positionWidgets = {};
  final Map<String, AnimationController> _controllers = {};
  final Set<String> _topIDs = {};
  final Set<String> _bottomIDs = {};
  List<RowInfo?> _scrollRows = [];
  List<double> _topOutTimes = [];
  List<double> _bottomOutTimes = [];
  Size _viewport = Size.zero;
  double _rowHeight = 0;
  bool _metricsDirty = true;

  @override
  void initState() {
    super.initState();
    _option = widget.option;
    _controller = DanmakuController(
        onAddItems: addItems,
        onUpdateOption: updateOption,
        onPause: pause,
        onResume: resume,
        onClear: clear);
    _controller.option = _option;
    widget.createdController(_controller);
    if (_controller.running) _clock.start();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Font fallback, inherited font family and text scale affect row metrics.
    _metricsDirty = true;
  }

  @override
  void dispose() {
    _clock.stop();
    clear(needSetState: false);
    super.dispose();
  }

  Size _measure(String text, {bool self = false}) =>
      DanmakuStrokeText.measure(context, text,
          fontSize: _option.fontSize,
          fontWeight: _option.fontWeight,
          fontHeight: _option.lineHeight,
          strokeWidth: _option.strokeWidth,
          border: _option.strokeText,
          self: self);

  void addItems(List<DanmakuItem> items) {
    if (!mounted || _metricsDirty || _viewport.isEmpty || _scrollRows.isEmpty) {
      return;
    }
    for (final item in items) {
      if (item.text.trim().isEmpty) continue;
      switch (item.type) {
        case DanmakuItemType.scroll:
          _addScroll(item);
        case DanmakuItemType.top:
        case DanmakuItemType.bottom:
          _addPosition(item);
      }
    }
    setState(() {});
  }

  void _registerController(String id, AnimationController controller) {
    _controllers[id] = controller;
  }

  void _addScroll(DanmakuItem item) {
    if (_option.hideScroll) return;
    final size = _measure(item.text, self: item.self);
    if (size.height > _viewport.height || size.width <= 0) return;
    final distance = _viewport.width + size.width;
    final duration = math.max(0.1, _option.duration);
    final info = RowInfo(
        distance: distance,
        joinTime: _runTime,
        outTime: _runTime + duration * size.width / distance,
        speed: distance / duration,
        width: size.width);
    var row = _scrollRows.indexWhere((last) =>
        last == null ||
        _runTime >= last.joinTime + duration * 0.1 ||
        _runTime > last.outTime);
    if (row < 0 && item.self) row = 0;
    if (row < 0 ||
        row * _rowHeight + size.height >
            _viewport.height * _option.area.clamp(0, 1)) {
      return;
    }
    _scrollRows[row] = info;
    final key = UniqueKey();
    final id = key.hashCode.toString();
    _scrollWidgets[id] = ScrollItemView(
      key: key,
      text: item.text,
      duration: duration,
      viewportWidth: _viewport.width,
      y: row * _rowHeight,
      size: size,
      color: item.color,
      fontSize: _option.fontSize,
      strokeWidth: _option.strokeWidth,
      fontWeight: _option.fontWeight,
      fontHeight: _option.lineHeight,
      border: _option.strokeText,
      self: item.self,
      playing: _controller.running,
      onComplete: onItemComplete,
      onCreated: (controller) => _registerController(id, controller),
    );
  }

  void _addPosition(DanmakuItem item) {
    final isTop = item.type == DanmakuItemType.top;
    if ((isTop && _option.hideTop) || (!isTop && _option.hideBottom)) return;
    final size = _measure(item.text, self: item.self);
    if (size.height > _viewport.height) return;
    final outTimes = isTop ? _topOutTimes : _bottomOutTimes;
    if (outTimes.isEmpty) return;
    var row = outTimes.indexWhere((time) => time <= _runTime);
    if (row < 0 && item.self) row = 0;
    if (row < 0) return;
    final offset = row * _rowHeight;
    if (offset + size.height > _viewport.height) return;
    outTimes[row] = _runTime + 5;
    final key = UniqueKey();
    final id = key.hashCode.toString();
    (isTop ? _topIDs : _bottomIDs).add(id);
    _positionWidgets[id] = PositionItemView(
      key: key,
      text: item.text,
      color: item.color,
      size: Size(math.min(size.width, _viewport.width), size.height),
      strokeWidth: _option.strokeWidth,
      fontSize: _option.fontSize,
      isTop: isTop,
      fontWeight: _option.fontWeight,
      fontHeight: _option.lineHeight,
      strokeText: _option.strokeText,
      playing: _controller.running,
      onComplete: onItemComplete,
      y: offset,
      self: item.self,
      onCreated: (controller) => _registerController(id, controller),
    );
  }

  void updateOption(DanmakuOption option) {
    if (!mounted) return;
    final geometryChanged = _option.fontSize != option.fontSize ||
        _option.fontWeight != option.fontWeight ||
        _option.lineHeight != option.lineHeight ||
        _option.strokeWidth != option.strokeWidth ||
        _option.strokeText != option.strokeText ||
        _option.area != option.area;
    if (geometryChanged) {
      clear(needSetState: false);
      _metricsDirty = true;
    } else {
      if (option.hideScroll) clearScroll(needSetState: false);
      if (option.hideTop) clearTop(needSetState: false);
      if (option.hideBottom) clearBottom(needSetState: false);
    }
    if (_option.duration != option.duration) {
      for (final id in _scrollWidgets.keys) {
        final controller = _controllers[id];
        controller?.duration = Duration(
            milliseconds: (math.max(0.1, option.duration) * 1000).round());
        if (_controller.running) controller?.forward();
      }
    }
    _option = option;
    _controller.option = option;
    setState(() {});
  }

  void pause() {
    for (final controller in _controllers.values) {
      controller.stop();
    }
    _controller.running = false;
    _clock.stop();
    widget.statusChanged?.call(false);
  }

  void resume() {
    for (final controller in _controllers.values) {
      controller.forward();
    }
    _controller.running = true;
    _clock.start();
    widget.statusChanged?.call(true);
  }

  void clear({bool needSetState = true}) {
    clearScroll(needSetState: false);
    clearTop(needSetState: false);
    clearBottom(needSetState: false);
    if (needSetState && mounted) setState(() {});
  }

  void clearScroll({bool needSetState = true}) {
    for (final id in _scrollWidgets.keys) {
      _controllers.remove(id);
    }
    _scrollWidgets.clear();
    _scrollRows.fillRange(0, _scrollRows.length, null);
    if (needSetState && mounted) setState(() {});
  }

  void _clearPosition(Set<String> ids, List<double> times) {
    for (final id in ids) {
      _positionWidgets.remove(id);
      _controllers.remove(id);
    }
    ids.clear();
    times.fillRange(0, times.length, 0);
  }

  void clearTop({bool needSetState = true}) {
    _clearPosition(_topIDs, _topOutTimes);
    if (needSetState && mounted) setState(() {});
  }

  void clearBottom({bool needSetState = true}) {
    _clearPosition(_bottomIDs, _bottomOutTimes);
    if (needSetState && mounted) setState(() {});
  }

  void onItemComplete(String id) {
    if (!mounted) return;
    _scrollWidgets.remove(id);
    _positionWidgets.remove(id);
    _controllers.remove(id);
    _topIDs.remove(id);
    _bottomIDs.remove(id);
    setState(() {});
  }

  void _updateViewport(Size viewport) {
    if (!_metricsDirty && viewport == _viewport) return;
    // Old animations contain old pixel coordinates. Recreate their rows when
    // leaving full screen, changing aspect ratio or changing font metrics.
    clear(needSetState: false);
    _viewport = viewport;
    _rowHeight = _measure('测试Ågjpq', self: true).height *
        math.max(1, _option.lineHeight);
    final rows = _rowHeight <= 0
        ? 0
        : (viewport.height * _option.area.clamp(0, 1) / _rowHeight).floor();
    _scrollRows = List<RowInfo?>.filled(rows, null);
    _topOutTimes = List<double>.filled((rows / 2).ceil(), 0);
    _bottomOutTimes = List<double>.filled((rows / 2).ceil(), 0);
    _metricsDirty = false;
  }

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        final safe = danmakuSafeRect(constraints.biggest);
        _updateViewport(safe.size);
        return ClipRect(
          clipBehavior: Clip.hardEdge,
          child: Stack(fit: StackFit.expand, children: [
            Positioned.fromRect(
                rect: safe,
                child: ClipRect(
                  clipBehavior: Clip.hardEdge,
                  child: Opacity(
                      opacity: _option.opacity.clamp(0, 1).toDouble(),
                      child: Stack(
                          fit: StackFit.expand,
                          clipBehavior: Clip.hardEdge,
                          children: [
                            ..._scrollWidgets.values,
                            ..._positionWidgets.values,
                          ])),
                )),
          ]),
        );
      });
}

class RowInfo {
  final double speed;
  final double joinTime;
  final double outTime;
  final double width;
  final double distance;
  RowInfo(
      {required this.distance,
      required this.joinTime,
      required this.outTime,
      required this.speed,
      required this.width});
}
