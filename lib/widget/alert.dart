import 'package:flutter/material.dart';

class AlertModal extends StatelessWidget {
  const AlertModal({Key? key, required this.text}) : super(key: key);

  final String text;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(29, 16, 29, 20),
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
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(color: const Color(0xffF0F0F0), borderRadius: BorderRadius.circular(10)),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 108),
                    child: Text("확인", style: TextStyle(fontSize: 18, fontFamily: "PretendardMedium"),),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
