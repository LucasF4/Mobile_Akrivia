class myDocs{
  String? key;

  myDocs();

  myDocs.fromMap(Map map){
    key = map['key'];
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic> {
      "key": key
    };
    return map;
  }

  @override
  String toString(){
    return "{key: $key}";
  }

}