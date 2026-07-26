import 'package:data_table_2/data_table_2.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ka_app/Classes/SideMenu.dart';
import 'package:ka_app/Resources/AppText.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Resources/SizeConfig.dart';
import 'QueryListScreen.dart';
import 'common_class.dart';

class AdminDataScreen extends StatefulWidget {
  const AdminDataScreen({super.key,});
  @override
  State<AdminDataScreen> createState() => AdminDataScreenState();
}

class AdminDataScreenState extends State<AdminDataScreen> {

  //List<bool> checkedList = List.generate(20, (_) => false);
  final ValueNotifier<List<bool>> checkedList = ValueNotifier<List<bool>>(List.generate(20, (_) => false));
  double fontHeading = 0.0;
  double fontColumn = 0.0;
  String forwardName = "";

  final ValueNotifier<String?> selectName = ValueNotifier<String?>(null);
  final ValueNotifier<List<String>> arrName = ValueNotifier<List<String>>(["Bhupendra Sir", "Maunik Sir", "Yash Sir", "Komal Ma'am", "ICT Group"]);
  final headers = [
    "Sent Date",
    "Engineer Name",
    "User Name",
    "Mobile No.",
    "Email",
    "Branch",
    "Dept.",
    "Sub Dept.",
    "Query",
    "Remarks",
    "Status",
  ];
  late final data = List.generate(20, (index) => [
    DateFormat('dd/MM/yyyy').format(DateTime.now()),
    "Bhudendra Sir",
    "Sanjay Gajjar",
    "8989989855",
    "abc@kataria.co.in",
    "Ahmedabad-Makarba",
    "Finance",
    "Audit",
    "Reports not downloading ?",
    "Please, solve ASAP",
    checkedList.value[index] ? "Completed" : "Pending",
  ]);

  final List<Query> allQueries = [
  Query(
    userId: '1',
  sentDate: "20/06/2026",
  engineerName: "Komal Shah",
  mobileNo: "9999999999",
  email: "komal@test.com",
  branch: "Surat-Varachha",
  department: "HR",
  subDepartment: "Payroll",
  query: "Salary slip not generated.",
  remarks: "Completed",
  imagePath: "assets/images/attach_photo.png",
  status: "Completed", city: 'Surat', wType: "Group"
       ),
  ];

