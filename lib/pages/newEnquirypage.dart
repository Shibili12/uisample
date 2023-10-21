import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uisample/pages/productPage.dart';
import 'package:uisample/productdetails.dart';

class Newenquiry extends StatefulWidget {
  const Newenquiry({super.key});

  @override
  State<Newenquiry> createState() => _NewenquiryState();
}

class _NewenquiryState extends State<Newenquiry> {
  TextEditingController dateinput = TextEditingController();
  TextEditingController expdate = TextEditingController();
  TextEditingController timecontroller = TextEditingController();
  TextEditingController producttext = TextEditingController();
  var productlist = [];
  List<ProductDetails> productdetails = List.empty(growable: true);
  String discountType = 'percentage';
  double discountValue = 0.0;

  void getproduct() async {
    final products = await Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => Productpage())));

    if (products != null) {
      setState(() {
        productlist.add(products);
        ProductDetails productDetails = ProductDetails(
            name: products.title,
            qty: '0',
            price: products.price.toString(),
            total: '0',
            tax: '5',
            taxamound: '0',
            salesvalue: '0');
        productdetails.add(productDetails);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Lead"),
        actions: [
          Icon(Icons.mic),
          SizedBox(
            width: 10,
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "SAVE",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Primary Number"),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Name",
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Secondary Number"),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Whatsapp Number",
                    ),
                  ),
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Outside Country Mob"),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Email",
                    ),
                  ),
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: dateinput,
                      decoration: InputDecoration(
                        labelText: "Follow.Date",
                        suffixIcon: Icon(Icons.calendar_month),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2050));
                        if (pickedDate != null) {
                          dateinput.text =
                              DateFormat('dd MMMM yyyy').format(pickedDate);
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        controller: timecontroller,
                        decoration: const InputDecoration(
                          labelText: "Follow.Time",
                          suffixIcon: Icon(Icons.alarm),
                        ),
                        onTap: () async {
                          var time = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          if (time != null) {
                            timecontroller.text = time.format(context);
                          }
                        }),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: expdate,
                      decoration: InputDecoration(
                        labelText: "Exp closure",
                        suffixIcon: Icon(Icons.calendar_month),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2050));
                        if (pickedDate != null) {
                          expdate.text =
                              DateFormat('dd MMMM yyyy').format(pickedDate);
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Source",
                      hintText: "Source",
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.keyboard_arrow_down),
                      ),
                    ),
                  ),
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Assigned user",
                      hintText: "Abhilash",
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.keyboard_arrow_down),
                      ),
                    ),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Tag user",
                      hintText: "Select",
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.keyboard_arrow_down),
                      ),
                    ),
                  ),
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Location",
                      suffixIcon: Icon(Icons.location_on),
                    ),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      labelText: "Reffered by",
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: producttext,
                    decoration: const InputDecoration(
                      labelText: "Products",
                    ),
                    onTap: () {
                      getproduct();
                    },
                  ),
                )),
              ],
            ),
            Container(
              height: 150,
              child: productlist.isEmpty
                  ? Container()
                  : ListView.builder(
                      itemCount: productlist.length,
                      itemBuilder: ((context, index) => Dismissible(
                            key: Key("${productlist[index].id}"),
                            background: Container(
                              color: Colors.red,
                              child: Center(
                                child: Text("DELETE"),
                              ),
                            ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              setState(() {
                                productlist.removeAt(index);

                                if (index >= 0 &&
                                    index < productdetails.length) {
                                  productdetails.removeAt(index);
                                } else {
                                  // Handle the case where index is out of bounds (invalid)
                                  print('Invalid index: $index');
                                }
                              });
                            },
                            child: ListTile(
                              title: Text(productlist[index].title ?? ""),
                              subtitle: Text(
                                  "Price:${productlist[index].price}" ?? ""),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => openPopUp(
                                      context, productlist[index], null),
                                );
                              },
                              trailing: Container(
                                width: 200,
                                child: Row(
                                  children: [
                                    productdetails.isNotEmpty
                                        ? Expanded(
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    decreaseQuantity(index);
                                                  },
                                                  icon: Icon(Icons
                                                      .keyboard_arrow_left),
                                                ),
                                                Text(productdetails[index].qty),
                                                IconButton(
                                                  onPressed: () {
                                                    increaseQuantity(index);
                                                  },
                                                  icon: Icon(Icons
                                                      .keyboard_arrow_right),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox(),
                                    ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              openPopUp(
                                                  context,
                                                  productlist[index],
                                                  productdetails[index]),
                                        );
                                      },
                                      child: Text("Edit"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ),
            ),
            Container(
              height: 90,
              child: Column(
                children: [
                  productlist.isNotEmpty
                      ? Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Radio(
                              value: 'percentage',
                              groupValue: discountType,
                              onChanged: (String? value) {
                                setState(() {
                                  discountType = value!;
                                });
                              },
                            ),
                            Text('Percentage'),
                            Radio(
                              value: 'amount',
                              groupValue: discountType,
                              onChanged: (String? value) {
                                setState(() {
                                  discountType = value!;
                                });
                              },
                            ),
                            Text('Amount'),
                            SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 100,
                              height: 45,
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: "Discount",
                                ),
                                keyboardType:
                                    TextInputType.number, // Allow numeric input
                                onChanged: (value) {
                                  // Parse the discount value as a double
                                  setState(() {
                                    discountValue =
                                        double.tryParse(value) ?? 0.0;
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        productlist.isNotEmpty
                            ? 'Grand Total(${productdetails.length} items):${calculateDiscount()} '
                            : "",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 18),
                      ),
                      // Text(
                      //   productlist.isNotEmpty
                      //       ? 'Tax amount: \$${calculatetaxamount(productdetails).toStringAsFixed(2)}'
                      //       : "",
                      //   style: TextStyle(fontWeight: FontWeight.bold),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  openPopUp(BuildContext context, product, details) {
    TextEditingController productcntrl =
        TextEditingController(text: product.title);
    TextEditingController pricecontroller =
        TextEditingController(text: "${product.price}");
    TextEditingController taxcontroller = TextEditingController();

    TextEditingController qtycontroller = TextEditingController();
    TextEditingController totalcontroller = TextEditingController();
    TextEditingController taxamound = TextEditingController();
    TextEditingController salesvalue = TextEditingController();
    if (details != null) {
      qtycontroller.text = details.qty ?? "";
      totalcontroller.text = details.total ?? "";
      taxcontroller.text = details.tax ?? "";
      taxamound.text = details.taxamound ?? "";
      salesvalue.text = details.salesvalue ?? "";
    }

    return AlertDialog(
      content: SizedBox(
        height: 370,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: productcntrl,
                decoration: const InputDecoration(
                  labelText: "                   product",
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: qtycontroller,
                      decoration: InputDecoration(
                        labelText: "QTY",
                      ),
                      onChanged: (value) {
                        setState(() {
                          totalcontroller.text =
                              "${int.parse(qtycontroller.text) * product.price}";
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: pricecontroller,
                      decoration: InputDecoration(
                        labelText: "Price",
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: totalcontroller,
                      decoration: const InputDecoration(
                        labelText: "Total",
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: taxcontroller,
                        decoration: InputDecoration(
                          // labelText: 'Tax %',
                          suffixIcon: DropdownButtonFormField(
                            value: details != null ? taxcontroller.text : null,
                            decoration: const InputDecoration(
                              labelText: 'Tax %',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                taxcontroller.text = newValue!;
                                taxamound.text =
                                    "${product.price * int.parse(taxcontroller.text) / 100}";
                                salesvalue.text =
                                    "${int.parse(qtycontroller.text) * double.parse(taxamound.text) + int.parse(totalcontroller.text)}";
                              });
                            },
                            items: <String>['5', '10', '15']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      )),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: taxamound,
                      decoration: const InputDecoration(
                        labelText: "Tax amount",
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: salesvalue,
                      decoration: const InputDecoration(
                        labelText: "Sales value",
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    String name = productcntrl.text;
                    String qty = qtycontroller.text;
                    String price = pricecontroller.text;
                    String total = totalcontroller.text;
                    String tax = taxcontroller.text;
                    String taxamount = taxamound.text;
                    String sales = salesvalue.text;

                    setState(() {
                      if (productdetails.isEmpty ||
                          productdetails.length < productlist.length) {
                        // Adding a new product
                        ProductDetails newProduct = ProductDetails(
                          name: name,
                          qty: qty,
                          price: price,
                          total: total,
                          tax: tax,
                          taxamound: taxamount,
                          salesvalue: sales,
                        );
                        productdetails.add(newProduct);
                      } else {
                        // Updating existing product

                        details.qty = qtycontroller.text;
                        details.tax = taxcontroller.text;
                        details.total = totalcontroller.text;
                        details.taxamound = taxamound.text;
                        details.salesvalue = salesvalue.text;
                      }

                      print("Index: $productdetails");
                      print("ProductDetails Length: ${productdetails}");
                    });

                    Navigator.of(context).pop();
                  },
                  child: Text(productdetails.isEmpty ? "ADD" : "UPDATE"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("cancel"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double calculatetotalprice(List<ProductDetails> productdetails) {
    double total = 0.0;
    for (var element in productdetails) {
      setState(() {
        total += double.parse(element.total);
      });
    }
    return total;
  }

  double calculatetaxamount(List<ProductDetails> productdetails) {
    double taxamount = 0.0;
    for (var element in productdetails) {
      setState(() {
        taxamount +=
            double.parse(element.taxamound) * double.parse(element.qty);
      });
    }
    return taxamount;
  }

  void increaseQuantity(int index) {
    setState(() {
      try {
        int currentQty = int.parse(productdetails[index].qty);
        currentQty++;
        productdetails[index].qty = currentQty.toString();

        // Recalculate the total and other related fields
        int price = int.parse(productdetails[index].price.replaceAll(r'$', ''));
        int newTotal = currentQty * price;
        double taxPercentage = double.parse(productdetails[index].tax);
        double taxAmount = (taxPercentage / 100) * price;
        double salesValue = newTotal + taxAmount;

        productdetails[index].total = newTotal.toStringAsFixed(2);
        productdetails[index].taxamound = taxAmount.toStringAsFixed(2);
        productdetails[index].salesvalue = salesValue.toStringAsFixed(2);
      } catch (e) {
        print(e);
      }
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      try {
        int currentQty = int.parse(productdetails[index].qty);
        if (currentQty > 1) {
          currentQty--;
          productdetails[index].qty = currentQty.toString();
          // Recalculate the total and other related fields
          int price =
              int.parse(productdetails[index].price.replaceAll(r'$', ''));
          int newTotal = currentQty * price;
          double taxPercentage = double.parse(productdetails[index].tax);
          double taxAmount = (taxPercentage / 100) * price;
          double salesValue = newTotal + taxAmount;

          productdetails[index].total = newTotal.toStringAsFixed(2);
          productdetails[index].taxamound = taxAmount.toStringAsFixed(2);
          productdetails[index].salesvalue = salesValue.toStringAsFixed(2);
        }
      } catch (e) {
        print(e);
      }
    });
  }

  double calculateDiscount() {
    double originalPrice = calculatetotalprice(productdetails) +
        calculatetaxamount(productdetails); // Example original price
    double discountedPrice;
    if (discountType == 'percentage') {
      discountedPrice = originalPrice - (originalPrice * discountValue / 100);
    } else {
      discountedPrice = originalPrice - discountValue;
    }
    return discountedPrice;
  }
}
