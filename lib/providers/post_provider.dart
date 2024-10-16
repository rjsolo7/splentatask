import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../services/api_services.dart';

class PostProvider extends ChangeNotifier {
  bool isLoading = false;
  bool hasError = false;
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
      isLoading = false;
    } catch (e) {
      isLoading = false;
      hasError = true;
      errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> submitForm(Map<String, String> formData) async {
    isLoading = true;
    notifyListeners();

    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception('No Internet Connection');
      }

      await apiService.submitPost(formData);
      isLoading = false;
    } catch (e) {
      isLoading = false;
      hasError = true;
      errorMessage = e.toString();
    }

    notifyListeners();
  }
}
