import 'package:flutter/material.dart';
import 'package:han_bab/controller/home_provider.dart';

Widget formPickUpPlace(BuildContext context, HomeProvider homeProvider) {
  Size size = MediaQuery.of(context).size;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '수령 장소 선택',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "PretendardMedium",
                ),
              ),
              TextButton(
                onPressed: () => homeProvider.showRecommendPlace(context, size),
                child: const Text(
                  '추천 장소 ❯',
                  style: TextStyle(
                    fontFamily: "PretendardMedium",
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        // 중복됨
        TextFormField(
          controller: homeProvider.pickUpPlaceController,
          onChanged: (value) {
            homeProvider.checkPickUpPlaceFieldIsEmpty(value);
          },
          decoration: InputDecoration(
            hintText: '직접 입력하기',
            hintStyle: const TextStyle(fontSize: 14),
            suffixIcon: homeProvider.pickUpPlaceFieldIsEmpty
                ? const IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.place_outlined,
                      color: Color.fromRGBO(194, 194, 194, 1),
                      size: 24,
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      homeProvider.pickUpPlaceController.clear();
                      homeProvider.checkPickUpPlaceFieldIsEmpty('');
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: Color.fromRGBO(194, 194, 194, 1),
                      size: 24,
                    ),
                  ),
            isDense: true,
            contentPadding: const EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color.fromRGBO(194, 194, 194, 1),
              ),
            ),
          ),
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}
