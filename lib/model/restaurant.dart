import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String admin;
  final String currPeople;
  final String date;
  final String groupId;
  final String groupName;
  final String imgUrl;
  final String maxPeople;
  final List<dynamic> members;
  final String orderTime;
  final String pickup;
  final String recentMessage;
  final String recentMessageSender;
  final int deliveryTip;
  final String togetherOrder;
  final String restUrl;
  final double close;

  Restaurant({
    required this.groupName,
    required this.groupId,
    required this.imgUrl,
    required this.date,
    required this.orderTime,
    required this.currPeople,
    required this.maxPeople,
    required this.admin,
    required this.pickup,
    required this.members,
    required this.recentMessageSender,
    required this.recentMessage,
    required this.deliveryTip,
    required this.togetherOrder,
    required this.restUrl,
    required this.close,
  });


  static Restaurant fromSnapshot(DocumentSnapshot snap) {
    Restaurant restaurant = Restaurant(
        groupName: snap['groupName'],
        groupId: snap['groupId'],
        imgUrl: snap['imgUrl'],
        date: snap['date'],
        orderTime: snap['orderTime'],
        currPeople: snap['currPeople'],
        maxPeople: snap['maxPeople'],
        admin: snap['admin'],
        pickup: snap['pickup'],
        members: snap['members'],
        recentMessageSender: snap['recentMessageSender'],
        recentMessage: snap['recentMessage'],
        deliveryTip: snap['deliveryTip'],
        togetherOrder: snap['togetherOrder'],
        restUrl: snap['restUrl'],
        close: snap['close'].toDouble()
    );
    return restaurant;
  }
}
