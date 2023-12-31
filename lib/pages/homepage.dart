import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uisample/firebase_services/firebasenotification.dart';
import 'package:uisample/main.dart';
import 'package:uisample/pages/addclientpage.dart';
import 'package:uisample/pages/callLogspage.dart';
import 'package:uisample/pages/clientslistpage.dart';
import 'package:uisample/pages/complaintpage.dart';
import 'package:uisample/pages/complaintslist.dart';
import 'package:uisample/pages/enquirylist.dart';
import 'package:uisample/pages/loginpage.dart';
import 'package:uisample/pages/newEnquirypage.dart';
import 'package:uisample/pages/notificationpage.dart';
import 'package:uisample/pages/orderspage.dart';
import 'package:uisample/widegets/hometile.dart';

class Myhomepage extends StatefulWidget {
  const Myhomepage({super.key});

  @override
  State<Myhomepage> createState() => _MyhomepageState();
}

class _MyhomepageState extends State<Myhomepage> {
  bool light = false;
  TextEditingController loccontroller = TextEditingController();
  Position? _currentlocation;
  late bool servicepermission = false;
  late LocationPermission permission;
  String currentadress = "";
  late SharedPreferences preferences;
  late String username;
  List localemojies = ["🇺🇸", "🇮🇳", "🇮🇳"];
  List locales = ["English", "हिंदी", "മലയാളം"];
  List localcodes = ['en', 'hi', 'ml'];
  int currentindex = 0;
  bool selectedlocales = false;

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

  NotificationServices notificationServices = NotificationServices();
  List<RemoteMessage> notificationlist = [];
  @override
  void initState() {
    getuser();
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();

    notificationServices.isTokenRefresh();
    // setState(() {
    //   notificationlist = notificationServices.notificationslist;
    // });
    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    FirebaseMessaging.onMessage.listen((message) {
      setState(() {
        notificationlist.add(message);
      });
    });
  }

  void getuser() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    // var localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // leading: const Icon(Icons.menu),
        title: LocaleText("off_duty"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.task_alt),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotificationPage(
                          notifications: notificationlist,
                        )),
              );
            },
            icon: Badge(
              label: Text('${notificationlist.length}'),
              child: Icon(Icons.notifications),
            ),
          ),
          Switch(
            value: light,
            inactiveThumbColor: Colors.red,
            inactiveTrackColor: Colors.white,
            activeColor: Colors.red,
            onChanged: (bool value) {
              setState(() {
                light = value;
              });
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Container(
            height: 40,
            width: double.infinity,
            color: Colors.blue[700],
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Wrap(
                      children: [
                        LocaleText(
                          'welcome',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          username,
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            currentadress,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () async {
                              _currentlocation = await _getCurrentlocation();
                              await _getaddressfromcordinator();
                            },
                            icon: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Center(child: Text("")),
            ),
            ExpansionTile(
                title: Text("Langauges"),
                children: List.generate(locales.length, (index) {
                  selectedlocales = currentindex == index;
                  return ListTile(
                    leading: Text(localemojies[index]),
                    title: Text(locales[index]),
                    trailing: Text(localcodes[index]),
                    onTap: () {
                      setState(() {
                        currentindex = index;
                      });
                      Locales.change(context, localcodes[currentindex]);
                    },
                  );
                })),
            ListTile(
              title: const Text("logout"),
              trailing: const Icon(Icons.logout),
              onTap: () {
                preferences.setBool('newuser', true);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Loginpage()));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          children: [
            Homecard(
              name: "New Enquiries",
              color: Colors.blue,
              icon: Icons.accessibility,
              ontap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Newenquiry()));
              },
            ),
            Homecard(
              name: "Enquiries",
              color: Colors.green,
              icon: Icons.insert_chart_rounded,
              ontap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => Enquirylistspage())));
              },
            ),
            Homecard(
              name: "Add Client",
              color: Colors.yellow,
              icon: Icons.person_pin_rounded,
              ontap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddClientPage()));
              },
            ),
            Homecard(
              name: "client",
              color: Colors.red,
              icon: Icons.card_travel_rounded,
              ontap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Clientslistpage()));
              },
            ),
            Homecard(
              name: "orders",
              color: Colors.blue,
              icon: Icons.add_card_sharp,
              ontap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Orderspage()));
              },
            ),
            Homecard(
              name: "CallLogs",
              color: Colors.green,
              icon: Icons.call,
              ontap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CallLogsscreen()));
              },
            ),
            Homecard(
              name: "Add Complaints",
              color: Colors.orange,
              icon: Icons.note_add_sharp,
              ontap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Complaintpage()));
              },
            ),
            Homecard(
              name: "Complaints",
              color: Colors.blue,
              icon: Icons.article_rounded,
              ontap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Complaintslist()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
