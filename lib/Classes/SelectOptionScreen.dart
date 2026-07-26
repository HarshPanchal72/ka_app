import 'package:flutter/material.dart';
import 'package:ka_app/Classes/GenerateTokenScreen.dart';
import '../Resources/SizeConfig.dart';
import 'common_class.dart';

class SelectOptionScreen extends StatefulWidget {
  const SelectOptionScreen({super.key});

  @override
  State<SelectOptionScreen> createState() => _SelectOptionScreenState();
}

class _SelectOptionScreenState extends State<SelectOptionScreen> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return
      // PopScope(
      // canPop: false,
      // child:
      Scaffold(
        appBar: CommonClass().commonAppBar(title: "Select Option", toolbarHeight: 50,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,size: 18),
          onPressed: () => Navigator.pop(context),
        ),),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        CommonClass().commonWhiteButton(
                          width: SizeConfig.getWidth(92),
                          height: SizeConfig.getHeight(40),
                          fontSize: SizeConfig.getFont(09),
                          text: "Generate Token",
                          icon: Icons.person,
                          onPressed: () {
                            CommonClass.navClass(context, GenerateTokenScreen());
                          },
                         ),

                         SizedBox(height: 15),

                        CommonClass().commonWhiteButton(
                          width: SizeConfig.getWidth(92),
                          height: SizeConfig.getHeight(40),
                          fontSize: SizeConfig.getFont(09),
                          text: "Status Token",
                          icon: Icons.person,
                          onPressed: () {},
                        ),

                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
     // ),
    );
  }
}