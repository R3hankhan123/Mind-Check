import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mind_check/pages/doctor_details_page.dart';

class DoctorList extends StatefulWidget {
  const DoctorList({super.key});

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(67, 206, 162, 1),
            Color.fromRGBO(24, 90, 157, 1)
          ],
        ),
      ),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final doctorList = snapshot.data!.docs;
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: doctorList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DoctorProfilePage(
                                  name: doctorList[index]['Name'],
                                  email: doctorList[index]['Email'],
                                  phone: doctorList[index]['Phone'],
                                  city: doctorList[index]['City'],
                                  hospital: doctorList[index]['Hospital'],
                                )));
                  },
                  child: Card(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiEGk3Z0eB7ISHbhC8uHMEYQWvge6RIz2j6g&usqp=CAU'),
                        radius: 60,
                      ),
                      SizedBox(
                        width: 180,
                        child: Column(
                          children: [
                            Text(
                              "Dr ${doctorList[index]['Name']}",
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(doctorList[index]['Email'],
                                style: const TextStyle(fontSize: 18)),
                            Text(doctorList[index]['Phone'],
                                style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 220,
                        child: Column(
                          children: [
                            Text(doctorList[index]['City'],
                                style: const TextStyle(fontSize: 18)),
                            Text(doctorList[index]['Hospital'],
                                style: const TextStyle(fontSize: 18)),
                            Text(doctorList[index]['Pincode'],
                                style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                      )
                    ],
                  )),
                );
              },
            );
          } else {
            return const SpinKitDualRing(
              color: Color.fromRGBO(12, 205, 163, 1),
              size: 50.0,
            );
          }
        },
      ),
    ));
  }
}
