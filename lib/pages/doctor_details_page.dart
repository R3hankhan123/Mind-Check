import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

// ignore: must_be_immutable
class DoctorProfilePage extends StatefulWidget {
  String name;
  String email;
  String phone;
  String city;
  String hospital;
  DoctorProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    required this.hospital,
  });

  @override
  State<DoctorProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<DoctorProfilePage> {
  late TwilioFlutter twilioFlutter;
  final curr = FirebaseAuth.instance;
  final spinkit = const SpinKitRipple(
    color: Color.fromRGBO(0, 99, 219, 1),
    size: 50.0,
  );

  @override
  void initState() {
    super.initState();
    twilioFlutter = TwilioFlutter(
        accountSid: 'XXXXXX', authToken: 'XXXXXX', twilioNumber: 'XXXXXX');
  }

  void sendSms(String name, String phone) async {
    twilioFlutter.sendSMS(
        toNumber: '+91${widget.phone}',
        messageBody:
            'Hello Dr ${widget.name}, I am  $name and my phone number is $phone. I want to book an appointment with you.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Doctor's Profile")),
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
          elevation: 0,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('Email', isEqualTo: curr.currentUser?.email)
              .snapshots(),
          builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return Container(
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
                child: ListView(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const CircleAvatar(
                          minRadius: 80.0,
                          child: CircleAvatar(
                            radius: 70.0,
                            backgroundImage: NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiEGk3Z0eB7ISHbhC8uHMEYQWvge6RIz2j6g&usqp=CAU'),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        ListTile(
                          title: const Text(
                            'Hospital',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 99, 219, 1),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            widget.hospital,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text(
                            'City',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 99, 219, 1),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            widget.city,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text(
                            'Phone Number',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 99, 219, 1),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '+91${widget.phone}',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 100,
                        ),
                        MaterialButton(
                          onPressed: () {
                            sendSms(snapshot.data!.docs[0]['Name'],
                                snapshot.data!.docs[0]['Phone']);
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Appointment Booked'),
                                    content: const Text(
                                        'Your appointment has been booked. You will be contacted by the doctor soon.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: const Color.fromRGBO(0, 99, 219, 1),
                          child: const Text(
                            'Book Appointment',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            } else {
              return spinkit;
            }
          }),
        ));
  }
}
