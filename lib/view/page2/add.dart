import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/view/page2/chat_page.dart';

import '../../database/databaseService.dart';

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
  String imageUrl =
      "https://firebasestorage.googleapis.com/v0/b/han-bab.appspot.com/o/hanbab_icon.png?alt=media&token=a5cf00de-d53f-4e57-8440-ef7a5f6c6e1c";
  String userName = "";
  String id = FirebaseAuth.instance.currentUser!.uid;
  String groupId = "";
  String loading = "start";
  String text = "";

  @override
  void initState() {
    getUserName();
    super.initState();
  }

  getUserName() {
    DatabaseService().getUserName().then((value) => setState(() {
          userName = value;
        }));
  }

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
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "밥채팅 만들기",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          if (!text.contains(nameController.text)) {
            setState(() {
              loading = "loading";
              text = nameController.text;
            });
            DatabaseService().getImage(nameController.text).then(
              (value) {
                if (value.contains("start")) {
                  setState(() {
                    loading = "start";
                  });
                } else if (value.contains(
                    "https://firebasestorage.googleapis.com/v0/b/han-bab.appspot.com/o/hanbab_icon.png?alt=media&token=a5cf00de-d53f-4e57-8440-ef7a5f6c6e1c")) {
                  setState(() {
                    loading = "null";
                  });
                } else {
                  setState(() {
                    loading = "";

                    imageUrl = value;
                  });
                }
              },
            );
          }
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(
              30,
              MediaQuery.of(context).size.height * 0.03,
              30,
              MediaQuery.of(context).size.height * 0.035),
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
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: loading == "start"
                              ? Column(
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
                                          fontSize: 16,
                                          color: Color(0xff919191)),
                                    )
                                  ],
                                )
                              : loading == "null"
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/icons/vector.png",
                                          scale: 2,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          "가게의 이미지가 준비중입니다",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff919191)),
                                        )
                                      ],
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: loading == "loading"
                                          ? const Center(
                                              child: CircularProgressIndicator(
                                              color: Colors.black,
                                            ))
                                          : Image.network(imageUrl,
                                              fit: BoxFit.fill)),
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
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
                                  onTapOutside:
                                      !text.contains(nameController.text)
                                          ? (PointerEvent event) {
                                              setState(() {
                                                loading = "loading";
                                                text = nameController.text;
                                              });
                                              DatabaseService()
                                                  .getImage(nameController.text)
                                                  .then(
                                                (value) {
                                                  if (value.contains("start")) {
                                                    setState(() {
                                                      loading = "start";
                                                    });
                                                  } else if (value.contains(
                                                      "https://firebasestorage.googleapis.com/v0/b/han-bab.appspot.com/o/hanbab_icon.png?alt=media&token=a5cf00de-d53f-4e57-8440-ef7a5f6c6e1c")) {
                                                    setState(() {
                                                      loading = "null";
                                                    });
                                                  } else {
                                                    setState(() {
                                                      loading = "";

                                                      imageUrl = value;
                                                    });
                                                  }
                                                },
                                              );
                                            }
                                          : null,
                                  onEditingComplete: () {
                                    setState(() {
                                      loading = "loading";
                                      text = nameController.text;
                                    });
                                    DatabaseService()
                                        .getImage(nameController.text)
                                        .then(
                                      (value) {
                                        if (value.contains("start")) {
                                          setState(() {
                                            loading = "start";
                                          });
                                        } else if (value.contains(
                                            "https://firebasestorage.googleapis.com/v0/b/han-bab.appspot.com/o/hanbab_icon.png?alt=media&token=a5cf00de-d53f-4e57-8440-ef7a5f6c6e1c")) {
                                          setState(() {
                                            loading = "null";
                                          });
                                        } else {
                                          setState(() {
                                            loading = "";

                                            imageUrl = value;
                                          });
                                        }
                                      },
                                    );
                                  },
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    hintText: "가게명을 입력해주세요",
                                    hintStyle: Theme.of(context)
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
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 8, 0, 8),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        _formatTime(pickedTime),
                                        style: Theme.of(context)
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
                                  controller: placeController,
                                  decoration: InputDecoration(
                                    hintText: "수령할 장소를 입력하세요",
                                    hintStyle: Theme.of(context)
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
                                  controller: peopleController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: "최대 인원을 입력하세요",
                                    hintStyle: Theme.of(context)
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
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 18.0, right: 18.0, top: 15, bottom: 15),
                          child: Text(
                            "취소",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15),
                          ),
                        )),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        var time =
                            '${pickedTime?.hour.toString().padLeft(2, '0')}:${pickedTime?.minute.toString().padLeft(2, '0')}';
                        DatabaseService()
                            .createGroup(
                                userName,
                                id,
                                nameController.text,
                                time,
                                placeController.text,
                                peopleController.text,
                                imageUrl)
                            .then((value) {
                          setState(() {
                            groupId = value;
                          });
                          Map<String, dynamic> chatMessageMap = {
                            "message": "$userName 님이 입장하셨습니다",
                            "sender": userName,
                            "time": DateTime.now().toString(),
                            "isEnter": 1
                          };

                          DatabaseService().sendMessage(value, chatMessageMap);
                        }).whenComplete(() => Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                          groupId: groupId,
                                          groupName: nameController.text,
                                          userName: userName,
                                          groupTime: time,
                                          groupPlace: placeController.text,
                                          groupCurrent: 1,
                                          groupAll:
                                              int.parse(peopleController.text),
                                          members: ["${id}_$userName"],
                                        ))));
                      },
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
