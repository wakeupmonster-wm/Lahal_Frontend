class UserProfile {
  final String? id;
  final String userName;
  final String phone;
  final bool isPhoneVerified;
  final bool isEmailVerified;
  final UserImage? image;
  final UserLocation? location;
  final String gender;
  final int? age;
  final String dob;
  final bool isNewUser;
  final String accountType;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? email; // Adding optional email as it's in the update body

  UserProfile({
    this.id,
    required this.userName,
    required this.phone,
    this.isPhoneVerified = false,
    this.isEmailVerified = false,
    this.image,
    this.location,
    required this.gender,
    this.age,
    required this.dob,
    this.isNewUser = false,
    this.accountType = 'USER',
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.email,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      userName: json['userName'] ?? '',
      phone: json['phone'] ?? '',
      isPhoneVerified: json['isPhoneVerified'] ?? false,
      isEmailVerified: json['isEmailVerified'] ?? false,
      image: json['image'] != null ? UserImage.fromJson(json['image']) : null,
      location: json['location'] != null
          ? UserLocation.fromJson(json['location'])
          : null,
      gender: json['gender'] ?? '',
      age: json['age'],
      dob: json['dob'] ?? '',
      isNewUser: json['isNewUser'] ?? false,
      accountType: json['accountType'] ?? 'USER',
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'phone': phone,
      'isPhoneVerified': isPhoneVerified,
      'isEmailVerified': isEmailVerified,
      'image': image?.toJson(),
      'location': location?.toJson(),
      'gender': gender,
      'age': age,
      'dob': dob,
      'isNewUser': isNewUser,
      'accountType': accountType,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'email': email,
    };
  }

  UserProfile copyWith({
    String? id,
    String? userName,
    String? phone,
    bool? isPhoneVerified,
    bool? isEmailVerified,
    UserImage? image,
    UserLocation? location,
    String? gender,
    int? age,
    String? dob,
    bool? isNewUser,
    String? accountType,
    bool? isActive,
    String? createdAt,
    String? updatedAt,
    String? email,
  }) {
    return UserProfile(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      phone: phone ?? this.phone,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      image: image ?? this.image,
      location: location ?? this.location,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      dob: dob ?? this.dob,
      isNewUser: isNewUser ?? this.isNewUser,
      accountType: accountType ?? this.accountType,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      email: email ?? this.email,
    );
  }

  // Adding getters for backward compatibility if needed, though better to update usage
  String get name => userName;
  String get phoneNumber => phone;
  String? get profilePhoto => image?.url;
}

class UserImage {
  final String url;
  final String publicId;
  final String uploadedAt;

  UserImage({
    required this.url,
    required this.publicId,
    required this.uploadedAt,
  });

  factory UserImage.fromJson(Map<String, dynamic> json) {
    return UserImage(
      url: json['url'] ?? '',
      publicId: json['publicId'] ?? '',
      uploadedAt: json['uploadedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'publicId': publicId, 'uploadedAt': uploadedAt};
  }
}

class UserLocation {
  final String type;
  final List<double> coordinates;
  final String address;
  final String city;
  final String state;

  UserLocation({
    required this.type,
    required this.coordinates,
    required this.address,
    required this.city,
    required this.state,
  });

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      type: json['type'] ?? 'Point',
      coordinates:
          (json['coordinates'] as List?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
      'address': address,
      'city': city,
      'state': state,
    };
  }
}
