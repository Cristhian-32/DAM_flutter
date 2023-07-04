class RoleUtil {
  RoleUtil._();
  static List<String> ROLE = [" "];
}

class RoleGuard {
  static bool isAdmin() {
    List<String> roles = RoleUtil.ROLE;
    if (roles.contains('admin')) {
      return true;
    }
    return false;
  }

  static bool isAdviser() {
    List<String> roles = RoleUtil.ROLE;
    if (roles.contains('adviser')) {
      return true;
    }
    return false;
  }

  static bool isUser() {
    List<String> roles = RoleUtil.ROLE;
    if (roles.contains('user')) {
      return true;
    }
    return false;
  }
}
