import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uisample/model/enquiry.dart';
import 'package:uisample/pages/newEnquirypage.dart';

class Enquirylistspage extends StatefulWidget {
  const Enquirylistspage({super.key});

  @override
  State<Enquirylistspage> createState() => _EnquirylistspageState();
}

class _EnquirylistspageState extends State<Enquirylistspage> {
  List<Enquiry> enquiries = [];

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
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Newenquiry(
                          enquiries: enquiries[index],
                        )));
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
