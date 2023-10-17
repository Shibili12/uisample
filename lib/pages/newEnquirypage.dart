import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uisample/pages/productPage.dart';

class Newenquiry extends StatefulWidget {
  const Newenquiry({super.key});

  @override
  State<Newenquiry> createState() => _NewenquiryState();
}

class _NewenquiryState extends State<Newenquiry> {
  TextEditingController dateinput = TextEditingController();
  TextEditingController expdate = TextEditingController();
  TextEditingController timecontroller = TextEditingController();
  TextEditingController producttext = TextEditingController();
  var productlist = [];
  void gotoPage() async {
    final products = await Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => Productpage())));
    setState(() {
      productlist = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Lead"),
        actions: [
          Icon(Icons.mic),
          SizedBox(
            width: 10,
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "SAVE",
              style: TextStyle(color: Colors.white, fontSize: 18),
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
                  child: TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Primary Number"),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Name",
                      suffixIcon: Icon(Icons.search),
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
                    decoration:
                        const InputDecoration(labelText: "Secondary Number"),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Whatsapp Number",
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
                    decoration:
                        const InputDecoration(labelText: "Outside Country Mob"),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
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
                      decoration: InputDecoration(
                        labelText: "Follow.Date",
                        suffixIcon: Icon(Icons.calendar_month),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2050));
                        if (pickedDate != null) {
                          dateinput.text =
                              DateFormat('dd MMMM yyyy').format(pickedDate);
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        controller: timecontroller,
                        decoration: const InputDecoration(
                          labelText: "Follow.Time",
                          suffixIcon: Icon(Icons.alarm),
                        ),
                        onTap: () async {
                          var time = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          if (time != null) {
                            timecontroller.text = time.format(context);
                          }
                        }),
                  ),
                ),
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
                      decoration: InputDecoration(
                        labelText: "Exp closure",
                        suffixIcon: Icon(Icons.calendar_month),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2050));
                        if (pickedDate != null) {
                          expdate.text =
                              DateFormat('dd MMMM yyyy').format(pickedDate);
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Source",
                      hintText: "Source",
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.keyboard_arrow_down),
                      ),
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
                    decoration: InputDecoration(
                      labelText: "Assigned user",
                      hintText: "Abhilash",
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.keyboard_arrow_down),
                      ),
                    ),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Tag user",
                      hintText: "Select",
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.keyboard_arrow_down),
                      ),
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
                    decoration: const InputDecoration(
                      labelText: "Location",
                      suffixIcon: Icon(Icons.location_on),
                    ),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      labelText: "Reffered by",
                      suffixIcon: Icon(Icons.search),
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
                    controller: producttext,
                    decoration: const InputDecoration(
                      labelText: "Products",
                    ),
                    onTap: () {
                      gotoPage();
                    },
                  ),
                )),
              ],
            ),
            Container(
              height: 500,
              child: productlist.isEmpty
                  ? Container()
                  : ListView.builder(
                      itemCount: productlist.length,
                      itemBuilder: ((context, index) => ListTile(
                            title: productlist[index]['title'],
                          )),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
