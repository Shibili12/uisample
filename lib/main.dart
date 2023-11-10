import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uisample/firebase_options.dart';
import 'package:uisample/firebase_services/firebasenotification.dart';
import 'package:uisample/model/client.dart';
import 'package:uisample/model/complaints.dart';
import 'package:uisample/model/enquiry.dart';
import 'package:uisample/model/product.dart';
import 'package:uisample/model/selectedproduct.dart';
// import 'package:uisample/model/product.dart';

import 'package:uisample/pages/loginpage.dart';
import 'package:uisample/pages/notificationpage.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Hive.registerAdapter(ProductDbAdapter());
  Hive.registerAdapter(EnquiryAdapter());
  Hive.registerAdapter(SelectedproductsAdapter());
  Hive.registerAdapter(ClientDbAdapter());
  Hive.registerAdapter(ComplaintAdapter());
  await Hive.openBox<ProductDb>('products');
  await Hive.openBox<Enquiry>('enquiryBox');
  await Hive.openBox<Selectedproducts>('selectedProducts');
  await Hive.openBox<ClientDb>('client');
  await Hive.openBox<Complaint>('complaints');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Loginpage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
