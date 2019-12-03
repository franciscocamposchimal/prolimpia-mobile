class User {
  int id;
  String name;
  String email;
  String reference;

  User({this.id, this.name, this.email, this.reference});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    reference = json['reference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['reference'] = this.reference;
    return data;
  }
}