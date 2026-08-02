import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ka_app/Resources/AppColors.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';
import '../Resources/AppText.dart';
import '../Resources/SizeConfig.dart';

class CommonClass {

  static String rb = 'Roboto';
  static double hDist = 10.0;

  static Future<bool> saveLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    bool result = await prefs.setBool("isLogin", value);
    return result;
  }

  static void navClass(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  Future<String> getHeading() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("heading") ?? "";
  }

  Future<void> setHeading(String heading, {String email = ''}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("heading", heading);
  }

  Future<String> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("user") ?? "";
  }

  Future<void> setUser(String user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user", user);
  }

  Future<void> setUserData(Map<String, dynamic> userMap) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user", userMap["username"] ?? "");
    await prefs.setString("user_badge_id", userMap["badge_id"] ?? userMap["company"] ?? userMap["username"] ?? "");
    await prefs.setString("user_email", userMap["email"] ?? "");
    await prefs.setString("user_mobile", userMap["mobile"] ?? "");
    await prefs.setString("user_company", userMap["company"] ?? "");
    await prefs.setString("user_branch", userMap["branch"] ?? "");
    await prefs.setString("user_city", userMap["city"] ?? "");
    await prefs.setString("user_department", userMap["department"] ?? "");
    await prefs.setString("user_designation", userMap["designation"] ?? "");
    await prefs.setString("user_reporting_manager", userMap["reporting_manager"] ?? "");
    await prefs.setString("user_profile_picture", userMap["profile_picture"] ?? "");
    await prefs.setString("user_role", userMap["role"] ?? "");
  }

  Future<Map<String, String>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "username": prefs.getString("user") ?? "",
      "badge_id": prefs.getString("user_badge_id") ?? "",
      "email": prefs.getString("user_email") ?? "",
      "mobile": prefs.getString("user_mobile") ?? "",
      "company": prefs.getString("user_company") ?? "",
      "branch": prefs.getString("user_branch") ?? "",
      "city": prefs.getString("user_city") ?? "",
      "department": prefs.getString("user_department") ?? "",
      "designation": prefs.getString("user_designation") ?? "",
      "reporting_manager": prefs.getString("user_reporting_manager") ?? "",
      "profile_picture": prefs.getString("user_profile_picture") ?? "",
      "role": prefs.getString("user_role") ?? "",
    };
  }

  Future<String> getScreen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("screen") ?? "";
  }

  Future<void> setScreen(String screen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("screen", screen);
  }

  Future<String> getFName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("fName") ?? "";
  }

  Future<void> setFName(String fName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("fName", fName);
  }

  PreferredSizeWidget commonAppBar({
    required String title,
    List<Widget>? actions,
    Widget? leading,
    bool centerTitle = true,
    double toolbarHeight = 30,
  }) {
    return AppBar(
      toolbarHeight: toolbarHeight,
      title: AppText(text:
        title,
          fontSize: SizeConfig.getFont(14),
          fontWeight: FontWeight.w800,
          color: Colors.deepPurple,
      ),
      centerTitle: centerTitle,
      backgroundColor: Colors.transparent,
      elevation: 2,
      leading: leading,
      actions: actions,
    );
  }

  Widget customTextField( String label, TextEditingController controller, { required BuildContext context,  bool isMandatory = false,
    double width = 0, int maxLines = 1, required String? Function(String?) validator, bool isMobile = false,
    bool readOnly = false, bool remarks = false, IconData? prefixIcon, bool opt = false,
    IconData? suffixIcon, final VoidCallback? onSuffixPressed,
    bool obscureText = false,}) {
    return SizedBox(
      width: width,
      child: TextFormField(
        keyboardType: isMobile
            ? TextInputType.phone
            : TextInputType.text,
        obscureText: obscureText,
        enabled: !readOnly,
        cursorColor: AppColors.mainColor,
        inputFormatters: (!isMobile) ? [] : [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
        readOnly: readOnly,
        maxLines: maxLines,
        validator: validator,
        controller: controller,
        style: TextStyle(
            color: Colors.black, fontSize: SizeConfig.getFont(09), fontWeight: FontWeight.normal, fontFamily: rb
            //color: Colors.black, fontSize: SizeConfig.getFont(context,13), fontWeight: FontWeight.normal, fontFamily: 'Roboto'
         ),
        decoration: InputDecoration(
          errorMaxLines: 1,
          errorStyle: TextStyle(
            //fontSize: 10,
            fontSize: SizeConfig.getFont(08),
            overflow: TextOverflow.ellipsis,
            height: 1.0,
          ),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 18) : null,
          suffixIcon: suffixIcon != null ? IconButton(icon: Icon(suffixIcon, size: 16,), onPressed: onSuffixPressed,) : null,
          alignLabelWithHint: (remarks) ? true : false,
        isDense: true,
        //contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 11),
        label: RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontFamily: rb,
              //fontSize: 11,
              fontSize: SizeConfig.getFont(08),
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: isMandatory ? ' *' : opt ? ' (Optional) ':' ',
                style: TextStyle(
                  fontFamily: rb,
                  color: isMandatory ? Colors.red : Colors.grey,
                  fontSize: isMandatory ? SizeConfig.getFont(10) : SizeConfig.getFont(11),
                ),
              ),
            ],
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(width: 1.2),
        ),
        // floatingLabelStyle: const TextStyle(
        //   fontSize: 13,
        //   color: Colors.deepPurpleAccent,
        //   fontWeight: FontWeight.w500,
        // ),
      ),
    ),);
  }

  final valueListenable = ValueNotifier<String?>(null);

  Widget customDropdown({
    required String hint,
    required List<String> items,
    required String? value,
    required ValueChanged<String?>? onChanged,
    required BuildContext context,
    double? width,
    String? Function(String?)? validator,
    bool readOnly = false,

  }) {
    final ValueNotifier<String?> dropdownValue =
    ValueNotifier<String?>(value);
    return Stack(
      children: [ Padding(
        padding: const EdgeInsets.only(top: 8),
        child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField2<String>(
      isExpanded: true,
      valueListenable: dropdownValue,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // hint: AppText(
      //   text: hint,
      //   fontSize: 11,
      //   color: Colors.black,
      //   fontFamily: rb,
      //   fontWeight: FontWeight.normal,
      // ),
      hint: RichText(
        text: TextSpan(
          text: hint,
          style: TextStyle(
            fontFamily: rb,
            fontSize: SizeConfig.getFont(08) ,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text:' *' ,
              style: TextStyle(
                fontFamily: rb,
                color: Colors.red,
                fontSize: SizeConfig.getFont(09) ,
              ),
            ),
          ],
        ),
      ),
      items: items.map((item) => DropdownItem<String>(
        value: item,
        height: 25,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: AppText(
            text: item,
            fontSize: SizeConfig.getFont(08) ,
            color: Colors.black,
            fontFamily: rb,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      ).toList(),
      onChanged: !readOnly ? (val) {
        dropdownValue.value = val;
        if (onChanged != null) onChanged(val);
      } : null,
      buttonStyleData: FormFieldButtonStyleData(
        height: 36,
        width: width ?? double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: readOnly ? Colors.grey.shade300 : Colors.black,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 9),
      ),

      iconStyleData: IconStyleData(
        iconSize: 22,
        icon: readOnly
            ? const SizedBox.shrink()
            : const Icon(Icons.arrow_drop_down_sharp),
        openMenuIcon: const Icon(Icons.arrow_drop_up),
      ),

      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        errorStyle: TextStyle(
          fontSize: SizeConfig.getFont(08),
            overflow: TextOverflow.ellipsis,
            height: 0.3
        ),
      ),
    ),
    ),),

        if (value != null && value.isNotEmpty)
          Positioned(
            left: 12,
            top: 8,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: RichText(
                text: TextSpan(
                  text: hint,
                  style: TextStyle(
                    fontFamily: rb,
                    color: Colors.black,
                    fontSize: SizeConfig.getFont(08),
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: " *",
                      style: TextStyle(color: Colors.red, fontSize: SizeConfig.getFont(09) ,
                        fontWeight: FontWeight.w500,),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );

  }

  Widget commonButton({
    required String text,
    required VoidCallback onPressed,
    double width = double.infinity,
    double height = 40,
    Color backgroundColor = AppColors.mainColor,
    Color color = Colors.deepPurple,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: AppText(
          text: text,
          fontSize: SizeConfig.getFont(14),
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget commonWhiteButton1({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    double width = 120,
    double height = 45,
    double fontSize = 13,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null
            ? Icon(
          icon,
          color: Colors.deepPurple,
          size: 16,
        )
            : SizedBox.shrink(),
        label: AppText(
          text: text,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: Colors.deepPurple,
          textAlign: TextAlign.center,
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          backgroundColor: Colors.white,
          foregroundColor: Colors.deepPurple,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget commonWhiteButton({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    double width = 120,
    double height = 45,
    double fontSize = 13,
    Color textColor = Colors.deepPurple
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          backgroundColor: Colors.white,
          foregroundColor: Colors.deepPurple,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: Colors.deepPurple,
                size: 16,
              ),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: AppText(
                text: text,
                textAlign: TextAlign.center,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  static void showSnackBar(BuildContext context, {required String message, Color backgroundColor = Colors.white,
    Color textColor = Colors.red, Duration duration = const Duration(seconds: 2),
      }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: backgroundColor,
          padding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          content: SizedBox(
            height: 20,
            child: AppText(
                text: message,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: textColor,
            ),
          ),
        ),
    );
  }

  static void showLoader(BuildContext context) {
  showDialog(
  context: context,
  barrierDismissible: false,
  barrierColor: Colors.black45,
  builder: (context) {
  return Center(
  child: SpinKitFadingCircle(
  color: Colors.deepPurple,
  size: 40,
  ),
  );
  },
  );
  }

  static void hideLoader(BuildContext context) {
  if (Navigator.canPop(context)) {
   Navigator.pop(context);
    }
  }

  static Future<void> exportPDF({
    required String title,
    required List<String> headers,
    required List<List<String>> data,
    required String fileName,
  }) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) => [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 15),

          pw.Table.fromTextArray(
            headers: headers,
            data: data,
            border: pw.TableBorder.all(),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 10,
            ),
            cellStyle: const pw.TextStyle(fontSize: 9),
            cellAlignment: pw.Alignment.centerLeft,
          ),
        ],
      ),
    );

    final directory = await getExternalStorageDirectory();

    if (directory == null) {
      throw Exception("Storage directory not found");
    }

    final downloadDir = Directory("${directory.path}/Download");

    if (!downloadDir.existsSync()) {
      downloadDir.createSync(recursive: true);
    }

    final file = File("${downloadDir.path}/$fileName.pdf");

    await file.writeAsBytes(await pdf.save());

    await OpenFilex.open(file.path);
  }
}