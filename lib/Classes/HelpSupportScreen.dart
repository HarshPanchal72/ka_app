import 'package:flutter/material.dart';
import 'package:ka_app/Resources/AppText.dart';

import 'SideMenu.dart';
import 'common_class.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  Widget buildTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.blue,
  }) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 14,
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 13),
        ),
        title: AppText(text: title, fontWeight: FontWeight.w500, color: Colors.black),
        trailing: const Icon(Icons.arrow_forward_ios, size: 12),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: CommonClass().commonAppBar(title: "Help / Support", toolbarHeight: 50,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const AppText(text:
              "We're here to help!",
                fontSize: 15,
                fontWeight: FontWeight.w700,
            ),

            const SizedBox(height: 5),

            const AppText(text:
              "If you're facing any issues, feel free to contact us.", fontSize: 13,
               textAlign: TextAlign.center, fontWeight: FontWeight.w500,
            ),

            const SizedBox(height: 20),

            buildTile(
              icon: Icons.email,
              title: "Email Support",
              onTap: () {},
            ),

            buildTile(
              icon: Icons.phone,
              title: "Call Support",
              onTap: () {},
            ),

            // buildTile(
            //   icon: Icons.bug_report,
            //   title: "Report a Bug",
            //   onTap: () {},
            //   color: Colors.red,
            // ),
            //

            buildTile(
              icon: Icons.privacy_tip,
              title: "Privacy Policy",
              onTap: () {},
              color: Colors.green,
            ),

            buildTile(
              icon: Icons.description,
              title: "Terms & Conditions",
              onTap: () {},
              color: Colors.orange,
            ),

            const Spacer(),

            const AppText(text: "App Version 1.0.0", color: Colors.grey),
            const SizedBox(height: 10),

          ],
        ),
      ),
    );
  }

}