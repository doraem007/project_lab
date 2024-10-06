import 'package:flutter/material.dart';

class AddDeviceScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Device'), // ปรับชื่อหน้าจอให้มีความชัดเจนขึ้น
        backgroundColor: Colors.pink.shade100,
      ),
    body: Container(
      child: Text("Add Device Screen")
      ),
    );
  }
}