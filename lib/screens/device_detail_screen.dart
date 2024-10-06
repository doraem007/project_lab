import 'package:flutter/material.dart';
import '../services/networking.dart';
import '../global.dart'
    as globals;

class DeviceDetailScreen extends StatelessWidget {
  final int deviceId;

  const DeviceDetailScreen({Key? key, required this.deviceId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String apiUrl =
        'devices/$deviceId';

    return Scaffold(
      appBar: AppBar(
        title: Text('Device Details'),
        backgroundColor: Colors.pink.shade100,
      ),
      body: FutureBuilder(
        future:
            NetworkHelper(apiUrl).getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final deviceData = snapshot.data;

            // Check if deviceData is null
            if (deviceData == null) {
              return Center(child: Text('No data found.'));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Device Name: ${deviceData['device_name']}'),
                  Text('Current Value: ${deviceData['current_value']}'),
                  Text(
                      'Device Status: ${deviceData['device_status'] ? "Active" : "Inactive"}'),
                  Text('Firmware Version: ${deviceData['firmware_version']}'),
                  Text('Created At: ${deviceData['create_at']}'),
                  SizedBox(height: 20),
                  Text('Logs:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...deviceData['logs'].map<Widget>((log) {
                    return Text(
                        'Log ID: ${log['id']}, Value Watt: ${log['value_watt']}, Log At: ${log['log_at']}');
                  }).toList(),
                  SizedBox(height: 20),
                  Text('Details:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...deviceData['details'].map<Widget>((detail) {
                    return Text(
                        'Detail ID: ${detail['id']}, Channel ID: ${detail['channel_id']}, Channel Status: ${detail['channel_status']}, Location: ${detail['location']}');
                  }).toList(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
