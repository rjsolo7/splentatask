import 'package:flutter/material.dart';

class FormProvider extends ChangeNotifier {
  // GlobalKey for Form validation
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Map to store controllers for each unique field
  Map<String, TextEditingController> controllers = {};

  // Map to store boolean switches for each field (if needed)
  Map<String, bool> switches = {};

  // Map to store validators for each field
  Map<String, String? Function(String?)?> validators = {};

  // Map to store input types for each field
  Map<String, TextInputType> inputTypes = {};

  // Function to get the input type based on the value
  TextInputType getInputType(String value) {
    if (RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
      return TextInputType.emailAddress;
    } else if (RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
      return TextInputType.phone;
    } else if (RegExp(r'^\d+$').hasMatch(value)) {
      return TextInputType.number;
    } else {
      return TextInputType.text;
    }
  }

  // Function to create validation rules based on the value
  String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    if (RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
      return null; // Valid email
    }
    if (RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
      return null; // Valid phone number
    }
    if (RegExp(r'^\d+$').hasMatch(value)) {
      return null; // Valid number
    }
    return null;
  }

  // Process the API response and dynamically create unique form fields
  void processApiResponse(List<dynamic> apiResponse) {
    controllers.clear();
    switches.clear();
    validators.clear();
    inputTypes.clear();

    // Use a Set to track unique keys and avoid duplicates
    Set<String> uniqueKeys = {};

    for (var field in apiResponse) {
      // Iterate over each key-value pair in the object
      field.forEach((key, value) {
        // Only add unique keys to the form
        if (!uniqueKeys.contains(key)) {
          uniqueKeys.add(key);

          if (value is bool) {
            // If the field is boolean, create a switch
            switches[key] = value;
          } else {
            // For non-boolean values, create a text field
            controllers[key] = TextEditingController(text: '');  // Start with an empty value
            inputTypes[key] = getInputType(value.toString());  // Determine the input type based on value
            validators[key] = (value) => validateField(value);  // Set dynamic validation
          }
        }
      });
    }

    notifyListeners(); // Notify listeners that state has changed
  }

  // Function to clear all text fields and switches
  void clearForm() {
    // Clear text field controllers
    controllers.forEach((key, controller) => controller.clear());

    // Reset switches
    switches.updateAll((key, value) => false);

    notifyListeners(); // Notify listeners after clearing
  }

  // Dispose of controllers when the provider is destroyed
  @override
  void dispose() {
    controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }
}
