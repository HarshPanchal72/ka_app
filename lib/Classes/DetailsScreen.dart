import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ka_app/Classes/QueryListScreen.dart';
import 'package:ka_app/Models/LoginPassModel.dart';
import 'package:url_launcher/url_launcher.dart';
import '../API Manager/APIConstants.dart';
import '../API Manager/APIService.dart';
import '../Resources/AppColors.dart';
import '../Resources/AppText.dart';
import 'WelcomeScreen.dart';
import 'common_class.dart';

class DetailsScreen extends StatefulWidget {
  final LoginPassModel loginData;
  const DetailsScreen({super.key, required this.loginData,});
  @override
  State<DetailsScreen> createState() => DetailsScreenState();
}

class DetailsScreenState extends State<DetailsScreen> {

  final ValueNotifier<bool> isSame = ValueNotifier<bool>(true);
  final ValueNotifier<File?> selectedImage = ValueNotifier<File?>(null);
  final ImagePicker picker = ImagePicker();
  String currentDate = "";
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  final ValueNotifier<String?> selectDepartment = ValueNotifier<String?>(null);
  final ValueNotifier<String?> selectSubDepartment = ValueNotifier<String?>(null);
  final ValueNotifier<String?> selectQuery = ValueNotifier<String?>(null);
  final ValueNotifier<String?> selectEngName = ValueNotifier<String?>(null);

  final ValueNotifier<List<String>> arrDepartments = ValueNotifier<List<String>>(["HR", "ERP", "Accounts", "Sales"]);
  final ValueNotifier<List<String>> arrSubDepartments = ValueNotifier<List<String>>([]);
  final ValueNotifier<List<String>> arrQuery = ValueNotifier<List<String>>(
      [ "Screen not Showing ?", "Reports not downloading ?", "Wings Id not log in ?", "Screen Path not getting ?"]);
  final ValueNotifier<List<String>> arrEngName = ValueNotifier<List<String>>(["Bhupendra Sir", "Maunik Sir", "Yash Sir", "Komal Ma'am"]);
  final ValueNotifier<Map<String, List<String>>> subDepartmentMap = ValueNotifier<Map<String, List<String>>>({
        "HR": [
          "Recruitment",
          "Payroll",
          "Training",
        ],
        "ERP": [
          "Development",
          "Support",
          "Testing",
        ],
        "Accounts": [
          "Billing",
          "Audit",
          "Tax",
        ],
        "Sales": [
          "Marketing",
          "Tele-calling",
          "Showroom",
        ],
      });

  // String? selectDepartment;
  // String? selectSubDepartment;
  // String? selectQuestions;
  // String? selectEngName;

  // final List<String> arrDepartments = [ "HR", "ERP", "Accounts", "Sales"];
  // List<String> arrSubDepartments = [];
  // final List<String> arrQuestions = [ "Screen not Showing ?", "Reports not downloading ?",
  //                                    "Wings Id not log in ?", "Screen Path not getting ?"];
  // final List<String> arrEngName = [ "Bhupendra Sir", "Maunik Sir", "Yash Sir", "Komal Ma'am"];
  //
  // final Map<String, List<String>> subDepartmentMap = {
  //   "HR": [
  //     "Recruitment",
  //     "Payroll",
  //     "Training",
  //   ],
  //   "ERP": [
  //     "Development",
  //     "Support",
  //     "Testing",
  //   ],
  //   "Accounts": [
  //     "Billing",
  //     "Audit",
  //     "Tax",
  //   ],
  //   "Sales": [
  //     "Marketing",
  //     "Tele-calling",
  //     "Showroom",
  //   ],
  // };

