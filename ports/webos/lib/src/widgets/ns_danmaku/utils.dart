import 'models/danmaku_item.dart';

class DanmakuUtils {
  static DanmakuItemType getPosition(int mode) {
    DanmakuItemType type = DanmakuItemType.scroll;
    if (mode == 3) {
      type = DanmakuItemType.bottom;
    } else if (mode == 2) {
      type = DanmakuItemType.top;
    } else {
      type = DanmakuItemType.scroll;
    }
    return type;
  }

  static DanmakuItemType getBilibiliPosition(int mode) {
    DanmakuItemType type = DanmakuItemType.scroll;
    if (mode >= 1 && mode <= 3) {
      type = DanmakuItemType.scroll;
    } else if (mode == 4) {
      type = DanmakuItemType.bottom;
    } else if (mode == 5) {
      type = DanmakuItemType.top;
    }
    return type;
  }

  static DanmakuItemType getQQPosition(int mode) {
    DanmakuItemType type = DanmakuItemType.scroll;
    if (mode > 1) {
      type = DanmakuItemType.top;
    } else {
      type = DanmakuItemType.scroll;
    }
    return type;
  }
}
