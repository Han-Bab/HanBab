import 'package:flutter/material.dart';

class ProfileModify extends StatelessWidget {
  const ProfileModify({Key? key, required this.name, required this.email, required this.phone}) : super(key: key);

  final String name;
  final String email;
  final String phone;

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController emailController = TextEditingController(text: email);
    TextEditingController phoneController = TextEditingController(text: phone);


    return Scaffold(
      appBar: AppBar(
        title: const Text("프로필 관리"),
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 30, 24, 48),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("내 정보 변경"),
                  TextFormField(controller: nameController,),
                  TextFormField(controller: emailController,),
                  TextFormField(controller: phoneController,)
                ],
              ),
            ),
            ElevatedButton(onPressed: (){}, child: Text("저장하기"))
          ],
        ),
      ),
    );
  }
}
