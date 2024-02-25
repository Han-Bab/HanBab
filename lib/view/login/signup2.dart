import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:han_bab/controller/signup_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:io';
import '../../widget/PDFScreen.dart';
import '../../widget/button2.dart';
import '../app.dart';

class Signup2Page extends StatefulWidget {
  const Signup2Page({super.key});

  @override
  State<Signup2Page> createState() => _Signup2PageState();
}

class _Signup2PageState extends State<Signup2Page> {
  TextEditingController emailController = TextEditingController();
  String termsPDF = "";
  String personalPDF = "";
  bool obscure1 = true;
  bool obscure2 = true;

  @override
  void initState() {
    super.initState();
    SignupController controller =
    Provider.of<SignupController>(context, listen: false);
    emailController = TextEditingController(text: controller.email);
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
  void dispose() {
    // 컨트롤러들을 정리해주어야 합니다.
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SignupController controller = Provider.of<SignupController>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('회원가입'),
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
        body: Container(
          padding: const EdgeInsets.fromLTRB(24, 46, 24, 0),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          enabled: false,
                          controller: emailController,
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffC2C2C2), width: 0.5)),
                            contentPadding:
                            EdgeInsets.fromLTRB(0, 10, 10, 10),
                          ),
                        ),
                        const SizedBox(
                          height: 27,
                        ),
                        // 비밀번호 입력폼
                        Stack(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xffC2C2C2), width: 0.5)),
                                errorText: controller.passwordErrorText,
                                hintText: "비밀번호",
                                hintStyle: const TextStyle(
                                    color: Color(0xffC2C2C2),
                                    fontSize: 18,
                                    fontFamily: "PretendardLight"),
                                contentPadding:
                                const EdgeInsets.fromLTRB(0, 10, 10, 10),
                              ),
                              obscureText: obscure1,
                              focusNode: controller.pwFocus,
                              onSaved: (value) {
                                controller.setPassword(value!);
                              },
                              onChanged: (value) {
                                controller.setPassword(value);
                              },
                            ),
                            controller.password != "" ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(onPressed: (){
                                  setState(() {
                                    obscure1 = !obscure1;
                                  });
                                }, icon: Icon(!obscure1 ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: const Color(0xff1C1B1F), weight: 0.1,)),
                              ],
                            ) : Container()
                          ],
                        ),
                        const SizedBox(
                          height: 27,
                        ),
                        Stack(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xffC2C2C2), width: 0.5)),
                                errorText: controller.passwordConfirmErrorText,
                                hintText: "비밀번호 재확인",
                                hintStyle: const TextStyle(
                                    color: Color(0xffC2C2C2),
                                    fontSize: 18,
                                    fontFamily: "PretendardLight"),
                                contentPadding:
                                const EdgeInsets.fromLTRB(0, 10, 10, 10),
                              ),
                              focusNode: controller.pwConfirmFocus,
                              obscureText: obscure2,
                              onChanged: (value) {
                                controller.setPasswordConfirm(value);
                              },
                            ),
                            controller.passwordConfirm != "" ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(onPressed: (){
                                  setState(() {
                                    obscure2 = !obscure2;
                                  });
                                }, icon: Icon(!obscure2 ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: const Color(0xff1C1B1F), weight: 0.1,)),
                              ],
                            ) : Container()
                          ],
                        ),
                        const SizedBox(height: 27),
                        TextFormField(
                          onChanged: (value) {
                            controller.setAccount(value);
                          },
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffC2C2C2), width: 0.5)),
                            hintText: "(선택)  계좌번호  예) 1002452023325 우리",
                            hintStyle: TextStyle(
                                color: Color(0xffC2C2C2),
                                fontSize: 18,
                                fontFamily: "PretendardLight"),
                            contentPadding:
                            EdgeInsets.fromLTRB(0, 10, 10, 10),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.setOption1Selected(!controller.option1Selected);
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
                              builder: (context) => PDFScreen(path: termsPDF),
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
                  controller.setOption2Selected(!controller.option2Selected);
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
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(24,15,24,34),
          child: SizedBox(
              height: 60,
              child: Button2(
                function: controller.password == "" ||
                    controller.passwordConfirm == "" ||
                    !controller.option1Selected ||
                    !controller.option2Selected
                    ? null
                    : () async {
                  if (controller.step1Validation()) {
                    await controller.register();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const App()),
                      // MyApp 를 메인 페이지로 교체해 주세요.
                          (route) => false, // 모든 이전 루트를 제거하여 새로운 페이지로 이동합니다
                    );
                  }
                },
                title: '가입하기',
              )),
        ),
      ),
    );
  }
}