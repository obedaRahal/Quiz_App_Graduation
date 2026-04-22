class SubmitGraduateAcademicProfileParams {
  final String email;
  final String universityName;
  final String department;
  final String? certificateImagePath;
  final String? identityImagePath;

  const SubmitGraduateAcademicProfileParams({
    required this.email,
    required this.universityName,
    required this.department,
    this.certificateImagePath,
    this.identityImagePath,
  });
}