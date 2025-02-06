import 'package:aplikasi_kasir/pages/components/appbar.dart';
import 'package:aplikasi_kasir/pages/components/botNavbar.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_kasir/pages/admin/customer.dart';
import 'package:aplikasi_kasir/pages/admin/dashboard.dart';
import 'package:aplikasi_kasir/pages/admin/transaksi.dart';
import 'package:aplikasi_kasir/pages/admin/list_item.dart';

class routePage extends StatefulWidget {
  const routePage({super.key});

  @override
  State<routePage> createState() => _routePageState();
}

class _routePageState extends State<routePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const Dashboard(),
    const ListItem(
    ),
    const TransactionPage(
    ),
    const Account(
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _selectedIndex;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppsBar(),
      ),
      body: Dashboard(),
      // bottomNavigationBar: Botnavbar(
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      // ),
    );
  }
}
