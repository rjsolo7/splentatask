# splentatask

Splenta Assesement assigned to RAJA.

# Given Task:
Imagine you receive data from an API that defines a list of form fields dynamically. The API response includes details like title and description. Consider API response as form values, how would you implement a dynamic form that generates the textformfield widgets based on the API response and handles form validation and submission?

1.What is your approach for rendering these form fields dynamically in Flutter?
2.How would you handle validation (e.g., required fields)?
3.Could you explain how you would structure the form submission back to the API in Readme.md?

## RAJA's Approach is hereby











## Code Explanation


# main.dart

1.Main entry point of the application:
2.This file serves as the entry point for the application, setting up necessary providers and defining the primary screen (PostListScreen).
State management:
3.Uses Provider for state management. The PostProvider manages data related to posts across the app.


# post_provider.dart

1.PostProvider:
This class manages the state for fetching and submitting posts in the app.
State flags like isLoading, hasError, and hasResult help in tracking the status of API requests and handle UI updates.

2.Internet Connectivity: It checks for internet connectivity using the connectivity_plus package before making API calls.

3.Error Handling: Catches and stores error messages if an API request fails.

4.API Interaction:
fetchPosts() fetches posts from the API, and submitForm() submits form data to the API using methods from the ApiService.

## api_services.dart

# 1.ApiInterceptor:

Intercepts HTTP requests to add a dummy token for authorization.

Checks for internet connectivity before making API requests.

Logs request and response details for debugging purposes.

# 2.ApiService:

Provides methods to interact with the API:

getPosts(): Fetches a list of posts from the API and handles internet connectivity and error management.

submitPost(): Submits form data to the API and handles errors.

Uses http_interceptor to manage requests and responses.

Logs the request and response for better debugging and transparency.


## post_list.dart

# Post List Screen:
 1. State Management:Uses Provider to manage the state of fetching posts, handling loading and error states.

2. UI Logic:
Shows a CircularProgressIndicator while loading.
Displays an error message with a retry button if fetching posts fails.
If successful, displays a list of posts with an animation for each card.
Each post is displayed as key-value pairs inside a Card with a slide-in animation.

3. Floating Action Button: A floating button is shown when posts are fetched, which navigates to a form page (DynamicFormPage) to add new posts.


## form_provider.dart

# Form Provider:

1.State Management: Uses ChangeNotifier to manage the state of dynamic form fields.

2.Dynamic Form Creation: Based on an API response, it dynamically generates form fields (text fields for non-boolean data, switches for boolean values).

3.Validation: Each field has its own dynamic validation rules that ensure proper input (e.g., email, phone, number).

4.Controller Management: Handles dynamic TextEditingController instances for each field and disposes them appropriately when the provider is destroyed.

5.Input Type Determination: Dynamically determines the appropriate input type (e.g., text, email, number) based on the field data.

## post_form.dart

# DynamicFormPage

1. DynamicFormPage Class:
   Constructor: Takes apiResponse as a required parameter, which is expected to be a list of dynamic form fields.
   ChangeNotifierProvider: Wraps the widget tree in a ChangeNotifierProvider to provide the FormProvider instance.
   Scaffold: The main structure of the page, with an AppBar and a body that displays the form.
2. FormProvider and Consumer<FormProvider>:
   ChangeNotifierProvider initializes FormProvider, and the Consumer widget listens to changes in the provider.
   processApiResponse is called only once when the form is being built to set up form fields based on the API response.
3. Form Fields (Dynamically Generated):
   The form fields are dynamically created using the keys from the formProvider.controllers map:
   Switches: For fields where the value is boolean, a SwitchListTile is created.
   Text Fields: For other data types (e.g., strings, numbers), a TextFormField is used.
   Each field is rendered based on its type:
   Switch: A SwitchListTile widget that toggles the boolean state.
   TextFormField: A text input field with validation, placeholder text, and decoration.
   The controller for each field is fetched from formProvider.controllers.
   The inputType and validator are dynamically assigned from formProvider.inputTypes and formProvider.validators.
4. Submit Button:
   When the "Submit" button is pressed, it checks whether the form is valid using the formKey.
   If the form is valid, a success SnackBar is shown; otherwise, an error SnackBar is displayed.