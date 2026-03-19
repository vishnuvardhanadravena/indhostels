class SupportResponse {
  final bool success;
  final int statusCode;
  final String message;

  const SupportResponse({
    required this.success,
    required this.statusCode,
    required this.message,
  });

  factory SupportResponse.fromJson(Map<String, dynamic> json) =>
      SupportResponse(
        success: json['success'] ?? false,
        statusCode: json['statuscode'] ?? 0,
        message: json['message'] ?? '',
      );
}