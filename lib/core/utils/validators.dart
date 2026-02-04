class Validators {
  /// =============================
  /// NOT EMPTY VALIDATION
  /// =============================
  static String? notEmpty(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
  }

  /// =============================
  /// NAME VALIDATION
  /// =============================
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name cannot be empty';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  /// =============================
  /// BIO VALIDATION
  /// =============================
  static String? bio(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bio cannot be empty';
    }
    if (value.trim().length > 150) {
      return 'Bio must be under 150 characters';
    }
    return null;
  }

  /// =============================
  /// POST TEXT VALIDATION
  /// =============================
  static String? postText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Post cannot be empty';
    }
    if (value.trim().length > 280) {
      return 'Post must be under 280 characters';
    }
    return null;
  }

  /// =============================
  /// COMMENT VALIDATION
  /// =============================
  static String? comment(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Comment cannot be empty';
    }
    if (value.trim().length > 200) {
      return 'Comment must be under 200 characters';
    }
    return null;
  }

  /// =============================
  /// GENERIC LENGTH VALIDATION
  /// =============================
  static String? minLength(
      String? value, {
        required int min,
        String fieldName = 'Field',
      }) {
    if (value == null || value.trim().length < min) {
      return '$fieldName must be at least $min characters';
    }
    return null;
  }
}
