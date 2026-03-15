class UserModel {
  final String id;
  final String userName;
  final String phone;
  final String? image;
  final bool isNewUser;

  UserModel({
    required this.id,
    required this.userName,
    required this.phone,
    this.image,
    required this.isNewUser,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      userName: json['userName'] as String,
      phone: json['phone'] as String,
      image: json['image'] as String?,
      isNewUser: json['isNewUser'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'phone': phone,
      'image': image,
      'isNewUser': isNewUser,
    };
  }

  @override
  String toString() {
    return 'UserModel(id: $id, userName: $userName, phone: $phone, isNewUser: $isNewUser)';
  }
}
