import 'package:flutter/material.dart';

class LogDeviceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0), // เพิ่ม Padding เพื่อความสวยงาม
        child: Center( // ใช้ Center เพื่อให้ข้อความอยู่กลางหน้าจอ
          child: Text(
            "LogDeviceScreen",
            style: TextStyle(fontSize: 24), // เพิ่มขนาดฟอนต์เพื่อให้อ่านง่าย
          ),
        ),
      ),
    );
  }
}
