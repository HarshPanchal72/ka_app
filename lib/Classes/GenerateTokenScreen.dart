import 'package:flutter/material.dart';
import 'package:ka_app/Classes/SideMenu.dart';
import 'package:ka_app/Models/LoginPassModel.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../API Manager/APIConstants.dart';
import '../API Manager/APIService.dart';
import '../Resources/AppColors.dart';
import '../Resources/AppText.dart';
import '../Resources/SizeConfig.dart';
import 'DetailsScreen.dart';
import 'common_class.dart';

class GenerateTokenScreen extends StatefulWidget {
  const GenerateTokenScreen({super.key, });
  @override
  State<GenerateTokenScreen> createState() => GenerateTokenScreenState();
}

class GenerateTokenScreenState extends State<GenerateTokenScreen> {

  final TextEditingController remarksController = TextEditingController();
  bool isScan = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    double screenWidth = MediaQuery.of(context).size.width;
    return
      Scaffold(
        drawer: SideMenu(),
        appBar: CommonClass().commonAppBar(title: "Generate Token", toolbarHeight: 50,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20,top: 5),
            child: Column(
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 20),
                    width: 200,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: MobileScanner(
                      onDetect: (capture) {
                      //if (isScanned) return;
                      final barcode = capture.barcodes.first;

                      if (barcode.rawValue != null) {
                        isScan = true;
                        String token = barcode.rawValue!;
                        print("Scanned Token: $token");

                      }
                    },
                  ),),),),

                  SizedBox(height: 20),

                  (isScan) ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: SizeConfig.getFont(10),
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "Customer Name : ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "JAGUBHAI NARUBHAI GOHIL-BNCKA101755",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),

                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: SizeConfig.getFont(10),
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "Estimate No. : ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "ASEBNC26 192",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),

                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: SizeConfig.getFont(10),
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "Chasis No. : ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "MA3EDC03TTE400883",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),

                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: SizeConfig.getFont(10),
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "Vehicle : ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "MARUTI SUPER CARRY STD CNG 1.2L 5MT-CARCGS200",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),

                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: SizeConfig.getFont(10),
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "Sales Exe. : ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "PRASHANT DEVJIBHAI BADHIYA",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),

                      CommonClass().customTextField("Remarks", remarksController, width: screenWidth, maxLines: 2,  remarks: true, readOnly: false,
                          validator: (value) {
                            print(remarksController);
                          }, context: context
                      ),

                      SizedBox(height: 30),

                      CommonClass().commonButton(
                          text: "Save",
                          width: screenWidth,
                          onPressed: () {
                            CommonClass.showLoader(context);
                            CommonClass.showSnackBar(context, message: "Edit Profile Successfully", textColor: Colors.deepPurple);
                            Future.delayed(const Duration(seconds: 2), () {
                              CommonClass.hideLoader(context);
                              Navigator.pop(context);
                            });
                          }
                      ),

                    ]
                  ) : SizedBox.shrink(),

                ],
              ),
          ),
          ),
        ),
      );
  }
}
