import 'package:flutter/material.dart';

class Myhomepage extends StatefulWidget {
  Myhomepage({super.key});

  @override
  State<Myhomepage> createState() => _MyhomepageState();
}

class _MyhomepageState extends State<Myhomepage> {
  bool light = false;
  var icons = [
    Icons.accessibility,
    Icons.insert_chart_rounded,
    Icons.person_pin_rounded,
    Icons.card_travel_rounded,
    Icons.add_card_sharp,
    Icons.call,
    Icons.note_add_sharp,
    Icons.article_rounded,
  ];

  var names = [
    "New Enquiries",
    "Enquiries",
    "Add Client",
    "clients",
    "Orders",
    "CallLogs",
    "Add complaints",
    "Complaints",
  ];

  var colors = [
    Colors.blue[700],
    Colors.green,
    Colors.yellow,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.blue[700],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Icon(Icons.menu),
        title: Text("Off Duty"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.task_alt),
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
        child: GridView.builder(
          itemCount: names.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors[index],
                    ),
                    child: Icon(
                      icons[index],
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    names[index],
                    style: TextStyle(color: Colors.blue[700]),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
