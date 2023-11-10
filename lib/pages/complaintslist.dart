import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uisample/model/complaints.dart';

class Complaintslist extends StatefulWidget {
  const Complaintslist({super.key});

  @override
  State<Complaintslist> createState() => _ComplaintslistState();
}

class _ComplaintslistState extends State<Complaintslist> {
  List<Complaint> complaints = [];
  late Box<Complaint> complaintBox;

  void retrieveComplaints() async {
    complaintBox = await Hive.openBox('complaints');
    List<Complaint> retrievedcomplaints = complaintBox.values.toList();
    setState(() {
      complaints = retrievedcomplaints;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveComplaints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Complaints"),
        elevation: 0,
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => ListTile(
          title: Text(complaints[index].name),
          subtitle: Text(complaints[index].remarks),
        ),
        separatorBuilder: (context, index) => Divider(),
        itemCount: complaints.length,
      ),
    );
  }
}
