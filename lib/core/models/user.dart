class User {
  int? id;
  String? nik;
  String? email;
  String? username;
  String? fullname;
  String? birthplace;
  String? birthdate;
  Photos? photos;
  String? gender;
  String? address;
  int? createdAt;
  int? updatedAt;

  User({
    this.id,
    this.nik,
    this.email,
    this.username,
    this.fullname,
    this.birthplace,
    this.birthdate,
    this.photos,
    this.gender,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nik: json['nik'],
      email: json['email'],
      username: json['username'],
      fullname: json['fullname'],
      birthplace: json['birthplace'],
      birthdate: json['birthdate'],
      photos: json['photos'] != null ? Photos.fromJson(json['photos']) : null,
      gender: json['gender'],
      address: json['address'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nik': nik,
      'email': email,
      'username': username,
      'fullname': fullname,
      'birthplace': birthplace,
      'birthdate': birthdate,
      'photos': photos?.toJson(),
      'gender': gender,
      'address': address,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Photos {
  String? front;
  String? left;
  String? right;

  Photos({this.front, this.left, this.right});

  factory Photos.fromJson(Map<String, dynamic> json) {
    return Photos(
      front: json['front'],
      left: json['left'],
      right: json['right'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'front': front,
      'left': left,
      'right': right,
    };
  }
}
