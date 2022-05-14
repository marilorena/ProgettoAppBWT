class YogaPose {
  final int id;
  final String name;
  final String sanskrit_name;
  final String image_url;

  YogaPose(
    { required this.id,
      required this.name,
      required this.sanskrit_name,
      required this.image_url

    }
  );

  factory YogaPose.fromJson(Map<String, dynamic> json){
    return YogaPose(
      id: json['id'], 
      name: json['name'], 
      sanskrit_name: json['sanskrit_name'], 
      image_url: json['image_url']);
  }





}