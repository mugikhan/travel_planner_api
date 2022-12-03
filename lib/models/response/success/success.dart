import 'package:freezed_annotation/freezed_annotation.dart';

part 'success.freezed.dart';

part 'success.g.dart';

@freezed
class SuccessResponse with _$SuccessResponse {
  const factory SuccessResponse({
    required Map<String, dynamic> data,
    String? message,
  }) = _SuccessResponse;

  factory SuccessResponse.fromJson(Map<String, Object?> json) =>
      _$SuccessResponseFromJson(json);
}
