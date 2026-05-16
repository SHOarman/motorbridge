class ApiServices {

  ApiServices._();

  static const String baseurl = "https://9cx6xd5z-5000.inc1.devtunnels.ms";

  //=====================================Auth_APi============================
static const String login = "/api/auth/login";
static const String register = "/api/auth/register";
static const String forgotPassword = "/api/auth/forget-password";
static const String resetPassword = "/api/auth/reset-password";
static const String verif_email = "/api/auth/verify-email";
static const String verify_code = "/api/auth/code-verify";

//========================User_profile======================
static const String user_profile = "/api/user";
static const String update_profile = "/api/user/";
static const String delete_account = "/api/user/";



}