  @override
  void initState() {
    super.initState();

    fontHeading = SizeConfig.getFont(10);
    fontColumn = SizeConfig.getFont(08);
    loadFName();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      CommonClass.showLoader(context);

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          CommonClass.hideLoader(context);
        }
      });
    });
  }

  Future<void> loadFName() async {
    forwardName = await CommonClass().getFName();
    setState(() {
      arrName.value.remove(forwardName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      // PopScope(
      // canPop: false,
      // child:
      Scaffold(
        drawer: SideMenu(),
      backgroundColor: Colors.white,
      appBar: CommonClass().commonAppBar(title: "Admin Solution", toolbarHeight: 50,
        actions: [
          Padding(padding: const EdgeInsets.only(right: 20),
            child: CommonClass().commonWhiteButton(
              text: "Export PDF", fontSize: SizeConfig.getFont(08),
              width: SizeConfig.getWidth(55),
              height: SizeConfig.getHeight(35),
              onPressed: exportPDF,
            ),),
        ],
      ),
        body: SafeArea(
          child: Material(
          child: Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
           child: DataTable2(
              columnSpacing: 20,
              //horizontalMargin: 52,
              minWidth: 1460,
              isVerticalScrollBarVisible: true,
              isHorizontalScrollBarVisible: true,
              columns: [
                DataColumn2(
                  fixedWidth: 100,
                  label: AppText(text:'Sent Date',color: Colors.green, fontWeight: FontWeight.w700, fontSize: fontHeading),),
                DataColumn2(
                  fixedWidth: 130,
                  label: AppText(text:'Engineer Name', color: Colors.green, fontWeight: FontWeight.w700, fontSize: fontHeading),),
                DataColumn2(
                  fixedWidth: 120,
                  label: AppText(text:'User Name', color: Colors.green, fontWeight: FontWeight.w700, fontSize: fontHeading),),
                DataColumn2(
                  fixedWidth: 120,
                  label: AppText(text:'Mobile No.', color: Colors.green, fontWeight: FontWeight.w700, fontSize: fontHeading),),
                DataColumn2(
                  fixedWidth: 120,
                  label: AppText(text:'Email', color: Colors.green, fontWeight: FontWeight.w700, fontSize: fontHeading),),
                DataColumn2(
                  fixedWidth: 120,
                  label: AppText(text:'Branch', color: Colors.green, fontWeight: FontWeight.w700, fontSize: fontHeading),),
                DataColumn2(
                  fixedWidth: 90,
                  label: AppText(text:'Dept.', color: Colors.green, fontWeight: FontWeight.w700, fontSize: fontHeading),),
                DataColumn2(
                  fixedWidth: 100,
                  label: AppText(text:'Sub Dept.', color: Colors.green, fontWeight: FontWeight.w700, fontSize: fontHeading),),
                DataColumn2(
                  fixedWidth: 120,
                  label: AppText(text:'Query Que.', color: Colors.green, fontWeight: FontWeight.w700, fontSize:  fontHeading),),
                DataColumn2(
                  fixedWidth: 90,
                  label: AppText(text:'View Photo', color: Colors.green, fontWeight: FontWeight.w700, fontSize: fontHeading, textAlign: TextAlign.center),),
                DataColumn2(
                  fixedWidth: 120,
                  label: AppText(text:'Remarks', color: Colors.green, fontWeight: FontWeight.w700, fontSize: fontHeading),),
                DataColumn2(
                  fixedWidth: 80,
                  label: AppText(text:'Status', color: Colors.green, fontWeight: FontWeight.w700, fontSize: fontHeading),),
                DataColumn2(
                  minWidth: 110,
                  label: AppText(text:'Forward Query', color: Colors.green, fontWeight: FontWeight.w700,
                    fontSize: fontHeading, maxLines: 2,),),
              ],
              rows: List<DataRow>.generate(20, (index) => DataRow(cells: [
                    DataCell(AppText(text: DateFormat('dd/MM/yyyy').format(DateTime.now()),fontWeight: FontWeight.w500, fontSize: fontColumn),),
                    DataCell(AppText(text: allQueries.first.engineerName, fontWeight: FontWeight.w500, fontSize: fontColumn),),
                    DataCell(AppText(text: 'Sanjay Gajjar', fontWeight: FontWeight.w500, fontSize: fontColumn),),
                    DataCell(AppText(text: allQueries.first.mobileNo, fontWeight: FontWeight.w500, fontSize: fontColumn),),
                    DataCell(AppText(text: allQueries.first.email, fontWeight: FontWeight.w500, fontSize: fontColumn),),
                    DataCell(AppText(text: allQueries.first.branch, fontWeight: FontWeight.w500, fontSize: fontColumn),),
                    DataCell(AppText(text: allQueries.first.department, fontWeight: FontWeight.w500, fontSize: fontColumn),),
                    DataCell(AppText(text: allQueries.first.subDepartment, fontWeight: FontWeight.w500, fontSize: fontColumn),),
                    DataCell(AppText(text: allQueries.first.query, fontWeight: FontWeight.w500, fontSize: fontColumn),),
                    DataCell(CommonClass().commonWhiteButton(
                        text: "View Photo", fontSize: SizeConfig.getFont(06),
                        width: SizeConfig.getWidth(48),
                        height: SizeConfig.getHeight(28),
                        onPressed: () {
                          print("${index+1} photo");
                          showPhotoDialog(
                            context,
                            allQueries.first.imagePath,
                          );
                        },
                      ),
                    ),
                    DataCell(AppText(text: 'Please, solve ASAP',fontWeight: FontWeight.w500, fontSize: fontColumn),),
                    //DataCell(AppText(text: 'Pending',fontWeight: FontWeight.w500, fontSize: 13,color: Colors.red),),
                    DataCell(
                    ValueListenableBuilder<List<bool>>(
                    valueListenable: checkedList,
                    builder: (context, checkedListt, child) {
                    return Transform.scale(
                      scale: 0.8,
                      child: Checkbox(
                            value: checkedListt[index],
                            checkColor: Colors.white,
                            onChanged: (bool? value) {
                                checkedList.value[index] = value ?? false;
                                checkedList.notifyListeners();
                            },
                          ),);},),
                        ),
                    DataCell(CommonClass().commonWhiteButton(
                    text: "Forward Query", textColor: Colors.red,
                    fontSize: SizeConfig.getFont(07),
                    width: SizeConfig.getWidth(60),
                    height: SizeConfig.getHeight(28),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: AppText(text: " Are you sure forward query ?", fontSize: SizeConfig.getFont(11), color: Colors.black, fontWeight: FontWeight.w400,),
                              content: StatefulBuilder(
                                builder: (context, setState) {
                                  return ValueListenableBuilder<List<String>>(
                                      valueListenable: arrName,
                                      builder: (context, names, child) {
                                        return ValueListenableBuilder<String?>(
                                          valueListenable: selectName,
                                          builder: (context, selectedName, child) {
                                            return CommonClass().customDropdown(
                                              context: context,
                                              width: 70,
                                              hint: (selectedName?.isNotEmpty ?? false) ? "Forward Name": "Select Name",
                                              items: names,
                                              value: selectedName,
                                              onChanged: (value) {
                                                selectName.value = value;
                                                //selectName.value = allQueries.first.wType == "Group" ? "Group" : value;
                                                print(selectedName);
                                              },
                                              // validator: (value) {
                                              //   if (value == null || value.isEmpty) {
                                              //     return "Please select Name";
                                              //   }
                                              //   return null;
                                              // },
                                            );
                                          },
                                        );
                                      },
                                    );
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                    child: AppText(text: 'Cancel', fontSize: SizeConfig.getFont(10), color: Colors.deepPurple, fontWeight: FontWeight.normal,)
                                ),
                                CommonClass().commonWhiteButton(
                                  text: "Forward", fontSize: SizeConfig.getFont(10) ,
                                  width: SizeConfig.getWidth(55),
                                  height: SizeConfig.getHeight(35),
                                  onPressed: () {
                                    Navigator.pop(context);
                                   // allQueries.first.wType != "Group" ? openWhatsApp() : shareToWhatsAppGroup();
                                   openWhatsApp();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                   ),
                 ),

                  ]))),),),),),
   // ),
      );
  }
  Future<void> exportPDF() async {
    CommonClass.showLoader(context);

    try {
      await CommonClass.exportPDF(
        title: "Admin Query List",
        fileName: "Admin_Query_List",
        headers: headers,
        data: data
      );

      CommonClass.hideLoader(context);

      CommonClass.showSnackBar(
        context,
        message: "PDF exported successfully.",
        textColor: Colors.deepPurple,
      );
    } catch (e) {
      CommonClass.hideLoader(context);

      CommonClass.showSnackBar(
        context,
        message: e.toString(),
      );
    }
  }

  Future<void> openWhatsApp() async {
    var phoneNo = '';
    //final message1 = "Hello, My Query is ${selectQuery.value}";

    final message = "Hello,\nMy Name: Sanjay Gajjar\nQuery: ${allQueries.first.query}\n"
        "Department: ${allQueries.first.department}\n"
        "City: ${allQueries.first.city}\n"
        "Branch: ${allQueries.first.branch}\n"
        "Mobile No: ${allQueries.first.mobileNo}";

    print(message);

    if (selectName.value == 'Bhupendra Sir') {
      phoneNo = '919558810046';
    }else if (selectName.value == 'Maunik Sir') {
      phoneNo = '916357071694';
    }else if (selectName.value == 'Yash Sir') {
      phoneNo = '918488985930';
    }else if (selectName.value == "Komal Ma'am") {
      phoneNo = '918200684556';
    }else {
      phoneNo = '';
    }

    print('${selectName.value}:$phoneNo');
    CommonClass().setFName(selectName.value ?? "");

    final Uri uri = Uri.parse(
        "whatsapp://send?phone=$phoneNo&text=${Uri.encodeComponent(message)}");

    if (await launchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print("WhatsApp not installed");
    }
  }

  Future<void> shareToWhatsAppGroup() async {

    final message = "Hello,\nMy Name: Sanjay Gajjar\nQuery: ${allQueries.first.query}\n"
        "Department: ${allQueries.first.department}\n"
        "City: ${allQueries.first.city}\n"
        "Branch: ${allQueries.first.branch}\n"
        "Mobile No: ${allQueries.first.mobileNo}";

    final Uri uri = Uri.parse(
      "https://wa.me/?text=${Uri.encodeComponent(message)}",
    );

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }
}

void showPhotoDialog(BuildContext context, String imagePath) {
  //double screenWidth = MediaQuery.of(context).size.width;
  showDialog(
    context: context,
     builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.symmetric(horizontal: 40),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ExtendedImage.asset(
                imagePath,
                mode: ExtendedImageMode.gesture,
                fit: BoxFit.contain,
                initGestureConfigHandler: (state) => GestureConfig(
                  minScale: 1.0,
                  maxScale: 5.0,
                  animationMinScale: 0.8,
                  animationMaxScale: 6.0,
                  speed: 1.0,
                  inertialSpeed: 100.0,
                  initialScale: 1.0,
                  inPageView: false,
                  initialAlignment: InitialAlignment.center,
                ),
              )
              //Image.asset(imagePath, fit: BoxFit.cover),
            ),

            Positioned(
              top: -15,
              right: -15,
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 18,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}