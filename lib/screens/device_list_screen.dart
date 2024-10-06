import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global.dart' as globals;
import '../services/networking.dart';
import 'dart:async';
import 'device_detail_screen.dart';
import 'add_device_screen.dart';
import 'share_device-screen.dart';
import 'edit_device_screen.dart';

class DeviceListScreen extends StatefulWidget {
  @override
  _DeviceListScreenState createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  List<dynamic> devices = [];
  Timer? _timer; // Declare a Timer

  @override
  void initState() {
    super.initState();
    fetchDevices();
    // Start the timer to fetch devices every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      fetchDevices();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<void> fetchDevices() async {
    NetworkHelper networkHelper =
        NetworkHelper('devices'); // Adjust the endpoint as needed

    try {
      var data = await networkHelper.getData();

      if (data != null) {
        setState(() {
          devices = data; // Assuming the data is a list of devices
          print(devices);
        });
      } else {
        // Handle case where data is null
        print('Failed to load devices');
      }
    } catch (e) {
      // Handle error here (e.g., show a Snackbar or alert dialog)
      print(e);
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
                'Welcom',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              // ToDo wellcom fetch data from api
              // Text(
              //       'Watt : $value', // แสดงค่า Value พร้อมข้อความ
              //       style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              //     ),

              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddDeviceScreen()), // ใช้ MaterialPageRoute
                      );
                    },
                    child: Text('Add Device'),
                  ),
                  SizedBox(height: 8), // ระยะห่างระหว่างปุ่ม
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ShareDeviceScreen()), // ใช้ MaterialPageRoute
                      );
                    },
                    child: Text('Share'),
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
                  isConnected: device['device_status'] ==
                      true, // Check boolean value directly
                  id: device['id'], // เพิ่ม id ที่นี่
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
  final int id; // เพิ่ม id เพื่อใช้ในการนำทาง

  const DeviceListItem({
    Key? key,
    required this.name,
    required this.value,
    required this.isConnected,
    required this.id, // เพิ่ม id ที่นี่
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // นำทางไปยังหน้ารายละเอียดโดยส่ง id
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeviceDetailScreen(
                deviceId: id), // เปลี่ยนไปใช้หน้าที่คุณสร้างไว้
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
                    name, // แสดงชื่ออุปกรณ์
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Watt : $value', // แสดงค่า Value พร้อมข้อความ
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
                  SizedBox(width: 16), // ระยะห่างระหว่างไอคอนและปุ่ม Edit
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditDeviceScreen(
                                deviceId: id), // เปลี่ยนไปใช้หน้าที่คุณสร้างไว้
                          ));
                    },
                    child: Text('Edit'),
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
