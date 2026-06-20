import 'dart:typed_data';

import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_academic_certificate_entity.dart';

class OtherProfileAcademicCertificateModel
    extends OtherProfileAcademicCertificateEntity {
  const OtherProfileAcademicCertificateModel({required super.imageBytes});

  factory OtherProfileAcademicCertificateModel.fromBytes(dynamic data) {
    if (data is Uint8List) {
      return OtherProfileAcademicCertificateModel(imageBytes: data);
    }

    if (data is List<int>) {
      return OtherProfileAcademicCertificateModel(
        imageBytes: Uint8List.fromList(data),
      );
    }

    throw Exception('Invalid certificate image bytes');
  }
}
