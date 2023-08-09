import 'package:flutter/material.dart';

class FullRoom extends StatelessWidget {
  const FullRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Container(
        width: 358,
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        // builder에서 정의된 변수들로 변경하였습니다.
        child: Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("이미 방이 꽉 찼습니다.", style: TextStyle(fontSize: 24, color: Color(0xff3E3E3E)),),
              const SizedBox(height: 40,),
              TextButton(onPressed: (){Navigator.pop(context);}, child: Text("확인", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff75B165)),))
            ],
          ),
        )
      ),
    );
  }
}
