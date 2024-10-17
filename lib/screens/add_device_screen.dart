import 'package:flutter/material.dart';
import '../services/networking.dart'; // Ensure the correct path for NetworkHelper

class AddDeviceScreen extends StatefulWidget {
  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _formKey = GlobalKey<FormState>();
  String deviceName = '';
  String location = '';
  double currentValue = 0;
  String serial_number = '';
  bool alertStatus = true;
  bool deviceStatus = true; // default value
  String firmwareVersion = '';
  int userId = 2; // Assuming a fixed user ID, modify as needed

  Future<void> _addDevice() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> deviceData = {
        "value_controller_id": 1, // Assuming this is static for your case
        "device_name": deviceName,
        "current_value": currentValue,
        "serial_number": serial_number,
        "device_status": deviceStatus,
        "alert_status": alertStatus,
        "firmware_version": firmwareVersion,
        "location": location,
        "user_id": userId,
      };

      NetworkHelper networkHelper =
          NetworkHelper('devices/'); // Adjust endpoint as necessary
      final response = await networkHelper.postData(deviceData);

      if (response.containsKey('error')) {
        // Handle the error accordingly
        print('Error: ${response['error']}');
      } else {
        // Device added successfully, show a success message or navigate back
        _showSuccessDialog();
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('สำเร็จ'), // "Success" in Thai
          content: Text(
              'เพิ่มอุปกรณ์สำเร็จ!'), // "Device added successfully!" in Thai
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context); // Close the AddDeviceScreen
              },
              child: Text('ตกลง'), // "OK" in Thai
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มอุปกรณ์'), // "Add Device" in Thai
        backgroundColor: Colors.pink.shade100,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.green),
            onPressed: _addDevice,
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Wrap the body in a SingleChildScrollView
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ชื่ออุปกรณ์:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText:
                      'กรุณาใส่ชื่ออุปกรณ์', // "Please enter device name" in Thai
                ),
                onChanged: (value) {
                  deviceName = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาใส่ชื่ออุปกรณ์'; // "Please enter device name" in Thai
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text('ตำแหน่ง:', style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText:
                      'กรุณาใส่ตำแหน่ง', // "Please enter location" in Thai
                ),
                onChanged: (value) {
                  location = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาใส่ตำแหน่ง'; // "Please enter location" in Thai
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text('หมายเลข S/N เครื่อง:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText:
                      'กรุณาใส่หมายเลข S/N เครื่อง', // "Please enter firmware version" in Thai
                ),
                onChanged: (value) {
                  serial_number = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาใส่หมายเลข S/N เครื่อง'; // "Please enter firmware version" in Thai
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text('สถานะการแจ้งเตือนอุปกรณ์:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SwitchListTile(
                title: Text(alertStatus
                    ? 'เปิดใช้งาน'
                    : 'ปิดใช้งาน'), // "Enabled" or "Disabled" in Thai
                value: alertStatus,
                onChanged: (value) {
                  setState(() {
                    alertStatus = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
