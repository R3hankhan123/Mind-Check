import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final curr = FirebaseAuth.instance;
  final spinkit = const SpinKitRipple(
    color: Color.fromRGBO(0, 99, 219, 1),
    size: 50.0,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('Email', isEqualTo: curr.currentUser?.email)
          .snapshots(),
      builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView(children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(67, 206, 162, 1),
                      Color.fromRGBO(24, 90, 157, 1)
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 400,
                        width: 400,
                        child: Image(
                            image: AssetImage(
                                'asset/mind-check-high-resolution-logo-color-on-transparent-background.png')),
                      ),
                      Text(
                        snapshot.data!.docs[0]['Name'],
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              title: Text(
                                snapshot.data!.docs[0]['City'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: const Text(
                                'City',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                snapshot.data!.docs[0]['Phone'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: const Text(
                                'Phone Number',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          ListTile(
                            title: const Text(
                              'Email',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 99, 219, 1),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              snapshot.data!.docs[0]['Email'],
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            title: const Text(
                              'Age',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 99, 219, 1),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              snapshot.data!.docs[0]['Age'],
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            title: const Text(
                              'Pincode',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 99, 219, 1),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              snapshot.data!.docs[0]['Pincode'],
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
          ]);
        } else {
          return spinkit;
        }
      }),
    ));
  }
}
