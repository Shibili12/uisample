import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uisample/model/productmodel.dart';

import 'package:http/http.dart' as http;

class Productpage extends StatefulWidget {
  Productpage({super.key});

  @override
  State<Productpage> createState() => _ProductpageState();
}

class _ProductpageState extends State<Productpage> {
  List<Product> productlist = [];
  @override
  void initState() {
    fetchdata();
    super.initState();
  }

  void fetchdata() async {
    var url = Uri.parse("https://dummyjson.com/products");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      Productmodel productmodel = Productmodel.fromJson(jsonData);
      setState(() {
        productlist = productmodel.products!;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: productlist.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: productlist.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    title: Text(productlist[index].title!),
                    subtitle: Text("${productlist[index].price!}"),
                    onTap: () {
                      Navigator.of(context).pop(productlist[index]);
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
