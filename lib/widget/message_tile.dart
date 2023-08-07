import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final int isEnter;
  final String time;

  const MessageTile(
      {Key? key,
      required this.message,
      required this.sender,
      required this.sentByMe,
      required this.isEnter,
      required this.time})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    //isEnter == 1 'Enter' or 'Exit'
    //isEnter == 0 'Chats'
    return widget.isEnter == 1
        ? Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffF1F1F1)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.message,
                    style: TextStyle(
                        color: Color(0xff717171),
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.only(
                top: 4,
                bottom: 4,
                left: widget.sentByMe ? 0 : 24,
                right: widget.sentByMe ? 24 : 0),
            alignment:
                widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: widget.sentByMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  widget.sentByMe ? "나" : widget.sender.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff3E3E3E),
                      letterSpacing: -0.5),
                ),
                Row(
                  mainAxisAlignment: !widget.sentByMe ? MainAxisAlignment.start : MainAxisAlignment.end,
                  children: [
                    widget.sentByMe ? Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Text(DateFormat('h:mm a')
                              .format(DateTime.parse(widget.time)), style: TextStyle(fontSize: 13, color: Color(0xff717171)),),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                      ],
                    ) : Container(),
                    Container(
                      // margin: widget.sentByMe
                      //     ? EdgeInsets.only(left: widget.sentByMe 30)
                      //     : const EdgeInsets.only(right: 30),
                      padding: const EdgeInsets.only(
                          top: 13, bottom: 13, left: 18, right: 18),
                      decoration: BoxDecoration(
                          borderRadius: widget.sentByMe
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                )
                              : const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                          color: widget.sentByMe
                              ? Color(0xFF75B165)
                              : Color(0xFFF1F1F1)),
                      child: Text(widget.message,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 16,
                              color: widget.sentByMe
                                  ? Colors.white
                                  : Color(0xFF3E3E3E))),
                    ),
                    !widget.sentByMe ? Row(
                      children: [
                        const SizedBox(
                          width: 6,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Text(DateFormat('h:mm a')
                              .format(DateTime.parse(widget.time)), style: TextStyle(fontSize: 13, color: Color(0xff717171))),
                        ),
                      ],
                    ) : Container(),
                  ],
                ),
              ],
            ),
          );
  }
}
