import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'databaseService.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TimeOfDay? pickedTime;
  TextEditingController nameController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController peopleController = TextEditingController();

  String _formatTime(TimeOfDay? time) {
    if (time == null) {
      return "주문 예정 시간을 설정해주세요";
    } else {
      final hours = time.hour.toString().padLeft(2, '0');
      final minutes = time.minute.toString().padLeft(2, '0');
      return '$hours:$minutes';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "밥채팅 만들기",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme
            .of(context)
            .primaryColor,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xff919191)),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: SizedBox(
                          width: 400,
                          height: 250,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icons/vector.png",
                                scale: 2,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "가게를 검색하세요",
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xff919191)),
                              )
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                      //key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "./assets/icons/search.png",
                                scale: 2,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: TextFormField(
                                  onTapOutside: (PointerEvent event) {
                                    DatabaseService().getImage(nameController.text);
                                  },
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    hintText: "가게명을 입력해주세요",
                                    hintStyle: Theme
                                        .of(context)
                                        .inputDecorationTheme
                                        .hintStyle,
                                    contentPadding:
                                    const EdgeInsets.fromLTRB(16, 8, 0, 8),
                                    fillColor: Colors.transparent,
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Color(0xffC2C2C2)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.black87),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '가게명을 입력해주세요.';
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Image.asset("./assets/icons/time.png", scale: 2),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    TimeOfDay? selectedTime =
                                    await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    if (selectedTime != null) {
                                      setState(() {
                                        pickedTime = selectedTime;
                                      });
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: const Border.fromBorderSide(
                                        BorderSide(
                                            width: 1, color: Color(0xffC2C2C2)),
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    height: 50, // TextField 높이에 맞추세요.
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 8, 0, 8),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        _formatTime(pickedTime),
                                        style: Theme
                                            .of(context)
                                            .inputDecorationTheme
                                            .hintStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                "./assets/icons/place.png",
                                scale: 2,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "수령할 장소를 입력하세요",
                                    hintStyle: Theme
                                        .of(context)
                                        .inputDecorationTheme
                                        .hintStyle,
                                    contentPadding:
                                    const EdgeInsets.fromLTRB(16, 8, 0, 8),
                                    fillColor: Colors.transparent,
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Color(0xffC2C2C2)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.black87),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '수령할 장소를 입력하세요.';
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                "./assets/icons/people.png",
                                scale: 2,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: "최대 인원을 입력하세요",
                                    hintStyle: Theme
                                        .of(context)
                                        .inputDecorationTheme
                                        .hintStyle,
                                    contentPadding:
                                    const EdgeInsets.fromLTRB(16, 8, 0, 8),
                                    fillColor: Colors.transparent,
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Color(0xffC2C2C2)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.black87),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '최대 인원을 입력하세요.';
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          side: BorderSide(
                            width: 1,
                            color: Theme
                                .of(context)
                                .primaryColor,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 18.0, right: 18.0, top: 15, bottom: 15),
                          child: Text(
                            "취소",
                            style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                fontSize: 15),
                          ),
                        )),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(
                            left: 18.0, right: 18.0, top: 15, bottom: 15),
                        child: Text(
                          "만들기",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
