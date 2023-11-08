import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uisample/model/client.dart';

class AddClientPage extends StatefulWidget {
  List<ClientDb>? clients;
  AddClientPage({super.key, this.clients});

  @override
  State<AddClientPage> createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage> {
  late Box<ClientDb> clientBox;
  List<ClientDb> savedClients = [];
  final namecontroller = TextEditingController();
  final phonecontroller = TextEditingController();
  final secondary = TextEditingController();
  final emailcontroller = TextEditingController();
  final placecontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    clientBox = Hive.box<ClientDb>('client');
    savedClients = clientBox.values.toList();
    // clientBox.clear();
    // savedClients.clear();
    if (widget.clients != null) {
      retrieveClientfromHive();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Client"),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              if (widget.clients != null) {
                for (var element in widget.clients!) {
                  updateClientfromHive(element);
                }
                Navigator.of(context).pop(true);
              } else {
                saveClienttoHive();
                Navigator.of(context).pop();
              }
            },
            child: Text(
              widget.clients == null ? "ADD" : "UPDATE",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: namecontroller,
              decoration: const InputDecoration(
                hintText: "Enter your Name",
                labelText: "Full Name",
              ),
            ),
            TextField(
              controller: phonecontroller,
              decoration: const InputDecoration(
                hintText: " Enter your Primary  Number",
                labelText: "Primary  Number",
              ),
            ),
            TextField(
              controller: secondary,
              decoration: const InputDecoration(
                hintText: " Enter your secondary Number",
                labelText: "Secondary  Number",
              ),
            ),
            TextField(
              controller: emailcontroller,
              decoration: const InputDecoration(
                labelText: "Email Id",
                hintText: "Enter your email",
              ),
            ),
            TextField(
              controller: placecontroller,
              decoration: InputDecoration(
                  labelText: "Location",
                  hintText: "Enter your place",
                  suffixIcon: Icon(Icons.location_on)),
            ),
          ],
        ),
      ),
    );
  }

  void saveClienttoHive() async {
    final fullname = namecontroller.text;
    final phoneno = phonecontroller.text;
    final emailid = emailcontroller.text;
    final place = placecontroller.text;
    final secondaryno = secondary.text;
    final clientmodel = ClientDb(
      name: fullname,
      phonenumber: phoneno,
      place: place,
      email: emailid,
      secondarynumber: secondaryno,
    );
    await clientBox.add(clientmodel);
    setState(() {
      savedClients.add(clientmodel);
      print("clients Length:" + savedClients.length.toString());
    });
    namecontroller.clear();
    phonecontroller.clear();
    emailcontroller.clear();
    placecontroller.clear();
    secondary.clear();
  }

  void retrieveClientfromHive() {
    for (var element in widget.clients!) {
      setState(() {
        namecontroller.text = element.name;
        phonecontroller.text = element.phonenumber;
        placecontroller.text = element.place;
        emailcontroller.text = element.email;
        secondary.text = element.secondarynumber;
      });
    }
  }

  updateClientfromHive(ClientDb client) async {
    final index = savedClients.indexWhere((element) => element.id == client.id);
    if (index != -1) {
      final updatedClient = ClientDb(
          name: namecontroller.text,
          phonenumber: phonecontroller.text,
          place: placecontroller.text,
          email: emailcontroller.text,
          secondarynumber: secondary.text);
      savedClients[index] = updatedClient;
      await clientBox.put(index, updatedClient);
      setState(() {});
    }
  }
}
