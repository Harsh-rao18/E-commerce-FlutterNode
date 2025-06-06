import 'dart:convert';

class User {
  final String id;
  final String fullName;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String password;
  final String token;
  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.state,
    required this.city,
    required this.locality,
    required this.password,
    required this.token,
  });

  // Serialization: Convert User Object to Map
  // Map: A Map is collection of key-value paires
  // why: converting to a map is an intermediate step that makes it easier
  //to serialize the object to format like json for storage or transmission.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'email': email,
      'state': state,
      'city': city,
      'locality': locality,
      'password': password,
      'token': token,
    };
  }

  // Serialization: Convert Map to a Json String
  // this method directly encodes the datafrom the Map into a json String
  String toJson() => json.encode(toMap());


  // Deserialization: convert a map to user object
  // purpose - Manipulation and use : once the data is coverted to a user object
  // it can be easily use within application .
  // For ex: we might want to diaplay user name and email on UI.
  // or we might want to save data locally

  // The factory constructor takes a Map (Usually obtained from Jaon object)
  // amd convert it into a User Object. If a field is nnot present in the ,
  // it defaultes to an empty String

  // fromMap(): this constructor take a Map(<Stringn , dyanmic>) and
  // converts into a User Object .
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as String? ??"",
      fullName: map['fullName'] as String? ??"",
      email: map['email'] as String? ??"",
      state: map['state'] as String? ??"",
      city: map['city'] as String? ??"",
      locality: map['locality'] as String? ??"",
      password: map['password'] as String? ??"",
      token: map['token'] as String? ??"",
    );
  }
  
  // fromJson(): this factory constructor takes json String and Decodes
  // into a Map(<String,dyanmic>) . and the uses fromMap to covert that map into user object.
  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}
