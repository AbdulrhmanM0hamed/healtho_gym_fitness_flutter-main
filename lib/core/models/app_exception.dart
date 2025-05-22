class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() {
    return 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
  }

  factory AppException.server({
    required String message,
    String? code,
    dynamic details,
  }) {
    return AppException(
      message: message,
      code: code ?? 'SERVER_ERROR',
      details: details,
    );
  }

  factory AppException.network({
    String? message,
    String? code,
    dynamic details,
  }) {
    return AppException(
      message: message ?? 'Network error occurred',
      code: code ?? 'NETWORK_ERROR',
      details: details,
    );
  }

  factory AppException.unauthorized({
    String? message,
    String? code,
    dynamic details,
  }) {
    return AppException(
      message: message ?? 'Unauthorized access',
      code: code ?? 'UNAUTHORIZED',
      details: details,
    );
  }

  factory AppException.notFound({
    String? message,
    String? code,
    dynamic details,
  }) {
    return AppException(
      message: message ?? 'Resource not found',
      code: code ?? 'NOT_FOUND',
      details: details,
    );
  }

  factory AppException.unknown({
    String? message,
    String? code,
    dynamic details,
  }) {
    return AppException(
      message: message ?? 'An unknown error occurred',
      code: code ?? 'UNKNOWN_ERROR',
      details: details,
    );
  }
} 