import 'package:flutter/material.dart';
import 'package:futsal/home.dart';
import 'package:futsal/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getProfile(),
      builder: (
        BuildContext context,
        AsyncSnapshot<String> snapshot,
      ) {
        if (snapshot.hasData) {
          return Scaffold(
              appBar: AppBar(
                title: Text('My Profile'),
                backgroundColor: Colors.purple[900],
              ),
              body: Column(children: [
                Text("email:" + snapshot.data.toString()),
                ElevatedButton(
                  onPressed: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    pref.remove("email");
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) {
                      return Login();
                    }));
                  },
                  child: Text(
                    "Logout",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ]));
        } else {
          return Text('Loading data');
        }
      },
    );
  }

  getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString("email");
  }
}
