import 'dart:convert';
import 'package:agile_task_farhana/product_list.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Variable to store the access token
  String? _accessToken = 'This is Access Token';

  //function to handle Authentication

  void authenticate(String username, String password) async {
    try {
      final url =
          'https://stg-zero.propertyproplus.com.au/api/TokenAuth/Authenticate';
      final headers = {
        'Content-Type': 'application/json',
        'Abp.TenantId': '10'
      };
      final body = {"userNameOrEmailAddress": username, "password": password};

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final accessToken = jsonResponse['result']['accessToken'];

        // Set the access token in the state
        setState(() {
          _accessToken = accessToken;
        });

        VxToast.show(context, msg: 'Successfully Authoized');

        Get.to(() => ProductList(
              accessToToken: _accessToken,
            ));
      } else {
        VxToast.show(context,
            msg:
                'Failed to authenticate with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Authorization'.text.make(),
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
                  controller: _usernameController,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Enter Username'),
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
                  controller: _passwordController,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Enter Password'),
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
                  authenticate(
                      _usernameController.text, _passwordController.text);
                },
                child: 'Login'
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
