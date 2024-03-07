import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cookie_app/services/UserService.dart';

class ChangeName extends StatefulWidget {
  const ChangeName({Key? key}) : super(key: key);

  @override
  State<ChangeName> createState() => _ChangeNamePageState();
}

class _ChangeNamePageState extends State<ChangeName> {
  final usernameController = TextEditingController();
  late UserService userService;

  dynamic displayName;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser!;
    userService = UserService(user);
    fetchUserInfo();
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  Future<void> fetchUserInfo() async {
    final userInfo = await userService.getUserInfo();
    setState(() {
      displayName = userInfo['displayName'];
    });
  }

  Future<void> updateDisplayName() async {
    final newDisplayName = usernameController.text;
    await userService.updateDisplayName(newDisplayName);
    fetchUserInfo();

    // Show success notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Display name updated successfully'),
      ),
    );

    // Navigate back to information page
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leadingWidth: 24,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: Text(
          "Thông tin",
          style: GoogleFonts.inter(
            textStyle: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 72,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 64),
            child: Column(
              children: [
                Text(
                  "Đổi tên",
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Bạn có thể đổi thành tên khác",
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF9A9A9A),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: "Tên",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFFB99B6B),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFFB99B6B),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB99B6B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      updateDisplayName();
                    },
                    child: Text(
                      "Thay đổi",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Display Name: $displayName",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}