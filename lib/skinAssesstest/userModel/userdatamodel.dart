class UserSkinData {
  String? name;                      // User's name
  int? ageGroup;                     // Age group as an index (e.g., 0 for '<12', 1 for '12-18')
  String? gender;                    // Male or Female
  String? skinType;                  // Normal, Oily, Dry, etc.
  String? skinSensitivity;           // Low, Moderate, High
  List<String> skinConcerns = [];    // List of selected concerns
  List<String> proneConditions = [];         // List of prone conditions
  String? allergies;                 // Free-text input for allergies
  String? routinePreference; // Simple or Extensive
  String? sunExposure;               // Frequent, Rare, etc.
  String? primaryEnvironment;        // Urban, Rural, etc.
  String? wearsMakeup;               // Yes, No, Sometimes

  // Convert the data to JSON format for API communication
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ageGroup': ageGroup,
      'gender': gender,
      'skinType': skinType,
      'skinSensitivity': skinSensitivity,
      'skinConcerns': skinConcerns,
      'proneConditions': proneConditions,
      'allergies': allergies,
      'routinePreference': routinePreference,
      'sunExposure': sunExposure,
      'primaryEnvironment': primaryEnvironment,
      'wearsMakeup': wearsMakeup,
    };
  }
}
