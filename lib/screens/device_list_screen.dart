import 'package:flutter/material.dart';
import '../global.dart' as globals;
import '../services/networking.dart';
import 'dart:async';
import 'device_detail_screen.dart';
import 'add_device_screen.dart';
import 'share_device_screen.dart';
import 'edit_device_screen.dart';

class DeviceListScreen extends StatefulWidget {
  @override
  _DeviceListScreenState createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  List<dynamic> devices = [];
  Timer? _timer; // ประกาศ Timer
  int memberId = globals.memberID; // สมมติว่าคุณเก็บ userId ไว้ใน globals

  @override
  void initState() {
    super.initState();
    fetchDevices(memberId); // ดึงอุปกรณ์สำหรับ memberId ที่ระบุ
    // เริ่มต้น Timer เพื่อดึงอุปกรณ์ทุก ๆ 5 วินาที
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      fetchDevices(memberId);
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // ยกเลิก Timer เมื่อ Widget ถูกกำจัด
    super.dispose();
  }

  Future<void> fetchDevices(int memberId) async {
    NetworkHelper networkHelper = NetworkHelper('user/$memberId'); // ปรับ endpoint ตามที่จำเป็น

    try {
      var response = await networkHelper.getData();

      // ตรวจสอบว่าการตอบสนองเป็น Map และมีคีย์ devices
      if (response is Map<String, dynamic> && response['devices'] is List) {
        setState(() {
          devices = response['devices']; // เข้าถึงรายการอุปกรณ์จาก response map
          print(devices);
        });
      } else {
        // จัดการกรณีที่ข้อมูลอุปกรณ์เป็น null หรือไม่ใช่รายการ
        print('ไม่สามารถโหลดอุปกรณ์หรือไม่พบอุปกรณ์');
      }
    } catch (e) {
      // จัดการข้อผิดพลาดที่นี่ (เช่น แสดง Snackbar หรือ Alert Dialog)
      print('ข้อผิดพลาดในการดึงอุปกรณ์: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DeviceList(devices: devices),
    );
  }
}

class DeviceList extends StatelessWidget {
  final List<dynamic> devices;

  DeviceList({required this.devices});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ยินดีต้อนรับ', // "Welcome" in Thai
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddDeviceScreen()),
                      );
                    },
                    child: Text('เพิ่มอุปกรณ์'), // "Add Device" in Thai
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent, // Updated
                    ),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShareDeviceScreen()),
                      );
                    },
                    child: Text('แชร์'), // "Share" in Thai
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent, // Updated
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                var device = devices[index];
                return DeviceListItem(
                  name: device['device_name'],
                  value: device['current_value'].toString(),
                  isConnected: device['device_status'] == true,
                  id: device['id'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DeviceListItem extends StatelessWidget {
  final String name;
  final String value;
  final bool isConnected;
  final int id;

  const DeviceListItem({
    Key? key,
    required this.name,
    required this.value,
    required this.isConnected,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeviceDetailScreen(deviceId: id),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Watt: $value',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    isConnected ? Icons.check_circle : Icons.cancel,
                    color: isConnected ? Colors.green : Colors.red,
                    size: 32,
                  ),
                  SizedBox(width: 5),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditDeviceScreen(deviceId: id),
                        ),
                      );
                    },
                    child: Text('แก้ไข'), // "Edit" in Thai
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
