
part of 'model.dart';

class CardType {
  String name;
  String image;

  CardType({required this.name, required this.image});

  CardType.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        image = json['image'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
      };

  @override
  String toString() {
    return 'CardType{name: $name, image: $image}';
  }
}
