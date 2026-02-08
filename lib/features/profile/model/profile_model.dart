class UserProfile {
  final String? id;
  final String name;
  final String phoneNumber;
  final String email;
  final String dob;
  final String gender;
  final String? profilePhoto;

  UserProfile({
    this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.dob,
    required this.gender,
    this.profilePhoto,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
      profilePhoto: json['profile_photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'email': email,
      'dob': dob,
      'gender': gender,
      'profile_photo': profilePhoto,
    };
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    String? dob,
    String? gender,
    String? profilePhoto,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      profilePhoto: profilePhoto ?? this.profilePhoto,
    );
  }
}
