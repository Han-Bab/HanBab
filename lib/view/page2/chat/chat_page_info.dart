import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../color_schemes.dart';

class ChatInfo extends StatefulWidget {
  const ChatInfo({Key? key, required this.snapshot}) : super(key: key);
  final snapshot;

  @override
  State<ChatInfo> createState() => _ChatInfoState();
}

class _ChatInfoState extends State<ChatInfo> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 0.5),
            )
          ],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
                children: [
                  !_expanded
                      ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    child: Column(
                      children: [
                        widget.snapshot.data['close'] >= 1
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 14.0),
                                child: Image.asset(
                                    "./assets/icons/chat_icons/order${widget.snapshot.data['close'].floor()}.png"),
                              )
                            : Container(),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        "./assets/icons/time2.png",
                                        scale: 2,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        widget.snapshot.data['orderTime'],
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "PretendardMedium",
                                            color: lightColorScheme.primary),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "./assets/icons/money.png",
                                        scale: 2,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        widget.snapshot.data['deliveryTip'] ==
                                                -1
                                            ? "? 원"
                                            : "${NumberFormat('#,###').format(widget.snapshot.data['deliveryTip'] / widget.snapshot.data['members'].length)}원",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "PretendardMedium",
                                            color: lightColorScheme.primary),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Flexible(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "./assets/icons/vector2.png",
                                          scale: 2,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            widget.snapshot.data['pickup'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "PretendardMedium",
                                              color: lightColorScheme.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              "./assets/icons/arrow_down.png",
                              scale: 1.8,
                            )
                          ],
                        ),
                      ],
                    ),
                  ): Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    child: Column(
                      children: [
                        widget.snapshot.data['close'] >= 1
                            ? Padding(
                          padding: const EdgeInsets.only(bottom: 14.0),
                          child: Image.asset(
                              "./assets/icons/chat_icons/order${widget.snapshot.data['close'].floor()}.png"),
                        )
                            : Container(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      "./assets/icons/time2.png",
                                      scale: 2,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      "주문예정시간",
                                      style: TextStyle(
                                          fontFamily: "PretendardMedium",
                                          fontSize: 14,
                                          color: Color(0xff313131)),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      "./assets/icons/money.png",
                                      scale: 2,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      "전체배달팁",
                                      style: TextStyle(
                                          fontFamily: "PretendardMedium",
                                          fontSize: 14,
                                          color: Color(0xff313131)),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      "./assets/icons/vector2.png",
                                      scale: 2,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      "주문장소",
                                      style: TextStyle(
                                          fontFamily: "PretendardMedium",
                                          fontSize: 14,
                                          color: Color(0xff313131)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 19,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.snapshot.data['orderTime'],
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "PretendardMedium",
                                      color: lightColorScheme.primary),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  widget.snapshot.data['deliveryTip'] == -1
                                      ? "? 원"
                                      : "${NumberFormat('#,###').format(widget.snapshot.data['deliveryTip'] / widget.snapshot.data['members'].length)}원",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "PretendardMedium",
                                      color: lightColorScheme.primary),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  widget.snapshot.data['pickup'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "PretendardMedium",
                                    color: lightColorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Image.asset(
                              "./assets/icons/arrow_up.png",
                              scale: 1.8,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  // click zone
                  Positioned(
                      bottom: !_expanded ? 0 : 56,
                      right: 0,
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            _expanded = !_expanded;
                          });
                        },
                        child: Container(
                          width: 60,
                          height: 40,
                          color: Colors.transparent,
                        ),
                      ))
                ],
              )
            ,
      ),
    );
  }
}
