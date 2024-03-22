import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/controller/signup_controller.dart';
import 'package:han_bab/widget/appBar.dart';
import 'package:han_bab/widget/config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../widget/PDFScreen.dart';
import '../../widget/button.dart';
import '../../widget/flutterToast.dart';

class Signup3Page extends StatefulWidget {
  const Signup3Page({super.key});

  @override
  State<Signup3Page> createState() => _Signup3PageState();
}

class _Signup3PageState extends State<Signup3Page> {
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
    fromAsset('assets/pdf/personal.pdf', 'terms.pdf').then((f) {
      // 수정
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
    final controller = Provider.of<SignupController>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: appbar(context, "회원가입"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: const TextSpan(
                      children: [
                        TextSpan(
                          text: '한밥',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 23,
                          ),
                        ),
                        TextSpan(
                          text: '을 사용하기 전\n약관에 동의해주세요 :)',
                          style: TextStyle(
                            color: Color.fromARGB(255, 116, 116, 116),
                            fontSize: 23,
                          ),
                        ),
                      ],
                    )),
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller
                                  .setAllSelected(!controller.allSelected);
                            },
                            child: Row(
                              children: [
                                Checkbox(
                                  value: controller.allSelected,
                                  visualDensity: VisualDensity.compact,
                                  onChanged: (selected) {
                                    controller.setAllSelected(selected!);
                                  },
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  '모두 동의합니다',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          GestureDetector(
                            onTap: () {
                              controller.setOption1Selected(
                                  !controller.option1Selected);
                            },
                            child: Row(
                              children: [
                                Checkbox(
                                  value: controller.option1Selected,
                                  visualDensity: VisualDensity.compact,
                                  onChanged: (selected) {
                                    controller.setOption1Selected(selected!);
                                  },
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    '한밥 이용약관 동의',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (termsPDF.isNotEmpty) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PDFScreen(path: termsPDF),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.setOption2Selected(
                                  !controller.option2Selected);
                            },
                            child: Row(
                              children: [
                                Checkbox(
                                  value: controller.option2Selected,
                                  visualDensity: VisualDensity.compact,
                                  onChanged: (selected) {
                                    controller.setOption2Selected(selected!);
                                  },
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    '개인정보 수집 및 이용 동의',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (personalPDF.isNotEmpty) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PDFScreen(path: personalPDF),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 28),
          child: SizedBox(
            height: 42,
            child: Button(
              backgroundColor: Theme.of(context).primaryColor,
              function: () async {
                if (controller.optionsValidation()) {
                  // DEBUG
                  print(
                      "-----------------------------------------------------------");
                  controller.printAll();
                  await controller.register();
                  Future.delayed(const Duration(seconds: 1));
                  try {
                    final user = FirebaseAuth.instance.currentUser!;
                    await user.sendEmailVerification();
                  } catch (e) {
                    print(e);
                  }
                  Navigator.pushNamed(context, '/verify');
                } else {
                  FToast().init(context);
                  FToast().showToast(
                    child: toastTemplate('약관에 동의해주세요', Icons.check,
                        Theme.of(context).primaryColor),
                    gravity: ToastGravity.CENTER,
                  );
                }
              },
              title: '회원가입',
            ),
          ),
        ),
      ),
    );
  }
}
