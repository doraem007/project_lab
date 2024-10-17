import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/networking.dart';
import 'dart:async';
import 'edit_channel_screen.dart';

class DeviceDetailScreen extends StatefulWidget {
  final int deviceId;

  const DeviceDetailScreen({Key? key, required this.deviceId})
      : super(key: key);

  @override
  _DeviceDetailScreenState createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  Map<String, dynamic>? _deviceData; // ตัวแปรสถานะสำหรับข้อมูลอุปกรณ์
  Timer? _refreshTimer; // ประกาศตัวแปร Timer

  @override
  void initState() {
    super.initState();
    _fetchDeviceData(); // ดึงข้อมูลอุปกรณ์เริ่มต้น

    // เริ่มตั้งเวลาเพื่อรีเฟรชข้อมูลอุปกรณ์ทุก ๆ 2 วินาที
    _refreshTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      _refreshDeviceData();
    });
  }

  // ฟังก์ชันเพื่อดึงข้อมูลอุปกรณ์
  Future<void> _fetchDeviceData() async {
    final response =
        await NetworkHelper('devices/${widget.deviceId}').getData();

    // ตรวจสอบว่าวิดเจ็ตยังคงติดตั้งอยู่ก่อนที่จะอัปเดตสถานะ
    if (mounted) {
      setState(() {
        _deviceData = response; // อัปเดตสถานะด้วยข้อมูลที่ดึงมา
      });
    }
  }

  // ฟังก์ชันเพื่อรีเฟรชข้อมูลอุปกรณ์
  void _refreshDeviceData() {
    _fetchDeviceData();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel(); // ยกเลิกตัวจับเวลาขณะกำลังทิ้งวิดเจ็ต
    super.dispose();
  }

  // ฟังก์ชันเพื่อสลับสถานะช่อง
  Future<void> _toggleChannelStatus(int channelId, bool currentStatus) async {
    print(
        'กำลังสลับสถานะช่องสำหรับ Channel ID: $channelId ด้วย Device ID: ${widget.deviceId}'); // บันทึก Channel ID และ Device ID

    // รวม Device ID ใน URL ของคำขอ
    final response =
        await NetworkHelper('channels/toggle/${widget.deviceId}/$channelId')
            .postData({'status': !currentStatus}); // สลับสถานะปัจจุบัน

    print('ผลลัพธ์การสลับช่อง: $response'); // บันทึกดีบัก

    if (response != null && response is Map<String, dynamic>) {
      if (response['success']) {
        print(
            'Channel ID $channelId สลับสถานะสำเร็จเป็น ${response['new_status']}');
        _refreshDeviceData(); // รีเฟรชข้อมูลอุปกรณ์หลังจากเปลี่ยนสถานะ
      } else {
        print(
            'ไม่สามารถสลับ Channel ID $channelId: ${response['message'] ?? 'ข้อผิดพลาดที่ไม่รู้จัก'}');
      }
    } else {
      print('ข้อผิดพลาดหรือผลลัพธ์เป็น null: $response');
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบอุปกรณ์นี้?'),
          actions: <Widget>[
            TextButton(
              child: Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(); // ปิดกล่องโต้ตอบ
              },
            ),
            TextButton(
              child: Text('ลบ'),
              onPressed: () {
                // ดำเนินการลบ
                NetworkHelper('devices/${widget.deviceId}')
                    .deleteData()
                    .then((response) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  String convertToThailandTime(String utcTime) {
    DateTime utcDateTime = DateTime.parse(utcTime);
    DateTime thailandDateTime = utcDateTime.add(Duration(hours: 7));
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(thailandDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดอุปกรณ์'),
        backgroundColor: Colors.pink.shade100,
      ),
      body: _deviceData == null // ตรวจสอบว่าข้อมูลถูกโหลดแล้วหรือไม่
          ? Center(child: CircularProgressIndicator()) // ใช้ CircularProgressIndicator สำหรับการโหลด
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                // เพิ่ม SingleChildScrollView
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ชื่ออุปกรณ์: ${_deviceData!['device_name']}'),
                    Text('ค่าปัจจุบัน: ${_deviceData!['current_value']} Watt'),
                    Text(
                      'สถานะอุปกรณ์: ${_deviceData?['device_status'] == true ? "ทำงาน" : "ไม่ทำงาน"}',
                    ),
                    Text(
                        'เวอร์ชันเฟิร์มแวร์: ${_deviceData!['firmware_version']}'),
                    Text(
                        'สร้างเมื่อ: ${convertToThailandTime(_deviceData!['create_at'])}'),
                    Text(
                      'ตำแหน่งที่: ${_deviceData!['location'] ?? "ไม่ระบุ"}',
                    ),
                    SizedBox(height: 20),
                    Text('รายละเอียด: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),

                    // ตรวจสอบว่ามีรายละเอียดอยู่หรือไม่ และเป็น List หรือไม่
                    if (_deviceData!['details'] == null ||
                        !(_deviceData!['details'] is List) ||
                        _deviceData!['details'].isEmpty)
                      Center(child: Text('ไม่พบรายละเอียด.'))
                    else
                      ListView.builder(
                        itemCount: _deviceData!['details'].length,
                        shrinkWrap: true, // ช่วยให้ ListView ใช้พื้นที่น้อยลง
                        physics:
                            NeverScrollableScrollPhysics(), // ปิดการเลื่อนของ ListView
                        itemBuilder: (context, index) {
                          final detail = _deviceData!['details'][index];
                          bool isActive = detail['channel_status'] ?? false;

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Channel ID: ${detail['channel_id']}',
                                      style: TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis, // ตัดข้อความที่ยาวเกิน
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        isActive
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color: isActive
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                      SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          // นำทางไปยังหน้าจอแก้ไขช่อง
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditChannelScreen(
                                                      deviceDetailId: detail['id']),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4), // ลดขนาด padding
                                          minimumSize:
                                              Size(60, 30), // กำหนดขนาดขั้นต่ำ
                                        ),
                                        child: Text('แก้ไข',
                                            style: TextStyle(
                                                fontSize: 12)), // ลดขนาดตัวอักษร
                                      ),
                                      SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          _toggleChannelStatus(
                                              detail['channel_id'], isActive);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4), // ลดขนาด padding
                                          minimumSize:
                                              Size(40, 30), // กำหนดขนาดขั้นต่ำ
                                          backgroundColor: isActive
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                        child: Text(isActive ? 'เปิด' : 'ปิด',
                                            style: TextStyle(
                                                fontSize:
                                                    12)), // ลดขนาดตัวอักษร
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                    ElevatedButton(
                      onPressed:
                          _showDeleteConfirmationDialog, // แสดงกล่องยืนยันการลบ
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text('ลบ'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
