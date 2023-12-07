import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:uisample/model/product.dart';
import 'package:uisample/model/productmodel.dart';

import 'package:http/http.dart' as http;

class Productpage extends StatefulWidget {
  Productpage({super.key});

  @override
  State<Productpage> createState() => _ProductpageState();
}

class _ProductpageState extends State<Productpage> {
  late List<Product> productlist = [];
  TextEditingController serchcontroller = TextEditingController();
  // List<Product> selectedProducts = [];
  List<Product> selectedProducts = [];
  late Box<ProductDb> productBox;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController _qrViewController;

  Future fetchAndCacheData() async {
    if (productBox.isNotEmpty) {
      print("Hi");
      setState(() {
        productlist = productBox.values.map((productDb) {
          return Product(
            id: productDb.id,
            title: productDb.title,
            price: productDb.price,
            isSelected: productDb.isSelected,
          );
        }).toList();
      });
    } else {
      var url = Uri.parse("https://dummyjson.com/products");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        Productmodel productmodel = Productmodel.fromJson(jsonData);
        setState(() {
          productlist = productmodel.products!;

          productBox.clear();
          productBox.addAll(productlist.map((product) {
            return ProductDb(
              id: product.id!,
              title: product.title!,
              price: product.price!,
              isSelected: product.isSelected,
            );
          }));
        });
      }
    }
    return productlist;
  }

  @override
  void initState() {
    super.initState();
    Hive.openBox<ProductDb>('productBox').then((box) {
      productBox = box;
      // Fetch and update products here.
      // productBox.clear();

      fetchAndCacheData();
      // print("Productbox length:" + productBox.values.length.toString());
    });
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
                child: Row(
                  children: [
                    Expanded(
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
                    IconButton(
                      onPressed: () async {
                        String scannedResult = await _scanQR();
                        if (scannedResult.isNotEmpty) {
                          setState(() {
                            serchcontroller.text = scannedResult;
                          });
                          searchProduct(scannedResult);
                        }
                      },
                      icon: Icon(Icons.qr_code),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: FutureBuilder(
                  future: Future(() => productlist),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      // print(
                      //     "Productbox :" + productBox.values.length.toString());
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
                                final product = snapshot.data![index];
                                setState(() {
                                  if (value == true) {
                                    selectedProducts.add(product);
                                    product.isSelected = true;
                                  } else {
                                    selectedProducts.remove(product);
                                    product.isSelected = false;
                                  }
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

  Future<String> _scanQR() async {
    String scannedResult = "";
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          child: QRView(
            key: _qrKey,
            onQRViewCreated: (QRViewController controller) {
              setState(() {
                _qrViewController = controller;
              });
              controller.scannedDataStream.listen((scanData) {
                scannedResult = scanData.code ?? "";
                _qrViewController.pauseCamera();
                Navigator.pop(context, scannedResult);
              });
            },
          ),
        );
      },
    );
    return scannedResult;
  }
}
