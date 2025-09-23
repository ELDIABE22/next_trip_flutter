class FormValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Requerido';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Inválido';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Requerido';
    }

    if (value.length < 6) {
      return 'Mínimo 6 caracteres';
    }

    if (value.length > 15) {
      return 'Máximo 15 caracteres';
    }

    return null;
  }

  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Requerido';
    }

    if (value.length < 2) {
      return 'Al menos 2 caracteres';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Requerido';
    }

    final phoneRegex = RegExp(r'^[0-9\+\s\-\(\)]{10,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Ingresa un número de teléfono válido';
    }

    return null;
  }

  static String? validateCC(String? value) {
    if (value == null || value.isEmpty) {
      return 'Requerido';
    }

    final numericValue = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (numericValue.length != 10) {
      return 'Debe tener exactamente 10 dígitos';
    }

    return null;
  }

  static String? validateBirthDate(DateTime? value) {
    if (value == null) {
      return 'Requerido';
    }

    final now = DateTime.now();
    final minDate = DateTime(now.year - 120, now.month, now.day);
    final maxDate = DateTime(now.year - 18, now.month, now.day);

    if (value.isBefore(minDate) || value.isAfter(maxDate)) {
      return 'Tiene que ser mayor de edad';
    }

    return null;
  }

  static String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Requerido';
    }

    final validGenders = ['masculino', 'femenino', 'otro', 'no especificar'];
    if (!validGenders.contains(value.toLowerCase())) {
      return 'Inválido';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Requerido';
    }

    if (value != password) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }
}
