import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smurp_app/feed.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;


//  If starting the program here, creates the following page
void main() => runApp(new Login());


//  Has the page created and displays it
class Login extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Login',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }

}

// This has the page created
class LoginScreen extends StatefulWidget{
  @override
  State createState() => new _LoginScreenState();
}

//  This is the page body
class _LoginScreenState extends State<LoginScreen>{
  //  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  String _username = "works";
  String _password = "filler";

  var userData;
  String endPtData = "{Failure : Default Value}";
  List data;


  // Builds the body of the page
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      backgroundColor: Colors.lightBlueAccent,
      body: new Container(
        padding: const EdgeInsets.all(30.0),
        child: new Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new FlutterLogo(size: 60.0),  // This is filler for if we were to have our own icon/logo
              new TextFormField(    // This is for inputting username
                decoration: new InputDecoration(
                  labelText: "Enter Username"
                ),
                keyboardType: TextInputType.text,
                validator: validateUsername,
                onSaved: (String val) {
                  _username = val;
                },
              ),
              new TextFormField(    // This is for inputting password. Text is obfuscated for privacy
                decoration: new InputDecoration(
                    labelText: "Enter Password"
                ),
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: validatePassword,
                onSaved: (String val) {
                  _password = val;
                },
              ),
              new Padding(
                  padding: const EdgeInsets.all(20.0)
              ),
              new RaisedButton(     // This puts the login button
                onPressed: _validateInputs, // login button gets the process of logging in moving
                child: new Text("Log in")
              ),
            ]
          )
        )
      ),
    );
  }

   /*
      Takes the text in the username and password input fields, sends them off to the database.
      If the database approves, user is logged in and moves to feed page.
      If the database rejects, the error message is displayed to the user and they can try again.
   */
  _validateInputs() {
    if (_formKey.currentState.validate()) {
      sleep(const Duration(seconds:1));
      _formKey.currentState.save();
      this.getLoginData();    // Have data sent off to database
      print('hold on a sec...');
      sleep(const Duration(seconds:3));   // Wait for response from database

      // receive the database's response.
      // If it has a problem, reject login and show user what was wrong
      // Else, go forward with logging in
      String loginResponse = endPtData.substring(1, 10).toLowerCase();
      print(userData == null ? 'Null userdata' : userData);
      print('endpointdata: '+endPtData);
      print('loginResponse: '+loginResponse);
      print('Checking response ' + loginResponse.contains('failure').toString());

      if(loginResponse.contains('failure')){  //  If the response returns a login failure
        print('Wrong Data');
          return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text(endPtData)
            );
          }
        );
      }
      else {  // Inputs were valid
        print('Correct Data');
        sleep(const Duration(seconds:1));   // Wait for everything to catch up
        print(userData == null ? 'Null userdata' : userData);
        // Store information (in globals)
        globals.username = userData["username"] == null ? " " : userData["username"].trim();
        globals.lastfm_name = userData["lastfm_name"] == null ? " " : userData["lastfm_name"].trim();
        globals.joindate = userData["join_date"] == null ? " " : userData["join_date"].trim();
        globals.user_id = userData["user_id"] == null ? " " : userData["user_id"];
        globals.session_key = userData["session_key"] == null ? " " : userData["session_key"].trim();
        globals.isLoggedIn = true;
        print('storing data as: '+globals.username+' and '+
            globals.lastfm_name +' and '+
            globals.joindate +' and '+
            globals.user_id.toString()+' and '+
            globals.isLoggedIn.toString());

        // Add countdown+pause so everything can catch up. Then move to feed page
        print('registered data. starting new screen in 3...2..1.');
        sleep(const Duration(seconds:3));
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new FeedPage()));
      }

    } else {
      //  If all data are not valid then start auto validation
      //  This means as the user types again it tells them if their inputs are valid

      setState(() {
        _autoValidate = true;
      });
      return null;
    }
  }



  // Validates username as it is input
  String validateUsername(String value) {
    if (value.length < 1)
      return 'Please enter a username';
    else
      return null;
  }

  // Validates password as it is input
  String validatePassword(String value) {
    if (value.length < 1)
      return 'Please enter a password';
    else
      return null;
  }

  //  Async call to get data from endpoint
  void getLoginData() async {
    print("Is that an endpoint i see? ");
    http.Response response = await http.get(
        "http://ec2-52-91-42-119.compute-1.amazonaws.com:5000/loginuser?username="+_username+"&password="+_password
    );

    setState(() {
      userData = json.decode(response.body);  // Receive the endpoint

      endPtData = userData.toString();  // Save its (parsed) message
      print('ayy we got a respnse');
      print(endPtData);   // Print out said message
    });
  }

}












