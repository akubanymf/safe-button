import 'dart:convert';

class CustomContact {
  String? phoneNumber;
  String? name;
  String? byteImage;

  CustomContact(this.phoneNumber, this.name, this.byteImage);

  factory CustomContact.fromJson(Map<String, dynamic> jsonData) {
    return CustomContact(
      jsonData['phoneNumber'],
      jsonData['name'],
      jsonData['byteImage']
    );
  }

  static Map<String, dynamic> toMap(CustomContact music) => {
    'phoneNumber': music.phoneNumber,
    'name': music.name,
    'byteImage': music.byteImage
  };

  static String encode(List<CustomContact> musics) => json.encode(
    musics
        .map<Map<String, dynamic>>((music) => CustomContact.toMap(music))
        .toList(),
  );

  static List<CustomContact> decode(String contacts) =>
      (json.decode(contacts) as List<dynamic>)
          .map<CustomContact>((item) => CustomContact.fromJson(item))
          .toList();
}