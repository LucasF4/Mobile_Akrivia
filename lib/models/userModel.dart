class User{
  String? email;

  User();

  User.fromMap(Map map){
    email = map['email'];
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic> {
      "email": email
    };
    return map;
  }

  @override
  String toString(){
    return "{email: $email}";
  }

}