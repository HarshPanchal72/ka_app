import 'package:flutter/material.dart';
import 'package:ka_app/Classes/SideMenu.dart';
import 'package:ka_app/Models/LoginPassModel.dart';
import '../API Manager/APIConstants.dart';
import '../API Manager/APIService.dart';
import '../Resources/AppColors.dart';
import '../Resources/AppText.dart';
import '../Resources/SizeConfig.dart';
import 'DetailsScreen.dart';
import 'common_class.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, });
  @override
  State<EditProfileScreen> createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {

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


  @override
  void initState() {
    super.initState();

    userNameController.addListener(() {
      setState(() {});
    });
    mobNoController.addListener(() {
      setState(() {});
    });
    emailController.addListener(() {
      setState(() {});
    });
    orgController.addListener(() {
      setState(() {});
    });

    userNameController.text = "Teena Shah";
    mobNoController.text = "9876543211";
    emailController.text = "teena@gmail.com";
    orgController.text = "kamk1234";

    selectCity.value = "Ahmedabad";
    arrBranch.value = branchMap.value[selectCity.value] ?? [];
    selectBranch.value = "Ahmedabad-Makarba";
    selectDepartment.value = "ERP";
    arrDesignations.value = designationMap.value[selectDepartment.value] ?? [];
    selectDesignation.value = "Manager ERP";

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
        drawer: SideMenu(),
        appBar: CommonClass().commonAppBar(title: "Edit My Profile", toolbarHeight: 50,
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back_ios,size: 18),
          //   onPressed: () => Navigator.pop(context),
          // ),
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

                  CommonClass().customTextField(userNameController.text.isEmpty?"Enter User Name":"User Name",
                      userNameController, width: screenWidth, opt: false,
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
                      isMandatory: false, opt: true,
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

                  CommonClass().customTextField("Orange Id",
                      orgController, width: screenWidth, readOnly: true,
                      validator: (value) {
                        // if (value == null || value.trim().isEmpty) {
                        //   return "Please enter Orange Id";
                        // }
                        // return null;
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
                            //hint: (selectedCity?.isNotEmpty ?? false) ? "Select City".replaceAll("Select ", "") : "Select City",
                            hint: (selectedCity?.isNotEmpty ?? false) ? "Select City".replaceAll("Select ", "") : "Select City",
                            items: cities,
                            value: selectedCity,
                            readOnly: true,
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
                            //hint: " Branch6666",
                            items: branches,
                            value: selectedBranch,
                            readOnly: true,
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
                            readOnly: true,
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
                            //hint: (selectedDesignation?.isNotEmpty ?? false) ? selectedDesignation ?? '': "Select Designation",
                            items: designations,
                            value: selectedDesignation,
                            readOnly: true,
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

                  //SizedBox(height: 15),

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
                      text: "Edit",
                      width: screenWidth,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          CommonClass.showLoader(context);
                          CommonClass.showSnackBar(context, message: "Edit Profile Successfully", textColor: Colors.deepPurple);
                          Future.delayed(const Duration(seconds: 2), () {
                            CommonClass.hideLoader(context);
                            Navigator.pop(context);
                          });
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
}
