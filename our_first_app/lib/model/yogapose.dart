class YogaPose {
  final int id;
  final String name;
  final String sanskritname;
  final String imageurl;

  YogaPose(
    { required this.id,
      required this.name, 
      required this.sanskritname,
      required this.imageurl

    }
  );

  factory YogaPose.fromJson(Map<String, dynamic> json){
    return YogaPose(
      id: json['id'], 
      name: json['name'], 
      sanskritname: json['sanskritname'], 
      imageurl: json['imageurl']);
  }
 




}