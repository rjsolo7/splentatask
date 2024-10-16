import 'dart:async';
import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ApiInterceptor implements InterceptorContract {
  final String _token = 'your_dummy_token'; // You can use a dummy token

  // This method is called before the request is sent to check if it should be intercepted
  @override
  Future<http.BaseRequest> interceptRequest({required http.BaseRequest request}) async {
    // Check Internet Connection
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('No Internet Connection');
    }

    // Add Authorization Header (if necessary, can skip it if no token is used)
    request.headers['Authorization'] = 'Bearer $_token';

    // Log request details (for debugging)
    print("Request: ${request.method} ${request.url}");
    print("Headers: ${request.headers}");

    return request;
  }

  // Intercept the response to log the details
  @override
  Future<http.BaseResponse> interceptResponse({required http.BaseResponse response}) async {
    // Log response details (for debugging)
    print("Response: ${response.statusCode}");
    print("Headers: ${response.headers}");
    print("Response Body: ${response}");

    return response;
  }

  @override
  FutureOr<bool> shouldInterceptRequest() {
    // Implement if needed, for now, we return true (always intercept)
    return true;
  }

  @override
  FutureOr<bool> shouldInterceptResponse() {
    // Implement if needed, for now, we return true (always intercept)
    return true;
  }
}

class ApiService {
  final String _baseUrl = 'https://jsonplaceholder.typicode.com';
  late http.Client client;

  ApiService() {
    client = InterceptedClient.build(interceptors: [ApiInterceptor()]);
  }

  // GET request
  Future<List<dynamic>> getPosts() async {
    try {
      // Check if there is internet connectivity before making the request
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception('No Internet Connection');
      }

      final response = await client.get(
        Uri.parse('$_baseUrl/posts'),
      );

      // Log response details
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      // Handle error and log the exception
      print("Error fetching posts: $e");
      throw Exception('Error fetching posts: $e');
    }
  }

  // POST request
  Future<void> submitPost(Map<String, dynamic> formData) async {
    try {
      final response = await client.post(
        Uri.parse('$_baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(formData),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to submit form');
      }
    } catch (e) {
      // Handle error and log the exception
      print("Error submitting form: $e");
      throw Exception('Error submitting form: $e');
    }
  }
}


