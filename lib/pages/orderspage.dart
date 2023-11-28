import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uisample/model/client.dart';
import 'package:uisample/model/enquiry.dart';
import 'package:uisample/model/orderproducts.dart';
import 'package:uisample/model/orders.dart';
import 'package:uisample/model/selectedproduct.dart';
import 'package:uisample/pages/productPage.dart';
import 'package:uisample/productdetails.dart';

class Orderspage extends StatefulWidget {
  List<Enquiry>? enquiries;
  Orderspage({super.key, this.enquiries});

  @override
  State<Orderspage> createState() => _OrderspageState();
}

class _OrderspageState extends State<Orderspage> with TickerProviderStateMixin {
  TextEditingController dateinput = TextEditingController();
  TextEditingController expdate = TextEditingController();
  TextEditingController timecontroller = TextEditingController();
  TextEditingController producttext = TextEditingController();
  TextEditingController primary = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController secondary = TextEditingController();
  TextEditingController whatsapp = TextEditingController();
  TextEditingController outside = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController refered = TextEditingController();
  TextEditingController taguser = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController source = TextEditingController();
  TextEditingController assigned = TextEditingController();
  late AnimationController _popupController;
  late Animation<double> _popupScaleAnimation;
  List<ProductDetails> productdetails = List.empty(growable: true);
  final _formKey = GlobalKey<FormState>();
  late Box<Orderproducts> selectedProductsBox;
  List<Orderproducts> productSelected = [];
  String discountType = 'percentage';
  double discountValue = 0.0;
  late Box<Order> orderBox;
  List<Order> saveddata = [];
  late Box<Enquiry> enquiryBox;
  List<Enquiry> savedenquiry = [];
  late Box<Selectedproducts> selectedProductBx;
  List<Selectedproducts> productSelectedbx = [];
  List<ClientDb> clients = [];
  String? dropdownClient;

