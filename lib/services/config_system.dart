import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ConfigSystem {
  static Future<String> getServer() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/server.txt');
      String text = await file.readAsString();
      return text;
    } catch (e) {
      print("New File");
      setServer('plugapi.nareubad.work');
      return 'plugapi.nareubad.work';
    }
  }

  static void setServer(String serverIP) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/server.txt');
    final text = serverIP;
    await file.writeAsString(text);
    print('saved');
  }
}
