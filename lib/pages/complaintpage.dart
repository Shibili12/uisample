import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uisample/model/complaints.dart';
import 'package:uisample/model/enquiry.dart';
import 'package:uisample/model/selectedproduct.dart';

class Complaintpage extends StatefulWidget {
  const Complaintpage({super.key});

  @override
  State<Complaintpage> createState() => _ComplaintpageState();
}

class _ComplaintpageState extends State<Complaintpage> {
  TextEditingController dateinput = TextEditingController();
  TextEditingController expdate = TextEditingController();
  TextEditingController timecontroller = TextEditingController();
  TextEditingController remarktext = TextEditingController();
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
  late Box<Enquiry> enquiryBox;
  List<Enquiry> enquirylist = [];
  List<Enquiry> suggestionList = [];
  late Box<Selectedproducts> selectedproductsBox;
  List<Selectedproducts> productselected = [];
  late Box<Complaint> complaintBox;
  List<Complaint> savedcomplaints = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loadEnquiryData();
    complaintBox = Hive.box<Complaint>('complaints');
    savedcomplaints = complaintBox.values.toList();
  }

  void loadEnquiryData(String searchTerm) async {
    enquiryBox = await Hive.openBox<Enquiry>('enquiryBox');
    enquirylist = enquiryBox.values.toList();

    setState(() {
      suggestionList = enquirylist
          .where((enquiry) =>
              enquiry.primarynumber.startsWith(searchTerm) &&
              enquiry.primarynumber != searchTerm)
          .toList();
    });
  }

  void loadProductsForEnquiry(String enquiryId) async {
    selectedproductsBox =
        await Hive.openBox<Selectedproducts>('selectedProducts');
    productselected = selectedproductsBox.values
        .where((product) => product.enquiryId == enquiryId)
        .toList();

    // Update the product list in your UI
    setState(() {
      // Update the product list in your UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Complaints"),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              addComplaintToHive();
              Navigator.of(context).pop();
            },
            child: Text(
              "ADD",
              style: TextStyle(color: Colors.white),
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
                    child: Autocomplete<Enquiry>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        return suggestionList
                            .where((enquiry) => enquiry.primarynumber
                                .contains(textEditingValue.text))
                            .toList();
                      },
                      onSelected: (Enquiry selectedEnquiry) {
                        setState(() {
                          primary.text = selectedEnquiry.primarynumber;
                          name.text = selectedEnquiry.name;
                          secondary.text = selectedEnquiry.secondarynumber;
                          whatsapp.text = selectedEnquiry.whatsappnumber;
                          outside.text = selectedEnquiry.outsidemob;
                          email.text = selectedEnquiry.email;
                          dateinput.text = selectedEnquiry.followdate;
                          timecontroller.text = selectedEnquiry.followtime;
                          expdate.text = selectedEnquiry.expclosure;
                          source.text = selectedEnquiry.source;
                          assigned.text = selectedEnquiry.assigneduser;
                          taguser.text = selectedEnquiry.taguser;
                          location.text = selectedEnquiry.location;
                          refered.text = selectedEnquiry.referedby;
                        });
                        var enqid;
                        for (var key in enquiryBox.keys) {
                          var value = enquiryBox.get(key);
                          if (suggestionList.contains(value)) {
                            enqid = key.toString();
                            loadProductsForEnquiry(enqid);
                          }
                        }
                      },
                      fieldViewBuilder: (
                        BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted,
                      ) {
                        return TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          onFieldSubmitted: (String value) {
                            if (primary.text != "") {
                              textEditingController.text = primary.text;
                            }
                            onFieldSubmitted();
                          },
                          onChanged: (String value) {
                            loadEnquiryData(value);
                          },
                          decoration: InputDecoration(
                            labelText: "Primary Number",
                          ),
                        );
                      },
                      optionsViewBuilder: (
                        BuildContext context,
                        AutocompleteOnSelected<Enquiry> onSelected,
                        Iterable<Enquiry> options,
                      ) {
                        return Material(
                          elevation: 4.0,
                          child: SizedBox(
                            height: 200.0,
                            child: ListView.builder(
                              padding: EdgeInsets.all(8.0),
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final Enquiry enquiry =
                                    options.elementAt(index);
                                return ListTile(
                                  title: Text(enquiry.name),
                                  subtitle: Text(enquiry.primarynumber),
                                  onTap: () {
                                    onSelected(enquiry);
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: name,
                    decoration: const InputDecoration(
                      labelText: "Name",
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
                    decoration:
                        const InputDecoration(labelText: "secondary Number"),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: whatsapp,
                    decoration: const InputDecoration(
                      labelText: "Whatsapp number",
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
                    decoration: const InputDecoration(
                        labelText: "Outside Coubtry  mob"),
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
                    decoration: const InputDecoration(labelText: "Follow date"),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: timecontroller,
                    decoration: const InputDecoration(
                      labelText: "Follow time",
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
                    controller: expdate,
                    decoration: const InputDecoration(labelText: "Exp closure"),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: source,
                    decoration: const InputDecoration(
                      labelText: "Source",
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
                    decoration:
                        const InputDecoration(labelText: "Assigned user"),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: taguser,
                    decoration: const InputDecoration(
                      labelText: "Tag user",
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
                    decoration: const InputDecoration(labelText: "Location"),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: refered,
                    decoration: const InputDecoration(
                      labelText: "Reffered by",
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
                    controller: remarktext,
                    decoration: const InputDecoration(
                      labelText: "Remarks",
                    ),
                  ),
                )),
              ],
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                itemCount: productselected.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(productselected[index].title),
                  subtitle: Text("${productselected[index].price}"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addComplaintToHive() async {
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
    final remark = remarktext.text;
    final complaintmodel = Complaint(
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
      email: emailid,
      remarks: remark,
    );
    await complaintBox.add(complaintmodel);
    setState(() {
      savedcomplaints.add(complaintmodel);
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
    remarktext.clear();
  }
}
