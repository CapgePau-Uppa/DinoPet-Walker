class Validator {
  static String? email(String email) {
    if (email.isEmpty) return "L'email est requis";
    if (!email.contains('@')) return "Email invalide";
    return null;
  }

  static String? password(String password) {
    if (password.isEmpty) return "Le mot de passe est requis";
    if (password.length < 6) return "Minimum 6 caractères";
    return null;
  }

  static String? passwordsMatch(String password, String confirm) {
    if (password != confirm) return "Les mots de passe ne correspondent pas";
    return null;
  }

  static String? username(String username) {
    if (username.isEmpty) return "Nom requis";
    return null;
  }
}
