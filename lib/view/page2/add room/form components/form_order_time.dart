import 'package:flutter/material.dart';
import 'package:han_bab/controller/home_provider.dart';

import '../../../../widget/time_picker/dates.dart';
import '../../../../widget/time_picker/hours.dart';
import '../../../../widget/time_picker/minutes.dart';

Widget formOrderTime(BuildContext context, HomeProvider homeProvider) {
  FixedExtentScrollController datesController =
      FixedExtentScrollController(initialItem: homeProvider.selectedDatesIndex);
  FixedExtentScrollController hoursController =
      FixedExtentScrollController(initialItem: homeProvider.selectedHoursIndex);
  FixedExtentScrollController minutesController = FixedExtentScrollController(
      initialItem: homeProvider.selectedMinutesIndex);

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Text(
            '주문 예정 시간',
            style: TextStyle(
              fontSize: 16,
              fontFamily: "PretendardMedium",
            ),
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                height: 50,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 200,
                    child: ListWheelScrollView.useDelegate(
                      controller: datesController,
                      itemExtent: 50,
                      perspective: 0.005,
                      diameterRatio: 1.2,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        homeProvider.setSelectedDatesIndex(index);

                        homeProvider.setWillOrderDateTime();
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: 2,
                        builder: (context, index) {
                          if (index == homeProvider.selectedDatesIndex) {
                            if (index == 0) {
                              return const DatePicker(
                                isToday: true,
                                color: Colors.white,
                              );
                            } else {
                              return const DatePicker(
                                isToday: false,
                                color: Colors.white,
                              );
                            }
                          } else {
                            if (index == 0) {
                              return DatePicker(
                                isToday: true,
                                color: Colors.grey[400]!,
                              );
                            } else {
                              return DatePicker(
                                isToday: false,
                                color: Colors.grey[400]!,
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 200,
                    child: ListWheelScrollView.useDelegate(
                      controller: hoursController,
                      itemExtent: 50,
                      perspective: 0.005,
                      diameterRatio: 1.2,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        homeProvider.setSelectedHoursIndex(index);

                        homeProvider.setWillOrderDateTime();
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: 24,
                        builder: (context, index) {
                          if (index == homeProvider.selectedHoursIndex) {
                            return HourPicker(
                              hours: index,
                              color: Colors.white,
                            );
                          } else {
                            return HourPicker(
                              hours: index,
                              color: Colors.grey[400]!,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 200,
                    child: ListWheelScrollView.useDelegate(
                      controller: minutesController,
                      itemExtent: 50,
                      perspective: 0.005,
                      diameterRatio: 1.2,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        homeProvider.setSelectedMinutesIndex(index);

                        homeProvider.setWillOrderDateTime();
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: 60,
                        builder: (context, index) {
                          if (index == homeProvider.selectedMinutesIndex) {
                            return MinutePicker(
                              mins: index,
                              color: Colors.white,
                            );
                          } else {
                            return MinutePicker(
                              mins: index,
                              color: Colors.grey[400]!,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Color.fromRGBO(194, 194, 194, 1)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      int mins = homeProvider.selectedMinutesIndex + 10;
                      if (mins > 59) {
                        mins = mins - 60;
                        homeProvider.setSelectedHoursIndex(
                            homeProvider.selectedHoursIndex + 1);
                        hoursController.animateToItem(
                          homeProvider.selectedHoursIndex,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                        if (homeProvider.selectedHoursIndex == 24) {
                          homeProvider.setSelectedHoursIndex(0);
                          homeProvider.setSelectedDatesIndex(1);
                          hoursController.animateToItem(
                            homeProvider.selectedHoursIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                          datesController.animateToItem(
                            homeProvider.selectedDatesIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      }
                      homeProvider.setSelectedMinutesIndex(mins);
                      minutesController.animateToItem(
                        homeProvider.selectedMinutesIndex,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );

                      homeProvider.setWillOrderDateTime();
                    },
                    child: const Text(
                      '10분 후',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Color.fromRGBO(194, 194, 194, 1)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      int mins = homeProvider.selectedMinutesIndex + 20;
                      if (mins > 59) {
                        mins = mins - 60;
                        homeProvider.setSelectedHoursIndex(
                            homeProvider.selectedHoursIndex + 1);
                        hoursController.animateToItem(
                          homeProvider.selectedHoursIndex,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                        if (homeProvider.selectedHoursIndex == 24) {
                          homeProvider.setSelectedHoursIndex(0);
                          homeProvider.setSelectedDatesIndex(1);
                          hoursController.animateToItem(
                            homeProvider.selectedHoursIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                          datesController.animateToItem(
                            homeProvider.selectedDatesIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      }
                      homeProvider.setSelectedMinutesIndex(mins);
                      minutesController.animateToItem(
                        homeProvider.selectedMinutesIndex,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );

                      homeProvider.setWillOrderDateTime();
                    },
                    child: const Text(
                      '20분 후',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Color.fromRGBO(194, 194, 194, 1)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      int mins = homeProvider.selectedMinutesIndex + 30;
                      if (mins > 59) {
                        mins = mins - 60;
                        homeProvider.setSelectedHoursIndex(
                            homeProvider.selectedHoursIndex + 1);
                        hoursController.animateToItem(
                          homeProvider.selectedHoursIndex,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                        if (homeProvider.selectedHoursIndex == 24) {
                          homeProvider.setSelectedHoursIndex(0);
                          homeProvider.setSelectedDatesIndex(1);
                          hoursController.animateToItem(
                            homeProvider.selectedHoursIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                          datesController.animateToItem(
                            homeProvider.selectedDatesIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      }
                      homeProvider.setSelectedMinutesIndex(mins);
                      minutesController.animateToItem(
                        homeProvider.selectedMinutesIndex,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );

                      homeProvider.setWillOrderDateTime();
                    },
                    child: const Text(
                      '30분 후',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Color.fromRGBO(194, 194, 194, 1)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      int hours = homeProvider.selectedHoursIndex + 1;
                      if (hours > 23) {
                        hours = 0;
                        homeProvider.setSelectedDatesIndex(1);
                        datesController.animateToItem(
                          homeProvider.selectedDatesIndex,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      }
                      homeProvider.setSelectedHoursIndex(hours);
                      hoursController.animateToItem(
                        homeProvider.selectedHoursIndex,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );

                      homeProvider.setWillOrderDateTime();
                    },
                    child: const Text(
                      '1시간 후',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 15),
          child: Text(
            "주문 예정 시간은 언제든지 수정할 수 있어요",
            style: TextStyle(
              color: Color.fromRGBO(125, 125, 125, 1),
              fontSize: 12,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    ),
  );
}
