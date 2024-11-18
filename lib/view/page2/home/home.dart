import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/view/page2/home/chatList.dart';
import 'package:han_bab/view/page2/home/nowEntering.dart';
import 'package:han_bab/widget/alert.dart';
import 'package:intl/intl.dart';
import '../../../database/databaseService.dart';
import '../../../widget/bottom_navigation.dart';
import '../../../widget/customToolbarShape.dart';

DateTime now = DateTime.now();
DateFormat formatter = DateFormat('yyyy-MM-dd');
String strToday = formatter.format(now);
var currentTime = DateFormat("HH:mm").format(now);

String getName(String res) {
  return res.substring(res.indexOf("_") + 1);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchText = "";
  String userName = "";

  @override
  void initState() {
    getUserName();
    super.initState();
  }

  getUserName() {
    DatabaseService().getUserName().then((value) {
      if (mounted) {
        setState(() {
          userName = value;
        });
      }
    });
  }


  Future<bool> _onBackPressed() async {
    final shouldExit = await showDialog(
        context: context,
        builder: (BuildContext context) => AlertModal(
          text: '나가시겠습니까?',
          yesOrNo: true,
          function: () {
            Navigator.pop(context, true);
          },
        ));

    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: homeAppBar(),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: Center(
                child: Column(
              children: [
                // ElevatedButton(onPressed: (){FirebaseAuth.instance.signOut();}, child: Text("비상탈출")),
                const SizedBox(
                  height: 22,
                ),
                NowEntering(userName: userName),
                const SizedBox(
                  height: 31,
                ),
                ChatList(searchText: searchText, userName: userName),
              ],
            )),
          ),
          bottomNavigationBar: const BottomNavigation(),
        ),
      ),
    );
  }

  PreferredSize homeAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: Container(
          color: Colors.transparent,
          child: Stack(fit: StackFit.loose, children: <Widget>[
            Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: const CustomPaint(
                  painter: CustomToolbarShape(lineColor: Colors.orange),
                )),
            const Align(
              alignment: Alignment(0.0, 0.1),
              child: Text(
                "한동 밥먹자",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: "GmarketSansMedium"),
              ),
            ),
            Align(
                alignment: const Alignment(0.0, 1.25),
                child: Container(
                    height: MediaQuery.of(context).size.height / 14.5,
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 20.0,
                              // shadow
                              spreadRadius: .5,
                              // set effect of extending the shadow
                              offset: Offset(
                                0.0,
                                5.0,
                              ),
                            )
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 15, 0, 15),
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: const Padding(
                                padding: EdgeInsets.only(right: 22.0),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.orange,
                                  size: 30,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(25)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(25))),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          onSubmitted: (submittedText) {
                            setState(() {
                              searchText = submittedText;
                            });
                          },
                        )))),
          ])),
    );
  }
}
