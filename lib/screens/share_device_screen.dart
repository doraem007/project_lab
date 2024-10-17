import 'package:flutter/material.dart';

class ShareDeviceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share Device'), // ปรับชื่อหน้าจอให้มีความชัดเจนขึ้น
        backgroundColor: Colors.pink.shade100,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0), // เพิ่ม Padding เพื่อความสวยงาม
        child: Center( // ใช้ Center เพื่อให้ข้อความอยู่กลางหน้าจอ
          child: Text(
            "Share Device Screen",
            style: TextStyle(fontSize: 24), // เพิ่มขนาดฟอนต์เพื่อให้อ่านง่าย
          ),
        ),
      ),
    );
  }
}
