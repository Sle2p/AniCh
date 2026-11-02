import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class ReplyNewDialog extends StatefulWidget {
  final String id;
  final String? parent;
  final String? reply;
  final Function(Map json) sendFn;

  const ReplyNewDialog(
      {super.key,
      required this.id,
      this.parent,
      this.reply,
      required this.sendFn});

  @override
  State<ReplyNewDialog> createState() => _ReplyNewDialogState();
}

class _ReplyNewDialogState extends State<ReplyNewDialog>
    with WidgetsBindingObserver {
  final TextEditingController _replyContentController = TextEditingController();
  final FocusNode replyContentFocusNode = FocusNode();
  final GlobalKey _formKey = GlobalKey<FormState>();
  late double emoteHeight = 0.0;
  double keyboardHeight = 0.0; // 键盘高度
  final _debouncer = Debouncer(milliseconds: 200); // 设置延迟时间
  String toolbarType = 'input';

  @override
  void initState() {
    super.initState();
    // 监听输入框聚焦
    // replyContentFocusNode.addListener(_onFocus);
    // 界面观察者 必须
    WidgetsBinding.instance.addObserver(this);
    // 自动聚焦
    _autoFocus();
    // 监听聚焦状态
    _focuslistener();
  }

  _autoFocus() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (context.mounted) {
      // ignore: use_build_context_synchronously
      FocusScope.of(context).requestFocus(replyContentFocusNode);
    }
  }

  _focuslistener() {
    replyContentFocusNode.addListener(() {
      if (replyContentFocusNode.hasFocus) {
        setState(() {
          toolbarType = 'input';
        });
      }
    });
  }

  Future submitReplyAdd() async {
    String message = _replyContentController.text;
    if (message.length > 1000) {
      SmartDialog.showToast('已超过限制字数: ${message.length} / 1000');
      return;
    }
    if (message.isEmpty) return;

    final json = {
      'id': widget.id,
      'parent': widget.parent,
      'reply': widget.reply,
      'contents': [
        {'content': "​$message\n", 'type': 'text'}
      ]
    };
    widget.sendFn.call(json);
    debugPrint(json.toString());
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final String routePath = Get.currentRoute;
    if (mounted && (routePath.startsWith('/vod'))) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 键盘高度
        final viewInsets = EdgeInsets.fromViewPadding(
            View.of(context).viewInsets, View.of(context).devicePixelRatio);
        _debouncer.run(() {
          if (mounted) {
            if (keyboardHeight == 0 && emoteHeight == 0) {
              setState(() {
                emoteHeight = keyboardHeight =
                    keyboardHeight == 0.0 ? viewInsets.bottom : keyboardHeight;
              });
            }
          }
        });
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _replyContentController.dispose();
    replyContentFocusNode.removeListener(() {});
    replyContentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double keyboardHeight = EdgeInsets.fromViewPadding(
            View.of(context).viewInsets, View.of(context).devicePixelRatio)
        .bottom;
    debugPrint('_keyboardHeight: $keyboardHeight');
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 200,
              minHeight: 120,
            ),
            child: Container(
              padding: const EdgeInsets.only(
                  top: 12, right: 15, left: 15, bottom: 10),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextField(
                    controller: _replyContentController,
                    minLines: 1,
                    maxLines: null,
                    autofocus: false,
                    focusNode: replyContentFocusNode,
                    decoration: const InputDecoration(
                        hintText: '输入内容',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 14,
                        )),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).dividerColor.withOpacity(0.1),
          ),
          Container(
            height: 52,
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                TextButton(
                    onPressed: () {
                      submitReplyAdd();
                    },
                    child: const Text('发送'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

typedef DebounceCallback = void Function();

class Debouncer {
  DebounceCallback? callback;
  final int? milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds});

  run(DebounceCallback callback) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds!), () {
      callback();
    });
  }
}
