import 'package:aplikasi_kasir/Colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Basicappbar extends StatefulWidget {
  final String title;
  const Basicappbar({super.key, required this.title});

  @override
  State<Basicappbar> createState() => _BasicappbarState();
}

class _BasicappbarState extends State<Basicappbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.primaryPurple,
      title: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_sharp, color: Colors.white, size: 30,)),
          SizedBox(width: 15,),
          Text(
            widget.title,
             style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),);
  }
}
