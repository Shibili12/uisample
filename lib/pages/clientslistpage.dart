import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uisample/model/client.dart';
import 'package:uisample/pages/addclientpage.dart';

class Clientslistpage extends StatefulWidget {
  const Clientslistpage({super.key});

  @override
  State<Clientslistpage> createState() => _ClientslistpageState();
}

class _ClientslistpageState extends State<Clientslistpage> {
  List<ClientDb> clients = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveclients();
  }

  void retrieveclients() async {
    Box<ClientDb> clientbox = await Hive.openBox('client');
    List<ClientDb> retrievedClients = clientbox.values.toList();
    setState(() {
      clients = retrievedClients;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Clients"),
        elevation: 0,
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => ListTile(
          title: Text(clients[index].name),
          subtitle: Text(clients[index].phonenumber),
          trailing: Wrap(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddClientPage(
                              clients: [clients[index]],
                            )));
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  )),
            ],
          ),
        ),
        separatorBuilder: (context, index) => Divider(),
        itemCount: clients.length,
      ),
    );
  }
}
