import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uisample/model/client.dart';
import 'package:uisample/pages/addclientpage.dart';
import 'package:uisample/pages/clientsmap.dart';

class Clientslistpage extends StatefulWidget {
  const Clientslistpage({super.key});

  @override
  State<Clientslistpage> createState() => _ClientslistpageState();
}

class _ClientslistpageState extends State<Clientslistpage> {
  List<ClientDb> clients = [];
  late Box<ClientDb> clientbox;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveclients();
  }

  void retrieveclients() async {
    clientbox = await Hive.openBox('client');
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ClientsMap()));
            },
            icon: Icon(Icons.location_on),
          ),
        ],
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => ListTile(
          title: Text(clients[index].name),
          subtitle: Text(clients[index].phonenumber),
          trailing: Wrap(
            children: [
              IconButton(
                  onPressed: () async {
                    clientbox.deleteAt(index);
                    clients.removeAt(index);
                    retrieveclients();
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
              IconButton(
                  onPressed: () async {
                    final output =
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddClientPage(
                                  clients: [clients[index]],
                                )));
                    if (output) {
                      retrieveclients();
                    }
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
