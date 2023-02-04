import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:mind_check/api/qr.dart';

class DiagnosisPage extends StatefulWidget {
  const DiagnosisPage({super.key});

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  final TextEditingController _controller = TextEditingController();
  bool isLoading = true;
  String url = '';
  Future<void> genQR() async {
    try {
      Uri uri = Uri.parse(
          'https://api.apyhub.com/generate/qr-code/url?output=sample.png');
      var body = jsonEncode(
          {'content': 'https://huggingface.co/spaces/upranayak/MindCheck'});
      var response = await http.post(uri,
          headers: {
            'apy-token':
                'APY0rM9hVfGAphpF1sdZ4JXsUS8bJAa5bsvJYbHaT9vQ3jQVIfDtU51GbLDYCu6RZbTQMuEu9A',
            'Content-Type': 'application/json'
          },
          body: body);
      final Url url = Url.fromJson(jsonDecode(response.body));
      setState(() {
        this.url = url.data!;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error, please try again later'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final spinkit = const SpinKitDualRing(
    color: Color.fromRGBO(0, 99, 219, 1),
    size: 50.0,
  );
  @override
  initState() {
    genQR();
    super.initState();
  }

  final currentUser = FirebaseAuth.instance;
  Future<void> addDianosis() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.currentUser!.uid)
          .update({'Diagonsis': FieldValue.arrayUnion([])});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error, please try again later'),
        ),
      );
    }
  }

  final curr = FirebaseAuth.instance;
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
                    children: <Widget>[
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Image.asset(
                            'asset/mind-check-high-resolution-logo-color-on-transparent-background.png'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "So how has social media affeced you lately?",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 45,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "If you said depressed,anxious,feel free to talk to our chatbot or Schedule an appointment with a therapist ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: TextButton(
                          onPressed: () async {
                            Uri uri = Uri.parse(
                                'https://huggingface.co/spaces/upranayak/MindCheck');
                            await launchUrl(uri);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(0, 99, 219, 1),
                          ),
                          child: const Text(
                            "Click here to chat",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Or",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Scan the QR code ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: isLoading
                            ? spinkit
                            : Image.network(
                                url,
                              ),
                      ),
                    ],
                  ),
                ))
          ]);
        } else {
          return spinkit;
        }
      }),
    ));
  }
}
