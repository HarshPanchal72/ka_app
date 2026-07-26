import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Resources/AppText.dart';
import '../Resources/SizeConfig.dart';
import 'SideMenu.dart';
import 'common_class.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: CommonClass().commonAppBar(title: "My Profile", toolbarHeight: 50),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage("assets/images/profile.jpg"),
            ),
            const SizedBox(height: 12),

            AppText(text:"Teena Shah", fontSize: SizeConfig.getFont(14), fontWeight: FontWeight.w800, color: Colors.black),
            const SizedBox(height: 3),
            AppText(text:"Teena@gmail.com", fontSize: SizeConfig.getFont(12), fontWeight: FontWeight.w600, color: Colors.grey.shade600),
            const SizedBox(height: 25),

            profileTile(
              Icons.perm_identity_sharp,
              "Orange Id",
              "kamk1234",
            ),

            profileTile(
              Icons.phone,
              "Mobile",
              "9876543210",
            ),

            profileTile(
              Icons.business,
              "Department",
              "ERP",
            ),

            profileTile(
              Icons.work,
              "Designation",
              "Flutter Developer",
            ),

            profileTile(
              Icons.location_on,
              "City",
              "Ahmedabad",
            ),

            profileTile(
              Icons.location_on,
              "Branch",
              "Ahmedabad-Makarba",
            ),

            const SizedBox(height: 20),

            // CommonClass().commonWhiteButton(
            //   text: "Edit", width: 75, height: 35,
            //   icon: Icons.edit,
            //   onPressed: () {
            //    // if (formKey.currentState!.validate()) {
            //
            //     //}
            //   },
            // ),

          ],
        ),
      ),
    );
  }

  Widget profileTile(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple, size: 15,),
        minTileHeight: 15,
        title: AppText(text: title, fontSize: SizeConfig.getFont(10), fontWeight: FontWeight.w600, color: Colors.black,),
        subtitle: AppText(text: value, fontSize: SizeConfig.getFont(09), fontWeight: FontWeight.w500, color: Colors.black,),
      ),
    );
  }
}