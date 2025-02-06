import 'package:aplikasi_kasir/pages/components/edit_pelanggan.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:aplikasi_kasir/Colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../components/BasicAppbar.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final List<Map<String, dynamic>> pelanggan = [];
  late TextEditingController namaPelangganController = TextEditingController();
  late TextEditingController alamatController = TextEditingController();
  late TextEditingController nomorTeleponController = TextEditingController();
  bool isLoading = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> createPelanggan(
      String namaPelanggan, String alamat, String nomorTelepon) async {
    try {
      await supabase.from('pelanggan').insert({
        'NamaPelanggan': namaPelanggan,
        'Alamat': alamat,
        'NomorTelepon': nomorTelepon,
      });

      await fetchPelanggan();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produk ditambahkan'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambah produk: $e'),
          ),
        );
      }
    }
  }

  Future<void> fetchPelanggan() async {
    try {
      final response = await supabase.from('pelanggan').select();

      setState(() {
        pelanggan.clear();
        pelanggan.addAll((response as List<dynamic>).map((pelanggan) {
          return {
            'ID': pelanggan['PelangganID'],
            'NamaPelanggan': pelanggan['NamaPelanggan'],
            'Alamat': pelanggan['Alamat'],
            'NomorTelepon': pelanggan['NomorTelepon'],
          };
        }).toList());
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil Pelanggan: $e')),
        );
      }
    }
  }

  void addPelanggan() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Tambah Pelanggan',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: namaPelangganController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama pelanggan tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Nama Pelanggan',
                      prefixIcon: const Icon(Icons.person_outline),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primaryPurple),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: alamatController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Alamat tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Alamat',
                      prefixIcon: Icon(Icons.location_on_outlined),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primaryPurple),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nomorTeleponController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor telepon tidak boleh kosong';
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Nomor telepon hanya boleh berisi angka';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Nomor Telepon',
                      prefixIcon: const Icon(Icons.phone_outlined),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primaryPurple),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Batal',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final nama = namaPelangganController.text;
                              final alamat = alamatController.text;
                              final telepon = nomorTeleponController.text;

                              createPelanggan(nama, alamat, telepon);
                              Navigator.of(context).pop();
                              namaPelangganController.clear();
                              alamatController.clear();
                              nomorTeleponController.clear();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryPurple,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Submit',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    await fetchPelanggan();
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const Basicappbar(title: 'Daftar Customer'),
      ),
      body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: ListView.builder(
                itemCount: pelanggan.length,
                itemBuilder: (context, index) {
                return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPurple.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryPurple.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        pelanggan[index]['NamaPelanggan']
                                                ?.substring(0, 1)
                                                .toUpperCase() ??
                                            'P',
                                        style: GoogleFonts.poppins(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryPurple,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pelanggan[index]['NamaPelanggan'] ??
                                              'Nama Pelanggan',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryPurple
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            'Customer',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: AppColors.primaryPurple,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            Icons.location_on_outlined,
                                            size: 20,
                                            color: AppColors.primaryPurple,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            pelanggan[index]['Alamat'],
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            Icons.phone_outlined,
                                            size: 20,
                                            color: AppColors.primaryPurple,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          pelanggan[index]['NomorTelepon'].toString(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Positioned(
                          top: 8,
                          right: 8,
                          child: Row(
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: IconButton(
                                  onPressed: () async {
                                    final updatePelanggan =
                                        await showDialog<Map<String, dynamic>>(
                                      context: context,
                                      builder: (context) => EditPelanggan(
                                        pelanggan: pelanggan[index],
                                      ),
                                    );
                                    if (updatePelanggan != null) {
                                      setState(() {
                                        pelanggan[index] = {
                                          'ID': updatePelanggan['PelangganID'],
                                          'NamaPelanggan':
                                              updatePelanggan['NamaPelanggan'],
                                          'Alamat': updatePelanggan['Alamat'],
                                          'NomorTelepon':
                                              updatePelanggan['NomorTelepon'],
                                        };
                                      });
                                      await fetchPelanggan();
                                    }
                                  },
                                  icon: Icon(
                                    Icons.edit_outlined,
                                    size: 20,
                                    color: AppColors.primaryPurple,
                                  ),
                                  splashRadius: 24,
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.delete_outline_rounded,
                                    size: 20,
                                    color: Colors.red[400],
                                  ),
                                  splashRadius: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: addPelanggan,
        backgroundColor: AppColors.primaryPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
