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

  void getproduct() async {
    final products = await Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => Productpage())));
    print(products);
    setState(() {
      productlist.add(products);
    });
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
              height: 200,
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
                                productdetails.removeAt(index);
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
                              trailing: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        openPopUp(
                                            context, productlist[index], index),
                                  );
                                },
                                child: Text("Edit"),
                              ),
                            ),
                          )),
                    ),
            ),
            Container(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    productlist.isNotEmpty
                        ? 'Total Price: \$${calculatetotalprice(productdetails).toStringAsFixed(2)}'
                        : "",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    productlist.isNotEmpty
                        ? 'Tax amount: \$${calculatetaxamount(productdetails).toStringAsFixed(2)}'
                        : "",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  openPopUp(BuildContext context, product, int? index) {
    TextEditingController productcntrl =
        TextEditingController(text: product.title);
    TextEditingController pricecontroller =
        TextEditingController(text: "\$ ${product.price}");
    TextEditingController taxcontroller = TextEditingController();

    TextEditingController qtycontroller = TextEditingController();
    TextEditingController totalcontroller = TextEditingController();
    TextEditingController taxamound = TextEditingController();
    TextEditingController salesvalue = TextEditingController();
    if (index != null) {
      qtycontroller.text = productdetails[index].qty;
      totalcontroller.text = productdetails[index].total;
      taxcontroller.text = productdetails[index].tax;
      taxamound.text = productdetails[index].taxamound;
      salesvalue.text = productdetails[index].salesvalue;
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
                            value: index != null ? taxcontroller.text : null,
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
                      if (index == null) {
                        productdetails.add(ProductDetails(
                            name: name,
                            qty: qty,
                            price: price,
                            total: total,
                            tax: tax,
                            taxamound: taxamount,
                            salesvalue: sales));
                      } else {
                        productdetails[index].qty = qtycontroller.text;
                        productdetails[index].tax = taxcontroller.text;
                        productdetails[index].total = totalcontroller.text;
                        productdetails[index].taxamound = taxamound.text;
                        productdetails[index].salesvalue = salesvalue.text;
                      }
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
        taxamount += double.parse(element.taxamound);
      });
    }
    return taxamount;
  }
}
