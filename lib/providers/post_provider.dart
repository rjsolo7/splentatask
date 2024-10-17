import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../services/api_services.dart';

class PostProvider extends ChangeNotifier {
  bool isLoading = false;
  bool hasError = false;
  bool hasResult=false;
  String errorMessage = '';
  List<dynamic> posts = [];
  final ApiService apiService = ApiService();

  Future<void> fetchPosts() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception('No Internet Connection');
      }

      posts = await apiService.getPosts();
      hasResult=true;
      isLoading = false;
    } catch (e) {
      isLoading = false;
      hasError = true;
      errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> submitForm(Map<String, dynamic> formData, BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception('No Internet Connection');
      }

      // Make the post API call
      await apiService.submitPost(formData);

      isLoading = false;
      hasResult = true;  // Mark as successful

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data added successfully!')),
      );
    } catch (e) {
      isLoading = false;
      hasError = true;
      errorMessage = e.toString();
      notifyListeners();

      // Show error message if something went wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add data: $errorMessage')),
      );
    }
  }

}
