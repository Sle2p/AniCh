import 'package:get_storage/get_storage.dart';
import 'package:xs/protobuf/account.pb.dart';

final box = GetStorage();

class AccountUtil {
  static String token() {
    final token = box.read('token');
    if (token != null) {
      final timestamp = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
      final key = token_(token: token, time: timestamp.toRadixString(16));
      return key.writeToBuffer().join(',');
    }
    return '';
  }
}
