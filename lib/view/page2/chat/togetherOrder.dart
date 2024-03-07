import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TogetherOrder extends StatelessWidget {
  TogetherOrder({Key? key, required this.link, required this.close})
      : super(key: key);

  late Uri _url;
  final String link;
  final bool close;

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: close
          ? null
          : () {
              _url = Uri.parse(link);
              _launchUrl();
            },
      child: Padding(
        padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 9.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
                color:
                    close ? const Color(0xffC2C2C2) : const Color(0xff3DBABE),
                width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                offset: Offset(0, 1),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 13.0),
                child: Text(
                  close ? "정산이  완료되었습니다." : "함께 주문 바로가기",
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: "PretendardSemiBold",
                      color: close ? const Color(0xffC2C2C2) : const Color(0xff3DBABE)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
