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
  // List<Product> selectedProducts = [];
  Set<Product> selectedProducts = {};

  Future<List<Product>> fetchdata() async {
    var url = Uri.parse("https://dummyjson.com/products");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      Productmodel productmodel = Productmodel.fromJson(jsonData);
      setState(() {
        productlist = productmodel.products!;
        // for (var product in productlist) {
        //   product.isSelected = selectedProductsMap[product.id] ?? false;
        // }
      });
      return productlist;
    } else {
      return productlist;
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
              child: FutureBuilder(
                  future: fetchdata(),
                  builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: productlist.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            title: Text(snapshot.data![index].title.toString()),
                            subtitle:
                                Text(snapshot.data![index].price.toString()),
                            trailing: Checkbox(
                              value: selectedProducts
                                  .contains(snapshot.data![index]),
                              onChanged: (bool? value) {
                                setState(() {
                                  final product = snapshot.data![index];
                                  print(
                                      "Checkbox changed for: ${snapshot.data![index].title}");
                                  if (value == true &&
                                      !selectedProducts.contains(product)) {
                                    selectedProducts.add(product);
                                    product.isSelected = true;
                                  } else {
                                    selectedProducts.remove(product);
                                    product.isSelected = false;
                                  }

                                  // getSelectedProducts();
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    }
                  }),
            ),
            Expanded(
                child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 8,
                  bottom: 8,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    print(selectedProducts.length);

                    Navigator.of(context).pop(
                      selectedProducts.toList(),
                    );
                  },
                  child: Text("ADD"),
                ),
              ),
            )),
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

  // void getSelectedProducts() {
  //   selectedProducts.clear();
  //   for (var product in productlist) {
  //     // if (selectedProducts.contains(product)) {
  //     //   selectedProducts.clear();
  //     // }
  //     if (product.isSelected) {
  //       selectedProducts.add(product);
  //     }
  //   }

  //   print("Selected products count: ${selectedProducts.length}");
  //   for (var product in selectedProducts) {
  //     print("Selected product: ${product.title}");
  //   }
  // }
}
