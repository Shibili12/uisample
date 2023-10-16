import 'package:flutter/material.dart';
import 'package:uisample/pages/newEnquirypage.dart';
import 'package:uisample/widegets/hometile.dart';

class Myhomepage extends StatefulWidget {
  Myhomepage({super.key});

  @override
  State<Myhomepage> createState() => _MyhomepageState();
}

class _MyhomepageState extends State<Myhomepage> {
  bool light = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const Icon(Icons.menu),
        title: const Text("Off Duty"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.task_alt),
          ),
          IconButton(
            onPressed: () {},
            icon: const Badge(
              label: Text('2'),
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
            height: 30,
            width: double.infinity,
            color: Colors.blue[700],
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "welcome Abhilash",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
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
              ontap: () {},
            ),
            Homecard(
              name: "Add Client",
              color: Colors.yellow,
              icon: Icons.person_pin_rounded,
              ontap: () {},
            ),
            Homecard(
              name: "Clients",
              color: Colors.red,
              icon: Icons.card_travel_rounded,
              ontap: () {},
            ),
            Homecard(
              name: "orders",
              color: Colors.blue,
              icon: Icons.add_card_sharp,
              ontap: () {},
            ),
            Homecard(
              name: "CallLogs",
              color: Colors.green,
              icon: Icons.call,
              ontap: () {},
            ),
            Homecard(
              name: "Add Complaints",
              color: Colors.orange,
              icon: Icons.note_add_sharp,
              ontap: () {},
            ),
            Homecard(
              name: "Complaints",
              color: Colors.blue,
              icon: Icons.article_rounded,
              ontap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
