class User {
  final int? id;
  final String first_name;
  final String last_name;
  final String email;
  final int phone_number;
  final String password;
  final String commentaire;
  final String? image;
  final String? updated_At;

  User({
    this.id,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.phone_number,
    required this.password,
    required this.commentaire,
    this.image,
    this.updated_At,
  });

  factory User.fromJson(dynamic json) {
    return User(
      id: json['user_id'] as int,
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      email: json['email'] as String,
      phone_number: json['phone_number'] as int,
      password: json['password'] as String,
      commentaire: json['commentaire'] as String,
      image: json['image'] as String,
      updated_At: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "first_name": first_name,
        "last_name": last_name,
        "email": email,
        "phone_number": phone_number,
        "password": password,
        "commentaire": commentaire,
        "image": image,
        "updated_at": updated_At,
      };

  static List<User> usersFromSnapshot(List snapshot) {
    return snapshot.map((data) => User.fromJson(data)).toList();
  }

  static User userFromSnapshot(User snapshot) {
    return snapshot;
  }

  @override
  String toString() {
    return 'User {user_id:$id,first_name: $first_name, last_name: $last_name, email: $email, phone_number: $phone_number,password:$password, commentaire:$commentaire, image!$image,updated_at!$updated_At}';
  }
}