  Future<void> getproduct() async {
    final products = await Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => Productpage())));

    if (products != null) {
      setState(() {
        // productlist = products;
        // final enquiryList = enquiryBox.values.toList();

        for (var selectedProduct in products) {
          ProductDetails productDetails = ProductDetails(
              name: selectedProduct.title!,
              qty: '0',
              price: selectedProduct.price.toString(),
              total: '0',
              tax: '5',
              taxamound: '0',
              salesvalue: '0');
          productdetails.add(productDetails);
        }
      });
    }
  }

  Future<void> loadClientfromhive() async {
    var clientbox = await Hive.openBox<ClientDb>('client');
    setState(() {
      clients = clientbox.values.toList();
      dropdownClient = clients.isNotEmpty ? clients[0].name : null;
    });
  }

  Future<void> _initializeHive() async {
    await Hive.initFlutter();
    await Hive.openBox<Order>('order');
    await Hive.openBox<Orderproducts>('orderproducts');
    enquiryBox = Hive.box<Enquiry>('enquiryBox');
    savedenquiry = enquiryBox.values.toList();
    selectedProductBx = Hive.box<Selectedproducts>('selectedProducts');
    orderBox = Hive.box<Order>('order');
    saveddata = orderBox.values.toList();
    selectedProductsBox = Hive.box<Orderproducts>('orderproducts');
    print("order Box Length : " + orderBox.length.toString());
    print("selelected Box Length : " + selectedProductsBox.length.toString());
    // enquiryBox.clear();
    // selectedProductsBox.clear();
    setState(() {});
    if (widget.enquiries != null) {
      retrieveDataFromHive();
      await retrieveSelectedProductsFromHive();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeHive();
    loadClientfromhive();
    _popupController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    // Initialize the scale animation
    _popupScaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _popupController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Order"),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                print('Form is valid!');
                if (widget.enquiries != null) {
                  saveordertoHive();
                }
                saveSelectedProductsToHive(productdetails);
                Navigator.of(context).pop();
              }
            },
            child: const Text(
              "SAVE",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: primary,
                      decoration:
                          const InputDecoration(labelText: "Primary Number"),
                      validator: (value) {
                        if (value!.length < 10 || value.isEmpty) {
                          return 'Primary Number is required';
                        }

                        return null;
                      },
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: name,
                      decoration: const InputDecoration(
                        labelText: "Name",
                        suffixIcon: Icon(Icons.search),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter valid name';
                        }

                        return null;
                      },
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
                      controller: secondary,
                      decoration:
                          const InputDecoration(labelText: "Secondary Number"),
                      validator: (value) {
                        if (value!.length < 10 || value.isEmpty) {
                          return 'secondary Number is required';
                        }

                        return null;
                      },
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: whatsapp,
                      decoration: const InputDecoration(
                        labelText: "Whatsapp Number",
                      ),
                      validator: (value) {
                        if (value!.length < 10 || value.isEmpty) {
                          return 'Whatsapp Number is required';
                        }

                        return null;
                      },
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
                      controller: outside,
                      decoration: const InputDecoration(
                          labelText: "Outside Country Mob"),
                      validator: (value) {
                        if (value!.length < 10 || value.isEmpty) {
                          return 'outside country mob is required';
                        }

                        return null;
                      },
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: email,
                      decoration: const InputDecoration(
                        labelText: "Email",
                      ),
                      validator: (value) {
                        if (!value!.contains("@") || value.isEmpty) {
                          return 'enter valid email';
                        }

                        return null;
                      },
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
                        decoration: const InputDecoration(
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'select date';
                          }

                          return null;
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
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'select time';
                          }

                          return null;
                        },
                      ),
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
                        decoration: const InputDecoration(
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'select date';
                          }

                          return null;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: source,
                      decoration: InputDecoration(
                        labelText: "Source",
                        hintText: "Source",
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.keyboard_arrow_down),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'enter valid source';
                        }

                        return null;
                      },
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'enter valid source';
                        }

                        return null;
                      },
                      controller: assigned,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            List<ClientDb> filteredClients = List.from(clients);
                            return StatefulBuilder(
                              builder: (context, setState) => Column(
                                children: [
                                  Container(
                                    height: 70,
                                    color: Colors.blue,
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "Assigned user",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: TextField(
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: 'Search...',
                                                suffixIcon: Icon(Icons.search),
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  filteredClients = clients
                                                      .where((client) => client
                                                          .name
                                                          .toLowerCase()
                                                          .contains(value
                                                              .toLowerCase()))
                                                      .toList();
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.separated(
                                      itemCount: filteredClients.length,
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              const Divider(
                                        thickness: 2,
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        ClientDb client =
                                            filteredClients[index];
                                        return ListTile(
                                          title: Text(client.name),
                                          onTap: () {
                                            setState(() {
                                              dropdownClient = client.name;
                                              assigned.text = dropdownClient!;
                                            });
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      decoration: InputDecoration(
                        labelText: "Assigned user",
                        hintText: dropdownClient,
                        suffixIcon: const Icon(Icons.keyboard_arrow_down),
                      ),
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: taguser,
                      decoration: const InputDecoration(
                        labelText: "tag user",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'enter valid details';
                        }

                        return null;
                      },
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
                      controller: location,
                      decoration: const InputDecoration(
                        labelText: "Location",
                        suffixIcon: Icon(Icons.location_on),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'select location';
                        }
                        // Add more specific validation logic if needed
                        return null;
                      },
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: refered,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        labelText: "Reffered by",
                        suffixIcon: const Icon(Icons.search),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'select refered by';
                        }
                        // Add more specific validation logic if needed
                        return null;
                      },
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
                      onTap: () async {
                        if (widget.enquiries == null) {
                          saveordertoHive();
                          await getproduct();
                        } else {
                          await getproduct();
                        }
                      },
                    ),
                  )),
                ],
              ),
              SizedBox(
                height: 150,
                child: productdetails.isEmpty
                    ? Container()
                    : SingleChildScrollView(
                        child: Column(
                          children: productdetails.asMap().entries.map((entry) {
                            final index = entry.key;
                            final selectedproduct = entry.value;
                            return Dismissible(
                              key: Key("${selectedproduct.name}"),
                              background: Container(
                                color: Colors.red,
                                child: const Center(
                                  child: Text("DELETE"),
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                setState(() {
                                  if (index >= 0 &&
                                      index < productdetails.length) {
                                    productdetails.removeAt(index);
                                    selectedProductsBox.deleteAt(index);
                                    // productSelected.removeAt(index);
                                  } else {
                                    print('Invalid index: $index');
                                  }
                                });
                              },
                              child: ListTile(
                                title: Text(selectedproduct.name),
                                subtitle:
                                    Text("Price:${selectedproduct.price}"),
                                // onTap: () {
                                //   showDialog(
                                //     context: context,
                                //     builder: (BuildContext context) =>
                                //         openPopUp(context, selectedproduct),
                                //   );
                                // },
                                trailing: SizedBox(
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
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_left),
                                                  ),
                                                  Text(productdetails[index]
                                                      .qty),
                                                  IconButton(
                                                    onPressed: () {
                                                      increaseQuantity(index);
                                                    },
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_right),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox(),
                                      ElevatedButton(
                                        onPressed: () {
                                          _popupController.forward();
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return StatefulBuilder(
                                                builder: (context, setState) {
                                                  return AnimatedBuilder(
                                                    animation: _popupController,
                                                    builder: (context, child) {
                                                      return Transform.scale(
                                                        scale:
                                                            _popupScaleAnimation
                                                                .value,
                                                        child: openPopUp(
                                                            context,
                                                            productdetails[
                                                                index]),
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          ).then((value) {
                                            _popupController.reset();
                                          });
                                        },
                                        child: const Text("Edit"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
              ),
              SizedBox(
                height: 90,
                child: Column(
                  children: [
                    productdetails.isNotEmpty
                        ? Row(
                            children: [
                              const SizedBox(
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
                              const Text('Percentage'),
                              Radio(
                                value: 'amount',
                                groupValue: discountType,
                                onChanged: (String? value) {
                                  setState(() {
                                    discountType = value!;
                                  });
                                },
                              ),
                              const Text('Amount'),
                              const SizedBox(
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
                                  keyboardType: TextInputType
                                      .number, // Allow numeric input
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
                        : const SizedBox(),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          productdetails.isNotEmpty
                              ? 'Grand Total(${productdetails.length} items):${calculateDiscount()} '
                              : "",
                          style: const TextStyle(
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
      ),
    );
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

  double calculatetotalprice(List<ProductDetails> productdetails) {
    double total = 0.0;
    for (var element in productdetails) {
      setState(() {
        total += double.parse(element.salesvalue);
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

  double calculateDiscount() {
    double originalPrice = calculatetotalprice(productdetails);
    //  + calculatetaxamount(productdetails); // Example original price
    double discountedPrice;
    if (discountType == 'percentage') {
      discountedPrice = originalPrice - (originalPrice * discountValue / 100);
    } else {
      discountedPrice = originalPrice - discountValue;
    }
    return discountedPrice;
  }

  openPopUp(BuildContext context, details) {
    TextEditingController productcntrl =
        TextEditingController(text: details.name);
    TextEditingController pricecontroller =
        TextEditingController(text: "${details.price}");
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
    void _updateTax(String selectedTaxPercentage) {
      setState(() {
        try {
          taxcontroller.text = selectedTaxPercentage;

          double price = double.parse(details.price);
          int taxValue = int.parse(taxcontroller.text);
          print("tax" + taxValue.toString());
          double amount = price * (taxValue / 100);

          taxamound.text =
              "${(int.parse(qtycontroller.text) * amount).toStringAsFixed(2)}";

          // Convert to string to avoid formatting issues
          salesvalue.text =
              "${(amount + double.parse(totalcontroller.text)).toString()}";
        } catch (e) {
          print("Error parsing values in _updateTax: $e");
        }
      });
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
                              "${int.parse(qtycontroller.text) * details.price}";
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
                          suffixIcon: AnimatedBuilder(
                            animation: _popupController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _popupScaleAnimation.value,
                                child: child,
                              );
                            },
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      // Adjust the container's height and styling as needed
                                      height: 200,
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: Text('5%'),
                                            onTap: () {
                                              _updateTax('5');
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            title: Text('10%'),
                                            onTap: () {
                                              _updateTax('10');
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            title: Text('15%'),
                                            onTap: () {
                                              _updateTax('15');
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: TextField(
                                enabled:
                                    false, // To make the field non-editable
                                controller: taxcontroller,
                                decoration: InputDecoration(
                                  labelText: 'Tax %',
                                  suffixIcon: Icon(Icons.keyboard_arrow_down),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
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
                    var equid;

                    for (var key in enquiryBox.keys) {
                      equid = key.toString();
                    }

                    setState(() {
                      if (productdetails.isEmpty) {
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
                        // Updating existing product in the list
                        for (int i = 0; i < productdetails.length; i++) {
                          if (productdetails[i].name == details.name) {
                            productdetails[i].qty = qty;
                            productdetails[i].price = price;
                            productdetails[i].total = total;
                            productdetails[i].tax = tax;
                            productdetails[i].taxamound = taxamount;
                            productdetails[i].salesvalue = sales;
                            break;
                          }
                        }

                        // Updating existing product in the box (selectedProductsBox)
                        Orderproducts model = Orderproducts(
                          title: name,
                          price: int.parse(price),
                          total: total,
                          tax: tax,
                          taxamound: taxamount,
                          salesvalue: sales,
                          qty: qty,
                          orderid: equid,
                        );

                        selectedProductsBox.put(equid, model);
                      }

                      print("Index: $productdetails");
                      print("ProductDetails Length: ${productdetails}");
                    });

                    _popupController.reverse();
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

  void saveordertoHive() async {
    final primarynumber = primary.text;
    final leadname = name.text;
    final secondarynumber = secondary.text;
    final whatsappnumber = whatsapp.text;
    final outsideno = outside.text;
    final emailid = email.text;
    final followdate = dateinput.text;
    final followtime = timecontroller.text;
    final expclosure = expdate.text;
    final sources = source.text;
    final assigneduser = assigned.text;
    final tag = taguser.text;
    final loc = location.text;
    final refer = refered.text;

    final ordermodel = Order(
        primarynumber: primarynumber,
        name: leadname,
        secondarynumber: secondarynumber,
        whatsappnumber: whatsappnumber,
        outsidemob: outsideno,
        followdate: followdate,
        followtime: followtime,
        expclosure: expclosure,
        source: sources,
        assigneduser: assigneduser,
        taguser: tag,
        location: loc,
        referedby: refer,
        email: emailid);
    await orderBox.add(ordermodel);
    print("enquiryBox" + orderBox.toString());
    print("selected:" + productSelected.toString());
    setState(() {
      saveddata.add(ordermodel);
      print(saveddata.length);
    });
  }

  Future<void> saveSelectedProductsToHive(saveproducts) async {
    var enqid;

    for (var key in orderBox.keys) {
      enqid = key.toString();
    }
    for (var products in saveproducts) {
      final selectModel = Orderproducts(
        title: products.name ?? "",
        price: int.parse(products.price),
        total: products.total ?? "",
        tax: products.tax ?? "",
        taxamound: products.taxamound ?? "",
        salesvalue: products.salesvalue ?? "",
        qty: products.qty ?? "",
        orderid: enqid,
      );
      await selectedProductsBox.add(selectModel);

      setState(() {
        productSelected.add(selectModel);
        print('selected' + productSelected.toString());
      });
    }
  }

  void retrieveDataFromHive() {
    for (var element in widget.enquiries!) {
      // Set the retrieved data into the text fields
      setState(() {
        primary.text = element.primarynumber;
        name.text = element.name;
        secondary.text = element.secondarynumber;
        whatsapp.text = element.whatsappnumber;
        outside.text = element.outsidemob;
        email.text = element.email;
        dateinput.text = element.followdate;
        timecontroller.text = element.followtime;
        expdate.text = element.expclosure;
        source.text = element.source;
        assigned.text = element.assigneduser;
        taguser.text = element.taguser;
        location.text = element.location;
        refered.text = element.referedby;
      });
    }
  }

  Future<void> retrieveSelectedProductsFromHive() async {
    List<ProductDetails> selectedProductsForEnquiry = [];

    var enqid;
    for (var key in enquiryBox.keys) {
      var value = enquiryBox.get(key);
      if (widget.enquiries!.contains(value)) {
        enqid = key;
        print("Key: ${enqid}, Value: ${value}");
      }
    }

    for (var key in selectedProductBx.keys) {
      final selectmodel = selectedProductBx.get(key) as Selectedproducts;
      print(selectmodel.enquiryId);
      print(enqid);
      if (enqid.toString() == selectmodel.enquiryId) {
        print("hi");
        selectedProductsForEnquiry.add(ProductDetails(
          name: selectmodel.title,
          qty: selectmodel.qty,
          price: selectmodel.price.toString(),
          total: selectmodel.total,
          tax: selectmodel.tax,
          taxamound: selectmodel.taxamound,
          salesvalue: selectmodel.salesvalue,
        ));
        print(selectedProductsForEnquiry.toList());
        // }
      } else {
        print("MISMATCH");
      }
    }

    setState(() {
      productdetails = selectedProductsForEnquiry;
      print(productdetails);
    });
  }
}
