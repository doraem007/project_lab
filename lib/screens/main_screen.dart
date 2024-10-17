import 'package:flutter/material.dart';
import 'device_list_screen.dart';
import 'log_device_screen.dart';
import '../global.dart' as globals;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // สร้างตัวเลือกของหน้าจอที่แสดงในแต่ละ Tab
  final List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('Home Screen')), // หน้าหลัก
    Center(child: DeviceListScreen()), // หน้าจอ Device List
    Center(child: LogDeviceScreen()), // Placeholder สำหรับ List Machine
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Current Username: ${globals.username}");
    print("Current memberID: ${globals.memberID}");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Just Plug'),
        backgroundColor: Colors.pink.shade100,
      ),
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex), // เลือก Widget ตาม tab ที่ถูกเลือก
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.electrical_services),
            label: 'Device',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Logs',
          ),
        ],
        currentIndex: _selectedIndex, // Tab ปัจจุบัน
        selectedItemColor: Colors.teal, // สีของ Tab ที่ถูกเลือก
        onTap: _onItemTapped, // กดเปลี่ยน Tab
      ),
    );
  }
}
