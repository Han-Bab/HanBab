import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertModal extends StatelessWidget {
  const AlertModal({
    Key? key,
    required this.text,
    required this.yesOrNo,
    required this.function
  }) : super(key: key);

  final String text;
  final bool yesOrNo;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "./assets/icons/alertIcon.png",
                scale: 2,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 18),
                      softWrap: true,
                      maxLines: null,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 43,
              ),
              yesOrNo == false
                  ? GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xffF0F0F0),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10),
                                child: Center(
                                  child: Text(
                                    "확인",
                                    style: TextStyle(
                                        fontSize: 18, fontFamily: "PretendardMedium"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xffF0F0F0),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Center(
                                  child: Text(
                                    "아니오",
                                    style: TextStyle(
                                        fontSize: 18, fontFamily: "PretendardMedium"),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ),
                        const SizedBox(width: 12,),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                             function();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Center(
                                  child: Text(
                                    "네",
                                    style: TextStyle(
                                      color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: "PretendardMedium"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
