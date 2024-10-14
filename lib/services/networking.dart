import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global.dart' as globals;

class NetworkHelper {
  NetworkHelper(this.url);

  final String prefixUrl =
      'https://${globals.serverIP}/'; // Ensure this is correctly set
  final String url;

  // Future<dynamic> getData() async {
  //   try {
  //     final http.Response response = await http
  //         .get(Uri.parse(prefixUrl + url))
  //         .timeout(const Duration(seconds: 60));

  //     // Check response status and decode accordingly
  //     if (response.statusCode == 200) {
  //       return jsonDecode(response.body); // Return decoded JSON if successful
  //     } else {
  //       // Return response data even for errors
  //       return {
  //         'statusCode': response.statusCode,
  //         'body': jsonDecode(response.body),
  //       };
  //     }
  //   } catch (e) {
  //     print('Error during GET request: $e');
  //     return null; // Return null if an error occurs
  //   }
  // }
  Future<dynamic> getData() async {
    try {
      final http.Response response = await http
          .get(Uri.parse(prefixUrl + url))
          .timeout(const Duration(seconds: 60));

      // Check response status and decode accordingly
      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Return decoded JSON if successful
      } else {
        // Handle cases where response is not OK (non-200 status)
        final Map<String, dynamic> errorResponse = {
          'statusCode': response.statusCode,
          'body': _decodeResponseBody(response.body),
        };
        return errorResponse;
      }
    } catch (e) {
      print('Error during GET request: $e');
      return {'error': true, 'message': 'Network error'};
    }
  }

// Helper method to safely decode response body
  dynamic _decodeResponseBody(String body) {
    try {
      // Only decode if the body is not empty
      if (body.isNotEmpty) {
        return jsonDecode(body); // Attempt to decode JSON
      } else {
        return 'No response body'; // Return message for empty body
      }
    } catch (jsonError) {
      print('Error decoding JSON: $jsonError');
      return 'Invalid response format'; // Return message for invalid JSON
    }
  }

  Future<dynamic> postData(Map<String, dynamic> bodyData) async {
    try {
      String jsonData =
          jsonEncode(bodyData); // Properly encode the body to JSON
      print(jsonData);
      final http.Response response = await http
          .post(
            Uri.parse(prefixUrl + url),
            headers: {"Content-Type": "application/json"},
            body: jsonData,
          )
          .timeout(const Duration(seconds: 60));

      // Log the response status and body for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return jsonDecode(response.body); // Return decoded JSON if successful
        } else {
          print('Empty response body');
          return {'error': true, 'message': 'Empty response from server'};
        }
      } else {
        // Handle non-200 responses
        return {
          'statusCode': response.statusCode,
          'body': response.body.isNotEmpty
              ? jsonDecode(response.body)
              : 'No response body',
        };
      }
    } catch (e) {
      print('Error during POST request: $e'); // Log the error for debugging
      return null; // Return null if an error occurs
    }
  }
}
