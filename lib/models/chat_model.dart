class ChatModel {
  int? localid;
  List<dynamic>? msgs;
  int? lastModified;
  String? id;
  String? msgId;
  int? cBuild;
  int? join;
  String? ordId;
  String? pId;
  String? uId;
  int? pState;
  int? uState;
  int? uCount;
  int? pCount;
  // UDetails uDetails;
  // PDetails pDetails;
  // OrderDetails orderDetails;
  int? v;

  ChatModel({
    this.msgs,
    this.lastModified,
    this.id,
    this.msgId,
    this.cBuild,
    this.join,
    this.ordId,
    this.pId,
    this.uId,
    this.pState,
    this.uState,
    this.uCount,
    this.pCount,

    // this.uDetails,
    // this.pDetails,
    // this.orderDetails,
    this.v,
  });
  ChatModel.withId({
    this.localid,
    this.msgs,
    this.lastModified,
    this.id,
    this.msgId,
    this.cBuild,
    this.join,
    this.ordId,
    this.pId,
    this.uId,
    this.pState,
    this.uState,
    this.uCount,
    this.pCount,
    // this.uDetails,
    // this.pDetails,
    // this.orderDetails,
    //this.v,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();

    if (localid == null) map['localid'] = localid;

    map['id'] = id;
    map['msgs'] = msgs;
    map['lastModified'] = lastModified;
    map['msgId'] = msgId;
    map['cBuild'] = cBuild;
    map['join'] = join;
    map['ordId'] = ordId;
    map['pId'] = pId;
    map['uId'] = uId;
    map['pState'] = pState;
    map['uState'] = uState;
    map['uCount'] = uCount;
    map['pCount'] = pCount;
    return map;
  }

  ChatModel.fromMap(Map<String, dynamic> map) {
    localid = map['localid'];
    id = map['id'];
    lastModified = map['lastModified'];
    msgId = map['msgId'];
    cBuild = map['cBuild'];
    join = map['join'];
    ordId = map['ordId'];
    pId = map['pId'];
    uId = map['uId'];
    pState = map['pState'];
    uState = map['uState'];
    uCount = map['uCount'];
    pCount = map['pCount'];
  }
}
