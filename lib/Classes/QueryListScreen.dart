import 'package:data_table_2/data_table_2.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ka_app/Classes/SideMenu.dart';
import 'package:ka_app/Resources/AppText.dart';
import '../API Manager/APIConstants.dart';
import '../API Manager/APIService.dart';
import '../Resources/SizeConfig.dart';
import 'common_class.dart';

class Query {
  final String userId;
  final String sentDate;
  final String engineerName;
  final String mobileNo;
  final String email;
  final String branch;
  final String department;
  final String subDepartment;
  final String city;
  final String query;
  final String remarks;
  final String status;
  final String imagePath;
  final String wType;
  bool isCompleted;

  Query({
    required this.userId,
    required this.sentDate,
    required this.engineerName,
    required this.mobileNo,
    required this.email,
    required this.branch,
    required this.department,
    required this.subDepartment,
    required this.query,
    required this.remarks,
    required this.imagePath,
    this.isCompleted = false, required this.status, required this.city,  this.wType = "",
  });
}

class QueryListScreen extends StatefulWidget {
  final String userId;
  const QueryListScreen({super.key, required this.userId,});
  @override
  State<QueryListScreen> createState() => QueryListScreenState();
}

class QueryListScreenState extends State<QueryListScreen> {
  List<Query> userQueries = [];
  double fontHeading = 0.0;
  double fontColumn = 0.0;

  final ValueNotifier<List<bool>> checkedList = ValueNotifier<List<bool>>(List.generate(20, (_) => false));

  final List<Query> allQueries = [
    Query(
      userId: "1",
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
      status: "Completed", city: 'Surat'
    ),

    Query(
      userId: "1",
      sentDate: "25/06/2026",
      engineerName: "Komal Shah",
      mobileNo: "9999999999",
      email: "komal@test.com",
      branch: "Surat-Varachha",
      department: "HR",
      subDepartment: "Recruitment",
      query: "Candidate profile missing.",
      remarks: "Pending",
      imagePath: "assets/images/attach_photo.png",
      status: "Pending", city: 'Surat'
    ),

    Query(
        userId: "1",
        sentDate: "02/07/2026",
        engineerName: "Komal Shah",
        mobileNo: "9999999999",
        email: "komal@test.com",
        branch: "Surat-Varachha",
        department: "HR",
        subDepartment: "Recruitment",
        query: "Wings id not login",
        remarks: "On Running",
        imagePath: "assets/images/attach_photo.png",
        status: "On Running", city: 'Surat'
    ),

    Query(
        userId: "2",
        sentDate: "14/06/2026",
        engineerName: "Rahul Patel",
        mobileNo: "9876543210",
        email: "rahul@test.com",
        branch: "Ahmedabad-Makarba",
        department: "Finance",
        subDepartment: "Audit",
        query: "Reports are not downloading.",
        remarks: "Pending",
        imagePath: "assets/images/attach_photo.png",
        status: "Pending", city: 'Ahmedabad'
    ),
  ];

