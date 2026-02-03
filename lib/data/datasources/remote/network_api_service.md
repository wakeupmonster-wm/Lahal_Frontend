# NetworkApiServices Documentation

Welcome to the **NetworkApiServices** documentation! This class helps you interact with APIs easily by sending HTTP requests and handling responses. It supports both simple requests (GET, POST, etc.) and file uploads.

---

## Overview
The `NetworkApiServices` class is designed to:
1. Send HTTP requests to APIs.
2. Handle responses, including success and error cases.
3. Support file uploads for APIs that require files (like images or documents).

---

## Features
1. **Make API Requests**: Supports GET, POST, PUT, DELETE methods.
2. **File Uploads**: Upload files with your request using the same function.
3. **Automatic Error Handling**: Handles common errors like network issues or server errors.
4. **Dynamic Headers**: Adds headers dynamically (like authentication tokens).

---

## How It Works
The class provides one main method:
```dart
Future<Map<String, dynamic>> sendHttpRequest({
  required Uri url,
  required HttpMethod method,
  Map<String, String>? body,
  Map<String, String>? queryParams,
  Map<String, XFile>? files,
  String? id,
  bool includeHeaders = true,
});
```

---

## Understanding the Parameters

| Parameter        | Type                  | Description                                                                                     |
|------------------|-----------------------|-------------------------------------------------------------------------------------------------|
| **url**          | `Uri`                | The API endpoint you want to call.                                                             |
| **method**       | `HttpMethod`         | The HTTP method (GET, POST, PUT, DELETE).                                                      |
| **body**         | `Map<String, String>?`| Data to send in the request body (e.g., form data or JSON).                                     |
| **queryParams**  | `Map<String, String>?`| Optional query parameters to add to the URL.                                                   |
| **files**        | `Map<String, XFile>?`| Files to upload (e.g., images).                                                                |
| **id**           | `String?`            | An optional ID to append to the API endpoint (e.g., `url/id`).                                  |
| **includeHeaders** | `bool`              | Whether to include headers like authentication tokens (default: `true`).                       |

---

## How to Use

### 1. **Basic GET Request**
When you want to retrieve data from an API:
```dart
final response = await NetworkApiServices().sendHttpRequest(
  url: Uri.parse('https://api.example.com/resource'),
  method: HttpMethod.get,
);
print(response); // Output: API response as a Map
```

---

### 2. **POST Request with Body**
When you need to send data to the API:
```dart
final response = await NetworkApiServices().sendHttpRequest(
  url: Uri.parse('https://api.example.com/resource'),
  method: HttpMethod.post,
  body: {
    'key': 'value',
    'anotherKey': 'anotherValue',
  },
);
print(response); // Output: API response as a Map
```

---

### 3. **GET Request with Query Parameters**
When the API requires query parameters:
```dart
final response = await NetworkApiServices().sendHttpRequest(
  url: Uri.parse('https://api.example.com/resource'),
  method: HttpMethod.get,
  queryParams: {
    'search': 'flutter',
    'page': '1',
  },
);
print(response); // Output: API response as a Map
```

---

### 4. **POST Request with File Upload**
When you need to send files (e.g., images) to the API:
```dart
final file = XFile('/path/to/your/file.png');
final response = await NetworkApiServices().sendHttpRequest(
  url: Uri.parse('https://api.example.com/upload'),
  method: HttpMethod.post,
  files: {'fileField': file},
);
print(response); // Output: API response as a Map
```

---

### 5. **PUT Request with ID**
When you want to update a specific resource (e.g., `/resource/123`):
```dart
final response = await NetworkApiServices().sendHttpRequest(
  url: Uri.parse('https://api.example.com/resource'),
  method: HttpMethod.put,
  body: {'name': 'Updated Name'},
  id: '123',
);
print(response); // Output: API response as a Map
```

---

## What Happens Behind the Scenes?
1. **Build URL**: Combines the base URL, query parameters, and ID.
2. **Prepare Request**:
   - For file uploads, it uses `http.MultipartRequest`.
   - For other requests, it uses `http.Request`.
3. **Add Headers**: Automatically adds headers like authentication tokens (if enabled).
4. **Send Request**: Sends the request to the API.
5. **Handle Response**:
   - Success: Returns the response as a `Map<String, dynamic>`.
   - Error: Throws exceptions like `ApiException` or `FetchDataException`.

---

## Error Handling

### Common Exceptions
| Exception                | Description                                        |
|--------------------------|----------------------------------------------------|
| `ApiException`           | API returned an error (e.g., invalid input).       |
| `FetchDataException`     | Network issues or response parsing errors.         |
| `InternalServerException`| Server-side error (status code 500).               |

### Example:
```dart
try {
  final response = await NetworkApiServices().sendHttpRequest(
    url: Uri.parse('https://api.example.com/resource'),
    method: HttpMethod.get,
  );
  print(response);
} catch (e) {
  print('Error: $e'); // Handles API or network errors
}
```

---

## Best Practices
1. **Always Handle Errors**: Wrap your API calls in a `try-catch` block.
2. **Validate Inputs**: Check the required parameters before making a request.
3. **Log Responses**: Use `.log()` to debug your requests and responses.
4. **Use Secure Endpoints**: Always use HTTPS for secure communication.

---

## Example Use Case
Imagine you’re building a Flutter app where users can upload profile pictures and fetch user details. You can use this class to:

### **Fetch User Details**:
```dart
final response = await NetworkApiServices().sendHttpRequest(
  url: Uri.parse('https://api.example.com/user'),
  method: HttpMethod.get,
  includeHeaders: true,
);
print('User Details: $response');
```

### **Upload Profile Picture**:
```dart
final file = XFile('/path/to/profile_picture.png');
final response = await NetworkApiServices().sendHttpRequest(
  url: Uri.parse('https://api.example.com/user/upload'),
  method: HttpMethod.post,
  files: {'profilePicture': file},
);
print('Upload Response: $response');
```

---

## Conclusion
The `NetworkApiServices` class simplifies API communication in your app. Whether you’re sending data, fetching information, or uploading files, this class has you covered!

Feel free to reach out to the team if you have questions or need assistance. 🚀
