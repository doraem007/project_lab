import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../constants.dart';
import '../components/rounded_button.dart';
import '../global.dart' as globals;
import '../services/config_system.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = "";
  String password = "";
  String ip = '';
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Just Plug'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                if (globals.serverIP == '') {
                  globals.serverIP = await ConfigSystem.getServer();
                }
                await showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text('Config server ip'),
                          content: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.important_devices,
                                color: Colors.blue,
                                size: 50.0,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: TextFormField(
                                  initialValue: globals.serverIP,
                                  textAlign: TextAlign.center,
                                  onChanged: (value) {
                                    //Do something with the user input.
                                    ip = value;
                                  },
                                  decoration: kTextFieldDecoration.copyWith(
                                      hintText: 'Enter Server IP'),
                                ),
                              )
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Save'),
                              onPressed: () {
                                globals.serverIP = ip;
                                ConfigSystem.setServer(globals.serverIP);
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                                child: const Text('Close'),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ],
                        ));
              }),
          IconButton(
              icon: const Icon(Icons.info),
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text('About developer'),
                          content: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.account_box,
                                    color: Colors.blue,
                                    size: 50.0,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: Text("Thanawat Phattaraworamet"),
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.email,
                                    color: Colors.blue,
                                    size: 50.0,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: Text("thanawat.pha@ku.th"),
                                  )
                                ],
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                                child: Text('Close'),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ],
                        ));
              }),
        ],
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
                    Icons.person,
                    size: 50.0,
                    color: Colors.blue.shade800,
                  ),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        //Do something with the user input.
                        username = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your username'),
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
                    Icons.vpn_key,
                    size: 50.0,
                    color: Colors.blue.shade800,
                  ),
                  Expanded(
                    child: TextField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        //Do something with the user input.
                        password = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your password'),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12.0,
              ),
              RoundedButton(
                title: 'Login',
                colour: Colors.blue.shade800,
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainScreen()));
                  // setState(() {
                  //   showSpinner = true;
                  // });
                  // globals.username = username;
                  // //call web service check user password
                  // NetworkHelper networkHelper = NetworkHelper(
                  //     'login?Username=$username&Password=$password');
                  // var json = await networkHelper.getData();
                  // if (json == null) {
                  //   await showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) => AlertDialog(
                  //             title: const Text('Error'),
                  //             content: Text(
                  //                 'Can not connect server: ${globals.serverIP}'),
                  //             actions: <Widget>[
                  //               TextButton(
                  //                   child: const Text('Close'),
                  //                   onPressed: () {
                  //                     Navigator.pop(context);
                  //                   }),
                  //             ],
                  //           ));
                  // } else if (json['error'] == false) {
                  //   globals.memberID = json["user"]["id"];
                  //   Navigator.push(context,
                  //       MaterialPageRoute(builder: (context) => MainScreen()));
                  // } else {
                  //   await showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) => AlertDialog(
                  //             title: const Text('Error'),
                  //             content: const Text('Incorrect username or password'),
                  //             actions: <Widget>[
                  //               TextButton(
                  //                   child: const Text('Close'),
                  //                   onPressed: () {
                  //                     Navigator.pop(context);
                  //                   }),
                  //             ],
                  //           ));
                  // }
                  // setState(() {
                  //   showSpinner = false;
                  // });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
