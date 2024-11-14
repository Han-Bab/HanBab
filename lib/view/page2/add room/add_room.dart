import 'package:flutter/material.dart';
import 'package:han_bab/controller/home_provider.dart';
import 'package:han_bab/controller/map_provider.dart';
import 'package:han_bab/view/page2/add%20room/create_form.dart';
import 'package:han_bab/widget/appBar.dart';
import 'package:provider/provider.dart';
import 'bottom_navigation_bar.dart';

class AddRoomPage extends StatelessWidget {
  final bool isModify;

  const AddRoomPage({super.key, required this.isModify});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final mapProvider = Provider.of<MapProvider>(context);

    return Consumer<HomeProvider>(
      builder: (context, value, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: Column(
              children: [
                appbar(context, isModify ? "함께주문 수정하기" : "함께주문 만들기"),
                createForm(context, isModify, mapProvider, homeProvider),
              ],
            ),
            bottomNavigationBar: bottomNavigationBar(
                context, mapProvider, homeProvider, isModify),
          ),
        );
      },
    );
  }
}
