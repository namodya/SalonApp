import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:salo_admin/beauty_screen.dart';
import 'package:salo_admin/massage_screen.dart';
import 'package:salo_admin/hairspecialist_screen.dart';
import 'package:salo_admin/homescreen.dart';
import 'package:salo_admin/feedback_screen.dart';
import 'package:salo_admin/makeup_screen.dart';
import 'package:salo_admin/appointment_screen.dart';
import 'package:salo_admin/haircut_screen.dart';
import 'package:salo_admin/spa_screen.dart';
import 'package:salo_admin/user_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDs5fU4TSzC39eVDGbH_ZIEKsZ-ulGe34c",
        appId: "1:587304697037:web:c60ebc21d7f5a38f183d84",
        messagingSenderId: "587304697037",
        projectId: "saloon-app-cc8be",
      ),
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      initialRoute: HomeScreen.id,
      routes: {
        // LoginScreen.id: (context) => LoginScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        UserScreen.id: (context) => UserScreen(),
        AppointmentScreen.id: (context) => AppointmentScreen(),
        MassageScreen.id: (context) => MassageScreen(),
        FeedbackScreen.id: (context) => FeedbackScreen(),
        HairspecialistScreen.id: (context) => HairspecialistScreen(),
        HaircutScreen.id: (context) => HaircutScreen(),
        SpaScreen.id: (context) => SpaScreen(),
        BeautyScreen.id: (context) => BeautyScreen(),
        MakeupScreen.id: (context) => MakeupScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
