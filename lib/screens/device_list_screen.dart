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
  int memberId = globals.memberID; // Assuming you store the userId in globals

  @override
  void initState() {
    super.initState();
    fetchDevices(memberId); // Fetch devices for the specified memberId
    // Start the timer to fetch devices every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      fetchDevices(memberId);
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<void> fetchDevices(int memberId) async {
    NetworkHelper networkHelper =
        NetworkHelper('user/$memberId'); // Adjust the endpoint as needed

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
                'Welcome', // Fixed the typo from 'Welcom' to 'Welcome'
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
                    child: Text('Add Device'),
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
