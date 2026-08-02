import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ka_app/Classes/SideMenu.dart';
import 'package:ka_app/Models/LoginPassModel.dart';
import '../API Manager/APIConstants.dart';
import '../API Manager/APIService.dart';
import '../Resources/AppColors.dart';
import '../Resources/AppText.dart';
import '../Resources/SizeConfig.dart';
import 'DetailsScreen.dart';
import 'common_class.dart';

class CreateNewUserScreen extends StatefulWidget {
  const CreateNewUserScreen({super.key, });
  @override
  State<CreateNewUserScreen> createState() => CreateNewUserScreenState();
}

class CreateNewUserScreenState extends State<CreateNewUserScreen> {

  final TextEditingController mobNoController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController orgController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final ValueNotifier<String?> selectDepartment = ValueNotifier<String?>(null);
  final ValueNotifier<String?> selectDesignation = ValueNotifier<String?>(null);
  final ValueNotifier<String?> selectCity = ValueNotifier<String?>(null);
  final ValueNotifier<String?> selectBranch = ValueNotifier<String?>(null);

  final ValueNotifier<List<String>> arrDepartments = ValueNotifier<List<String>>([
    "HR",
    "ERP",
    "Accounts",
    "Sales",
  ]);
  final ValueNotifier<List<String>> arrDesignations = ValueNotifier<List<String>>([]);
  final ValueNotifier<List<String>> arrCity = ValueNotifier<List<String>>(["Ahmedabad", "Gandhinagar", "Vadodara", "Surat", "Banglore"]);
  final ValueNotifier<List<String>> arrBranch = ValueNotifier<List<String>>([]);
  final ValueNotifier<Map<String, List<String>>> branchMap = ValueNotifier<Map<String, List<String>>>({
    "Ahmedabad": [
      "Ahmedabad-Makarba",
      "Prahladnagar Nexa",
      "Sanathal", "Maninagar", "Dariyapur",
    ],
    "Gandhinagar": [
      "Nexa Gandhinagar",
      "Ather Gandhinagar",
    ],
    "Vadodara": [
      "Ather Vadodara",
      "Workshop Vadodara",
      "Arena Vadodara",
      "BharatBenz Vadodara",
    ],
    "Surat": [
      "Ather Vesu",
      "Piplod Surat",
      "Bardoli-Surat", "Kadodara Surat", "TrueValue Surat",
    ],
    "Banglore": [
      "TrueValue Banglore",
      "Arena Banglore",
      "Nexa Banglore",
    ],
  });
  final ValueNotifier<Map<String, List<String>>> designationMap = ValueNotifier<Map<String, List<String>>>({
    "HR": [
      "HR Manager",
      "HR Executive",
      "HR Recruiter",
    ],
    "ERP": [
      "GM ERP",
      "Manager ERP",
      "ERP Sr.Executive",
      "ERP Jr.Executive",
    ],
    "Accounts": [
      "Account Manager",
      "Senior Accountant",
      "Junior Accountant",
    ],
    "Sales": [
      "Sales Manager",
      "Sales Executive",
      "Sales Officer",
    ],
  });

