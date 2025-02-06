import 'package:aplikasi_kasir/Colors.dart';
import 'package:flutter/material.dart';

class Botnavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const Botnavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: AppColors.primaryPurple,
      unselectedItemColor: Colors.grey.shade400,
      backgroundColor: Colors.white,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
      ),
      onTap: onTap,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.widgets),
          activeIcon: Icon(Icons.widgets_rounded),
          label: 'Product Menu',
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books_outlined),
          activeIcon: Icon(Icons.library_books_rounded),
          label: 'List Product',
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history_outlined),
          activeIcon: Icon(Icons.history_rounded),
          label: 'Transaction',
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          activeIcon: Icon(Icons.people_rounded),
          label: 'Customer',
          backgroundColor: Colors.white,
        ),
      ],
    );
  }
}
