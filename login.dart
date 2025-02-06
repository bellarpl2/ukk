import 'package:aplikasi_kasir/Colors.dart';
import 'package:aplikasi_kasir/pages/admin/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aplikasi_kasir/pages/admin/route_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObsecured = true;
  final supabase = Supabase.instance.client;

  // void _signIn() async {
  //   try {
  //     print(_emailController.text);
  //     print(_passwordController.text);
  //     final AuthResponse res = await supabase.auth.signInWithPassword(
  //       email: _emailController.text,
  //       password: _passwordController.text,
  //     );

  //     final User? user = res.user;
  //     if (user != null) {
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('user_email', user.email!);
  //       print("User email saved to shared preferences: ${user.email}");
  //     } else {
  //       print("Sign in failed");
  //     }

  //     if (res != null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('User login successfully'),
  //           duration: Duration(seconds: 2),
  //         ),
  //       );

  //       Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => routePage()));
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('login error $e'),
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //   }
  // }

Future<Map<String, dynamic>?> _signIn() async {
    try {
      final response = await supabase
          .from('users')
          .select('username, role')
          .eq('username', _emailController.text)
          .eq('password', _passwordController.text)
          .single();

      if (response != null) {
        String role = response['role'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', response['username']);
        await prefs.setString('role', role);

         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            backgroundColor: Colors.green,
            content: Text('$role login successfully',  
            style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            duration: Duration(seconds: 2),
          ),
        );

        Get.to(() => routePage());
        return response;
      }

      return null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Login gagal, periksa username dan password anda', 
          style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      );
      print('Login error: $e');
      return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void _showField(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.darkPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.lightPurple, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPurple.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: const Image(
                      image: AssetImage('assets/auth.png'),
                      height: 180,
                      width: 180,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Selamat Datang',
                    style: GoogleFonts.poppins(
                      color: AppColors.darkPurple,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                          text: 'di ',
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryPurple,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: 'Halaman Login ',
                          style: GoogleFonts.poppins(
                            color: AppColors.darkPurple,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'Kasir Sederhana',
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryPurple,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Card(
                    elevation: 8,
                    shadowColor: AppColors.primaryPurple.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryPurple,
                              ),
                              prefixIcon: Icon(
                                Icons.person_rounded,
                                size: 24,
                                color: AppColors.primaryPurple,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: AppColors.lightPurple),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: AppColors.primaryPurple),
                              ),
                              filled: true,
                              fillColor: AppColors.lightPurple.withOpacity(0.1),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _isObsecured,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryPurple,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline_rounded,
                                size: 24,
                                color: AppColors.primaryPurple,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObsecured
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.primaryPurple,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObsecured = !_isObsecured;
                                  });
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: AppColors.lightPurple),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: AppColors.primaryPurple),
                              ),
                              filled: true,
                              fillColor: AppColors.lightPurple.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _signIn,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.primaryPurple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 8,
                      shadowColor: AppColors.primaryPurple.withOpacity(0.5),
                    ),
                    child: Text(
                      'Masuk',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
