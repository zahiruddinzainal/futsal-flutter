import 'package:flutter/material.dart';
import 'package:futsal/home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constant.dart' as Constants;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 30),
            child: Container(
                width: 200,
                height: 150,
                /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                child: Image.network(
                    'https://malaysiagazette.com/wp-content/uploads/2020/03/uitm-681x384.png')),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text(
              "E-Futsal Pundana\nCourt Booking App",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                  border: OutlineInputBorder(),
                  hintText: 'Enter valid email address'),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                  border: OutlineInputBorder(),
                  hintText: 'Enter password'),
              obscureText: true,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[900],
                minimumSize: Size.fromHeight(
                    40), // fromHeight use double.infinity as width and 40 is the height
              ),
              onPressed: () async {
                var email = _emailController.text;
                var password = _passwordController.text;
                var url = "http://" +
                    Constants.LARAVEL_ENDPOINT_URL +
                    "/api/login/$email/$password";
                var response = await http.get(Uri.parse(url));
                if (response.statusCode == 200) {
                  print(response.statusCode);
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.setString("email", "useremail@gmail.com");
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Home()));
                } else {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 250,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.error_outline_rounded,
                                color: Colors.red,
                                size: 60,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Sorry, user not found!'),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[900],
                                      minimumSize: Size.fromHeight(
                                          40), // fromHeight use double.infinity as width and 40 is the height
                                    ),
                                    child: const Text('Close'),
                                    onPressed: () => Navigator.pop(context)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
              child: Text('Login'),
            ),
          ),
        ],
      ),
    );
  }
}