  @override
  void initState() {
    super.initState();

    fontHeading = SizeConfig.getFont(10);
    fontColumn = SizeConfig.getFont(08);

    userQueries = allQueries.where((e) => e.userId == widget.userId).toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      CommonClass.showLoader(context);
      fetchQueries();
    });
  }

  Future<void> fetchQueries() async {
    try {
      final api = ApiService();
      var response = await api.getApi(endpoint: ApiConstants.queries);
      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> list = response.data;
        List<Query> fetched = list.map((json) {
          return Query(
            userId: json["user_id"]?.toString() ?? "1",
            sentDate: json["sent_date"]?.toString() ?? "",
            engineerName: json["engineer_name"]?.toString() ?? "",
            mobileNo: json["mobile_no"]?.toString() ?? "",
            email: json["email"]?.toString() ?? "",
            branch: json["branch"]?.toString() ?? "",
            department: json["department"]?.toString() ?? "",
            subDepartment: json["sub_department"]?.toString() ?? "",
            query: json["query_text"]?.toString() ?? "",
            remarks: json["remarks"]?.toString() ?? "",
            imagePath: json["image_path"]?.toString() ?? "assets/images/attach_photo.png",
            status: json["status"]?.toString() ?? "Pending",
            city: json["city"]?.toString() ?? "",
            wType: json["w_type"]?.toString() ?? "",
          );
        }).toList();

        if (fetched.isNotEmpty) {
          setState(() {
            userQueries = fetched;
            checkedList.value = List.generate(userQueries.length, (i) => userQueries[i].status == "Completed");
          });
        }
      }
    } catch (e) {
      print("Error fetching queries: $e");
    } finally {
      if (mounted) {
        CommonClass.hideLoader(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      // PopScope(
      // canPop: false,
      // child:
      Scaffold(
        drawer: SideMenu(),
        appBar: CommonClass().commonAppBar(title: "New Query", toolbarHeight: 50,
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
        // AppBar(
        //   backgroundColor: Colors.transparent,
        //   automaticallyImplyLeading: false,
        //   toolbarHeight: 40,
        //   centerTitle: true,
        //   leading: Builder(
        //     builder: (context) => IconButton(
        //       icon: const Icon(Icons.menu),
        //       onPressed: () => Scaffold.of(context).openDrawer(),
        //     ),
        //   ),
        //   actions: [
        //     Padding(padding: const EdgeInsets.only(right: 20),
        //     child: CommonClass().commonWhiteButton(
        //       text: "Export PDF", width: 80, height: 30, fontSize: 11,
        //       onPressed: exportPDF,
        //     ),),
        //   ],
        //   // leading: IconButton(
        //   //   icon: Icon(Icons.arrow_back_ios,size: 18,),
        //   //   onPressed: () { Navigator.pop(context);},
        //   // ),
        //   title: AppText(text: "My Query List", fontSize: SizeConfig.getFont(10), fontWeight: FontWeight.bold, color: Colors.deepPurple,
        //   ),),
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
                    minWidth: 1220,
                    isVerticalScrollBarVisible: true,
                    isHorizontalScrollBarVisible: true,
                    columns: [
                      DataColumn2(
                        fixedWidth: 100,
                        label: AppText(text:'Sent Date',color: Colors.green, fontWeight: FontWeight.w700, fontSize: fontHeading),),
                      DataColumn2(
                        fixedWidth: 115,
                        label: AppText(text:'Engineer Name', color: Colors.green, fontWeight: FontWeight.w700, fontSize: fontHeading),),
                      DataColumn2(
                        fixedWidth: 100,
                        label: AppText(text:'Mobile No.', color: Colors.green, fontWeight: FontWeight.w700, fontSize: fontHeading),),
                      DataColumn2(
                        fixedWidth: 100,
                        label: AppText(text:'Email', color: Colors.green, fontWeight: FontWeight.w700, fontSize: fontHeading),),
                      DataColumn2(
                        fixedWidth: 60,
                        label: AppText(text:'Branch', color: Colors.green, fontWeight: FontWeight.w700, fontSize: fontHeading),),
                      DataColumn2(
                        fixedWidth: 50,
                        label: AppText(text:'Dept.', color: Colors.green, fontWeight: FontWeight.w700, fontSize: fontHeading),),
                      DataColumn2(
                        fixedWidth: 100,
                        label: AppText(text:'Sub Dept.', color: Colors.green, fontWeight: FontWeight.w700, fontSize: fontHeading),),
                      DataColumn2(
                        fixedWidth: 100,
                        label: AppText(text:'Query Que.', color: Colors.green, fontWeight: FontWeight.w700, fontSize: fontHeading),),
                      DataColumn2(
                        fixedWidth: 90,
                        label: AppText(text:'View Photo', color: Colors.green, fontWeight: FontWeight.w700, fontSize: fontHeading),),
                      DataColumn2(
                        fixedWidth: 80,
                        label: AppText(text:'Remarks', color: Colors.green, fontWeight: FontWeight.w700, fontSize: fontHeading),),
                      DataColumn2(
                        fixedWidth: 30,
                        label: AppText(text:'Status', color: Colors.green, fontWeight: FontWeight.w700, fontSize: fontHeading),),
                    ],
                  rows: userQueries.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return DataRow(
                      cells: [
                        DataCell(AppText(text: item.sentDate,fontWeight: FontWeight.w500, fontSize: fontColumn),),
                        DataCell(AppText(text: item.engineerName, fontWeight: FontWeight.w500, fontSize: fontColumn),),
                        DataCell(AppText(text: item.mobileNo, fontWeight: FontWeight.w500, fontSize: fontColumn),),
                        DataCell(AppText(text: item.email, fontWeight: FontWeight.w500, fontSize: fontColumn),),
                        DataCell(AppText(text: item.branch, fontWeight: FontWeight.w500, fontSize: fontColumn),),
                        DataCell(AppText(text: item.department, fontWeight: FontWeight.w500, fontSize: fontColumn),),
                        DataCell(AppText(text: item.subDepartment, fontWeight: FontWeight.w500, fontSize: fontColumn),),
                        DataCell(AppText(text: item.query, fontWeight: FontWeight.w500, fontSize: fontColumn),),

                        DataCell(
                          CommonClass().commonWhiteButton(
                            text: "View Photo", fontSize: SizeConfig.getFont(06),
                            width: SizeConfig.getWidth(48),
                            height: SizeConfig.getHeight(28),
                            onPressed: () {
                              showPhotoDialog(
                                context,
                                item.imagePath,
                              );
                            },
                          ),),
                        DataCell(AppText(text: item.remarks, fontWeight: FontWeight.w500, fontSize: fontColumn),),

                        DataCell(
                          ValueListenableBuilder<List<bool>>(
                            valueListenable: checkedList,
                            builder: (context, checkedListt, child) {
                              return Transform.scale(
                                scale: 0.8,
                                child: Checkbox(
                                  value: item.status == "Completed" ? true : false,
                                checkColor: Colors.white,
                                onChanged: (bool? value) {
                                  checkedList.value[index] = value!;
                                  checkedList.notifyListeners();
                                },
                              ),);},),
                        ),
                      ],
                    );
                  }).toList(),
                    )),),),),
        // ),
      );
  }


  // Future<void> exportCSV() async {
  //   CommonClass.showLoader(context);
  //
  //   try {
  //     StringBuffer csv = StringBuffer();
  //
  //     csv.writeln(
  //         "Sent Date,Engineer Name,Mobile No,Email,Branch,Department,Sub Department,Query,Remarks,Status");
  //
  //     for (var item in userQueries) {
  //       csv.writeln(
  //         '"${item.sentDate}",'
  //             '"${item.engineerName}",'
  //             '"${item.mobileNo}",'
  //             '"${item.email}",'
  //             '"${item.branch}",'
  //             '"${item.department}",'
  //             '"${item.subDepartment}",'
  //             '"${item.query}",'
  //             '"${item.remarks}",'
  //             '"${item.status}"',
  //       );
  //     }
  //
  //     Directory directory;
  //
  //     if (Platform.isAndroid) {
  //       directory = Directory('/storage/emulated/0/Download');
  //     } else if (Platform.isWindows) {
  //       directory = Directory(r'C:\Users\Public\Downloads');
  //     } else {
  //       throw Exception("Unsupported Platform");
  //     }
  //
  //     if (!directory.existsSync()) {
  //       directory.createSync(recursive: true);
  //     }
  //
  //     final filePath = '${directory.path}/Query_List.csv';
  //
  //     File file = File(filePath);
  //
  //     await file.writeAsString(csv.toString());
  //
  //     CommonClass.hideLoader(context);
  //
  //     final result = await OpenFilex.open(filePath);
  //
  //     if (result.type == ResultType.done) {
  //       CommonClass.showSnackBar(
  //         context, textColor: Colors.deepPurple,
  //         message: "File exported successfully.",
  //       );
  //     } else {
  //       CommonClass.showSnackBar(
  //         context, textColor: Colors.deepPurple,
  //         message: "File saved at:\n$filePath",
  //       );
  //     }
  //   } catch (e) {
  //     CommonClass.hideLoader(context);
  //
  //     CommonClass.showSnackBar(
  //       context,
  //       message: e.toString(),
  //     );
  //   }
  // }

  // Future<void> exportCSV1() async {
  //   CommonClass.showLoader(context);
  //
  //   try {
  //     StringBuffer csv = StringBuffer();
  //
  //     csv.writeln(
  //         "Sent Date,Engineer Name,Mobile No,Email,Branch,Department,Sub Department,Query,Remarks,Status");
  //
  //     for (var item in userQueries) {
  //       csv.writeln(
  //         '"${item.sentDate}",'
  //             '"${item.engineerName}",'
  //             '"${item.mobileNo}",'
  //             '"${item.email}",'
  //             '"${item.branch}",'
  //             '"${item.department}",'
  //             '"${item.subDepartment}",'
  //             '"${item.query}",'
  //             '"${item.remarks}",'
  //             '"${item.status}"',
  //       );
  //     }
  //
  //     Directory directory = Directory(r'C:\Users\Public\Downloads');
  //
  //     if (!directory.existsSync()) {
  //       directory.createSync(recursive: true);
  //     }
  //
  //     final path = '${directory.path}\\Query_List.csv';
  //
  //     final file = File(path);
  //
  //     await file.writeAsString(csv.toString());
  //
  //     CommonClass.hideLoader(context);
  //
  //     final result = await OpenFilex.open(path);
  //
  //     CommonClass.showSnackBar(
  //       context,
  //       message: result.message,
  //     );
  //   } catch (e) {
  //     CommonClass.hideLoader(context);
  //
  //     CommonClass.showSnackBar(
  //       context,
  //       message: e.toString(),
  //     );
  //   }
  // }

  // Future<void> exportPDF1() async {
  //   CommonClass.showLoader(context);
  //
  //   try {
  //     final pdf = pw.Document();
  //
  //     pdf.addPage(
  //       pw.MultiPage(
  //         pageFormat: PdfPageFormat.a4.landscape,
  //         build: (context) => [
  //           pw.Text(
  //             "My Query List",
  //             style: pw.TextStyle(
  //               fontSize: 20,
  //               fontWeight: pw.FontWeight.bold,
  //             ),
  //           ),
  //           pw.SizedBox(height: 15),
  //
  //           pw.Table.fromTextArray(
  //             border: pw.TableBorder.all(),
  //             headerStyle: pw.TextStyle(
  //               fontWeight: pw.FontWeight.bold,
  //               fontSize: 10,
  //             ),
  //             cellStyle: const pw.TextStyle(fontSize: 9),
  //             cellAlignment: pw.Alignment.centerLeft,
  //             headers: const [
  //               "Sent Date",
  //               "Engineer",
  //               "Mobile",
  //               "Email",
  //               "Branch",
  //               "Department",
  //               "Sub Dept",
  //               "Query",
  //               "Remarks",
  //               "Status",
  //             ],
  //             data: userQueries.map((item) {
  //               return [
  //                 item.sentDate,
  //                 item.engineerName,
  //                 item.mobileNo,
  //                 item.email,
  //                 item.branch,
  //                 item.department,
  //                 item.subDepartment,
  //                 item.query,
  //                 item.remarks,
  //                 item.status,
  //               ];
  //             }).toList(),
  //           ),
  //         ],
  //       ),
  //     );
  //
  //     final directory = await getExternalStorageDirectory();
  //
  //     if (directory == null) {
  //       throw Exception("Storage directory not found");
  //     }
  //
  //     final downloadDir = Directory("${directory.path}/Download");
  //
  //     if (!downloadDir.existsSync()) {
  //       downloadDir.createSync(recursive: true);
  //     }
  //
  //     final file = File("${downloadDir.path}/Query_List.pdf");
  //
  //     await file.writeAsBytes(await pdf.save());
  //
  //     print("Saved at: ${file.path}");
  //     print("Exists: ${await file.exists()}");
  //
  //     CommonClass.hideLoader(context);
  //     CommonClass.showSnackBar(context, message: "PDF exported successfully.", textColor: Colors.deepPurple);
  //     await OpenFilex.open(file.path);
  //
  //   } catch (e) {
  //     CommonClass.hideLoader(context);
  //
  //     CommonClass.showSnackBar(
  //       context,
  //       message: e.toString(),
  //     );
  //   }
  // }

  Future<void> exportPDF() async {
    CommonClass.showLoader(context);

    try {
      await CommonClass.exportPDF(
        title: "My Query List",
        fileName: "Query_List",
        headers: [
          "Sent Date",
          "Engineer",
          "Mobile",
          "Email",
          "Branch",
          "Department",
          "Sub Dept",
          "Query",
          "Remarks",
          "Status",
        ],
        data: userQueries.map((item) => [
          item.sentDate,
          item.engineerName,
          item.mobileNo,
          item.email,
          item.branch,
          item.department,
          item.subDepartment,
          item.query,
          item.remarks,
          item.status,
        ]).toList(),
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


}

void showPhotoDialog(BuildContext context, String imagePath) {
  //double screenWidth = MediaQuery.of(context).size.width;

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: (imagePath.startsWith("http") || imagePath.startsWith("/static/"))
                  ? ExtendedImage.network(
                      imagePath.startsWith("/static/")
                          ? "${ApiConstants.serverUrl}$imagePath"
                          : imagePath,
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
                  : ExtendedImage.asset(
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
                    ),
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