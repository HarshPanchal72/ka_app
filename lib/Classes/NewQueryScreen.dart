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

class NewQueryScreen extends StatefulWidget {
  final String userId;
  const NewQueryScreen({super.key, required this.userId});
  @override
  State<NewQueryScreen> createState() => NewQueryScreenState();
}

class NewQueryScreenState extends State<NewQueryScreen> {

  final TextEditingController mobNoController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController orgController = TextEditingController();

   final formKey = GlobalKey<FormState>();

  final ValueNotifier<String?> selectDepartment = ValueNotifier<String?>(null);
  final ValueNotifier<String?> selectDesignation = ValueNotifier<String?>(null);
  final ValueNotifier<String?> selectCity = ValueNotifier<String?>(null);
  final ValueNotifier<String?> selectBranch = ValueNotifier<String?>(null);
  final ValueNotifier<String?> selectCompany = ValueNotifier<String?>(null);
  final ValueNotifier<String?> selectRepMan = ValueNotifier<String?>(null);

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
  final ValueNotifier<List<String>> arrCompany = ValueNotifier<List<String>>(["KAPL", "KMPL", "KCPL", "KW", "Ather"]);
  final ValueNotifier<List<String>> arrRepMan = ValueNotifier<List<String>>(["RepMan1", "RepMan2", "RepMan3", "RepMan4", "RepMan5"]);

  //String? selectDepartment;
  //String? selectDesignation;
  //String? selectCity;
  //String? selectBranch;
  //String? selectCompany;
  //String? selectRepMan;

  //final List<String> arrDepartments = [ "HR", "ERP", "Accounts", "Sales"];
  //List<String> arrDesignations = [];
  //final List<String> arrCity = [ "Ahmedabad", "Gandhinagar", "Vadodara", "Surat", "Banglore"];
  //List<String> arrBranch= [];
  // final Map<String, List<String>> branchMap = {
  //   "Ahmedabad": [
  //     "Ahmedabad-Makarba",
  //     "Prahladnagar Nexa",
  //     "Sanathal", "Maninagar", "Dariyapur",
  //   ],
  //   "Gandhinagar": [
  //     "Nexa Gandhinagar",
  //     "Ather Gandhinagar",
  //   ],
  //   "Vadodara": [
  //     "Ather Vadodara",
  //     "Workshop Vadodara",
  //     "Arena Vadodara",
  //     "BharatBenz Vadodara",
  //   ],
  //   "Surat": [
  //     "Ather Vesu",
  //     "Piplod Surat",
  //     "Bardoli-Surat", "Kadodara Surat", "TrueValue Surat",
  //   ],
  //   "Banglore": [
  //     "TrueValue Banglore",
  //     "Arena Banglore",
  //     "Nexa Banglore",
  //   ],
  // };
  // final Map<String, List<String>> designationMap = {
  //   "HR": [
  //     "HR Manager",
  //     "HR Executive",
  //     "HR Recruiter",
  //   ],
  //   "ERP": [
  //     "GM ERP",
  //     "Manager ERP",
  //     "ERP Sr.Executive",
  //     "ERP Jr.Executive",
  //   ],
  //   "Accounts": [
  //     "Account Manager",
  //     "Senior Accountant",
  //     "Junior Accountant",
  //   ],
  //   "Sales": [
  //     "Sales Manager",
  //     "Sales Executive",
  //     "Sales Officer",
  //   ],
  // };
  //final List<String> arrCompany = [ "KAPL", "KMPL", "KCPL", "KW", "Ather"];
  //final List<String> arrRepMan = [ "RepMan1", "RepMan2", "RepMan3", "RepMan4", "RepMan5"];
  //         @override
  //         void initState() {
  //           super.initState();
  //
  //         }

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

  loadUserData();
}

