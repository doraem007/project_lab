import 'package:flutter/material.dart';

class EditDeviceScreen extends StatelessWidget {
  final int deviceId;
  
  const EditDeviceScreen({Key? key, required this.deviceId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Device'), // ปรับชื่อหน้าจอให้มีความชัดเจนขึ้น
        backgroundColor: Colors.pink.shade100,
      ),
    body: Center(
        child: Text('Edit for device ID: $deviceId'),
        // คุณสามารถเพิ่มการดึงข้อมูลเพิ่มเติมที่นี่ตาม ID ที่ได้รับ
      ),
    );
  }
}