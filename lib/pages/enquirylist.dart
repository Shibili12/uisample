import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uisample/model/enquiry.dart';
import 'package:uisample/model/selectedproduct.dart';
import 'package:uisample/pages/newEnquirypage.dart';

class Enquirylistspage extends StatefulWidget {
  var updatedEnquiry;
  Enquirylistspage({super.key, this.updatedEnquiry});

  @override
  State<Enquirylistspage> createState() => _EnquirylistspageState();
}

class _EnquirylistspageState extends State<Enquirylistspage> {
  List<Enquiry> enquiries = [];
  List<Selectedproducts> products = [];

  void retrieveEnquiries() async {
    Box<Enquiry> enquiryBox = await Hive.openBox('enquiryBox');

    // Retrieve the list of enquiries from the enquiryBox
    List<Enquiry> retrievedEnquiries = enquiryBox.values.toList();

    setState(() {
      enquiries = retrievedEnquiries;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveEnquiries();
    // enquiries.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text("Enquiries"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemBuilder: (context, index) => ListTile(
            title: Text(enquiries[index].name),
            subtitle: Text(enquiries[index].primarynumber),
            trailing: TextButton(
              onPressed: () async {
                final output =
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Newenquiry(
                              enquiries: [enquiries[index]],
                            )));
                if (output) {
                  retrieveEnquiries();
                }
              },
              child: Text("EDIT"),
            ),
          ),
          separatorBuilder: (context, index) => Divider(
            thickness: 1,
          ),
          itemCount: enquiries.length,
        ),
      ),
    );
  }
}
