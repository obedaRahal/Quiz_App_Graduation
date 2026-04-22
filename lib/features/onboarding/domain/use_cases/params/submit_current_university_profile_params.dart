class SubmitCurrentUniversityProfileParams {
  final String email;
  final String universityName;
  final String department;
  final int universityYear;

  const SubmitCurrentUniversityProfileParams({
    required this.email,
    required this.universityName,
    required this.department,
    required this.universityYear,
  });
}