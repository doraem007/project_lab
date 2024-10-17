// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../global.dart' as globals;

// class NetworkHelper {
//   NetworkHelper(this.url);

//   final String prefixUrl =
//       'https://${globals.serverIP}/'; // Ensure this is correctly set
//   final String url;

//   Future<dynamic> getData() async {
//     try {
//       final http.Response response = await http
//           .get(Uri.parse(prefixUrl + url))
//           .timeout(const Duration(seconds: 60));

//       // Check response status and decode accordingly
//       if (response.statusCode == 200) {
//         return jsonDecode(response.body); // Return decoded JSON if successful
//       } else {
//         // Handle cases where response is not OK (non-200 status)
//         final Map<String, dynamic> errorResponse = {
//           'statusCode': response.statusCode,
//           'body': _decodeResponseBody(response.body),
//         };
//         return errorResponse;
//       }
//     } catch (e) {
//       print('Error during GET request: $e');
//       return {'error': true, 'message': 'Network error'};
//     }
//   }

// // Helper method to safely decode response body
//   dynamic _decodeResponseBody(String body) {
//     try {
//       // Only decode if the body is not empty
//       if (body.isNotEmpty) {
//         return jsonDecode(body); // Attempt to decode JSON
//       } else {
//         return 'No response body'; // Return message for empty body
//       }
//     } catch (jsonError) {
//       print('Error decoding JSON: $jsonError');
//       return 'Invalid response format'; // Return message for invalid JSON
//     }
//   }
//   Future<dynamic> postData(Map<String, dynamic> bodyData) async {
//     try {
//       String jsonData =
//           jsonEncode(bodyData); // Properly encode the body to JSON
//       print(jsonData);

//       final http.Response response = await http
//           .post(
//             Uri.parse(prefixUrl + url),
//             headers: {"Content-Type": "application/json"},
//             body: jsonData,
//           )
//           .timeout(const Duration(seconds: 60));

//       // Log the response status and body for debugging
//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');

//       if (response.statusCode == 200) {
//         if (response.body.isNotEmpty) {
//           // Attempt to parse the body as JSON
//           try {
//             return jsonDecode(response.body);
//           } catch (e) {
//             print('Error decoding JSON: $e');
//             return {'error': 'Invalid JSON format in server response'};
//           }
//         } else {
//           print('Empty response body');
//           return {'error': true, 'message': 'Empty response from server'};
//         }
//       } else {
//         // Handle non-200 responses
//         return {
//           'statusCode': response.statusCode,
//           'body': response.body.isNotEmpty
//               ? response.body // Return the raw body if it’s not JSON
//               : 'No response body',
//         };
//       }
//     } catch (e) {
//       print('Error during POST request: $e'); // Log the error for debugging
//       return {'error': 'Network or server error: $e'};
//     }
//   }
// }
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global.dart' as globals;

class NetworkHelper {
  NetworkHelper(this.url);

  final String prefixUrl =
      'https://${globals.serverIP}/'; // Ensure this is correctly set
  final String url;

  Future<Map<String, dynamic>> getData() async {
    try {
      final http.Response response = await http
          .get(Uri.parse(prefixUrl + url))
          .timeout(const Duration(seconds: 60));

      // Check response status and decode accordingly
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>; // Cast to the expected type
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

  Future<Map<String, dynamic>> postData(Map<String, dynamic> bodyData) async {
    try {
      String jsonData = jsonEncode(bodyData); // Properly encode the body to JSON
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
          // Attempt to parse the body as JSON
          try {
            return jsonDecode(response.body) as Map<String, dynamic>; // Cast here
          } catch (e) {
            print('Error decoding JSON: $e');
            return {'error': 'Invalid JSON format in server response'};
          }
        } else {
          print('Empty response body');
          return {'error': true, 'message': 'Empty response from server'};
        }
      } else {
        // Handle non-200 responses
        return {
          'statusCode': response.statusCode,
          'body': response.body.isNotEmpty
              ? response.body // Return the raw body if it’s not JSON
              : 'No response body',
        };
      }
    } catch (e) {
      print('Error during POST request: $e'); // Log the error for debugging
      return {'error': 'Network or server error: $e'};
    }
  }
  Future<Map<String, dynamic>> deleteData() async {
    try {
      final http.Response response = await http
          .delete(
            Uri.parse(prefixUrl + url),
            headers: {"Content-Type": "application/json"},
          )
          .timeout(const Duration(seconds: 60));

      // Log the response status and body for debugging
      print('Delete Response status: ${response.statusCode}');
      print('Delete Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {'success': true}; // Indicate success
      } else {
        return {
          'statusCode': response.statusCode,
          'body': response.body.isNotEmpty
              ? response.body // Return the raw body if it’s not JSON
              : 'No response body',
        };
      }
    } catch (e) {
      print('Error during DELETE request: $e');
      return {'error': 'Network or server error: $e'};
    }
  }

  Future<Map<String, dynamic>> updateData(Map<String, dynamic> bodyData) async {
    try {
      String jsonData = jsonEncode(bodyData); // Properly encode the body to JSON
      print('Update Data: $jsonData');

      final http.Response response = await http
          .put(
            Uri.parse(prefixUrl + url),
            headers: {"Content-Type": "application/json"},
            body: jsonData,
          )
          .timeout(const Duration(seconds: 60));

      // Log the response status and body for debugging
      print('Update Response status: ${response.statusCode}');
      print('Update Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>; // Return updated data
      } else {
        return {
          'statusCode': response.statusCode,
          'body': response.body.isNotEmpty
              ? response.body // Return the raw body if it’s not JSON
              : 'No response body',
        };
      }
    } catch (e) {
      print('Error during UPDATE request: $e');
      return {'error': 'Network or server error: $e'};
    }
  }
}
