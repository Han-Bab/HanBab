class OrderInfo {
  final String? groupId;
  final String? groupName;
  final String? pickup;
  final String? currPeople;
  final String? maxPeople;
  final String? date;
  final String? orderTime;
  final String? imgUrl;
  final List<dynamic>? members;

  OrderInfo(
      {this.groupId,
      this.groupName,
      this.pickup,
      this.currPeople,
      this.maxPeople,
      this.date,
      this.orderTime,
      this.imgUrl,
      this.members});
}
