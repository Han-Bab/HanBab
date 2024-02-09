import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final int isEnter;
  final String time;
  final bool duplicateNickName;
  final bool duplicateTime;

  const MessageTile(
      {Key? key,
      required this.message,
      required this.sender,
      required this.sentByMe,
      required this.isEnter,
      required this.time,
      required this.duplicateNickName,
      required this.duplicateTime})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  void launchUrl(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw "Could not launch $link";
    }
  }

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
                    color: const Color(0xffF1F1F1)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Linkify(
                    onOpen: (link) => launchUrl(link.url),
                    text: widget.message,
                    style: const TextStyle(
                        color: Color(0xff717171),
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                    linkStyle: const TextStyle(color: Colors.blue),
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
                !widget.duplicateNickName
                    ? Text(
                        widget.sentByMe ? "나" : widget.sender.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xff3E3E3E),
                            letterSpacing: -0.5),
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: !widget.sentByMe
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    !widget.duplicateTime
                        ? widget.sentByMe
                            ? Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 50),
                                    child: Text(
                                      DateFormat('h:mm a')
                                          .format(DateTime.parse(widget.time)),
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: Color(0xff717171)),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                ],
                              )
                            : Container()
                        : Container(),
                    Flexible(
                      child: Container(
                        margin: widget.duplicateTime ? widget.sentByMe ? const EdgeInsets.only(left: 50) : EdgeInsets.only(right: 50) : null,
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                            borderRadius: widget.sentByMe
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                  )
                                : const BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                            color: widget.sentByMe
                                ? Color(0xFF75B165)
                                : Color(0xFFF1F1F1)),
                        child: Linkify(
                          text: widget.message,
                          onOpen: (link) => launchUrl(link.url),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 16,
                              color: widget.sentByMe
                                  ? Colors.white
                                  : Color(0xFF3E3E3E)),
                          linkStyle: TextStyle(color:  widget.sentByMe ? Colors.yellow : Colors.blue, decoration: TextDecoration.none),

                        ),
                      ),
                    ),
                    !widget.duplicateTime
                        ? !widget.sentByMe
                            ? Row(
                                children: [
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30.0, right: 50),
                                    child: Text(
                                        DateFormat('h:mm a').format(
                                            DateTime.parse(widget.time)),
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: Color(0xff717171))),
                                  ),
                                ],
                              )
                            : Container()
                        : Container(),
                  ],
                ),
              ],
            ),
          );
  }
}
