import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/networking.dart';

class EditDeviceScreen extends StatefulWidget {
  final int deviceId;

  const EditDeviceScreen({Key? key, required this.deviceId}) : super(key: key);

  @override
  _EditDeviceScreenState createState() => _EditDeviceScreenState();
}

class _EditDeviceScreenState extends State<EditDeviceScreen> {
  String deviceName = '';
  String location = '';
  bool alertStatus = false;
  Map<String, dynamic>? _deviceData;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchDeviceData();
  }

  Future<void> _fetchDeviceData() async {
    NetworkHelper networkHelper = NetworkHelper('devices/${widget.deviceId}');
    final response = await networkHelper.getData();

    if (response is Map<String, dynamic> && response['id'] != null) {
      setState(() {
        _deviceData = response;
        deviceName = response['device_name'] ?? '';
        location = response['location'] ?? ''; // ให้แน่ใจว่าค่าเริ่มต้นเป็นสตริงว่าง
        alertStatus = response['alert_status'] ?? false; // ให้แน่ใจว่าค่าเริ่มต้นเป็น false
      });
    } else {
      print('ข้อผิดพลาดในการดึงข้อมูลอุปกรณ์: $response');
    }
  }

  Future<void> _updateDeviceData() async {
    NetworkHelper networkHelper = NetworkHelper('devices/${widget.deviceId}');
    final response = await networkHelper.updateData({
      'device_name': deviceName,
      'alert_status': alertStatus,
      'location': location.trim() // ทำความสะอาดข้อมูลที่ป้อนใน location
    });

    print('Response: $response');

    if (response.containsKey('id')) {
      _showSuccessDialog();
    } else {
      print('ข้อผิดพลาดในการอัปเดตข้อมูลอุปกรณ์: $response');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('สำเร็จ'),
          content: Text('ข้อมูลอุปกรณ์อัปเดตสำเร็จ!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }

  String convertToThailandTime(String utcTime) {
    DateTime utcDateTime = DateTime.parse(utcTime);
    DateTime thailandDateTime = utcDateTime.toLocal().add(Duration(hours: 7));
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(thailandDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขอุปกรณ์'), // "Edit Device" in Thai
        backgroundColor: Colors.pink.shade100,
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.green),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _updateDeviceData();
              }
            },
          ),
        ],
      ),
      body: _deviceData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ชื่ออุปกรณ์:', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      initialValue: deviceName,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'กรุณากรอกชื่ออุปกรณ์', // "Enter device name" in Thai
                      ),
                      onChanged: (value) {
                        setState(() {
                          deviceName = value.trim(); // ทำความสะอาดข้อมูล
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกชื่ออุปกรณ์'; // "Please enter a device name" in Thai
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Text('สถานที่:', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      initialValue: location,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'กรุณากรอกสถานที่', // "Enter location" in Thai
                      ),
                      onChanged: (value) {
                        setState(() {
                          location = value.trim(); // ทำความสะอาดข้อมูล
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Text('สถานะการแจ้งเตือน:', style: TextStyle(fontWeight: FontWeight.bold)),
                    SwitchListTile(
                      title: Text(alertStatus ? 'เปิดใช้งาน' : 'ปิดใช้งาน'), // "Active" or "Inactive" in Thai
                      value: alertStatus,
                      onChanged: (value) {
                        setState(() {
                          alertStatus = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Text('เวอร์ชันเฟิร์มแวร์: ${_deviceData!['firmware_version']}', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text('สร้างเมื่อ: ${convertToThailandTime(_deviceData!['create_at'])}', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
