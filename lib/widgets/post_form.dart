import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/form_provider.dart';
import '../providers/post_provider.dart';

class DynamicFormPage extends StatefulWidget {
  final List apiResponse;

  DynamicFormPage({required this.apiResponse});

  @override
  _DynamicFormPageState createState() => _DynamicFormPageState();
}

class _DynamicFormPageState extends State<DynamicFormPage> {
  late FormProvider formProvider;

  @override
  void initState() {
    super.initState();
    // Initialize FormProvider here and process the API response
    formProvider = FormProvider();
    formProvider.processApiResponse(widget.apiResponse);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: formProvider,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dynamic Form'),
        ),
        body: Consumer<FormProvider>(
          builder: (context, formProvider, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formProvider.formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Dynamically generated fields based on unique keys
                      ...formProvider.controllers.keys.map((key) {
                        if (formProvider.switches.containsKey(key)) {
                          // For boolean fields, use a switch
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SwitchListTile(
                              title: Text(key),
                              value: formProvider.switches[key]! ,
                              onChanged: (bool newValue) {
                                formProvider.switches[key] = newValue;
                                formProvider.notifyListeners();
                              },
                            ),
                          );
                        } else {
                          // For text fields, use a TextFormField
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: formProvider.controllers[key],
                                keyboardType: formProvider.inputTypes[key],
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  labelText: key,
                                  hintText: 'Enter $key here',
                                  border: InputBorder.none,
                                ),
                                validator: formProvider.validators[key],
                              ),
                            ),
                          );
                        }
                      }).toList(),

                      // Submit Button
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (formProvider.formKey.currentState!.validate()) {
                              // Prepare form data to pass to the API
                              Map<String, dynamic> formData = {};
                              formProvider.controllers.forEach((key, controller) {
                                formData[key] = controller.text;
                              });

                              // Add switches data to the form data
                              formProvider.switches.forEach((key, value) {
                                formData[key] = value;
                              });

                              // Call the submitForm method from PostProvider
                              context.read<PostProvider>().submitForm(formData, context);

                              // Show feedback
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Submitting form...')),
                              );


                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Form is invalid')),
                              );
                            }
                          },

                          child: Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
