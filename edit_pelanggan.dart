import 'package:aplikasi_kasir/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPelanggan extends StatefulWidget {
  final Map<String, dynamic> pelanggan;

  const EditPelanggan({Key? key, required this.pelanggan}) : super(key: key);

  @override
  State<EditPelanggan> createState() => _EditPelangganState();
}

class _EditPelangganState extends State<EditPelanggan> {
  late TextEditingController namaPelangganController;
  late TextEditingController alamatController;
  late TextEditingController nomorTeleponController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  @override
  void initState() {
    super.initState();

    print("Data pelanggan sebelum edit: ${widget.pelanggan}");

    namaPelangganController = TextEditingController(
      text: widget.pelanggan['NamaPelanggan'] ?? '',
    );
    alamatController = TextEditingController(
      text: widget.pelanggan['Alamat']?.toString() ?? '',
    );
    nomorTeleponController = TextEditingController(
      text: widget.pelanggan['NomorTelepon']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    namaPelangganController.dispose();
    alamatController.dispose();
    nomorTeleponController.dispose();
    super.dispose();
  }

  Future<void> updatePelanggan(String id, String namaPelanggan, String alamat,
      String nomorTelepon) async {
    try {
      print("Mengupdate pelanggan dengan ID: $id");
      print(
          "Data yang dikirim: Nama = $namaPelanggan, Alamat = $alamat, No = $nomorTelepon");

      await supabase.from('pelanggan').update({
        'NamaPelanggan': namaPelanggan,
        'Alamat': alamat,
        'NomorTelepon': nomorTelepon,
      }).eq('PelangganID', id);

      if (mounted) {
        Navigator.of(context).pop({
          'PelangganID': id,
          'NamaPelanggan': namaPelanggan,
          'Alamat': alamat,
          'NomorTelepon': nomorTelepon,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pelanggan Berhasil Diperbarui'),
          ),
        );
      }
    } catch (e) {
      print("❌ Error saat update pelanggan: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal Memperbarui pelanggan: $e'),
          ),
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
                              final nomorTelepon = nomorTeleponController.text;

                              updatePelanggan(
                                widget.pelanggan['ID'].toString(),
                                nama,
                                alamat,
                                nomorTelepon,
                              );
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
  Widget build(BuildContext context) {
    // return AlertDialog(
    //   title: const Text('Edit Pelanggan'),
    //   content: Form(
    //     key: _formKey,
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         TextFormField(
    //           controller: namaPelangganController,
    //           validator: (value) {
    //             if (value == null || value.isEmpty) {
    //               return 'Nama Pelanggan Tidak Boleh Kosong';
    //             }
    //             return null;
    //           },
    //           decoration: const InputDecoration(
    //             labelText: 'Nama Pelanggan',
    //             icon: Icon(Icons.person),
    //           ),
    //         ),
    //         TextFormField(
    //           controller: alamatController,
    //           validator: (value) {
    //             if (value == null || value.isEmpty) {
    //               return 'Alamat Tidak Boleh Kosong';
    //             }
    //             return null;
    //           },
    //           decoration: const InputDecoration(
    //             labelText: 'Alamat',
    //             icon: Icon(Icons.mail),
    //           ),
    //         ),
    //         TextFormField(
    //           controller: nomorTeleponController,
    //           validator: (value) {
    //             if (value == null || value.isEmpty) {
    //               return 'Nomor Telepon Tidak Boleh Kosong';
    //             }
    //             if (double.tryParse(value) == null) {
    //               return 'Nomor Telepon Harus Berupa Angka';
    //             }
    //             return null;
    //           },
    //           decoration: const InputDecoration(
    //             labelText: 'Nomor Telepon',
    //             icon: Icon(Icons.phone),
    //           ),
    //           keyboardType: TextInputType.phone,
    //         ),
    //       ],
    //     ),
    //   ),
    //   actions: [
    //     TextButton(
    //       onPressed: () {
    //         Navigator.of(context).pop();
    //       },
    //       child: const Text('Batal'),
    //     ),
    //     ElevatedButton(
    //       onPressed: () {
    //         if (_formKey.currentState!.validate()) {
    //           final nama = namaPelangganController.text;
    //           final alamat = alamatController.text;
    //           final nomorTelepon = nomorTeleponController.text;

    //           updatePelanggan(
    //             widget.pelanggan['ID'].toString(),
    //             nama,
    //             alamat,
    //             nomorTelepon,
    //           );
    //         }
    //       },
    //       child: const Text('Simpan'),
    //     )
    //   ],
    // );
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
                    'Edit Pelanggan',
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
                              final nomorTelepon = nomorTeleponController.text;

                              updatePelanggan(
                                widget.pelanggan['ID'].toString(),
                                nama,
                                alamat,
                                nomorTelepon,
                              );
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
  }
}