  final ValueNotifier<bool> isPswdHidden = ValueNotifier<bool>(false);
  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    mobNoController.addListener(() {
      setState(() {});
    });
    userNameController.addListener(() {
      setState(() {});
    });
    emailController.addListener(() {
      setState(() {});
    });
    orgController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    double screenWidth = MediaQuery.of(context).size.width;
    return
      // PopScope(
      // canPop: false,
      // child:
      Scaffold(
        //drawer: SideMenu(),
        appBar: CommonClass().commonAppBar(title: "Create New User", toolbarHeight: 50,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child:
          // Column(
          //   children: [
              SingleChildScrollView(child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20,top: 5),
                child: Form(
                  key: formKey,
                  //autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Center(
                        child:Stack(
                            children: [
                              CircleAvatar(
                                radius: 42,
                                backgroundColor: Colors.grey.shade300,
                                backgroundImage:
                                selectedImage != null ? FileImage(selectedImage!) : null,
                                child: selectedImage == null
                                    ? const Icon(
                                  Icons.person,
                                  size: 25,
                                  color: Colors.grey,
                                )
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: pickImage,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.deepPurple,
                                    size: 18,
                                  ),),
                              ),
                            ],
                        ),
                      ),
                      SizedBox(height: CommonClass.hDist+10),
                      CommonClass().customTextField(userNameController.text.isEmpty ? "Enter User Name" : "User Name", userNameController, isMandatory: true, width: screenWidth,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter User Name";
                            }
                            return null;
                          },context: context),

                      SizedBox(height: CommonClass.hDist+10),

                      CommonClass().customTextField(mobNoController.text.isEmpty ? "Enter Mobile No": "Mobile No",
                        mobNoController, isMandatory: true, width: screenWidth, isMobile: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter Mobile No.";
                          }
                          if (value.length != 10) {
                            return "Mobile No. must be 10 digits";
                          }
                          return null;
                        }, context: context,),

                      SizedBox(height: CommonClass.hDist+10),

                      CommonClass().customTextField(emailController.text.isEmpty ? "Enter Email Address" : "Email Address", emailController, width: screenWidth,
                          isMandatory: false,
                           validator: (value) {
                            // if (value == null || value.trim().isEmpty) {
                            //   return "Please enter Email Address";
                            // }
                            // if (!RegExp(
                            //   r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
                            // ).hasMatch(value)) {
                            //   return "Please enter a valid email address";
                            // }
                            // return null;
                           },
                          context: context),

                      SizedBox(height: CommonClass.hDist+10),

                      CommonClass().customTextField(orgController.text.isEmpty ? "Enter Orange Id" : "Orange Id",
                          orgController, isMandatory: true, width: screenWidth,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter Orange Id";
                            }
                            return null;
                          }, context: context),

                      //SizedBox(height: CommonClass.hDist+5),

                      ValueListenableBuilder<List<String>>(
                        valueListenable: arrCity,
                        builder: (context, cities, child) {
                          return ValueListenableBuilder<String?>(
                            valueListenable: selectCity,
                            builder: (context, selectedCity, child) {
                              return CommonClass().customDropdown(
                                context: context,
                                width: screenWidth,
                                hint: (selectedCity?.isNotEmpty ?? false) ? "Select City".replaceAll("Select ", "") : "Select City",
                                items: cities,
                                value: selectedCity,
                                onChanged: (value) {
                                  selectCity.value = value;
                                  arrBranch.value = branchMap.value[value] ?? [];
                                  selectBranch.value = null;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please select City";
                                  }
                                  return null;
                                },
                              );
                            },
                          );
                        },
                      ),

                      //SizedBox(height: CommonClass.hDist+10),

                      ValueListenableBuilder<List<String>>(
                        valueListenable: arrBranch,
                        builder: (context, branches, child) {
                          return ValueListenableBuilder<String?>(
                            valueListenable: selectBranch,
                            builder: (context, selectedBranch, child) {
                              return CommonClass().customDropdown(
                                context: context,
                                width: screenWidth,
                                hint: (selectedBranch?.isNotEmpty ?? false) ? "Select Branch".replaceAll("Select ", "") : "Select Branch",
                                items: branches,
                                value: selectedBranch,
                                onChanged: (value) {
                                  selectBranch.value = value;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please select Branch";
                                  }
                                  return null;
                                },
                              );
                            },
                          );
                        },
                      ),

                      //SizedBox(height: CommonClass.hDist+10),

                      ValueListenableBuilder<List<String>>(
                        valueListenable: arrDepartments,
                        builder: (context, departments, child) {
                          return ValueListenableBuilder<String?>(
                            valueListenable: selectDepartment,
                            builder: (context, selectedDepartment, child) {
                              return CommonClass().customDropdown(
                                context: context,
                                width: screenWidth,
                                hint: (selectedDepartment?.isNotEmpty ?? false) ? "Select Department".replaceAll("Select ", "") : "Select Department",
                                items: departments,
                                value: selectedDepartment,
                                onChanged: (value) {
                                  selectDepartment.value = value;
                                  selectDesignation.value = null;
                                  arrDesignations.value = designationMap.value[value] ?? [];
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please select Department";
                                  }
                                  return null;
                                },
                              );
                            },
                          );
                        },
                      ),

                      //SizedBox(height:CommonClass.hDist),

                      ValueListenableBuilder<List<String>>(
                        valueListenable: arrDesignations,
                        builder: (context, designations, child) {
                          return ValueListenableBuilder<String?>(
                            valueListenable: selectDesignation,
                            builder: (context, selectedDesignation, child) {
                              return CommonClass().customDropdown(
                                context: context,
                                width: screenWidth,
                                hint: (selectedDesignation?.isNotEmpty ?? false) ? "Select Designation".replaceAll("Select ", "") : "Select Designation",
                                items: designations,
                                value: selectedDesignation,
                                onChanged: (value) {
                                  selectDesignation.value = value;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please select Designation";
                                  }
                                  return null;
                                },
                              );
                            },
                          );
                        },
                      ),

                      SizedBox(height: 15),

                      ValueListenableBuilder(
                      valueListenable: isPswdHidden,
                      builder: (context, pswd, child) {
                      return CommonClass().customTextField(passwordController.text.isEmpty
                          ? "Enter Password"
                          : "Password", passwordController, isMandatory: true, width: screenWidth, obscureText: pswd,
                          suffixIcon: isPswdHidden.value ? Icons.visibility_off : Icons.visibility,
                          onSuffixPressed: () {
                            isPswdHidden.value = !isPswdHidden.value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            if (!RegExp(r'[A-Z]').hasMatch(value)) {
                              return 'Include at least one uppercase letter';
                            }
                            if (!RegExp(r'[a-z]').hasMatch(value)) {
                              return 'Include at least one lowercase letter';
                            }
                            if (!RegExp(r'[0-9]').hasMatch(value)) {
                              return 'Include at least one number';
                            }
                            if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                              return 'Include at least one special character';
                            }
                            return null;
                          },context: context
                      );},),

                      ///SizedBox(height: CommonClass.hDist),

                      // ValueListenableBuilder<List<String>>(
                      //   valueListenable: arrCompany,
                      //   builder: (context, companies, child) {
                      //     return ValueListenableBuilder<String?>(
                      //       valueListenable: selectCompany,
                      //       builder: (context, selectedCompany, child) {
                      //         return CommonClass().customDropdown(
                      //           context: context,
                      //           width: screenWidth,
                      //           hint: (selectedCompany?.isNotEmpty ?? false) ? "Select Company".replaceAll("Select ", "") : "Select Company",
                      //           items: companies,
                      //           value: selectedCompany,
                      //           first: true,
                      //           onChanged: (value) {
                      //             selectCompany.value = value;
                      //           },
                      //           validator: (value) {
                      //             if (value == null || value.isEmpty) {
                      //               return "Please select Company";
                      //             }
                      //             return null;
                      //           },
                      //         );
                      //       },
                      //     );
                      //   },
                      // ),

                      ///SizedBox(height: CommonClass.hDist),

                      // ValueListenableBuilder<List<String>>(
                      //   valueListenable: arrRepMan,
                      //   builder: (context, repManagers, child) {
                      //     return ValueListenableBuilder<String?>(
                      //       valueListenable: selectRepMan,
                      //       builder: (context, selectedRepMan, child) {
                      //         return CommonClass().customDropdown(
                      //           context: context,
                      //           width: screenWidth,
                      //           hint: (selectedRepMan?.isNotEmpty ?? false) ? "Select Reporting Manager".replaceAll("Select ", "") : "Select Reporting Manager",
                      //           items: repManagers,
                      //           value: selectedRepMan,
                      //           first: true,
                      //           onChanged: (value) {
                      //             selectRepMan.value = value;
                      //           },
                      //           validator: (value) {
                      //             if (value == null || value.isEmpty) {
                      //               return "Please select Rep.Manager";
                      //             }
                      //             return null;
                      //           },
                      //         );
                      //       },
                      //     );
                      //   },
                      // ),

                      SizedBox(height: 22),

                      CommonClass().commonButton(
                          text: "Create New User",
                          width: screenWidth,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              CommonClass.showLoader(context);
                              callCreateUserApi();
                            }
                          }
                      ),


                      SizedBox(height: 10),

                    ],
                  ),),
              ),
              ),
            // ],),
        ),
        //),
      );
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> callCreateUserApi() async {
    try {
      final api = ApiService();

      Map<String, dynamic> formMap = {
        "username": userNameController.text.trim(),
        "password": passwordController.text.trim(),
        "role": "User",
        "mobile": mobNoController.text.trim(),
        "email": emailController.text.trim(),
        "company": "KAPL",
        "badge_id": orgController.text.trim(),
        "branch": selectBranch.value ?? '',
        "city": selectCity.value ?? '',
        "department": selectDepartment.value ?? '',
        "designation": selectDesignation.value ?? '',
      };

      if (selectedImage != null) {
        String fileName = selectedImage!.path.split('/').last;
        formMap["file"] = await MultipartFile.fromFile(
          selectedImage!.path,
          filename: fileName,
        );
      }

      FormData formData = FormData.fromMap(formMap);

      final response = await api.postFormDataApi(
        endpoint: ApiConstants.createUser,
        formData: formData,
      );

      CommonClass.hideLoader(context);
      if (response.statusCode == 200 || response.statusCode == 201) {
        CommonClass.showSnackBar(context, message: "User Created Successfully", textColor: Colors.deepPurple);
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      } else {
        String msg = response.data is Map && response.data['detail'] != null 
            ? response.data['detail'] 
            : "Failed to create user";
        if (msg.contains("Username already exists")) {
          msg = "Badge ID / User Name already exists. Please login using this Badge ID.";
        }
        CommonClass.showSnackBar(context, message: msg, backgroundColor: Colors.red, textColor: Colors.white);
      }
    } catch (e) {
      CommonClass.hideLoader(context);
      CommonClass.showSnackBar(context, message: "Error connecting to backend", backgroundColor: Colors.red);
      print("Create User Error: $e");
    }
  }
}

