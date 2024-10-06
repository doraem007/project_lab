import 'networking.dart';

class Privilege {
  static Future<bool> canVerify(String username) async {
    NetworkHelper net = NetworkHelper('can_verify?Username=$username');
    var json = await net.getData();
    if (json != null && json['error'] == false) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> canApprove(String username) async {
    NetworkHelper net = NetworkHelper('can_approve?Username=$username');
    var json = await net.getData();
    if (json != null && json['error'] == false) {
      return true;
    } else {
      return false;
    }
  }
}
