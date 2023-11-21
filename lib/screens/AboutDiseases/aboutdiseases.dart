import 'package:flutter/material.dart';

import '../../navigationDrawer/navigationDrawer.dart';
import 'Blister.dart';
import 'acne.dart';
import 'chickenpox.dart';
import 'eczema.dart';
import 'healthyskin.dart';
import 'melanoma.dart';
import 'psoriasis.dart';

class AboutDisease extends StatefulWidget {
  const AboutDisease({Key? key}) : super(key: key);

  static const String routeName = '/aboutdisease';
  @override
  State<AboutDisease> createState() => _AboutDiseaseState();
}

class _AboutDiseaseState extends State<AboutDisease> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("About Diseases")),
        body: SingleChildScrollView(
          child: Material(
            child: Column(children: [
              ListTile(
                leading: const Icon(Icons.assignment_rounded),
                title: const Text("Ringworm"),
                subtitle: const Text("Ringworm adalah infeksi kulit ...."),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Acne())),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
              ListTile(
                leading: const Icon(Icons.assignment_rounded),
                title: const Text("Healthy Skin"),
                subtitle: const Text("Keindahan kulit adalah Anda dapat......"),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Healthy())),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ]),
          ),
        ),
        drawer: const NavigatorDrawer(),
      ),
    );
  }
}
