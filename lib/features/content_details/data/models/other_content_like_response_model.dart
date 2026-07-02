import '../../domain/entities/other_content_like_response_entity.dart';

class OtherContentLikeResponseModel
    extends OtherContentLikeResponseEntity {

  const OtherContentLikeResponseModel({
    required super.success,
    required super.title,
    required super.message,
    required super.statusCode,
  });

  factory OtherContentLikeResponseModel.fromJson(
    Map<String,dynamic> json,
  ){

    return OtherContentLikeResponseModel(

      success: json['success'] ?? false,

      title: json['title'] ?? '',

      message: json['message'] ?? '',

      statusCode: json['status_code'] ?? 0,

    );

  }

}