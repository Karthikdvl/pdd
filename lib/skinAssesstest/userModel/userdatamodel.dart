class UserSkinData {
  String? name;                      // User's name
  int? ageGroup;                     // Age group as an index (e.g., 0 for '<12', 1 for '12-18')
  String? gender;                    // Male or Female
  String? skinType;                  // Normal, Oily, Dry, etc.
  SkinSensitivity? skinSensitivity;  // Using enum for better clarity
  List<String> skinConcerns = [];    // List of selected concerns
  List<String> proneConditions = []; // List of prone conditions
  String? allergies;                 // Free-text input for allergies
  String? routinePreference;         // Simple or Extensive
  String? sunExposure;               // Frequent, Rare, etc.
  String? primaryEnvironment;        // Urban, Rural, etc.
  String? wearsMakeup;               // Yes, No, Sometimes
  Map<String, int>? skinTypeSelections; // Map for skin type selections (Dry: 1, Oily: 0, etc.)

  // Constructor
  UserSkinData({
    this.name,
    this.ageGroup,
    this.gender,
    this.skinType,
    this.skinSensitivity,
    this.skinConcerns = const [],
    this.proneConditions = const [],
    this.allergies,
    this.routinePreference,
    this.sunExposure,
    this.primaryEnvironment,
    this.wearsMakeup,
    this.skinTypeSelections,
  });

  // Convert the data to JSON format for API communication
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ageGroup': ageGroup,
      'gender': gender,
      'skinType': skinType,
      'skinConcerns': skinConcerns,
      'proneConditions': proneConditions,
      'allergies': allergies,
      'routinePreference': routinePreference,
      'sunExposure': sunExposure,
      'primaryEnvironment': primaryEnvironment,
      'wearsMakeup': wearsMakeup,
      'skinTypeSelections': skinTypeSelections ?? {}, // Ensure it's never null
      'skinSensitivity': skinSensitivity?.index, // Convert enum to int (0 or 1)
    };
  }
}

enum SkinSensitivity { NotSensitive, Sensitive }
