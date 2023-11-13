import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
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
  Position? _currentlocation;
  late bool servicepermission = false;
  late LocationPermission permission;
  String currentadress = "";
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  var imagePath;

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  XFile? pickedImage = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );

                  if (pickedImage != null) {
                    setState(() {
                      _pickedImage = pickedImage;
                    });
                  }
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _pickedImage != null
                      ? FileImage(File(_pickedImage!.path))
                      : imagePath != null
                          ? FileImage(File(imagePath))
                          : null,
                ),
              ),
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
                  suffixIcon: IconButton(
                    onPressed: () async {
                      _currentlocation = await _getCurrentlocation();
                      await _getaddressfromcordinator();
                      setState(() {
                        placecontroller.text = currentadress;
                      });
                    },
                    icon: Icon(Icons.location_on),
                  ),
                ),
              ),
            ],
          ),
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
    if (_currentlocation != null) {
      final clientmodel = ClientDb(
        name: fullname,
        phonenumber: phoneno,
        place: place,
        email: emailid,
        secondarynumber: secondaryno,
        latittude: _currentlocation!.latitude,
        longittude: _currentlocation!.longitude,
        profileImage: _pickedImage!.path,
      );
      await clientBox.add(clientmodel);
      setState(() {
        savedClients.add(clientmodel);
        print("clients Length:" + savedClients.length.toString());
      });
    }
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
        imagePath = element.profileImage;
      });
    }
  }

  updateClientfromHive(ClientDb client) async {
    final index = savedClients.indexWhere((element) => element.id == client.id);
    if (index != -1) {
      print("object" + savedClients[index].profileImage.toString());
      if (_currentlocation != null && _pickedImage != null) {
        final updatedClient = ClientDb(
          name: namecontroller.text,
          phonenumber: phonecontroller.text,
          place: placecontroller.text,
          email: emailcontroller.text,
          secondarynumber: secondary.text,
          latittude: _currentlocation!.latitude,
          longittude: _currentlocation!.longitude,
          profileImage: _pickedImage!.path,
        );
        savedClients[index] = updatedClient;
        await clientBox.putAt(index, updatedClient);
        setState(() {});
        print("object" + savedClients[index].profileImage.toString());
      }
    }
  }

  Future<Position> _getCurrentlocation() async {
    servicepermission = await Geolocator.isLocationServiceEnabled();
    if (!servicepermission) {
      debugPrint("service disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  _getaddressfromcordinator() async {
    try {
      List<Placemark> placemark = await placemarkFromCoordinates(
          _currentlocation!.latitude, _currentlocation!.longitude);
      Placemark place = placemark[0];
      setState(() {
        currentadress = "${place.locality},${place.country}";
      });
    } catch (e) {
      debugPrint("$e");
    }
  }
}
