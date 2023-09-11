import 'dart:convert';

import 'package:agile_task_farhana/product_list.dart';
import 'package:agile_task_farhana/product_model.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AddProduct extends StatefulWidget {
  String? accessToToken;
  AddProduct({super.key, required this.accessToToken});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  late String localAccessToken;

  @override
  void initState() {
    super.initState();

    localAccessToken = widget.accessToToken ?? "";
    // addProducts();
  }

  Future<void> addProducts(productName, productDescription) async {
    // API endpoint URL
    String apiUrl =
        'https://stg-zero.propertyproplus.com.au/api/services/app/ProductSync/CreateOrEdit';

    // Access token obtained from the authentication API response
    String accessToken = 'your_access_token_here';

    // Tenant ID
    int tenantId = 10;

    // Request body
    Map<String, dynamic> requestBody = {
      "tenantId": tenantId,
      "name": productName,
      "description": productDescription,
    };

    try {
      // Send POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $localAccessToken',
          'Content-Type': 'application/json', // Specify the content type
        },
        body: jsonEncode(requestBody),
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        print("POST request successful");
        print("Response: ${response.body}");
      } else {
        print("POST request failed with status code: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Error sending POST request: $e");
    }
  }

  // controller
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Add Product'.text.make(),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Product Username'),
                ),
              )
                  .box
                  .size(MediaQuery.sizeOf(context).width * 0.9, 60)
                  .roundedLg
                  .border(color: Color.fromARGB(255, 45, 7, 90))
                  .make(),
              30.heightBox,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Product Description'),
                ),
              )
                  .box
                  .size(MediaQuery.sizeOf(context).width * 0.9, 60)
                  .roundedLg
                  .border(color: Color.fromARGB(255, 45, 7, 90))
                  .make(),

              50.heightBox,

              //Button to authenticate

              GestureDetector(
                onTap: () {
                  addProducts(
                      _nameController.text, _descriptionController.text);
                  Get.to(() => ProductList(
                        accessToToken: localAccessToken,
                      ));
                },
                child: 'Add'
                    .text
                    .white
                    .size(2)
                    .makeCentered()
                    .box
                    .size(250, 50)
                    .color(const Color.fromARGB(255, 60, 40, 114))
                    .rounded
                    .shadow
                    .make(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
