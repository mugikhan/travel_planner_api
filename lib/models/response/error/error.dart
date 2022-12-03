import 'package:freezed_annotation/freezed_annotation.dart';

part 'error.freezed.dart';

part 'error.g.dart';

@freezed
class ErrorResponse with _$ErrorResponse {
  const factory ErrorResponse({
    required String type,
    required String message,
    required int code,
  }) = _ErrorResponse;

  factory ErrorResponse.fromJson(Map<String, Object?> json) =>
      _$ErrorResponseFromJson(json);
}
