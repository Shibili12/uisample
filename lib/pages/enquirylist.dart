import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:uisample/model/enquiry.dart';
import 'package:uisample/model/selectedproduct.dart';
import 'package:uisample/pages/newEnquirypage.dart';
import 'package:uisample/pages/orderspage.dart';
import 'package:uisample/pages/viewenquirypage.dart';

class Enquirylistspage extends StatefulWidget {
  var updatedEnquiry;
  Enquirylistspage({super.key, this.updatedEnquiry});

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
          itemBuilder: (context, index) {
            final year = DateFormat('y').format(
                DateTime.fromMillisecondsSinceEpoch(DateTime.now().year));
            final month = DateFormat('MMM').format(
                DateTime.fromMillisecondsSinceEpoch(DateTime.now().month));
            final day = DateFormat('d').format(
                DateTime.fromMillisecondsSinceEpoch(DateTime.now().day));
            return ExpansionTile(
              iconColor: Colors.black,
              collapsedIconColor: Colors.black,
              textColor: Colors.black,
              collapsedTextColor: Colors.black,
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    // flex: 1,
                    child: Text(
                      year,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.yellow[600],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      day,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    // flex: 1,
                    child: Text(
                      month,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.red[600],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              title: Text(
                enquiries[index].name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              subtitle: Text(enquiries[index].primarynumber),
              children: [
                SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 80,
                          width: 90,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: GestureDetector(
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  Text("Edit Enquiry"),
                                ],
                              ),
                            ),
                            onTap: () async {
                              final output = await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (context) => Newenquiry(
                                            enquiries: [enquiries[index]],
                                          )));
                              if (output) {
                                retrieveEnquiries();
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 80,
                          width: 90,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: GestureDetector(
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.blue,
                                  ),
                                  Text("View Enquiry"),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Viewenquirypage(
                                        enquiries: [enquiries[index]],
                                      )));
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 80,
                          width: 90,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: GestureDetector(
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.swap_horiz_outlined,
                                    color: Colors.blue,
                                  ),
                                  Text("to order"),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Orderspage(
                                        enquiries: [enquiries[index]],
                                      )));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) => Divider(
            thickness: 1,
          ),
          itemCount: enquiries.length,
        ),
      ),
    );
  }
}
// TextButton(
//                         onPressed: () async {
                        //   final output = await Navigator.of(context)
                        //       .push(MaterialPageRoute(
                        //           builder: (context) => Newenquiry(
                        //                 enquiries: [enquiries[index]],
                        //               )));
                        //   if (output) {
                        //     retrieveEnquiries();
                        //   }
                        // },
//                         child: Text("EDIT"),
//                       ),