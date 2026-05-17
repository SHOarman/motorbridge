class ApiServices {

  ApiServices._();

  static const String baseurl = "https://9cx6xd5z-5000.inc1.devtunnels.ms";

  //=====================================Auth_APi============================
static const String login = "$baseurl/api/auth/login";
static const String register = "$baseurl/api/auth/register";
static const String forgotPassword = "$baseurl/api/auth/forget-password";
static const String resetPassword = "$baseurl/api/auth/reset-password";
static const String verif_email = "$baseurl/api/auth/verify-email";
static const String verify_code = "$baseurl/api/auth/code-verify";

//========================User_profile======================
static const String user_profile = "$baseurl/api/user/me";
static const String update_profile = "$baseurl/api/user/";
static const String delete_account = "$baseurl/api/user/";


//===========================crete_Repot========================================
static const String create_Repot="$baseurl/api/report/create";



//============================add vehicle=======================================
static const String find_vehicle="https://driver-vehicle-licensing.api.gov.uk/vehicle-enquiry/v1/vehicles";
static const crete_vehicle="$baseurl/api/vehicle/create";

//=========================document===========================================
static const String create_documet= "$baseurl/api/documents/create";
static const String get_document="$baseurl/api/documents";


//=======================addcost================================================

static const String crete_cost="$baseurl/api/cost/create";





}