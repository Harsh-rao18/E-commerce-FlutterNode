import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void manageHttpResponse({
  required http.Response response, // the HTTP response from the request
  required BuildContext context, // the context is to show SnackBar
  required VoidCallback
      onSuccess, // the callback is to execute on a successful response
}) {
  // Switch satement to handle differrnt http status codes
  switch (response.statusCode) {
    case 200: // Status 200 indicates a successful request
      onSuccess();
      break;
    case 400: // Status 400 indicates a bad request
      showSnackBar(context, json.decode(response.body)['msg']);
      break;
    case 500: // Status 500 indicates server error
      showSnackBar(context, json.decode(response.body)['error']);
      break;
    case 201: // Status 201 indicates a resource was created successfully
      onSuccess();
      break;
    default:
  }
}

void showSnackBar(BuildContext context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(title),
      margin: const EdgeInsets.all(15),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.grey,
    ),
  );
}
