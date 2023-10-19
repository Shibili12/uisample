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
  TextEditingController serchcontroller = TextEditingController();
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
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: serchcontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: "Search here",
                    suffixIcon: Icon(Icons.search),
                  ),
                  onChanged: searchProduct,
                ),
              ),
            ),
            Expanded(
                flex: 8,
                child: SizedBox(
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
                ))
          ],
        ),
      ),
    );
  }

  void searchProduct(String query) {
    final suggestions = productlist.where((product) {
      final productTitle = product.title!.toLowerCase();
      final input = query.toLowerCase();
      return productTitle.contains(input);
    }).toList();
    setState(() {
      productlist = suggestions;
    });
  }
}
