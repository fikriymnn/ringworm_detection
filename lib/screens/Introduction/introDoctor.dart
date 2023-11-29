import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../navigationDrawer/navigationDrawerDoctor.dart';
import '../../routes/pageRoute.dart';

class IntroDoctor extends StatelessWidget {
  const IntroDoctor({Key? key}) : super(key: key);

  static const String routeName = '/intropageDoctor';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Material(
            child: Background(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double
                        .infinity, //MediaQuery.of(context).size.height * 0.4,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Image.asset("assets/images/introimage.jpg"),
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.height * 0.4,
                      // height: MediaQuery.of(context).size.height *0.1,
                      child: const Text(
                        "\n Selamat Datang di\n Ringworm Disease Detection App",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.arrow_forward),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, PageRoutes.homeDoctor),
        ),
        drawer: const NavigatorDrawerDoctor(),
      ),
    );
  }
}

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        height: size.height,
        width: double.infinity,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            // Positioned(
            //   top: 0,
            //   left: 0,
            //   child: SvgPicture.asset("assets/images/Eclipse1.svg"),
            // ),
            // Positioned(
            //   top: 0,
            //   right: 0,
            //   child: SvgPicture.asset("assets/images/Eclipse2.svg"),
            // ),
            child,
          ],
        ),
      ),
    );
  }
}
