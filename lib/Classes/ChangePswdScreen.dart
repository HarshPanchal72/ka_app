import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../API Manager/APIConstants.dart';
import '../API Manager/APIService.dart';
import '../Resources/AppColors.dart';
import '../Resources/AppText.dart';
import 'SideMenu.dart';
import 'common_class.dart';

class ChangePswdScreen extends StatefulWidget {
  const ChangePswdScreen({super.key});

  @override
  State<ChangePswdScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePswdScreen> {
  final _formKey = GlobalKey<FormState>();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool oldObscure = true;
  bool newObscure = true;
  bool confirmObscure = true;

  final ValueNotifier<bool> isOldPswdHidden = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isNewPswdHidden = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isConfPswdHidden = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    oldPasswordController.addListener(() {
      setState(() {});
    });
    newPasswordController.addListener(() {
      setState(() {});
    });
    confirmPasswordController.addListener(() {
      setState(() {});
    });

  }

  Future<void> callChangePasswordApi() async {
    try {
      CommonClass.showLoader(context);
      Map<String, String> userData = await CommonClass().getUserData();
      String username = userData["username"] ?? "";

      final api = ApiService();
      Map<String, dynamic> body = {
        "username": username,
        "old_password": oldPasswordController.text.trim(),
        "new_password": newPasswordController.text.trim(),
      };

      final response = await api.postApi(
        endpoint: "${ApiConstants.baseUrl}/users/change-password",
        param: body,
      );

      CommonClass.hideLoader(context);
      if (response.statusCode == 200) {
        CommonClass.showSnackBar(context, message: "Password Changed Successfully", textColor: Colors.deepPurple);
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      } else {
        String msg = response.data is Map && response.data['detail'] != null
            ? response.data['detail']
            : "Failed to change password";
        CommonClass.showSnackBar(context, message: msg, backgroundColor: Colors.red);
      }
    } catch (e) {
      CommonClass.hideLoader(context);
      CommonClass.showSnackBar(context, message: "Error changing password", backgroundColor: Colors.red);
      print("Change Password Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
        drawer: SideMenu(),
        //backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          toolbarHeight: 60,
          centerTitle: true,
          title: AppText(text: "Change Password", fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue,),
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back_ios,size: 18,color: Colors.black,),
          //   onPressed: () { Navigator.pop(context);},
          // ),
        ),
       body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              ValueListenableBuilder(
                valueListenable: isOldPswdHidden,
                builder: (context, oldPswd, child) {
                  return CommonClass().customTextField(
                    oldPasswordController.text.isEmpty
                        ? "Enter Old Password"
                        : "Old Password",
                    oldPasswordController,
                    context: context,
                    isMandatory: true,
                    width: screenWidth,
                    obscureText: oldPswd,
                    suffixIcon: oldPswd
                        ? Icons.visibility_off
                        : Icons.visibility,
                    onSuffixPressed: () {
                      isOldPswdHidden.value = !isOldPswdHidden.value;
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter Old Password";
                      }
                      return null;
                    },
                  );
                },
              ),

              SizedBox(height: CommonClass.hDist+10),

              ValueListenableBuilder(
                valueListenable: isNewPswdHidden,
                builder: (context, newPswd, child) {
                  return CommonClass().customTextField(
                    newPasswordController.text.isEmpty
                        ? "Enter New Password"
                        : "New Password",
                    newPasswordController,
                    context: context,
                    isMandatory: true,
                    width: screenWidth,
                    obscureText: newPswd,
                    suffixIcon: newPswd
                        ? Icons.visibility_off
                        : Icons.visibility,
                    onSuffixPressed: () {
                      isNewPswdHidden.value = !isNewPswdHidden.value;
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter New Password";
                      }
                      // if (value != confirmPasswordController.text) {
                      //   return "New Password must match Confirm Password";
                      // }
                      return null;
                    },
                  );
                },
              ),

              SizedBox(height: CommonClass.hDist+10),

              ValueListenableBuilder(
                valueListenable: isConfPswdHidden,
                builder: (context, confPswd, child) {
                  return CommonClass().customTextField(
                    confirmPasswordController.text.isEmpty
                        ? "Enter Confirm Password"
                        : "Confirm Password",
                    confirmPasswordController,
                    context: context,
                    isMandatory: true,
                    width: screenWidth,
                    obscureText: confPswd,
                    suffixIcon: confPswd
                        ? Icons.visibility_off
                        : Icons.visibility,
                    onSuffixPressed: () {
                      isConfPswdHidden.value = !isConfPswdHidden.value;
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter Confirm Password";
                      }
                      if (value != newPasswordController.text) {
                        return "Confirm Password must match New Password";
                      }
                      return null;
                    },
                  );
                },
              ),

               SizedBox(height: 35),

              CommonClass().commonButton(
                text: "Change Password",
                width: screenWidth,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    callChangePasswordApi();
                  }
                },
              ),

            ],
          ),
        ),
    ),),);
  }
}