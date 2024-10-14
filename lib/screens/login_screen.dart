import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../constants.dart';
import '../components/rounded_button.dart';
import '../global.dart' as globals;
import '../services/config_system.dart';
import '../services/networking.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = "";
  String password = "";
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Just Plug'),
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(
                    Icons.account_circle,
                    size: 40,
                    color: const Color.fromARGB(255, 249, 131, 170),
                  ),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        username = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter username',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(
                    Icons.key,
                    size: 40.0,
                    color: const Color.fromARGB(255, 249, 131, 170),
                  ),
                  Expanded(
                    child: TextField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter password',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12.0,
              ),
              RoundedButton(
                title: 'Login',
                colour: const Color.fromARGB(255, 126, 194, 97),
                onPressed: () async {
                  // Start spinner
                  setState(() {
                    showSpinner = true;
                  });

                  // Validate input fields
                  if (username.isEmpty || password.isEmpty) {
                    setState(() {
                      showSpinner = false; // Stop spinner if validation fails
                    });
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Error'),
                        content: const Text(
                            'Username and password cannot be empty.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Close'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                    return; // Exit early
                  }

                  try {
                    globals.username = username;
                    NetworkHelper networkHelper = NetworkHelper('login');
                    var json = await networkHelper.postData({
                      "username": username,
                      "password": password,
                    });

                    // Check if json is null (connection issue)
                    if (json == null) {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Error'),
                          content: Text(
                              'Cannot connect to server: ${globals.serverIP}'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Close'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    } else if (json['detail'] == 'Login successful') {
                      // Successful login
                      globals.memberID = json["user"]["id"];
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    } else {
                      // Handle incorrect username or password
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Incorrect username or password'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Close'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  } catch (e) {
                    print('An unexpected error occurred: $e');
                  } finally {
                    // Stop spinner regardless of success or failure
                    setState(() {
                      showSpinner = false;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