Future<void> loadUserData() async {
  Map<String, String> data = await CommonClass().getUserData();
  userNameController.text = data["username"] ?? "";
  mobNoController.text = data["mobile"] ?? "";
  emailController.text = data["email"] ?? "";
  orgController.text = (data["badge_id"]?.isNotEmpty == true)
      ? data["badge_id"]!
      : (data["company"]?.isNotEmpty == true ? data["company"]! : data["username"] ?? "");

  String city = data["city"] ?? "";
  if (city.isNotEmpty && arrCity.value.contains(city)) {
    selectCity.value = city;
    arrBranch.value = branchMap.value[city] ?? [];
  } else if (arrCity.value.isNotEmpty) {
    selectCity.value = arrCity.value.first;
    arrBranch.value = branchMap.value[selectCity.value] ?? [];
  }

  String branch = data["branch"] ?? "";
  if (branch.isNotEmpty && arrBranch.value.contains(branch)) {
    selectBranch.value = branch;
  }

  String dept = data["department"] ?? "";
  if (dept.isNotEmpty && arrDepartments.value.contains(dept)) {
    selectDepartment.value = dept;
    arrDesignations.value = designationMap.value[dept] ?? [];
  } else if (arrDepartments.value.isNotEmpty) {
    selectDepartment.value = arrDepartments.value.first;
    arrDesignations.value = designationMap.value[selectDepartment.value] ?? [];
  }

  String desig = data["designation"] ?? "";
  if (desig.isNotEmpty && arrDesignations.value.contains(desig)) {
    selectDesignation.value = desig;
  }
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
        appBar: CommonClass().commonAppBar(title: "New Query", toolbarHeight: 50,
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back),
          //   onPressed: () => Navigator.pop(context),
          // ),
        ),
        body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/images/bg_image5.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),),
                    Expanded(child: SingleChildScrollView(child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20,top: 5),
                    child: Form(
                      key: formKey,
                      //autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // CommonClass().customTextField(userNameController.text.isEmpty ? "Enter User Name" : "User Name", userNameController, isMandatory: true, width: screenWidth,
                        //     validator: (value) {
                        //       if (value == null || value.trim().isEmpty) {
                        //         return "Please enter User Name";
                        //       }
                        //       return null;
                        //     },context: context),

                        CommonClass().customTextField("User Name", userNameController, isMandatory: true,
                            width: screenWidth, readOnly: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter User Name";
                              }
                              return null;
                            },context: context),

                        SizedBox(height: CommonClass.hDist+10),

                        // CommonClass().customTextField(mobNoController.text.isEmpty ? "Enter Mobile No": "Mobile No",
                        //   mobNoController, isMandatory: true, width: screenWidth, isMobile: true,
                        //   validator: (value) {
                        //   if (value == null || value.trim().isEmpty) {
                        //     return "Please enter Mobile No.";
                        //   }
                        //   if (value.length != 10) {
                        //     return "Mobile No. must be 10 digits";
                        //   }
                        //   return null;
                        // }, context: context,),

                        CommonClass().customTextField("Mobile No",
                          mobNoController, isMandatory: true, width: screenWidth, isMobile: true, readOnly: true,
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

                        // CommonClass().customTextField(emailController.text.isEmpty ? "Enter Email Address" : "Email Address", emailController, width: screenWidth,
                        //     isMandatory: true,
                        //     validator: (value) {
                        //       if (value == null || value.trim().isEmpty) {
                        //         return "Please enter Email Address";
                        //       }
                        //       if (!RegExp(
                        //         r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
                        //       ).hasMatch(value)) {
                        //         return "Please enter a valid email address";
                        //       }
                        //       return null;
                        //     }, context: context),

                        CommonClass().customTextField("Email Address", emailController, width: screenWidth,
                            isMandatory: true, readOnly: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter Email Address";
                              }
                              if (!RegExp(
                                r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
                              ).hasMatch(value)) {
                                return "Please enter a valid email address";
                              }
                              return null;
                            }, context: context),

                        SizedBox(height: CommonClass.hDist+10),

                        // CommonClass().customTextField(orgController.text.isEmpty ? "Enter Orange Id" : "Orange Id",
                        //     orgController, isMandatory: true, width: screenWidth,
                        //     validator: (value) {
                        //       if (value == null || value.trim().isEmpty) {
                        //         return "Please enter Orange Id";
                        //       }
                        //       return null;
                        //     }, context: context),

                        CommonClass().customTextField("Orange Id",
                            orgController, isMandatory: true, width: screenWidth, readOnly: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter Orange Id";
                              }
                              return null;
                            }, context: context),

                        ///SizedBox(height: CommonClass.hDist+10),

                        // ValueListenableBuilder<List<String>>(
                        //   valueListenable: arrCity,
                        //   builder: (context, cities, child) {
                        //     return ValueListenableBuilder<String?>(
                        //       valueListenable: selectCity,
                        //       builder: (context, selectedCity, child) {
                        //         return CommonClass().customDropdown(
                        //           context: context,
                        //           width: screenWidth,
                        //           hint: (selectedCity?.isNotEmpty ?? false) ? "Select City".replaceAll("Select ", "") : "Select City",
                        //           items: cities,
                        //           value: selectedCity,
                        //           first: true,
                        //           onChanged: (value) {
                        //             selectCity.value = value;
                        //             arrBranch.value = branchMap.value[value] ?? [];
                        //             selectBranch.value = null;
                        //           },
                        //           validator: (value) {
                        //             if (value == null || value.isEmpty) {
                        //               return "Please select City";
                        //             }
                        //             return null;
                        //           },
                        //         );
                        //       },
                        //     );
                        //   },
                        // ),

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

                        ///SizedBox(height: CommonClass.hDist+10),

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

                        ///SizedBox(height: CommonClass.hDist),

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

                        ///SizedBox(height:CommonClass.hDist),

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

                        ///SizedBox(height: CommonClass.hDist),

                        ValueListenableBuilder<List<String>>(
                          valueListenable: arrCompany,
                          builder: (context, companies, child) {
                            return ValueListenableBuilder<String?>(
                              valueListenable: selectCompany,
                              builder: (context, selectedCompany, child) {
                                return CommonClass().customDropdown(
                                  context: context,
                                  width: screenWidth,
                                  hint: (selectedCompany?.isNotEmpty ?? false) ? "Select Company".replaceAll("Select ", "") : "Select Company",
                                  items: companies,
                                  value: selectedCompany,
                                  onChanged: (value) {
                                    selectCompany.value = value;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please select Company";
                                    }
                                    return null;
                                  },
                                );
                              },
                            );
                          },
                        ),

                        ///SizedBox(height: CommonClass.hDist),

                        ValueListenableBuilder<List<String>>(
                          valueListenable: arrRepMan,
                          builder: (context, repManagers, child) {
                            return ValueListenableBuilder<String?>(
                              valueListenable: selectRepMan,
                              builder: (context, selectedRepMan, child) {
                                return CommonClass().customDropdown(
                                  context: context,
                                  width: screenWidth,
                                  hint: (selectedRepMan?.isNotEmpty ?? false) ? "Select Reporting Manager".replaceAll("Select ", "") : "Select Reporting Manager",
                                  items: repManagers,
                                  value: selectedRepMan,
                                  onChanged: (value) {
                                    selectRepMan.value = value;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please select Rep.Manager";
                                    }
                                    return null;
                                  },
                                );
                              },
                            );
                          },
                        ),

                        SizedBox(height: 22),

                        CommonClass().commonButton(
                          text: "Next",
                          width: screenWidth,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                CommonClass.navClass(context, DetailsScreen(
                                  loginData: LoginPassModel(
                                    userId: widget.userId,
                                    mobile: mobNoController.text,
                                    userName: userNameController.text,
                                    city: selectCity.value ?? '',
                                    branch: selectBranch.value ?? '',
                                    email: emailController.text,
                                    orange_id: orgController.text,
                                    department: selectDepartment.value ?? '',
                                    designation: selectDesignation.value ?? '',
                                    company: selectCompany.value ?? '',
                                    reporting_man: selectRepMan.value ?? '',
                                  ),
                                ),);
                              }
                            }
                        ),

                        SizedBox(height: 10),

                      ],
                    ),),
                  ),),
          ),
        ],),
      ),
    //),
    );
  }
}
