import 'package:flutter/material.dart';
import 'package:han_bab/controller/auth_controller.dart';
import 'package:han_bab/model/text_input_model.dart';
import 'package:han_bab/widget/bottom_navigation.dart';
import 'package:han_bab/widget/encryption.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    TextInputModel textInputModel = Provider.of<TextInputModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
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
        actions: [
          IconButton(
              onPressed: () {
                authController.logout();
              },
              icon: const Icon(Icons.logout_rounded)),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                controller: textInputModel.textEditingController,
              )),
              ElevatedButton(
                onPressed: () {
                  print(textInputModel.textEditingController.text);
                  textInputModel.encrypt = AccountEncryption.encryptWithAESKey(
                      textInputModel.textEditingController.text);
                },
                child: const Text('Encrypt'),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(child: TextFormField()),
              ElevatedButton(
                onPressed: () {
                  textInputModel.decrypt = AccountEncryption.decryptWithAESKey(
                      textInputModel.encrypt);
                },
                child: const Text('Decrypt'),
              ),
            ],
          ),
          Consumer<TextInputModel>(
            builder: (context, textInputModel, child) {
              return Column(
                children: [
                  SelectableText(
                      'Original Text: ${textInputModel.textEditingController.text}'),
                  SelectableText('Encrypt Text: ${textInputModel.encrypt}'),
                  SelectableText('Decrypt Text: ${textInputModel.decrypt}'),
                ],
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
