import 'package:aplikasi_kasir/Colors.dart';
import 'package:aplikasi_kasir/pages/admin/customer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplikasi_kasir/pages/admin/list_item.dart';
import 'package:aplikasi_kasir/pages/admin/route_page.dart';
import 'package:aplikasi_kasir/pages/admin/transaksi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth/login.dart';

class AppsBar extends StatefulWidget {
  final Widget? customIcon;
  final String? username;

  const AppsBar({
    Key? key,
    this.customIcon,
    this.username,
  }) : super(key: key);

  @override
  State<AppsBar> createState() => _AppsBarState();
}

class _AppsBarState extends State<AppsBar> {
  String? username = '';
  String? role = '';

  void getlocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      role = prefs.getString('role');
    });
  }

  @override
  void initState() {
    getlocaldata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 2,
      backgroundColor: AppColors.primaryPurple,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.lightPurple,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const CircleAvatar(
                  backgroundImage: AssetImage('assets/profile.jpg'),
                  radius: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                role ?? '',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              widget.customIcon ??
                  IconButton(
                    onPressed: _logout,
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: Colors.white,
                    ),
                    tooltip: 'Logout',
                  ),
                  IconButton(
                    onPressed: _showPopupMenu,
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    tooltip: 'Menu',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPopupMenu() async {
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset topRight = button.localToGlobal(button.size.topRight(Offset.zero));
    
    final RelativeRect position = RelativeRect.fromLTRB(
      topRight.dx - 200,
      topRight.dy + 50,
      topRight.dx,
      overlay.size.height
    );

    showMenu(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 4,
      color: Colors.white,
      constraints: const BoxConstraints(
        minWidth: 200,
        maxWidth: 200,
      ),
      items: [
        PopupMenuItem<int>(
          value: 0,
          child: ListTile(
            leading: const Icon(Icons.widgets_rounded, color: AppColors.primaryPurple),
            title: const Text('Product Menu'),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: ListTile(
            leading: const Icon(Icons.library_books_rounded, color: AppColors.primaryPurple),
            title: const Text('List Product'),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: ListTile(
            leading: const Icon(Icons.history_rounded, color: AppColors.primaryPurple),
            title: const Text('Transaction'),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ),
        if (role == 'admin')
          PopupMenuItem<int>(
            value: 3,
            child: ListTile(
              leading: Icon(Icons.people_rounded, color: AppColors.primaryPurple),
              title: Text('Customer'),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
          ),
      ],
    ).then((value) {
      if (value != null) {
        switch (value) {
          case 0:
          Get.to(routePage());
          case 1:
          Get.to(ListItem());
          case 2:
          Get.to(TransactionPage());
          case 3:
          Get.to(Account());
        }
      }
    });
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Konfirmasi",
            style: TextStyle(
              color: AppColors.darkPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Apakah Anda yakin ingin keluar?",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Batal",
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text("Keluar"),
            ),
          ],
        );
      },
    );
  }
}
