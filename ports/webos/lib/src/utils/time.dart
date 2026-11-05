class Time {
  static String dateTimeFormat(int timestamp, {bool time = false}) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    final second = date.second.toString().padLeft(2, '0');
    if (time) {
      return '$year年$month月$day日 $hour:$minute:$second';
    } else {
      return '$year年$month月$day日';
    }
  }

  static String timeFormat(dynamic time) {
    // 1小时内
    if (time is String && time.contains(':')) {
      return time;
    }
    if (time < 3600) {
      if (time == 0) {
        return '00:00';
      }
      final int minute = time ~/ 60;
      final double res = time / 60;
      if (minute != res) {
        return '${minute < 10 ? '0$minute' : minute}:${(time - minute * 60) < 10 ? '0${(time - minute * 60)}' : (time - minute * 60)}';
      } else {
        return '$minute:00';
      }
    } else {
      final int hour = time ~/ 3600;
      final String hourStr = hour < 10 ? '0$hour' : hour.toString();
      var a = timeFormat(time - hour * 3600);
      return '$hourStr:$a';
    }
  }

  // 完全相对时间显示
  static String formatTimestampToRelativeTime(timeStamp) {
    var difference = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(timeStamp));

    if (difference.inDays > 365) {
      return '${difference.inDays ~/ 365}年前';
    } else if (difference.inDays > 30) {
      return '${difference.inDays ~/ 30}个月前';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }

  // 时间显示，刚刚，x分钟前
  static String dateFormat(timeStamp, {formatType = 'list'}) {
    if (timeStamp == 0 || timeStamp == null || timeStamp == '') {
      return '';
    }
    // 当前时间
    int time = (DateTime.now().millisecondsSinceEpoch).round();
    // 对比
    int distance = (time - timeStamp).toInt();
    // 当前年日期
    String currentYearStr = 'MM月DD日 hh:mm';
    String lastYearStr = 'YY年MM月DD日 hh:mm';
    if (formatType == 'detail') {
      currentYearStr = 'MM-DD hh:mm';
      lastYearStr = 'YY-MM-DD hh:mm';
      return customStampStr(
          timestamp: timeStamp,
          date: lastYearStr,
          toInt: false,
          formatType: formatType);
    }
    // debugPrint('distance: $distance');
    if (distance <= 60) {
      return '刚刚';
    } else if (distance <= 3600) {
      return '${(distance / 60).floor()}分钟前';
    } else if (distance <= 43200) {
      return '${(distance / 60 / 60).floor()}小时前';
    } else if (DateTime.fromMillisecondsSinceEpoch(time).year ==
        DateTime.fromMillisecondsSinceEpoch(timeStamp).year) {
      return customStampStr(
          timestamp: timeStamp,
          date: currentYearStr,
          toInt: false,
          formatType: formatType);
    } else {
      return customStampStr(
          timestamp: timeStamp,
          date: lastYearStr,
          toInt: false,
          formatType: formatType);
    }
  }

  // 时间戳转时间
  static String customStampStr(
      {int? timestamp, // 为空则显示当前时间
      String? date, // 显示格式，比如：'YY年MM月DD日 hh:mm:ss'
      bool toInt = true, // 去除0开头
      String? formatType}) {
    timestamp ??= (DateTime.now().millisecondsSinceEpoch).round();
    String timeStr =
        (DateTime.fromMillisecondsSinceEpoch(timestamp)).toString();

    dynamic dateArr = timeStr.split(' ')[0];
    dynamic timeArr = timeStr.split(' ')[1];

    String yY = dateArr.split('-')[0];
    String mM = dateArr.split('-')[1];
    String dD = dateArr.split('-')[2];

    String hh = timeArr.split(':')[0];
    String mm = timeArr.split(':')[1];
    String ss = timeArr.split(':')[2];

    ss = ss.split('.')[0];

    // 去除0开头
    if (toInt) {
      mM = (int.parse(mM)).toString();
      dD = (int.parse(dD)).toString();
      hh = (int.parse(hh)).toString();
      mm = (int.parse(mm)).toString();
    }

    if (date == null) {
      return timeStr;
    }

    // if (formatType == 'list' && int.parse(DD) > DateTime.now().day - 2) {
    //   return '昨天';
    // }

    date = date
        .replaceAll('YY', yY)
        .replaceAll('MM', mM)
        .replaceAll('DD', dD)
        .replaceAll('hh', hh)
        .replaceAll('mm', mm)
        .replaceAll('ss', ss);
    if (int.parse(yY) == DateTime.now().year &&
        int.parse(mM) == DateTime.now().month) {
      // 当天
      if (int.parse(dD) == DateTime.now().day) {
        // return '今天';
        return formatTimestampToRelativeTime(timestamp);
      }
    }
    return date;
  }
}
