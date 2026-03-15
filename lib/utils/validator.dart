class Validator {
  static String? email(String email) {
    if (email.isEmpty) return "L'email est requis";
    final regex = RegExp(r'^[\w.-]+@[\w.-]+\.\w{2,}$');
    if (!regex.hasMatch(email.trim())) return "Email invalide";
    return null;
  }

  static String? password(String password) {
    if (password.isEmpty) return "Le mot de passe est requis";
    if (password.length < 6) return "Minimum 6 caractères";
    return null;
  }

  static String? passwordsMatch(String password, String confirm) {
    if (password != confirm) return "Les mots de passe ne\ncorrespondent pas";
    return null;
  }

  static String? username(String username) {
    if (username.isEmpty) return "Nom requis";
    if (username.trim().length < 3) return "Minimum 3 caractères";
    if (username.trim().length > 20) return "Maximum 10 caractères";
    final regex = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]{2,9}$');
    if (!regex.hasMatch(username.trim())) return "Nom d'utilisateur invalide";
    return null;
  }
}
