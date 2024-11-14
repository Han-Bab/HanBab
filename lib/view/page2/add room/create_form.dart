import 'package:flutter/material.dart';
import 'package:han_bab/controller/home_provider.dart';
import 'package:han_bab/view/page2/add%20room/form%20components/form_order_time.dart';
import 'package:han_bab/view/page2/add%20room/form%20components/form_pick_up_place.dart';
import 'package:han_bab/view/page2/add%20room/form%20components/form_max_people.dart';
import 'package:han_bab/view/page2/add%20room/form%20components/form_together_order_link.dart';

import '../../../controller/map_provider.dart';

Widget createForm(BuildContext context, bool isModify, MapProvider mapProvider,
    HomeProvider homeProvider) {
  return Expanded(
    child: SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            /* 배민 함께 주문하기 링크 복붙 */
            formTogetherOrderLink(context, isModify, mapProvider, homeProvider),
            const Divider(thickness: 5, color: Color(0xffE4E4E4)),

            /* 최대 인원 선택 */
            formMaxPeople(context, homeProvider),
            const Divider(thickness: 5, color: Color(0xffE4E4E4)),

            /* 수령 장소 선택 */
            formPickUpPlace(context, homeProvider),
            const Divider(thickness: 5, color: Color(0xffE4E4E4)),

            /* 주문 예정 시간 */
            formOrderTime(context, homeProvider),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ],
        ),
      ),
    ),
  );
}
