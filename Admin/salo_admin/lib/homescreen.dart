import 'package:flutter/material.dart';

import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:salo_admin/beauty_screen.dart';
import 'package:salo_admin/massage_screen.dart';
import 'package:salo_admin/user_screen.dart';

import 'package:salo_admin/hairspecialist_screen.dart';

import 'package:salo_admin/feedback_screen.dart';
import 'package:salo_admin/makeup_screen.dart';
import 'package:salo_admin/appointment_screen.dart';
import 'package:salo_admin/haircut_screen.dart';
import 'package:salo_admin/spa_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home-screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _selectedScreen = UserScreen();
  currentScreen(item) {
    switch (item.route) {
      case UserScreen.id:
        setState(() {
          _selectedScreen = UserScreen();
        });
        break;

      case AppointmentScreen.id:
        setState(() {
          _selectedScreen = AppointmentScreen();
        });
        break;

      case MassageScreen.id:
        setState(() {
          _selectedScreen = MassageScreen();
        });
        break;

      case FeedbackScreen.id:
        setState(() {
          _selectedScreen = FeedbackScreen();
        });
        break;

      case HairspecialistScreen.id:
        setState(() {
          _selectedScreen = HairspecialistScreen();
        });
        break;

      case HaircutScreen.id:
        setState(() {
          _selectedScreen = HaircutScreen();
        });
        break;

      case SpaScreen.id:
        setState(() {
          _selectedScreen = SpaScreen();
        });
        break;
      case BeautyScreen.id:
        setState(() {
          _selectedScreen = BeautyScreen();
        });
        break;
      case MakeupScreen.id:
        setState(() {
          _selectedScreen = MakeupScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Center(child: const Text('Admin Panel')),
        backgroundColor: Colors.blueGrey,
      ),
      sideBar: SideBar(
        width: 300,
        backgroundColor: Colors.blueGrey,
        activeBackgroundColor: Colors.blue,
        activeIconColor: Colors.white,
        activeTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        iconColor: Colors.black,
        textStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        items: const [
          AdminMenuItem(
            title: 'Manage Users',
            route: UserScreen.id,
            icon: Icons.people,
          ),
          AdminMenuItem(
            title: 'Manage Appointment',
            route: AppointmentScreen.id,
            icon: Icons.book,
          ),
          AdminMenuItem(
            title: 'Manage Message',
            route: MassageScreen.id,
            icon: Icons.contact_mail_rounded,
          ),
          AdminMenuItem(
            title: 'Manage Feedback',
            route: FeedbackScreen.id,
            icon: Icons.rate_review,
          ),
          AdminMenuItem(
            title: 'Manage Hairspecialist',
            route: HairspecialistScreen.id,
            icon: Icons.man,
          ),
          AdminMenuItem(
            title: 'Manage Haircuts',
            route: HaircutScreen.id,
            icon: Icons.cut,
          ),
          AdminMenuItem(
            title: 'Manage Spa',
            route: SpaScreen.id,
            icon: Icons.spa,
          ),
          AdminMenuItem(
            title: 'Manage Beauty',
            route: BeautyScreen.id,
            icon: Icons.girl,
          ),
          AdminMenuItem(
            title: 'Manage Makeup',
            route: MakeupScreen.id,
            icon: Icons.brush,
          ),
        ],
        selectedRoute: HomeScreen.id,
        onSelected: (item) {
          currentScreen(item);
          //if (item.route != null) {
          // Navigator.of(context).pushNamed(item.route!);
          //  }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: _selectedScreen,
      ),
    );
  }
}
