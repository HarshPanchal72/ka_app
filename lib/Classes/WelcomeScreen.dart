import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:ka_app/Classes/CreateNewUserScreen.dart';
import 'package:ka_app/Classes/MyProfileScreen.dart';
import 'package:ka_app/Classes/SelectOptionScreen.dart';
import 'package:ka_app/Resources/AppText.dart';
import '../API Manager/APIConstants.dart';
import '../API Manager/APIService.dart';
import '../Resources/InternetService.dart';
import '../Resources/SizeConfig.dart';
import 'common_class.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 5),);
    // _controller.forward();
    // _controller.repeat(reverse: true);
    _fadeAnimation = Tween<double>(begin: 0.7, end: 1.0,).animate(_controller);
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0,).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack,),);
    _controller.forward();

    InternetService.instance.initialize(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    InternetService.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return PopScope(
       canPop: false,
       child: Scaffold(
       body: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/bg_image3.png',
                  fit: BoxFit.fill,
                ),
                SafeArea(
                  child:LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Center(
                    child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.business,
                            size: 80,
                            color: Colors.white,
                          ),

                          const SizedBox(height: 20),

                          AppText(
                            text: 'Welcome To',
                            //fontSize: 25,
                            fontSize: SizeConfig.getFont(20),
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),

                          const SizedBox(height: 5),

                          AppText(
                            text: 'KATARIA',
                           // fontSize: 35,
                            fontSize: SizeConfig.getFont(30),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),

                          const SizedBox(height: 5),

                          AppText(
                            text: 'Empowering Your Business',
                            //fontSize: 16,
                            fontSize: SizeConfig.getFont(11),
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),

                          SizedBox(height: 15),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              CommonClass().commonWhiteButton(width: SizeConfig.getWidth(70),
                                height: SizeConfig.getHeight(38),
                                fontSize: SizeConfig.getFont(10),
                                text: "User",
                                icon: Icons.person,
                                onPressed: () {
                                  showLoginDialog(context, 'User');
                                },
                              ),

                              SizedBox(width: 15),

                              CommonClass().commonWhiteButton(width: SizeConfig.getWidth(90),
                                height: SizeConfig.getHeight(38),
                                fontSize: SizeConfig.getFont(10),
                                text: "Manager",
                                icon: Icons.person,
                                onPressed: () {
                                  showLoginDialog(context, 'Manager');
                                },
                              ),

                              SizedBox(width: 15),

                              CommonClass().commonWhiteButton(width: SizeConfig.getWidth(60),
                                height: SizeConfig.getHeight(38),
                                fontSize: SizeConfig.getFont(10),
                                text: "Acc.",
                                icon: Icons.person,
                                onPressed: () {
                                  showLoginDialog(context, 'Acc.');
                                },
                              ),

                            ],
                          ),

                          const SizedBox(height: 25),

                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: const [
                          //     AppText(
                          //       text: "Project Credits",
                          //       fontSize: 18,
                          //       fontWeight: FontWeight.w700,
                          //       color: Colors.orangeAccent,
                          //     ),
                          //     SizedBox(height: 8),
                          //
                          //     AppText(
                          //       text: "Developed By :",
                          //       textAlign: TextAlign.start,
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.w500,
                          //       color: Colors.white70,
                          //     ),
                          //     AppText(
                          //       text: "Komal Sathavara\nYash Patel",
                          //       textAlign: TextAlign.start,
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.w500,
                          //       color: Colors.white70,
                          //     ),
                          //     SizedBox(height: 8),
                          //
                          //     AppText(
                          //       text: "HOD ICT Department :\nBhupendra Panchal",
                          //       textAlign: TextAlign.start,
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.w500,
                          //       color: Colors.white70,
                          //     ),
                          //     SizedBox(height: 8),
                          //
                          //     AppText(
                          //       text: "Tested By :\nMaunik Prajapati",
                          //       textAlign: TextAlign.start,
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.w500,
                          //       color: Colors.white70,
                          //     ),
                          //   ],
                          // ),

                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: "Project Credits",
                                 // fontSize: 18,
                                  fontSize: SizeConfig.getFont(15),
                                  fontWeight: FontWeight.w700,
                                  color: Colors.orangeAccent,
                                ),
                                SizedBox(height: 8),

                                AppText(
                                  text: "Developed By :",
                                  //fontSize: 14,
                                  fontSize: SizeConfig.getFont(11),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                AppText(
                                  text: "Komal Sathavara",
                                  //fontSize: 14,
                                  fontSize: SizeConfig.getFont(11),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                                AppText(
                                  text: "Yash Patel",
                                  //fontSize: 14,
                                  fontSize: SizeConfig.getFont(11),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                                SizedBox(height: 8),

                                AppText(
                                  text: "HOD ICT Department :",
                                  //fontSize: 14,
                                  fontSize: SizeConfig.getFont(11),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                AppText(
                                  text: "Bhupendra Panchal",
                                  //fontSize: 14,
                                  fontSize: SizeConfig.getFont(11),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                                SizedBox(height: 8),

                                AppText(
                                  text: "Tested By :",
                                  //fontSize: 14,
                                  fontSize: SizeConfig.getFont(11),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                AppText(
                                  text: "Maunik Prajapati",
                                 // fontSize: 14,
                                  fontSize: SizeConfig.getFont(11),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),),
                    ),
                  ),
                ),),);},),),
              ],
            ),),
    );
  }

  void showLoginDialog(BuildContext context, String name) {

    final TextEditingController userNameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();


    double screenWidth = MediaQuery.of(context).size.width;
    final ValueNotifier<bool> isPswdHidden = ValueNotifier<bool>(false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
          return
            AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    title: Row(
                      children: [
                        AppText(text: "$name Login",
                          //fontSize: 17,
                          fontSize: SizeConfig.getFont(11),
                          color: Colors.black, fontWeight: FontWeight.w600,),
                        SizedBox(width: 5),
                        (name == 'Acc.') ? const SizedBox.shrink() : TextButton(
                          onPressed: () {
                            CommonClass.navClass(context, CreateNewUserScreen());
                          },
                          child: AppText(text: "Create New User",
                            //fontSize: 14,
                            fontSize: SizeConfig.getFont(11),
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple,
                            textDecoration: TextDecoration.underline,
                            textDecorationColor: Colors.blue,
                          ),
                        ),
                      ]
                    ),
                    content: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonClass().customTextField("$name Name", userNameController, isMandatory: true,
                            prefixIcon: Icons.person, width: screenWidth,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter $name Name";
                              }
                              return null;
                            }, context: context),

                          const SizedBox(height:18),

                          ValueListenableBuilder(
                            valueListenable: isPswdHidden,
                            builder: (context, pswd, child) {
                              return CommonClass().customTextField("Password", passwordController, isMandatory: true,
                            prefixIcon: Icons.lock, width: screenWidth, obscureText: pswd,
                            suffixIcon: isPswdHidden.value ? Icons.visibility_off : Icons.visibility,
                            onSuffixPressed: () {
                              isPswdHidden.value = !isPswdHidden.value;
                                },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },context: context
                          );},),
                        ],
                      ),),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: AppText(text: 'Cancel', fontSize: SizeConfig.getFont(10), color: Colors.deepPurple, fontWeight: FontWeight.normal,)
                      ),

                          CommonClass().commonWhiteButton(
                          text: "Login", fontSize: SizeConfig.getFont(10),
                            width: SizeConfig.getWidth(50),
                            height: SizeConfig.getHeight(35),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                CommonClass.showLoader(context);
                                callAPILogin(userNameController.text, passwordController.text, name);
                              }
                            },
                          ),
                     ],
                    );
          });
                },);}

  Future<void> callAPILogin(String username, String pswd, String heading) async {
    bool hasInternet = await InternetConnection().hasInternetAccess;

    if (!hasInternet) {
      CommonClass.hideLoader(context);
      CommonClass.showSnackBar(context, message: "No Internet Connection",
          backgroundColor: Colors.red, textColor: Colors.white);
      return;
    }

    try {
      final api = ApiService();

      Response response = await api.postApi(
        endpoint: ApiConstants.login,
        param: {
          "username": username,
          "password": pswd,
        },
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        print('Success Response==>${response.data}');
        CommonClass().setHeading(heading);
        CommonClass().setUser(username);

        Future.delayed(const Duration(seconds: 2), () {
          CommonClass.showSnackBar(
              context, message: "$heading Login Successfully", textColor: Colors.deepPurple);
          Navigator.pop(context);
          CommonClass.hideLoader(context);
          (heading == 'Acc.') ? CommonClass.navClass(context, SelectOptionScreen()) : CommonClass.navClass(context, MyProfileScreen());
        });

        (heading == "User") ? CommonClass().setScreen("users") : CommonClass().setScreen("manager");

      } else {
        Future.delayed(const Duration(seconds: 2), () {
          CommonClass.hideLoader(context);
          CommonClass.showSnackBar(
            context,
            message: "Login Failed",
          );
        });
      }
    } catch (e) {
      CommonClass.hideLoader(context);

      CommonClass.showSnackBar(
        context,
        message: "Something went wrong",
      );

      print("Error: $e");
    }
  }
}