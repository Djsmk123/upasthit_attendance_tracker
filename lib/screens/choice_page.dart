

import 'package:flutter/material.dart';
import 'package:upasthit/screens/signup_screen.dart';

import '../components/FadeAnimation.dart';

class ChoicePage extends StatelessWidget {
  const ChoicePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/background.png'),
                        fit: BoxFit.fill)),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: FadeAnimation(
                          1,
                          Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/light-1.png'))),
                          )),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: FadeAnimation(
                          1.3,
                          Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/light-2.png'))),
                          )),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: FadeAnimation(
                          1.5,
                          Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/clock.png'))),
                          )),
                    ),
                    Positioned(
                      child: FadeAnimation(
                          1.6,
                          Container(
                            margin: const EdgeInsets.only(top: 50),
                            child: const Center(
                              child: Text(
                                "Role",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    FadeAnimation(
                        1.8,
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(143, 148, 251, .2),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10))
                              ]),
                        )),
                    rolesSelector(context: context, data: [
                      {
                        'index': 0,
                        'title': "Volunteer",
                        "image": "assets/images/volunteer-icon.png",
                      },
                      {
                        'index': 1,
                        'title': "Member",
                        "image": "assets/images/member.png",
                      },
                    ]),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ));
  }

  Widget rolesSelector(
      {required BuildContext context, required List<Map> data}) {
    List<Widget> cards = [
      rolesCards(
          context: context,
          imagePath: data[0]['image'],
          index: data[0]['index'],
          title: data[0]['title']),
      rolesCards(
          context: context,
          imagePath: data[1]['image'],
          index: data[1]['index'],
          title: data[1]['title']),
    ];
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: cards);
  }

  Widget rolesCards(
      {required BuildContext context,
      required String imagePath,
      required String title,
      required int index}) {
    return FadeAnimation(
      4,
      InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
              context,
             MaterialPageRoute(builder: (builder)=> SignUpScreen(
               index: index,
             ))
          );

        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          height: 180,
          width: 100,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Image.asset(
                    imagePath,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
