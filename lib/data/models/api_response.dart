class ApiResponse<T> {
  final bool status;
  final String message;
  final T? data;

  const ApiResponse({required this.status, required this.message, this.data});

  bool get isSuccess => status == true;
  bool get isFailure => !isSuccess;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic json)? fromJsonT,
  }) {
    return ApiResponse<T>(
      status: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
    );
  }

  @override
  String toString() =>
      'ApiResponse(success: $status, message: $message, data: $data)';
}
