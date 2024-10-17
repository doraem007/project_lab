import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/networking.dart'; // นำเข้า NetworkHelper

class EditChannelScreen extends StatefulWidget {
  final int deviceDetailId; // ส่ง ID รายละเอียดอุปกรณ์

  EditChannelScreen({required this.deviceDetailId});

  @override
  _EditChannelScreenState createState() => _EditChannelScreenState();
}

class _EditChannelScreenState extends State<EditChannelScreen> {
  DateTime? timeOn;
  DateTime? timeOff;
  bool timeOnStatus = false;
  bool timeOffStatus = false;

  @override
  void initState() {
    super.initState();
    fetchDeviceDetail(); // Fetch device details on initialization
  }

  Future<void> fetchDeviceDetail() async {
    final url = 'device_details/${widget.deviceDetailId}';
    final NetworkHelper networkHelper = NetworkHelper(url);

    final response = await networkHelper.getData(); // Assuming you have a getData method

    if (response != null) {
      // Check if the response has the expected keys
      if (response['time_on'] != null) {
        setState(() {
          timeOn = DateTime.parse(response['time_on']);
          timeOff = DateTime.parse(response['time_off']);
          timeOnStatus = response['time_on_status'];
          timeOffStatus = response['time_off_status'];
        });
      } else {
        // Handle case where expected data is missing
        showErrorSnackBar('ไม่สามารถดึงข้อมูลรายละเอียดอุปกรณ์ได้');
      }
    } else {
      showErrorSnackBar('ไม่สามารถดึงข้อมูลรายละเอียดอุปกรณ์ได้');
    }
  }

  Future<void> updateDeviceDetail() async {
  // Validate time selections if both are active
  if (timeOnStatus && timeOffStatus) {
    if (timeOn == null || timeOff == null) {
      showErrorSnackBar('กรุณากำหนดเวลาเปิดและปิด');
      return;
    }
    if (timeOn!.isAfter(timeOff!)) {
      showErrorSnackBar('เวลาเปิดต้องน้อยกว่าเวลาปิด');
      return;
    }
  }

  final url = 'device_details/${widget.deviceDetailId}';
  final NetworkHelper networkHelper = NetworkHelper(url);

  // Prepare data to send, ensuring the format is correct
  final Map<String, dynamic> dataToSend = {
    'time_on': timeOnStatus ? timeOn?.toIso8601String() : null,
    'time_off': timeOffStatus ? timeOff?.toIso8601String() : null,
    'time_on_status': timeOnStatus,
    'time_off_status': timeOffStatus,
  };

  // Remove any null values from the data
  dataToSend.removeWhere((key, value) => value == null);

  // Call the updateData method and store the response
  final response = await networkHelper.updateData(dataToSend);

  if (response != null && response['detail'] == null) {
    // Update succeeded
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('อัปเดตรายละเอียดอุปกรณ์เรียบร้อยแล้ว')),
    );
  } else {
    // Handle error case
    String errorMessage = response?['detail']?.toString() ?? 'ไม่สามารถอัปเดตรายละเอียดอุปกรณ์ได้';
    showErrorSnackBar(errorMessage);
  }

  // Debug output
  print('Update Response: $response');
}


  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _selectTime(BuildContext context, bool isTimeOn) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final DateTime now = DateTime.now();
      final selectedTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      
      setState(() {
        if (isTimeOn) {
          // Ensure selected timeOn is before timeOff if timeOff is active
          if (timeOff != null && selectedTime.isAfter(timeOff!)) {
            showErrorSnackBar('เวลาเปิดต้องน้อยกว่าเวลาปิด');
            return; // Do not set timeOn if it is not valid
          }
          timeOn = selectedTime;
        } else {
          // Ensure selected timeOff is after timeOn if timeOn is active
          if (timeOn != null && selectedTime.isBefore(timeOn!)) {
            showErrorSnackBar('เวลาเปิดต้องน้อยกว่าเวลาปิด');
            return; // Do not set timeOff if it is not valid
          }
          timeOff = selectedTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Channel'),
        backgroundColor: Colors.pink.shade100,
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.green), // เปลี่ยนสีไอคอนเป็นสีเขียว
            onPressed: updateDeviceDetail, // เรียกฟังก์ชันบันทึก
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              _buildTimeSection('เวลาเปิด', timeOn, timeOnStatus, true),
              SizedBox(height: 20),
              _buildTimeSection('เวลาปิด', timeOff, timeOffStatus, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSection(String title, DateTime? selectedTime, bool isActive, bool isTimeOn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: isActive ? () => _selectTime(context, isTimeOn) : null,
          child: Text(selectedTime != null ? DateFormat('HH:mm').format(selectedTime) : 'เลือกเวลา'),
          style: ElevatedButton.styleFrom(
            backgroundColor: isActive ? Colors.pink : Colors.grey, // ใช้ backgroundColor แทน primary
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // จัดตำแหน่งให้ตรงกัน
          children: [
            Text('Active', style: TextStyle(fontSize: 16)),
            Switch(
              value: isActive,
              onChanged: (value) {
                setState(() {
                  if (isTimeOn) {
                    timeOnStatus = value;
                  } else {
                    timeOffStatus = value;
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
