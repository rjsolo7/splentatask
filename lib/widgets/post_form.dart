import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/form_provider.dart';


class DynamicFormPage extends StatelessWidget {
  final List apiResponse;

  DynamicFormPage({required this.apiResponse});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FormProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dynamic Form'),
        ),
        body: Consumer<FormProvider>(
          builder: (context, formProvider, child) {
            formProvider.processApiResponse(apiResponse); // Call the provider to process API response

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formProvider.formKey,
                child: Column(
                  children: [
                    // Dynamic title field
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: formProvider.isTitleSwitchOn
                          ? SwitchListTile(
                        title: Text('Switch for Title'),
                        value: formProvider.isTitleSwitchOn,
                        onChanged: (bool newValue) {
                          formProvider.isTitleSwitchOn = newValue;
                        },
                      )
                          : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: formProvider.titleController,
                          keyboardType: formProvider.titleInputType,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            labelText: 'Title',
                            hintText: 'Enter title here',
                            border: InputBorder.none,
                          ),
                          validator: formProvider.titleValidator,
                        ),
                      ),
                    ),

                    // Dynamic body field
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: formProvider.isBodySwitchOn
                          ? SwitchListTile(
                        title: Text('Switch for Body'),
                        value: formProvider.isBodySwitchOn,
                        onChanged: (bool newValue) {
                          formProvider.isBodySwitchOn = newValue;
                        },
                      )
                          : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: formProvider.bodyController,
                          keyboardType: formProvider.bodyInputType,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            labelText: 'Body',
                            hintText: 'Enter body here',
                            border: InputBorder.none,
                          ),
                          validator: formProvider.bodyValidator,
                        ),
                      ),
                    ),

                    // Submit Button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (formProvider.formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Form is valid!')),
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
            );
          },
        ),
      ),
    );
  }
}
