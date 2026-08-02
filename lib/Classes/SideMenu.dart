import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ka_app/Classes/AdminDataScreen.dart';
import 'package:ka_app/Classes/ChangePswdScreen.dart';
import 'package:ka_app/Classes/EditProfileScreen.dart';
import 'package:ka_app/Classes/HelpSupportScreen.dart';
import 'package:ka_app/Classes/MyProfileScreen.dart';
import 'package:ka_app/Classes/NewQueryScreen.dart';
import 'package:ka_app/Classes/QueryListScreen.dart';
import 'package:ka_app/Classes/WelcomeScreen.dart';
import '../API Manager/APIConstants.dart';
import '../Resources/AppText.dart';
import '../Resources/SizeConfig.dart';
import 'common_class.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String heading = "";
  String user = "";
  String screen = "";
  String profilePicture = "";

  @override
  void initState() {
    super.initState();
    loadHeading();
    loadUser();
    loadScreen();
  }

  Future<void> loadHeading() async {
    heading = await CommonClass().getHeading();
    setState(() {});
  }
  Future<void> loadUser() async {
    Map<String, String> data = await CommonClass().getUserData();
    user = data["username"] ?? "";
    profilePicture = data["profile_picture"] ?? "";
    setState(() {});
  }

  Future<void> loadScreen() async {
    screen = await CommonClass().getScreen();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.55,
      child: (screen == "users") ?
      Column(
        children: [

          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple,
                  Colors.indigo,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white24,
                    backgroundImage: (profilePicture.isNotEmpty)
                        ? NetworkImage(profilePicture.startsWith("http")
                            ? profilePicture
                            : "${ApiConstants.serverUrl}$profilePicture")
                        : const AssetImage("assets/images/profile.jpg") as ImageProvider,
                  ),
                   SizedBox(height: 10),
                   AppText(
                    text: heading,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.getFont(13),
                    color: Colors.white,
                    textAlign: TextAlign.center,
                  ),
                   SizedBox(height: 4),
                   AppText(
                    text: user,
                    fontWeight: FontWeight.w500,
                    fontSize: SizeConfig.getFont(13),
                    color: Colors.white,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          _drawerItem(
            context,
            icon: Icons.person,
            title: "My Profile",
            onTap: () {
              Navigator.pop(context);
              CommonClass.navClass(context, MyProfileScreen());
            },
          ),

          _drawerItem(
            context,
            icon: Icons.person,
            title: "New Query",
            onTap: () {
              Navigator.pop(context);
              CommonClass.navClass(context, NewQueryScreen(userId: "1"));
            },
          ),

          _drawerItem(
            context,
            icon: Icons.person,
            title: "Edit Profile",
            onTap: () {
              Navigator.pop(context);
              CommonClass.navClass(context, EditProfileScreen());
            },
          ),
          
          _drawerItem(
            context,
            icon: Icons.person,
            title: "History",
            onTap: () {
              Navigator.pop(context);
              CommonClass.navClass(context, QueryListScreen(userId: "1"));
            },
          ),

          _drawerItem(
            context,
            icon: Icons.settings,
            title: "Change Password",
            onTap: () {
              Navigator.pop(context);
              CommonClass.navClass(context, ChangePswdScreen());
            },
          ),

          _drawerItem(
            context,
            icon: Icons.settings,
            title: "Help/Support",
            onTap: () {
              Navigator.pop(context);
              CommonClass.navClass(context, HelpSupportScreen());
            },
          ),

          const Spacer(),

          const Divider(),

          _drawerItem(
            context,
            icon: Icons.logout,
            title: "Logout",
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: () {
              Navigator.pop(context);
              showLogoutDialog(context);
            },
          ),

          const SizedBox(height: 8),
        ],
      ):
      Column(
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple,
                  Colors.indigo,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage("assets/images/profile.jpg"),
                  ),
                  const SizedBox(height: 10),
                  AppText(
                    text: heading,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.getFont(13),
                    color: Colors.white,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    text: user,
                    fontWeight: FontWeight.w500,
                    fontSize: SizeConfig.getFont(13),
                    color: Colors.white,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          _drawerItem(
            context,
            icon: Icons.person,
            title: "My Profile",
            onTap: () {
              Navigator.pop(context);
              CommonClass.navClass(context, MyProfileScreen());
            },
          ),

          _drawerItem(
            context,
            icon: Icons.person,
            title: "New Query",
            onTap: () {
              Navigator.pop(context);
              CommonClass.navClass(context, NewQueryScreen(userId: "1"));
            },
          ),

          _drawerItem(
            context,
            icon: Icons.person,
            title: "Admin Query Lost",
            onTap: () {
              Navigator.pop(context);
              CommonClass.navClass(context, AdminDataScreen());
            },
          ),

          _drawerItem(
            context,
            icon: Icons.person,
            title: "Edit Profile",
            onTap: () {
              Navigator.pop(context);
              CommonClass.navClass(context, EditProfileScreen());
            },
          ),

          _drawerItem(
            context,
            icon: Icons.person,
            title: "History",
            onTap: () {
              Navigator.pop(context);
              CommonClass.navClass(context, QueryListScreen(userId: "1"));
            },
          ),

          _drawerItem(
            context,
            icon: Icons.settings,
            title: "Change Password",
            onTap: () {
              Navigator.pop(context);
              CommonClass.navClass(context, ChangePswdScreen());
            },
          ),

          _drawerItem(
            context,
            icon: Icons.settings,
            title: "Help/Support",
            onTap: () {
              Navigator.pop(context);
              CommonClass.navClass(context, HelpSupportScreen());
            },
          ),

          const Spacer(),

          const Divider(),

          SafeArea(
            top: false,
            child: Padding(padding: EdgeInsets.only(bottom: 20),
            child: _drawerItem(
            context,
            icon: Icons.logout,
            title: "Logout",
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: () {
              Navigator.pop(context);
              showLogoutDialog(context);
            },
          ),),),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
        Color iconColor = Colors.blue,
        Color textColor = Colors.black87,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: ListTile(
        minTileHeight: 20,
        leading: Icon(icon, color: iconColor,size: 20),
        title: AppText(text: title, color: textColor, fontWeight: FontWeight.w600,
            fontSize: SizeConfig.getFont(10)),
        trailing: Icon(Icons.arrow_forward_ios, size: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hoverColor: Colors.blue.shade50,
        //tileColor: Colors.grey.shade100,
        onTap: onTap,
      ),
    );
  }

  Future<void> showLogoutDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: Row(
            children: [
              const Icon(Icons.logout, color: Colors.red,size: 20,),
              const SizedBox(width: 8),
              AppText(text: "Logout", fontSize: SizeConfig.getFont(12), color: Colors.black, fontWeight: FontWeight.w600,),
            ],
          ),
          content: AppText(text: "Are you sure you want to logout?", fontSize: SizeConfig.getFont(11), color: Colors.black, fontWeight: FontWeight.w400,),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: AppText(text: 'Cancel', fontSize: SizeConfig.getFont(10), color: Colors.deepPurple, fontWeight: FontWeight.normal,)
            ),
            CommonClass().commonWhiteButton(
              text: "Logout", fontSize: SizeConfig.getFont(10) ,
              width: SizeConfig.getWidth(55),
              height: SizeConfig.getHeight(35),
              onPressed: () {
                Navigator.pop(context);
                CommonClass.navClass(context, WelcomeScreen());
              },
            ),
          ],
        );
      },
    );
  }
}