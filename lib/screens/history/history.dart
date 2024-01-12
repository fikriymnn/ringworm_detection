import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ringworm_detection/navigationDrawer/navigationDrawer.dart';

class HistoryScreens extends StatefulWidget {
  const HistoryScreens({super.key});
  static const String routName = '/history';

  @override
  State<HistoryScreens> createState() => _HistoryScreensState();
}

class _HistoryScreensState extends State<HistoryScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      drawer: const NavigatorDrawer(),
      body: SingleChildScrollView(
          child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("penyakit")
            .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length < 1) {
              return const Padding(
                padding: EdgeInsets.only(top: 200),
                child: Center(child: Text("Belum ada History")),
              );
            }
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final format = new DateFormat('yyyy-MM-dd');
                  dynamic accuracy = snapshot.data.docs[index]['accuracy'];
                  dynamic date = format
                      .format(snapshot.data.docs[index]['createdAt'].toDate());
                  dynamic img = snapshot.data.docs[index]['img'];
                  dynamic label = snapshot.data.docs[index]['label'];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 150,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(img),
                                    fit: BoxFit.cover)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "penyakit : ${label}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    date.toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          );
        },
      )),
    );
  }
}
