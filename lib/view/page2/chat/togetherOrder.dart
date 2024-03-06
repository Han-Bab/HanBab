import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TogetherOrder extends StatelessWidget {
  TogetherOrder({Key? key, required this.link}) : super(key: key);

  late Uri _url;
  final String link;

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _url = Uri.parse(
            link);
        _launchUrl();
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 9.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
              border: Border.all(color: const Color(0xff3DBABE), width: 1.5)
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 13.0),
                child: Text("함께 주문 바로가기", style: TextStyle(fontSize: 16, fontFamily: "PretendardSemiBold", color: Color(0xff3DBABE)),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
