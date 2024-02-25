import 'package:flutter/material.dart';
import 'package:han_bab/database/databaseService.dart';

import '../../widget/button.dart';
import '../app.dart';

class ProfileModify extends StatefulWidget {
  const ProfileModify(
      {Key? key,
      required this.name,
      required this.email,
      required this.phone,
      required this.account})
      : super(key: key);

  final String name;
  final String email;
  final String phone;
  final String account;

  @override
  State<ProfileModify> createState() => _ProfileModifyState();
}

class _ProfileModifyState extends State<ProfileModify> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController accountController = TextEditingController();

  @override
  void initState() {
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
    accountController = TextEditingController(text: widget.account);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("프로필 상세정보"),
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 30, 24, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("내 정보 변경"),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            enabled: false,
                            controller: nameController,
                            onChanged: (value) {
                              setState(() {
                                nameController.text = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            enabled: false,
                            controller: emailController,
                            onChanged: (value) {
                              setState(() {
                                emailController.text = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            enabled: false,
                            controller: phoneController,
                            onChanged: (value) {
                              setState(() {
                                phoneController.text = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            controller: accountController,
                            onChanged: (value) {
                              setState(() {
                                accountController.text = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          const Text("개인 정보 수정시 고객센터로 문의 주시기 바랍니다.")
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Button(
                      backgroundColor: Theme.of(context).primaryColor,
                      function: () async {
                        FocusScope.of(context).unfocus();
                        await DatabaseService().modifyUserInfo(
                            nameController.text,
                            emailController.text,
                            phoneController.text,
                            accountController.text);

                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('정보가 변경되었습니다.'),
                          duration: Duration(seconds: 5),
                        ));
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const App()),
                            (route) => false);
                      },
                      title: '저장하기',
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
