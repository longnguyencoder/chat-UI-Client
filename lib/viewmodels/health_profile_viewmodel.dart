import 'package:flutter/material.dart';
import 'package:mobilev2/models/health_profile_model.dart';
import 'package:mobilev2/services/health_profile_service.dart';

class HealthProfileViewModel extends ChangeNotifier {
  final HealthProfileService _service = HealthProfileService();
  final int userId;

  HealthProfileViewModel(this.userId) {
    loadHealthProfile();
  }

  // State
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  HealthProfileModel? _healthProfile;

  // Form controllers
  DateTime? _dateOfBirth;
  String? _gender;
  List<String> _allergies = [];
  List<String> _chronicDiseases = [];
  List<String> _currentMedications = [];

  // Getters
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  HealthProfileModel? get healthProfile => _healthProfile;
  DateTime? get dateOfBirth => _dateOfBirth;
  String? get gender => _gender;
  List<String> get allergies => _allergies;
  List<String> get chronicDiseases => _chronicDiseases;
  List<String> get currentMedications => _currentMedications;

  /// Load health profile from server
  Future<void> loadHealthProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _service.getHealthProfile(userId);

    if (result['success']) {
      if (result['data'] != null) {
        _healthProfile = HealthProfileModel.fromJson(result['data']);
        _dateOfBirth = _healthProfile?.dateOfBirth;
        _gender = _healthProfile?.gender;
        _allergies = List.from(_healthProfile?.allergies ?? []);
        _chronicDiseases = List.from(_healthProfile?.chronicDiseases ?? []);
        _currentMedications = List.from(_healthProfile?.currentMedications ?? []);
      }
    } else {
      _errorMessage = result['message'];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Update date of birth
  void setDateOfBirth(DateTime? date) {
    _dateOfBirth = date;
    notifyListeners();
  }

  /// Update gender
  void setGender(String? gender) {
    _gender = gender;
    notifyListeners();
  }

  /// Add allergy
  void addAllergy(String allergy) {
    if (allergy.trim().isNotEmpty && !_allergies.contains(allergy.trim())) {
      _allergies.add(allergy.trim());
      notifyListeners();
    }
  }

  /// Remove allergy
  void removeAllergy(String allergy) {
    _allergies.remove(allergy);
    notifyListeners();
  }

  /// Add chronic disease
  void addChronicDisease(String disease) {
    if (disease.trim().isNotEmpty && !_chronicDiseases.contains(disease.trim())) {
      _chronicDiseases.add(disease.trim());
      notifyListeners();
    }
  }

  /// Remove chronic disease
  void removeChronicDisease(String disease) {
    _chronicDiseases.remove(disease);
    notifyListeners();
  }

  /// Add medication
  void addMedication(String medication) {
    if (medication.trim().isNotEmpty && !_currentMedications.contains(medication.trim())) {
      _currentMedications.add(medication.trim());
      notifyListeners();
    }
  }

  /// Remove medication
  void removeMedication(String medication) {
    _currentMedications.remove(medication);
    notifyListeners();
  }

  /// Save health profile
  Future<bool> saveHealthProfile() async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    final profile = HealthProfileModel(
      id: _healthProfile?.id,
      userId: userId,
      dateOfBirth: _dateOfBirth,
      gender: _gender,
      allergies: _allergies,
      chronicDiseases: _chronicDiseases,
      currentMedications: _currentMedications,
    );

    final result = await _service.updateHealthProfile(profile);

    _isSaving = false;

    if (result['success']) {
      _healthProfile = profile;
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  /// Parse comma-separated string to list
  List<String> parseCommaSeparated(String input) {
    return input
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  /// Set allergies from comma-separated string
  void setAllergiesFromString(String input) {
    _allergies = parseCommaSeparated(input);
    notifyListeners();
  }

  /// Set chronic diseases from comma-separated string
  void setChronicDiseasesFromString(String input) {
    _chronicDiseases = parseCommaSeparated(input);
    notifyListeners();
  }

  /// Set medications from comma-separated string
  void setMedicationsFromString(String input) {
    _currentMedications = parseCommaSeparated(input);
    notifyListeners();
  }
}
