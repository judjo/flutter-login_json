import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'entry.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_json/login.dart';
import 'login.dart';
 
class Product {
  final String id;
  final String nomorRak;
  final String namaProduk;
  final String kategori;
  final String expiredDate;
  final String scanCode;
  final String discount;
 
  Product({this.id, this.nomorRak, this.namaProduk, this.kategori,
    this.expiredDate, this.scanCode, this.discount});
 
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      nomorRak: json['nomor_rak'],
      namaProduk: json['nama_produk'],
      kategori: json['kategori'],
      expiredDate: json['expired_date'],
      scanCode: json['scan_code'],
      discount: json['discount'],
    );
  }
}
 
List<Product> parseProduct(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
 
  return parsed.map<Product>((json) => Product.fromJson(json)).toList();
}
 
Future<List<Product>> fetchProduct(http.Client client) async {
  final response =
  await client.get('http://192.3.168.178/restapi/getproduct.php');
 
  // Use the compute function to run parsePhotos in a separate isolate
  return compute(parseProduct, response.body);
}
 
 
class ProductListBuilder extends StatelessWidget {
  final List<Product> product;
  ProductListBuilder({Key key, this.product}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: product.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              ListTile(
                title: Text("${product[index].namaProduk}"),
                subtitle: Text(
                    "Kategori: ${product[index].kategori}\n" +
                        "Nomor Rak: ${product[index].nomorRak}\n" +
                        "Expired Date: ${product[index].expiredDate}\n" +
                        "Scan code: ${product[index].scanCode}\n" +
                        "Discount: ${product[index].discount}"
                ),
              ),
              Divider(),
            ],
          );
        }
    );
  }
}
 
class ListProduct extends StatefulWidget {
  @override
  ListProductState createState() => new ListProductState();
}
 
class ListProductState extends State<ListProduct> {
 
 
  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      appBar: AppBar(
        title: Text("Product List"),
      ),
      body: new ProductList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EntryData()),
          );
        },
        child: Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            // header
            UserAccountsDrawerHeader(
              accountName: Text('Yudi Santoso'),
              accountEmail: Text('yudi@gmail.com'),
              currentAccountPicture:
                  CircleAvatar (
                    backgroundImage: NetworkImage('https://cdn4.iconfinder.com/data/icons/basic-interface-overcolor/512/user-512.png'),
                  ),
              decoration: BoxDecoration(color: Colors.blueAccent),
            ),
 
            // menu
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              trailing: Icon(Icons.arrow_forward),
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text("Map"),
              trailing: Icon(Icons.arrow_forward),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Preferences"),
              trailing: Icon(Icons.arrow_forward),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Logout"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () async {
                // hapus shared prefs login
                // final prefs = await SharedPreferences.getInstance();
                // prefs.remove('login');
                final prefs = await SharedPreferences.getInstance();
                prefs.remove('login');
                // redirect page/route ke login
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                // redirect page/route ke login
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Login()),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}
 
class ProductList extends StatelessWidget {
  const ProductList({
    Key key,
  }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: fetchProduct(http.Client()),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
 
        return snapshot.hasData
            ? ProductListBuilder(product: snapshot.data)
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}