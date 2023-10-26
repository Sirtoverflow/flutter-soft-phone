// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:sip_call_crossplatform/page/mainpage.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'dart:convert';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainPage(logout: () {}),
  ));
}


class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _isLoggedIn = false;

  void _login() {
    setState(() {
      _isLoggedIn = true;
    });
    debugPrint('login status: $_isLoggedIn');

  }

  void _logout() {
    setState(() {
      _isLoggedIn = false;
    });
    debugPrint('login status: $_isLoggedIn');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(View.of(context).toString());
    if (_isLoggedIn == true) {
      return MainPage(logout: _logout);
    } else {
      return LoginWidget(login: _login);
    }
  }
}

class LoginWidget extends StatefulWidget {
  final VoidCallback login;
  const LoginWidget({required this.login, Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  String result = '';
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _submitForm() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      debugPrint("Email: $_email");
      debugPrint("Password: $_password");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Processing data, Hi $_email !')),
      );
    widget.login();
     
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Try again')),
      );
    }
  }

  void _handleQRscan() async {
    var res = await Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => const SimpleBarcodeScannerPage(
            scanType: ScanType.qr,
          ),
        ));
    debugPrint('QR scan result: $res');
    
    RegExp regex = RegExp(r'[^"]+":"[^"]+","[^"]+":"[^"]+","[^"]+":"[^"]+');

    if (regex.hasMatch(res)) {
      debugPrint(res.runtimeType.toString());
      Map resObject = jsonDecode(res);
      _email = resObject['username'];
      _password = resObject['password'];
      if (_email == '' || _password == '') {
        setState(() {
          result = 'QR code không hợp lệ';
        });
      }
      debugPrint("qrcode: $_email");
      widget.login();
    } else {
      setState(() {
      result = 'QR code không hợp lệ';
    });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 25),
                const Text(
                  'Hello Again!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 50),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email',
                              contentPadding: EdgeInsets.only(left: 20.0),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập email';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _email = value!;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                              contentPadding: EdgeInsets.only(left: 20.0),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập mật khẩu';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _password = value!;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                
                      Text(result),

                      const SizedBox(height: 5),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Not a member? ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Register now',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: ElevatedButton(
                          onPressed: () => (_submitForm()),
                          child: const Text('Sign In'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
                FloatingActionButton.extended(
                  icon: const Icon(Icons.camera_alt_rounded),
                  label: const Text('Scan'),
                  onPressed: _handleQRscan,
                ),
              ]),
        ),
      ),
    );
  }
}

