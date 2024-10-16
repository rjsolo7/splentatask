import 'package:flutter/material.dart';

class FormProvider extends ChangeNotifier {
  // GlobalKey for Form validation
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Controllers for title and body
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  // Variables to handle boolean switch
  bool isTitleSwitchOn = false;
  bool isBodySwitchOn = false;

  // Validators for title and body fields
  String? Function(String?)? titleValidator;
  String? Function(String?)? bodyValidator;

  // Input types for title and body fields
  TextInputType titleInputType = TextInputType.text;
  TextInputType bodyInputType = TextInputType.text;

  // Function to get the input type based on the value
  TextInputType getInputType(String value) {
    // Check if it's an email
    if (RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
      return TextInputType.emailAddress;
    }
    // Check if it's a phone number
    else if (RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
      return TextInputType.phone;
    }
    // Check if it's a number
    else if (RegExp(r'^\d+$').hasMatch(value)) {
      return TextInputType.number;
    }
    // Default to text input if none of the above
    else {
      return TextInputType.text;
    }
  }

  // Function to create validation rules based on the value
  String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }

    // Check if the value is a valid email
    if (RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
      return null; // Valid email
    }

    // Check if the value is a valid phone number
    if (RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
      return null; // Valid phone number
    }

    // Check if the value is a number (digits only)
    if (RegExp(r'^\d+$').hasMatch(value)) {
      return null; // Valid number
    }

    return null; // Return null if no specific validation is needed
  }

  // This function will process the API response and figure out the necessary validation and keyboard type
  void processApiResponse(List<dynamic> apiResponse) {
    for (var field in apiResponse) {
      dynamic title = field['title'];
      dynamic body = field['body'];

      // Dynamically decide title and body input types and validation rules
      if (title is bool) {
        isTitleSwitchOn = title;
        titleInputType = TextInputType.text; // Default type for switch
        titleValidator = (value) => null; // No validation for switch
      } else if (title is String) {
        titleController.text = ''; // Clear title as no initial value
        titleInputType = getInputType(title); // Set input type based on content
        titleValidator = (value) => validateField(value); // Set dynamic validation
      }

      if (body is bool) {
        isBodySwitchOn = body;
        bodyInputType = TextInputType.text; // Default type for switch
        bodyValidator = (value) => null; // No validation for switch
      } else if (body is String) {
        bodyController.text = ''; // Clear body as no initial value
        bodyInputType = getInputType(body); // Set input type based on content
        bodyValidator = (value) => validateField(value); // Set dynamic validation
      }

      notifyListeners(); // Notify listeners that state has changed
    }
  }

  // Dispose of controllers when the provider is destroyed
  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }
}
