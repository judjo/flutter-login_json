import 'package:flutter/material.dart';
// import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
// import 'package:barcode_scan/barcode_scan.dart';
//import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
 
 
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
 
 
class EntryData extends StatefulWidget {
  @override
  EntryDataState createState() => new EntryDataState();
}
 
class EntryDataState extends State<EntryData> {
 
  // text field
  final _nomerRakController = TextEditingController();
  final _namaProdukController = TextEditingController();
  // dropdown category
  List _category = ["Buah-buahan", "Snack", "Stationary", "Baju", "Ice Cream"];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentCategory;

  // radio
  String _radioValue1;

  // member simpan data
  String _response = '';
  bool apiCall = false;
 
  @override
  void initState() {
    super.initState();
    // dropdown category
    _dropDownMenuItems = getDropDownMenuItems();
    _currentCategory = _dropDownMenuItems[0].value;

  }
 
  // widget simpan data
  Widget getProperWidget(){
    if(apiCall)
      return AlertDialog(
        content: new Column(
          children: <Widget>[
            CircularProgressIndicator(),
            Text("Please wait")
          ],
        )
      );
    else
      return Center(
        child: Text(
          _response,
          style: new TextStyle(fontSize: 15.0)
        )
      );
  }
 
  void _callPostAPI() {
    post(
        "http://192.3.168.178/restapi/addproduct.php",
        {
          "nomor_rak": _nomerRakController.text,
          "nama_produk": _namaProdukController.text,
          "kategori": _currentCategory,

          "discount": _radioValue1
        }).then((response) {
 
          setState(() {
            apiCall = false;
            _response = response.message;
          });
 
        },
 
        onError: (error) {
          apiCall = false;
          _response = error.toString();
        }
    );
  }
 
  // dropdown category
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String kategori in _category) {
      items.add(new DropdownMenuItem(
          value: kategori,
          child: new Text(kategori)
      ));
    }
    return items;
  }
 
  void changedDropDownItem(String selectedCategory) {
    setState(() {
      _currentCategory = selectedCategory;
    });
  }
 
  // radio discount
  void _handleRadioValueChange1(String value) {
    setState(() {
      _radioValue1 = value;
    });
  }
 
  
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produk Entry'),
      ),
      body: SafeArea(
          child: ListView(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            children: <Widget>[
              // text field
              TextField(
                controller: _nomerRakController,
                decoration: InputDecoration(
                  filled: false,
                  labelText: 'Nomer Rak',
                ),
              ),
              // spacer
              SizedBox(height: 5.0),
              // text field
              TextField(
                controller: _namaProdukController,
                decoration: InputDecoration(
                  filled: false,
                  labelText: 'Nama Produk',
                ),
              ),
 
              // Dropdown
              new Container(
                padding: EdgeInsets.all(10.0),
                //color: Colors.blueGrey,
                child: new Row(
                  children: <Widget>[
                    new Text("Kategori: ", style: new TextStyle(fontSize: 15.0)),
                    new DropdownButton(
                      value: _currentCategory,
                      items: _dropDownMenuItems,
                      onChanged: changedDropDownItem,
                    )
                  ],
                ),
              ),
 
              // datepicker
              new Container(
                //padding: EdgeInsets.all(10.0),
                //color: Colors.blueGrey,
                child: new Row(
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Expired Date', style: new TextStyle(fontSize: 15.0)),
                      onPressed: () {
                        //_showDatePicker();
                      },
                    ),
                    new Text(" ", style: new TextStyle(fontSize: 15.0)),
                  ],
                ),
              ),
 
              // QR scanner
              new Container(
                //padding: EdgeInsets.all(10.0),
                //color: Colors.blueGrey,
                child: new Row(
                  children: <Widget>[
                    RaisedButton(
                      child: Text(' Scan Code  ', style: new TextStyle(fontSize: 15.0)),
                      onPressed: () {
                        //_scanQR();
                      },
                    ),
                    new Text(" ", style: new TextStyle(fontSize: 15.0)),
                  ],
                ),
              ),
 
              // Radio
              new Container(
                //padding: EdgeInsets.all(10.0),
                //color: Colors.blueGrey,
                child: new Row(
                  children: <Widget>[
                    new Radio(
                      value: "Discount",
                      groupValue: _radioValue1,
                      onChanged: _handleRadioValueChange1,
                    ),
                    new Text(
                      'Discount',
                      style: new TextStyle(fontSize: 15.0),
                    ),
                    new Radio(
                      value: "Non Discount",
                      groupValue: _radioValue1,
                      onChanged: _handleRadioValueChange1,
                    ),
                    new Text(
                      'Non Discount',
                      style: new TextStyle(fontSize: 15.0),
                    ),
                    ],
                ),
              ),
 
              // button
              RaisedButton(
                child: Text('SIMPAN'),
                onPressed: () {
 
                  setState((){
                    apiCall=true; // Set state like this
                  });
 
                  _callPostAPI();
                  },
 
              ),
 
              // POST Response
              getProperWidget(),
 
            ],
          )
      ),
    );
  }
}