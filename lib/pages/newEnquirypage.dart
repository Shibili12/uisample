import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:get/utils.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uisample/model/client.dart';
import 'package:uisample/model/enquiry.dart';
import 'package:uisample/model/product.dart';
import 'package:uisample/model/productmodel.dart';
import 'package:uisample/model/selectedproduct.dart';

import 'package:uisample/pages/productPage.dart';
import 'package:uisample/productdetails.dart';

class Newenquiry extends StatefulWidget {
  List<Enquiry>? enquiries;
  Newenquiry({super.key, this.enquiries});

  @override
  State<Newenquiry> createState() => _NewenquiryState();
}

class _NewenquiryState extends State<Newenquiry> with TickerProviderStateMixin {
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

  var productlist = [];
  List<ProductDetails> productdetails = List.empty(growable: true);
  String discountType = 'percentage';
  double discountValue = 0.0;
  late Box<Enquiry> enquiryBox;
  List<Enquiry> saveddata = [];
  late Box<Selectedproducts> selectedProductsBox;
  List<Selectedproducts> productSelected = [];
  double discount = 0;

  List<ClientDb> clients = [];
  String? dropdownClient;

  Future<void> getproduct() async {
    final products = await Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => Productpage())));

    if (products != null) {
      setState(() {
        // productlist = products;
        // final enquiryList = enquiryBox.values.toList();
        print(productlist);
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

  Future<void> loadClientfromhive() async {
    var clientbox = await Hive.openBox<ClientDb>('client');
    setState(() {
      clients = clientbox.values.toList();
      dropdownClient = clients.isNotEmpty ? clients[0].name : null;
    });
  }

  Future<void> _initializeHive() async {
    await Hive.initFlutter();
    await Hive.openBox<Enquiry>('enquiryBox');
    await Hive.openBox<Selectedproducts>('selectedProducts');
    enquiryBox = Hive.box<Enquiry>('enquiryBox');
    saveddata = enquiryBox.values.toList();
    selectedProductsBox = Hive.box<Selectedproducts>('selectedProducts');
    print("Enquiry Box Length : " + enquiryBox.length.toString());
    print("selelected Box Length : " + selectedProductsBox.length.toString());
    // enquiryBox.clear();
    // selectedProductsBox.clear();
    setState(() {});
    if (widget.enquiries != null) {
      retrieveDataFromHive();
      await retrieveSelectedProductsFromHive();
    }
    // if (productSelected.isNotEmpty) {
    //   productdetails = productSelected;
    // }
  }

  Future<void> saveSelectedProductsToHive(saveproducts) async {
    var enqid;

    for (var key in enquiryBox.keys) {
      enqid = key.toString();
    }
    for (var products in saveproducts) {
      final selectModel = Selectedproducts(
        title: products.name ?? "",
        price: int.parse(products.price),
        total: products.total ?? "",
        tax: products.tax ?? "",
        taxamound: products.taxamound ?? "",
        salesvalue: products.salesvalue ?? "",
        qty: products.qty ?? "",
        enquiryId: enqid,
      );
      await selectedProductsBox.add(selectModel);

      setState(() {
        productSelected.add(selectModel);
        print('selected' + productSelected.toString());
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

    for (var key in selectedProductsBox.keys) {
      final selectmodel = selectedProductsBox.get(key) as Selectedproducts;
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

  void saveDataToHive() async {
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

    final enquiryModel = Enquiry(
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
    await enquiryBox.add(enquiryModel);
    print("enquiryBox" + enquiryBox.toString());
    print("selected:" + productSelected.toString());
    setState(() {
      saveddata.add(enquiryModel);
      print(saveddata.length);
    });

    primary.clear();
    name.clear();
    secondary.clear();
    whatsapp.clear();
    outside.clear();
    email.clear();
    dateinput.clear();
    timecontroller.clear();
    expdate.clear();
    source.clear();
    assigned.clear();
    taguser.clear();
    location.clear();
    refered.clear();
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

  void updateEnquiry(Enquiry updatedEnquiry) async {
    final index =
        saveddata.indexWhere((element) => element.id == updatedEnquiry.id);
    print("index:$index");

    if (index != -1) {
      // saveddata.removeAt(index);
      // await enquiryBox.delete(updatedEnquiry.id);
      final updatedmodel = Enquiry(
          primarynumber: primary.text,
          name: name.text,
          secondarynumber: secondary.text,
          whatsappnumber: whatsapp.text,
          outsidemob: outside.text,
          followdate: dateinput.text,
          followtime: timecontroller.text,
          expclosure: expdate.text,
          source: source.text,
          assigneduser: assigned.text,
          taguser: taguser.text,
          location: location.text,
          referedby: refered.text,
          email: email.text);
      saveddata[index] = updatedmodel;

      await enquiryBox.put(index, updatedmodel);

      setState(() {});
    }
  }

  Future<void> updateSelectedProductInHive(
    String enquiryId,
    List<ProductDetails> updatedProducts,
  ) async {
    final enqid = enquiryId;
    print(" id enq:$enqid");
    final selectedProductsForEnquiry = <Selectedproducts>[];
    final existingProducts = selectedProductsBox.values.toList();
    // final index =
    //     productSelected.indexWhere((element) => element.enquiryId == enquiryId);
    // print("index:" + index.toString());

    for (var product in updatedProducts) {
      // Check if a product with the same enquiryId and title already exists
      var existingProduct = existingProducts.firstWhereOrNull(
        (p) => p.enquiryId == enqid && p.title == product.name,
      );

      if (existingProduct != null) {
        // Update existing product title
        existingProduct.title = product.name ?? "";
        existingProduct.price = int.parse(product.price);
        existingProduct.total = product.total ?? "";
        existingProduct.tax = product.tax ?? "";
        existingProduct.taxamound = product.taxamound ?? "";
        existingProduct.salesvalue = product.salesvalue ?? "";
        existingProduct.qty = product.qty ?? "";

        // Save the updated product back to Hive
        // await selectedProductsBox.putAt(index, existingProduct);

        // Add the updated product to the list
        selectedProductsForEnquiry.add(existingProduct);
      } else {
        final model = Selectedproducts(
          title: product.name ?? "",
          price: int.parse(product.price),
          total: product.total ?? "",
          tax: product.tax ?? "",
          taxamound: product.taxamound ?? "",
          salesvalue: product.salesvalue ?? "",
          qty: product.qty ?? "",
          enquiryId: enqid,
        );
        await selectedProductsBox.add(model);
        selectedProductsForEnquiry.add(model);
      }

      setState(() {
        productSelected = selectedProductsForEnquiry;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LocaleText("enquiry_page_title"),
        actions: [
          const Icon(Icons.mic),
          const SizedBox(
            width: 10,
          ),
          TextButton(
            onPressed: () {
              if (widget.enquiries != null) {
                updateEnquiry(widget.enquiries![0]);
                for (var key in enquiryBox.keys) {
                  var value = enquiryBox.get(key);
                  print("Checking key: $key, value: $value");
                  print(widget.enquiries!.contains(value));
                  if (!widget.enquiries!.contains(value)) {
                    var enqid = key.toString();
                    print("hi heloo, enqid: $enqid");
                    updateSelectedProductInHive(enqid, productdetails);
                  }
                }
                Navigator.of(context).pop(true);
              } else {
                saveSelectedProductsToHive(productdetails);
                Navigator.of(context).pop();
              }
            },
            child: LocaleText(
              widget.enquiries == null ? "save" : "Update",
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
                    controller: primary,
                    decoration: InputDecoration(
                      labelText:
                          Locales.string(context, 'primary_number_label'),
                    ),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                      labelText: Locales.string(context, 'name_label'),
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
                    controller: secondary,
                    decoration: InputDecoration(
                      labelText:
                          Locales.string(context, 'secondary_number_label'),
                    ),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: whatsapp,
                    decoration: InputDecoration(
                      labelText:
                          Locales.string(context, 'whatsapp_number_label'),
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
                    controller: outside,
                    decoration: InputDecoration(
                      labelText: Locales.string(
                          context, 'outsidecontrymob_number_label'),
                    ),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      labelText: Locales.string(context, 'email_label'),
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
                        labelText: Locales.string(context, 'follow_date_label'),
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
                        decoration: InputDecoration(
                          labelText:
                              Locales.string(context, 'follow_time_label'),
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
                        labelText: Locales.string(context, 'exp_closure_label'),
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
                    controller: source,
                    decoration: InputDecoration(
                      labelText: Locales.string(context, 'source_label'),
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
                    controller: assigned,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          List<ClientDb> filteredClients = List.from(clients);
                          return StatefulBuilder(
                            builder: (context, setState) => Container(
                              child: Column(
                                children: [
                                  Container(
                                    height: 70,
                                    color: Colors.blue,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: LocaleText(
                                            "assigned_user_label",
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
                                              decoration: InputDecoration(
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
                            ),
                          );
                        },
                      );
                    },
                    decoration: InputDecoration(
                      labelText: Locales.string(context, 'assigned_user_label'),
                      hintText: dropdownClient,
                      suffixIcon: Icon(Icons.keyboard_arrow_down),
                    ),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: taguser,
                    decoration: InputDecoration(
                      labelText: Locales.string(context, 'tag_user_label'),
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
                    controller: location,
                    decoration: InputDecoration(
                      labelText: Locales.string(context, 'location_label'),
                      suffixIcon: Icon(Icons.location_on),
                    ),
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
                      labelText: Locales.string(context, 'refferd_label'),
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
                    decoration: InputDecoration(
                        labelText: Locales.string(context, 'products_label')),
                    onTap: () async {
                      if (widget.enquiries == null) {
                        saveDataToHive();
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
                              child: Center(
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
                                  // Handle the case where index is out of bounds (invalid)
                                  print('Invalid index: $index');
                                }
                              });
                            },
                            child: ListTile(
                              title: Text(selectedproduct.name),
                              subtitle: Text("Price:${selectedproduct.price}"),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      openPopUp(context, selectedproduct),
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
                                          // Reset the animation controller after the popup is closed
                                          _popupController.reset();
                                        });
                                      },
                                      child: Text("Edit"),
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
                        productdetails.isNotEmpty
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
                        Selectedproducts model = Selectedproducts(
                          title: name,
                          price: int.parse(price),
                          total: total,
                          tax: tax,
                          taxamound: taxamount,
                          salesvalue: sales,
                          qty: qty,
                          enquiryId: equid,
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
    double originalPrice = calculatetotalprice(productdetails);
    // +calculatetaxamount(productdetails); // Example original price
    double discountedPrice;
    if (discountType == 'percentage') {
      discountedPrice = originalPrice - (originalPrice * discountValue / 100);
      discount = originalPrice * discountValue / 100;
    } else {
      discountedPrice = originalPrice - discountValue;
      discount = discountValue;
    }
    return discountedPrice;
  }

//   Future<void> updateSelectedProducts(int enqid) async {
//   // Step 1: Retrieve selected products
//   List<ProductDetails> selectedProductsForEnquiry = await retrieveSelectedProductsFromHive(enqid);

//   // Step 2: Update the selected products
//   for (var product in selectedProductsForEnquiry) {
//     // Example: Update the quantity of each product
//     product.qty = "Updated Quantity";
//     // Add more update logic as needed
//   }

//   // Step 3: Save the updated selected products back to Hive
//   await saveUpdatedSelectedProducts(selectedProductsForEnquiry);
// }

// Future<void> saveUpdatedSelectedProducts(List<ProductDetails> updatedProducts) async {
//   for (var product in updatedProducts) {
//     // Create a Selectedproducts object from updated ProductDetails
//     final updatedProduct = Selectedproducts(
//       title: product.name,
//       price:int.parse( product.price),
//       total: product.total,
//       tax: product.tax,
//       taxamound: product.taxamound,
//       salesvalue: product.salesvalue,
//       qty: product.qty,
//       // Set the appropriate enquiryId
//       enquiryId:, // Replace 'enqid' with the correct value
//     );

//     // Find the existing selected product in Hive and update it
//     for (var key in selectedProductsBox.keys) {
//       final selectmodel = selectedProductsBox.get(key) as Selectedproducts;
//       if (selectmodel.title == updatedProduct.title) {
//         updatedProduct.id = selectmodel.id;
//         await selectedProductsBox.put(key, updatedProduct);
//         break; // Found and updated the product, exit the loop
//       }
//     }
//   }
// }
}
