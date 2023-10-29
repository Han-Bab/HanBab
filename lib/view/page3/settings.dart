import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../../widget/PDFScreen.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String termsPDF = "";
  String personalPDF = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fromAsset('assets/pdf/terms.pdf', 'terms.pdf').then((f) {
      setState(() {
        termsPDF = f.path;
      });
    });
    fromAsset('assets/pdf/personal2.pdf', 'terms.pdf').then((f) { // 수정
      setState(() {
        personalPDF = f.path;
      });
    });
  }
  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("환경설정"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffF97E13),
                Color(0xffFFCD96),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  if (termsPDF.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PDFScreen(path: termsPDF),
                      ),
                    );
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("이용약관", style: TextStyle(fontSize: 25),),
                    Icon(Icons.arrow_forward_ios_outlined)
                  ],
                ),
              ),
              const Divider(),
              GestureDetector(onTap: (){
                if (personalPDF.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFScreen(path: personalPDF),
                    ),
                  );
                }
              },child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("개인정보처리방침", style: TextStyle(fontSize: 25),),
                  Icon(Icons.arrow_forward_ios_outlined)
                ],
              ),),
              const Divider(),
              GestureDetector(
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("알림설정", style: TextStyle(fontSize: 25),),
                      Icon(Icons.arrow_forward_ios_outlined)
                    ],
                  ),),
            ],
          ),
        ),
      ),
    );
  }
}