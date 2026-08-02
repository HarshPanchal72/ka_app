import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../API Manager/APIConstants.dart';
import '../Resources/AppText.dart';
import '../Resources/SizeConfig.dart';
import 'SideMenu.dart';
import 'common_class.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  Map<String, String> userData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    userData = await CommonClass().getUserData();
    setState(() {
      isLoading = false;
    });
  }

  ImageProvider getProfileImage(String? pictureUrl) {
    if (pictureUrl != null && pictureUrl.isNotEmpty) {
      String fullUrl = pictureUrl.startsWith("http")
          ? pictureUrl
          : "${ApiConstants.serverUrl}$pictureUrl";
      return NetworkImage(fullUrl);
    }
    return const AssetImage("assets/images/profile.jpg");
  }

  @override
  Widget build(BuildContext context) {
    String username = userData["username"] ?? "";
    String email = userData["email"] ?? "";
    String mobile = userData["mobile"] ?? "";
    String department = userData["department"] ?? "";
    String designation = userData["designation"] ?? "";
    String city = userData["city"] ?? "";
    String branch = userData["branch"] ?? "";
    String company = userData["company"] ?? "";
    String profilePicture = userData["profile_picture"] ?? "";

    return Scaffold(
      drawer: const SideMenu(),
      appBar: CommonClass().commonAppBar(title: "My Profile", toolbarHeight: 50),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: getProfileImage(profilePicture),
                  ),
                  const SizedBox(height: 12),

                  AppText(
                    text: username.isNotEmpty ? username : "User Profile",
                    fontSize: SizeConfig.getFont(14),
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 3),
                  AppText(
                    text: email.isNotEmpty ? email : "No email provided",
                    fontSize: SizeConfig.getFont(12),
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 25),

                  profileTile(
                    Icons.badge,
                    "Badge ID",
                    username.isNotEmpty ? username : "N/A",
                  ),

                  profileTile(
                    Icons.phone,
                    "Mobile",
                    mobile.isNotEmpty ? mobile : "N/A",
                  ),

                  profileTile(
                    Icons.business,
                    "Department",
                    department.isNotEmpty ? department : "N/A",
                  ),

                  profileTile(
                    Icons.work,
                    "Designation",
                    designation.isNotEmpty ? designation : "N/A",
                  ),

                  profileTile(
                    Icons.location_on,
                    "City",
                    city.isNotEmpty ? city : "N/A",
                  ),

                  profileTile(
                    Icons.store,
                    "Branch",
                    branch.isNotEmpty ? branch : "N/A",
                  ),

                  if (company.isNotEmpty)
                    profileTile(
                      Icons.domain,
                      "Company",
                      company,
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget profileTile(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple, size: 18),
        minTileHeight: 15,
        title: AppText(
          text: title,
          fontSize: SizeConfig.getFont(10),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        subtitle: AppText(
          text: value,
          fontSize: SizeConfig.getFont(09),
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}