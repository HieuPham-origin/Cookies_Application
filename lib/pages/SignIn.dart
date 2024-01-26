// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'SignUp.dart';


class SignIn extends StatelessWidget {
  const SignIn({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFFFEF5E7),
                    
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                  ),
                ),
              ],
            ),

            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: 180.0,
                      width: 140.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/logo.png'),
                          fit: BoxFit.fill,
                        )
                      ),
                    ),
              
                    SizedBox(
                      height: 20,
                    ),
              
                    Container(
                      width: 350,
                      height: 500,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4,
                        surfaceTintColor: Colors.white,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 32,
                            ),
                            Text(
                              "Đăng nhập", 
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFB99B6B)
                                ),
                              )
                            ),
                            SizedBox(
                              height: 32,
                            ),
                    
                            //Email field
                            Padding(
                              padding: EdgeInsets.only(left: 16.0, right: 16.0),
                              child: TextField(
                                style: GoogleFonts.inter(),
                                obscureText: true,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Color(0xFFB99B6B)),
                                    borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color:Color(0xFFB99B6B), width: 1.0),
                                    borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  labelText: "Email",
                                  labelStyle: TextStyle(
                                    color: Color(0xFF9A9A9A),
                                  )
                                  
                                ),
                              ),
                            ),
                    
                            SizedBox(
                              height: 32,
                            ),
                    
                            //Password field
                            Padding(
                              padding: EdgeInsets.only(left: 16.0, right: 16.0),
                              child: TextField(
                                style: GoogleFonts.inter(),
                                obscureText: true,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: Color(0xFFB99B6B)),
                                    borderRadius: BorderRadius.all(Radius.circular(12))
                    
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  labelText: "Mật khẩu",
                                  labelStyle: TextStyle(
                                    color: Color(0xFF9A9A9A),
                                  )
                                  
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 12,
                            ),

                            Align(
                              alignment: Alignment.topRight,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: const TextStyle(
                                    fontSize: 16,                                  
                                  ),
                                
                                ),
                                onPressed: () {},
                                child: const Text(
                                  'Quên mật khẩu ?',
                                  style: TextStyle(
                                    color: Color(0xFF9A9A9A),
                                  )
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 16,
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
                                onPressed: () {}, 
                                child: Text(
                                  "Đăng Nhập",
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                    
                                  ),
                                )
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),

                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: const TextStyle(
                                    fontSize: 16,                                  
                                  ),
                                
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SignUp()),
                                  );
                                },
                                child: const Text(
                                  'Tạo tài khoản',
                                  style: TextStyle(
                                    color: Color(0xFF9A9A9A),
                                  )
                                ),
                              ),
                            ),


                            

                          ],
                        ),
                    
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}