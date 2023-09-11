import 'dart:convert';

import 'package:agile_task_farhana/product_model.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'add_update.dart';

class ProductList extends StatefulWidget {
  String? accessToToken;
  ProductList({super.key, required this.accessToToken});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late String
      localAccessToken; // Declare a local variable to store the access token

  @override
  void initState() {
    super.initState();

    localAccessToken = widget.accessToToken ?? "";
    fetchProducts();
  }

  List<Product> products =
      []; // Declare and initialize the class-level products list

  Future<void> fetchProducts() async {
    final String apiUrl =
        "https://stg-zero.propertyproplus.com.au/api/services/app/ProductSync/GetAllproduct";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $localAccessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> productList = json.decode(response.body);

      // Clear the existing products list before adding new products
      products.clear();

      for (var product in productList) {
        products.add(Product.fromJson(product));
      }
      // Uncomment this line to see the data in the debug console
      print(products);
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Product List'.text.make(),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              40.heightBox,
              FutureBuilder(
                future: fetchProducts(),
                builder: (context, snapshot) {
                  return Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        // Use the class-level products list to populate the UI
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              10.heightBox,
                              products[index]
                                  .id
                                  .text
                                  .black
                                  .makeCentered()
                                  .box
                                  .size(50, 50)
                                  .white
                                  .roundedFull
                                  .make(),
                              5.heightBox,
                              products[index]
                                  .name
                                  .text
                                  .color(Color.fromARGB(255, 255, 255, 255))
                                  .size(15)
                                  .make(),
                              5.heightBox,
                              products[index]
                                  .description
                                  .text
                                  .color(Color.fromARGB(255, 227, 227, 83))
                                  .size(13)
                                  .make(),
                              5.heightBox,
                              products[index].isAvailable
                                  ? 'Available'
                                      .text
                                      .color(const Color.fromARGB(
                                          255, 128, 224, 132))
                                      .make()
                                  : 'Not Available'
                                      .text
                                      .color(Color.fromARGB(255, 232, 106, 112))
                                      .make()
                            ],
                          ).box.size(140, 240).black.rounded.shadow.make(),
                        );
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddProduct(
                accessToToken: localAccessToken,
              ));
        },
        child: Icon(
          Icons.add,
          size: 35,
        ),
      ),
    );
  }
}
