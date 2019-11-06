import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'list.dart';
 
// class response json
class Response {
  final String status;
  final String message;
 
  Response({this.status, this.message});
 
  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      status: json['status'],
      message: json['message'],
    );
  }
}
 
 
class Login extends StatefulWidget {
  @override
  LoginState createState() => new LoginState();
}
 
class LoginState extends State<Login> {
 
  // variabel member class
  final _username = TextEditingController();
  final _password = TextEditingController();
 
  // member response
  String _response = '';
  bool _apiCall = false;
 
  // login shared prefs
  bool alreadyLogin = false;
 
  // fungsi untuk kirim http post
  Future<Response> post(String url,var body)async{
    return await http
        .post(Uri.encodeFull(url), body: body, headers: {"Accept":"application/json"})
        .then((http.Response response) {
 
      final int statusCode = response.statusCode;
 
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return Response.fromJson(json.decode(response.body));
    });
  }
 
  // fungsi panggil API
  void _callPostAPI() {
    post(
        'http://192.3.168.178/restapi/login.php',
        {
          'username': _username.text,
          'password': _password.text
        }).then((response) async {
      // jika respon normal
      setState(() {
        _apiCall = false;
        _response = response.message;
      });
 
      if (response.status == "success") {
 
        // menuju route list product
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListProduct())
        );
      }
 
    },
        // jika respon error
        onError: (error) {
          _apiCall = false;
          _response = error.toString();
        }
    );
  }
 
  Widget progressWidget() {
    if (_apiCall)
      // jika masih proses kirim API
      return AlertDialog(
        content: new Column(
          children: <Widget>[
            CircularProgressIndicator(),
            Text("Please wait")
          ],
        ),
      );
    else
      // jika sudah selesai kirim API
      return Center(
        child: Text(
          _response,
          style: new TextStyle(fontSize: 15.0),
        ),
      );
  }
 
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("Login"),
      ),
      body: loginForm(),
    );
  }
 
  Widget loginForm() {
    return SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          children: <Widget>[
            // nama
            TextField(
              controller: _username,
              decoration: InputDecoration(
                  filled: true,
                  labelText: 'Username'
              ),
            ),
            // spasi
            SizedBox(height: 5.0),
            // alamat
            TextField(
              controller: _password,
              decoration: InputDecoration(
                  filled: true,
                  labelText: 'Password'
              ),
              obscureText: true,
            ),
            // spasi
            SizedBox(height: 10.0),
            // tombol
            RaisedButton(
              child: Text('LOGIN'),
              onPressed: () {
 
                setState(() {
                  _apiCall = true;
                });
                _callPostAPI();
/*
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text('Username: ${_username.text}\nPassword: ${_password.text}'),
                      );
                    },
                  );
*/
              },
            ),
 
            // panggil loading widget
            progressWidget()
          ],
        )
    );
  }
}