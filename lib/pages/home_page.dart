// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mind_check/Firebase/auth_methods.dart';
import 'package:mind_check/pages/diagnosis_page.dart';
import 'package:mind_check/pages/doctor_list.dart';
import 'package:mind_check/pages/forgot_password.dart';
import 'package:mind_check/pages/landing_page.dart';
import 'package:mind_check/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final spinkit = const SpinKitDualRing(
    color: Color.fromRGBO(0, 99, 219, 1),
    size: 50.0,
  );
  final currentUser = FirebaseAuth.instance;

  void logout() async {
    await Auth().SignOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LandingPage(),
      ),
    );
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = <Widget>[
    const DiagnosisPage(),
    const DoctorList(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(right: 50),
          child: Center(child: Text('Mind Check')),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromRGBO(67, 206, 162, 1),
                Color.fromRGBO(24, 90, 157, 1)
              ],
            ),
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
          child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('Email', isEqualTo: currentUser.currentUser?.email)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromRGBO(67, 206, 162, 1),
                        Color.fromRGBO(58, 183, 161, 1)
                      ],
                    ),
                  ),
                  accountName: Text(snapshot.data?.docs[0]['Name']),
                  accountEmail: Text(snapshot.data?.docs[0]['Email']),
                ),
                ListTile(
                  title: const Text('Logout'),
                  onTap: () {
                    logout();
                  },
                ),
                ListTile(
                    title: const Text('Change Password'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPassword(),
                        ),
                      );
                    }),
              ],
            );
          } else {
            return spinkit;
          }
        },
      )),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.houseUser),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.userDoctor),
            label: 'Doctor',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.idCardClip),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(0, 99, 219, 1),
        onTap: _onItemTapped,
      ),
    );
  }
}
