class DestinationModel {
  String? id;
  String? id_fav;
  String? user_id;
  String? name;
  String? category;
  String? description;
  String? city;
  String? country;
  String? price;
  String? thumb;
  String? bg;

  DestinationModel({
    required this.id,
    required this.id_fav,
    required this.user_id,
    required this.name,
    required this.category,
    required this.description,
    required this.city,
    required this.country,
    required this.price,
    required this.thumb,
    required this.bg,
  });

  DestinationModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        id_fav = json['id_fav'],
        user_id = json['user_id'],
        name = json['name'],
        category = json['category'],
        description = json['description'],
        city = json['city'],
        country = json['country'],
        price = json['price_idr_k'],
        thumb =  json['thumb'],
        bg = json['bg'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_fav': id_fav,
      'user_id': user_id,
      'name': name,
      'category': category,
      'description': description,
      'city': city,
      'country': country,
      'price': price,
      'thumb': thumb,
      'bg': bg,
    };
  }
}