  @override
  void initState() {
    super.initState();
    currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    print(currentDate);

    emailController.text = widget.loginData.email;
    arrSubDepartments.value = subDepartmentMap.value[widget.loginData.department] ?? [];

    print(widget.loginData.mobile);
    print(widget.loginData.userName);
    print(widget.loginData.city);
    print(widget.loginData.branch);
    print(widget.loginData.email);
    print(widget.loginData.orange_id);
    print(widget.loginData.department);
    print(widget.loginData.designation);
    print(widget.loginData.company);
    print(widget.loginData.reporting_man);
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 30,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 18,),
            onPressed: () { Navigator.pop(context);},
          ),),
         body: SafeArea(
         child: SingleChildScrollView(child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                //autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppText(text: 'Date: ', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black,
                      ),
                      AppText(text:  DateFormat('dd/MM/yyyy').format(DateTime.now()), fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black,
                      ),
                    ],
                  ),

                  ValueListenableBuilder<bool>(
                    valueListenable: isSame,
                    builder: (context, isSamee, child) {
                      return Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 1,
                        runSpacing: 1,
                        children: [
                          AppText(
                            text: 'Location:',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),

                          Transform.scale(
                            scale: 0.8,
                            child: Checkbox(
                              value: isSamee,
                              onChanged: (value) {
                                isSame.value = true;
                                selectDepartment.value = widget.loginData.department;
                                selectSubDepartment.value = null;
                                arrSubDepartments.value = subDepartmentMap.value[widget.loginData.department] ?? [];
                              },
                            ),
                          ),

                          AppText(
                            text: 'Same Location',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),

                          Transform.scale(
                            scale: 0.8,
                            child: Checkbox(
                              value: !isSamee,
                              onChanged: (value) {
                                isSame.value = false;
                                selectDepartment.value = null;
                                selectSubDepartment.value = null;
                              },
                            ),
                          ),

                          AppText(
                            text: 'Change Location',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ],
                  );},),

                  SizedBox(height: CommonClass.hDist),

                  CommonClass().customTextField('Email Address', emailController,
                    width: screenWidth, readOnly: true,
                    validator: (value) {
                      //if (isSame) return null;
                      // if (value == null || value.trim().isEmpty) {
                      //   return "Please enter Email Address";
                      // }
                      // if (!RegExp(
                      //   r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
                      // ).hasMatch(value)) {
                      //   return "Please enter a valid email address";
                      // }
                      // return null;
                      }, context: context),

                  SizedBox(height: CommonClass.hDist),

                  ValueListenableBuilder<bool>(
                    valueListenable: isSame,
                    builder: (context, isSamee, child) {
                      return Row(
                        spacing: 15,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                           child: ValueListenableBuilder<List<String>>(
                            valueListenable: arrDepartments,
                            builder: (context, departments, child) {
                              return ValueListenableBuilder<String?>(
                                valueListenable: selectDepartment,
                                builder: (context, selectedDepartments, child) {
                                  return CommonClass().customDropdown(
                                    context: context,
                                    width: (screenWidth / 2.1) - 20,
                                    //hint: isSamee ? widget.loginData.department : "Select Department",
                                    hint: isSamee ? "Department" : (selectedDepartments?.isNotEmpty ?? false) ? "Select Department".replaceAll("Select ", "") : "Select Department",
                                    items: departments,
                                    value: isSamee ? widget.loginData.department : selectDepartment.value,
                                    readOnly: isSamee ? true : false,
                                    onChanged: (value) {
                                      selectDepartment.value = value;
                                      selectSubDepartment.value = null;
                                      arrSubDepartments.value = subDepartmentMap.value[value] ?? [];
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
                        ),
                        SizedBox(height: 15),
                        Expanded(
                          child: ValueListenableBuilder<List<String>>(
                            valueListenable: arrSubDepartments,
                            builder: (context, subDepartments, child) {
                              return ValueListenableBuilder<String?>(
                                valueListenable: selectSubDepartment,
                                builder: (context, selectedSubDept, child) {
                                  return CommonClass().customDropdown(context: context, width: (screenWidth/2.1)-20,
                                    hint: (selectedSubDept?.isNotEmpty ?? false) ? "Select Sub Department".replaceAll("Select ", "") : "Select Sub Department",
                                    items: (!isSamee&&selectDepartment.value == null) ? [] : subDepartments,
                                    value: selectSubDepartment.value,
                                    readOnly: false,
                                    onChanged: (value) {
                                      selectSubDepartment.value = value;
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  );},),

                  //SizedBox(height: CommonClass.hDist),

                  ValueListenableBuilder<List<String>>(
                    valueListenable: arrEngName,
                    builder: (context, engNames, child) {
                      return ValueListenableBuilder<String?>(
                        valueListenable: selectEngName,
                        builder: (context, selectedEngName, child) {
                          return CommonClass().customDropdown(
                            context: context,
                            width: screenWidth,
                            hint: (selectedEngName?.isNotEmpty ?? false) ? "Select Engineer Name".replaceAll("Select ", "") : "Select Engineer Name",
                            items: engNames,
                            value: selectedEngName,
                            readOnly: false,
                            onChanged: (value) {
                              selectEngName.value = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please select Eng.Name";
                              }
                              return null;
                            },
                          );
                        },
                      );
                    },
                  ),

                  //SizedBox(height: CommonClass.hDist),

                  ValueListenableBuilder<List<String>>(
                    valueListenable: arrQuery,
                    builder: (context, queries, child) {
                      return ValueListenableBuilder<String?>(
                        valueListenable: selectQuery,
                        builder: (context, selectedQuery, child) {
                          return CommonClass().customDropdown(
                            context: context,
                            width: screenWidth,
                            hint: (selectedQuery?.isNotEmpty ?? false) ? "Select Query".replaceAll("Select ", "") : "Select Query",
                            items: queries,
                            value: selectedQuery,
                            readOnly: false,
                            onChanged: (value) {
                              selectQuery.value = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please select Query";
                              }
                              return null;
                            },
                          );
                        },
                      );
                    },
                  ),

                  SizedBox(height: CommonClass.hDist+5),

                  CommonClass().customTextField("Remarks", remarksController, width: screenWidth, maxLines: 3,  remarks: true, readOnly: false,
                    validator: (value) {
                        print(remarksController);
                     }, context: context
                  ),

                  SizedBox(height: CommonClass.hDist+5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      CommonClass().commonWhiteButton(
                        text: "Attach Photo", width: 120, height: 30, fontSize: 11,
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Padding(padding: EdgeInsets.only(bottom: 40),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.camera_alt, size: 18,), minTileHeight: 20,
                                      title: AppText(text: 'Camera', fontSize: 12, fontWeight: FontWeight.w600, color: Colors.deepPurple,
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                        pickImage(ImageSource.camera);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.photo, size: 18,), minTileHeight: 20,
                                      title: AppText(text: 'Gallery', fontSize: 12, fontWeight: FontWeight.w600, color: Colors.deepPurple,
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                        pickImage(ImageSource.gallery);
                                      },
                                    ),
                                  ],
                                ),);
                            },
                          );
                        },
                      ),

                      IconButton(
                        onPressed: openWhatsApp,
                        icon: Image.asset(
                          'assets/images/whatsapp.jpeg',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: CommonClass.hDist+5),

                  ValueListenableBuilder<File?>(
                    valueListenable: selectedImage,
                    builder: (context, photo, child) {
                      if (photo == null) {
                        return const SizedBox.shrink();
                      }
                      return Container(
                    width: 250,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                     child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(photo, fit: BoxFit.cover,),
                    ),
                  );},),

                  SizedBox(height: 10),

                  CommonClass().commonButton(
                      text: "Submit Query",
                      width: screenWidth,
                      onPressed: () {
                       if (_formKey.currentState!.validate()) {
                         callSubmit();
                       }
                    },
                  ),

                  SizedBox(height: 10),
                  ],
            ),),
            ),
          ),
      ),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
        selectedImage.value = File(image.path);
    }
  }

  Future<void> callSubmit() async {
    try {
      CommonClass.showLoader(context);
      final api = ApiService();

      Map<String, dynamic> map = {
        "user_id": widget.loginData.userId.isNotEmpty ? widget.loginData.userId : "1",
        "sent_date": currentDate.isNotEmpty ? currentDate : DateFormat('dd/MM/yyyy').format(DateTime.now()),
        "user_name": widget.loginData.userName,
        "mobile_no": widget.loginData.mobile,
        "email": emailController.text.isNotEmpty ? emailController.text : widget.loginData.email,
        "branch": widget.loginData.branch,
        "department": (isSame.value) ? widget.loginData.department : (selectDepartment.value ?? widget.loginData.department),
        "sub_department": selectSubDepartment.value ?? '',
        "city": widget.loginData.city,
        "company": widget.loginData.company,
        "reporting_manager": widget.loginData.reporting_man,
        "engineer_name": selectEngName.value ?? '',
        "query_text": selectQuery.value ?? '',
        "remarks": remarksController.text,
        "status": "Pending",
        "w_type": "",
      };

      if (selectedImage.value != null && await selectedImage.value!.exists()) {
        String fileName = selectedImage.value!.path.split(RegExp(r'[/\\]')).last;
        map["file"] = await MultipartFile.fromFile(
          selectedImage.value!.path,
          filename: fileName,
        );
      }

      FormData formData = FormData.fromMap(map);

      var response = await api.postFormDataApi(
        endpoint: ApiConstants.submit,
        formData: formData,
      );

      CommonClass.hideLoader(context);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Success Response==>${response.data}');
        CommonClass().setFName(selectEngName.value ?? "");
        CommonClass.showSnackBar(context, message: "Query Submitted Successfully", textColor: Colors.deepPurple);
        Future.delayed(const Duration(seconds: 1), () {
          CommonClass.navClass(context, QueryListScreen(userId: widget.loginData.userId.isNotEmpty ? widget.loginData.userId : '1'));
        });
      } else {
        CommonClass.showSnackBar(context, message: "Submit Failed");
      }
    } catch (e) {
      CommonClass.hideLoader(context);
      print("Error: $e");
      CommonClass.showSnackBar(context, message: "Error submitting query: $e");
    }
  }


  // Future<void> openWhatsApp1() async {
  //   var phoneNo = '';
  //   final message = "Hello, My Query is ${selectQuery.value}";
  //   final message1 = "Hello, My Name: ${widget.loginData.userName}\n "
  //       "My Department: ${(isSame.value)? widget.loginData.department : selectDepartment.value}\n"
  //      // "SubDepartment: ${selectSubDepartment.value}\n"
  //       "City: ${widget.loginData.city}\n"
  //       "Branch: ${widget.loginData.branch}\n"
  //       "Mobile No.: ${widget.loginData.mobile}\n"
  //       "Query: ${selectQuery.value}\n";
  //
  //   print(message1);
  //
  //   if (selectEngName.value == 'Bhupendra Sir') {
  //     phoneNo = '919558810046';
  //   }else if (selectEngName.value == 'Maunik Sir') {
  //     phoneNo = '916357071694';
  //   }else if (selectEngName.value == 'Yash Sir') {
  //     phoneNo = '918488985930';
  //   }else {
  //     phoneNo = '918200684556';
  //   }
  //
  //   print('${selectEngName.value}:$phoneNo');
  //
  //   final Uri url = Uri.parse('https://wa.me/$phoneNo?text=${Uri.encodeComponent(message)}',);
  //
  //   if (await launchUrl(url)) {
  //     await launchUrl(url, mode: LaunchMode.externalApplication);
  //   } else {
  //     throw 'Could not launch WhatsApp';
  //   }
  // }

  Future<void> openWhatsApp() async {
    var phoneNo = '';
    //final message1 = "Hello, My Query is ${selectQuery.value}";

    final message = "Hello,\nMy Name: ${widget.loginData.userName}\n Query: ${selectQuery.value}\n"
               "Department: ${(isSame.value)? widget.loginData.department : selectDepartment.value}\n"
                  "City: ${widget.loginData.city}\n"
                 "Branch: ${widget.loginData.branch}\n"
                  "Mobile No: ${widget.loginData.mobile}";

                   print(message);

    if (selectEngName.value == 'Bhupendra Sir') {
      phoneNo = '919558810046';
    }else if (selectEngName.value == 'Maunik Sir') {
      phoneNo = '916357071694';
    }else if (selectEngName.value == 'Yash Sir') {
      phoneNo = '918488985930';
    }else {
      phoneNo = '918200684556';
    }

    print('${selectEngName.value}:$phoneNo');
    CommonClass().setFName(selectEngName.value ?? "");

    final Uri uri = Uri.parse(
        "whatsapp://send?phone=$phoneNo&text=${Uri.encodeComponent(message)}");

    if (await launchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print("WhatsApp not installed");
    }
  }
}
