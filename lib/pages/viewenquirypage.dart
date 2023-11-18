import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uisample/model/enquiry.dart';
import 'package:uisample/model/selectedproduct.dart';

class Viewenquirypage extends StatefulWidget {
  List<Enquiry>? enquiries;
  Viewenquirypage({super.key, this.enquiries});

  @override
  State<Viewenquirypage> createState() => _ViewenquirypageState();
}

class _ViewenquirypageState extends State<Viewenquirypage> {
  late Box<Selectedproducts> selectedproductsBox;
  List<Selectedproducts> productselected = [];
  late Box<Enquiry> enquiryBox;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  Future<void> init() async {
    try {
      var enqid;
      enquiryBox = await Hive.openBox<Enquiry>('enquiryBox');
      for (var key in enquiryBox.keys) {
        var value = enquiryBox.get(key);
        if (widget.enquiries!.contains(value)) {
          enqid = key.toString();
          await loadProductsForEnquiry(enqid);
        }
      }
    } catch (e) {
      print('Error initializing: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double netAmount = calculateNetAmount(productselected);
    double taxAmount = calculateTaxAmount(netAmount, 5.0);
    double discount = 0.0;
    double deduction = 0.0;
    double grandTotal =
        calculateGrandTotal(netAmount, discount, taxAmount, deduction);
    netAmount = double.parse(netAmount.toStringAsFixed(2));
    taxAmount = double.parse(taxAmount.toStringAsFixed(2));
    discount = double.parse(discount.toStringAsFixed(2));
    deduction = double.parse(deduction.toStringAsFixed(2));
    grandTotal = double.parse(grandTotal.toStringAsFixed(2));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text("View"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text(
              "Client Name",
              style: TextStyle(fontSize: 12),
            ),
            subtitle: Text(
              widget.enquiries![0].name,
              style: const TextStyle(
                  // fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ListTile(
                  title: const Text(
                    "primary number",
                    style: TextStyle(fontSize: 12),
                  ),
                  subtitle: Text(
                    widget.enquiries![0].primarynumber,
                    style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text(
                    "secondary number",
                    style: TextStyle(fontSize: 12),
                  ),
                  subtitle: Text(
                    widget.enquiries![0].secondarynumber,
                    style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ListTile(
                  title: const Text(
                    "whatsapp number",
                    style: TextStyle(fontSize: 12),
                  ),
                  subtitle: Text(
                    widget.enquiries![0].whatsappnumber,
                    style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text(
                    "outside mobile number",
                    style: TextStyle(fontSize: 12),
                  ),
                  subtitle: Text(
                    widget.enquiries![0].outsidemob,
                    style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ListTile(
                  title: const Text(
                    "Email id",
                    style: TextStyle(fontSize: 12),
                  ),
                  subtitle: Text(
                    widget.enquiries![0].email,
                    style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text(
                    "follow date",
                    style: TextStyle(fontSize: 12),
                  ),
                  subtitle: Text(
                    widget.enquiries![0].followdate,
                    style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ListTile(
                  title: const Text(
                    "Follow time",
                    style: TextStyle(fontSize: 12),
                  ),
                  subtitle: Text(
                    widget.enquiries![0].followtime,
                    style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text(
                    "Exp closure",
                    style: TextStyle(fontSize: 12),
                  ),
                  subtitle: Text(
                    widget.enquiries![0].expclosure,
                    style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ListTile(
                  title: const Text(
                    "Source",
                    style: TextStyle(fontSize: 12),
                  ),
                  subtitle: Text(
                    widget.enquiries![0].source,
                    style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text(
                    "Assigned user",
                    style: TextStyle(fontSize: 12),
                  ),
                  subtitle: Text(
                    widget.enquiries![0].assigneduser,
                    style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ListTile(
                  title: const Text(
                    "tag user",
                    style: TextStyle(fontSize: 12),
                  ),
                  subtitle: Text(
                    widget.enquiries![0].taguser,
                    style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text(
                    "location",
                    style: TextStyle(fontSize: 12),
                  ),
                  subtitle: Text(
                    widget.enquiries![0].location,
                    style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          ListTile(
            title: const Text(
              "Reffered by",
              style: TextStyle(fontSize: 12),
            ),
            subtitle: Text(
              widget.enquiries![0].referedby,
              style: const TextStyle(
                  // fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Products"),
                Text("Qty"),
                Text("price"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: Column(
                children: List.generate(
                    productselected.length,
                    (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(productselected[index].title),
                              Text(productselected[index].qty),
                              Text("${productselected[index].price}"),
                            ],
                          ),
                        )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Net Amount :"),
                Text("$netAmount"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Discount :"),
                Text("$discount"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Tax Amount :"),
                Text("$taxAmount"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Deduction :"),
                Text("$deduction"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                        'Grand Total(${productselected.length} items):$grandTotal ')),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadProductsForEnquiry(String enquiryId) async {
    selectedproductsBox =
        await Hive.openBox<Selectedproducts>('selectedProducts');
    productselected = selectedproductsBox.values
        .where((product) => product.enquiryId == enquiryId)
        .toList();

    setState(() {});
    print(productselected.length);
  }

  double calculateNetAmount(products) {
    double netAmount = 0.0;

    for (var product in products) {
      netAmount += double.parse(product.qty) * product.price;
    }

    return netAmount;
  }

  double calculateTaxAmount(double netAmount, double taxRate) {
    return netAmount * (taxRate / 100);
  }

  double calculateGrandTotal(
      double netAmount, double discount, double taxAmount, double deduction) {
    return netAmount - discount + taxAmount - deduction;
  }
}
