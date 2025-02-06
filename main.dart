import 'package:flutter/material.dart';
import 'package:aplikasi_kasir/pages/admin/route_page.dart';
import 'package:aplikasi_kasir/pages/auth/login.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://hnjoarjuwqkfohfjiwmy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhuam9hcmp1d3FrZm9oZmppd215Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzgyMjk5OTYsImV4cCI6MjA1MzgwNTk5Nn0._pz2e3gwRBE1frupprrpdsPjmt9BDBtLliWfqkSWMoE',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: user != null ? const routePage() : const Login(),
    );
  }
}
