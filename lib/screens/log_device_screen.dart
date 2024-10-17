import 'package:flutter/material.dart';
import '../global.dart' as globals; // Import your global library
import '../services/networking.dart'; // Import your NetworkHelper

class LogDeviceScreen extends StatefulWidget {
  @override
  _LogDeviceScreenState createState() => _LogDeviceScreenState();
}

class _LogDeviceScreenState extends State<LogDeviceScreen> {
  List<dynamic> logs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLogs();
  }

  Future<void> fetchLogs() async {
  // Fetch the devices associated with the user
  final deviceNetworkHelper = NetworkHelper('user/${globals.memberID}');
  final deviceResponse = await deviceNetworkHelper.getData();

  // ตรวจสอบว่า deviceResponse เป็น Map และมี devices
  if (deviceResponse is Map<String, dynamic> && deviceResponse.containsKey('devices')) {
    List<dynamic> devices = deviceResponse['devices'];
    List<dynamic> allLogs = [];

    // สร้างรายชื่อ logs จาก devices
    for (var device in devices) {
      if (device is Map<String, dynamic> && device.containsKey('id')) {
        final deviceId = device['id'];
        final logNetworkHelper = NetworkHelper('devices_logs/$deviceId');
        final logResponse = await logNetworkHelper.getData();

        // ตรวจสอบ logResponse ว่าเป็น Map และตรวจสอบ error
        if (logResponse is Map<String, dynamic> && logResponse['error'] == true) {
          print(logResponse['message']);
          continue;
        }

        // ตรวจสอบว่า 'logs' มีอยู่ใน logResponse
        if (logResponse is Map<String, dynamic> && logResponse.containsKey('logs') && logResponse['logs'] is List) {
          allLogs.addAll(logResponse['logs'] as List<Map<String, dynamic>>); // แสดง logs ที่ดึงมา
        } else if (logResponse is List) { // รองรับกรณีที่ logResponse เป็น List
          print("Warning: Log response is a list instead of a map. Attempting to process as logs directly.");
          allLogs.addAll(logResponse.cast<Map<String, dynamic>>()); // ใช้ cast เพื่อให้แน่ใจว่าเป็น List<Map>
        } else {
          print("Error: Logs not found in response for device ID: $deviceId");
        }
      }
    }

    // Update the state with all logs
    print("Fetched logs: $allLogs"); // แสดง logs ที่ดึงมา
    setState(() {
      logs = allLogs;
      isLoading = false;
    });
  } else if (deviceResponse is List) {
    // Handle case where deviceResponse is a List
    print("Error: Device response is a list. Expected a map with devices key.");
    setState(() {
      isLoading = false;
    });
  } else {
    print("Error: Device response is not a valid format");
    setState(() {
      isLoading = false;
    });
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : logs.isEmpty
              ? Center(child: Text("No logs available"))
              : ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 4,
                      child: ListTile(
                        title: Text("Log ID: ${log['id']}"),
                        subtitle: Text(
                            "Value: ${log['value'] ?? 'N/A'}"), // ตรวจสอบค่า
                        trailing: Text(log['log_at'] ??
                            "Unknown"), // ใช้ ?? เพื่อตรวจสอบค่าว่าง
                      ),
                    );
                  },
                ),
    );
  }
}
