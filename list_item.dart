import 'package:aplikasi_kasir/Colors.dart';
import 'package:aplikasi_kasir/pages/components/BasicAppbar.dart';
import 'package:aplikasi_kasir/pages/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ListItem extends StatefulWidget {
  const ListItem({super.key});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool isLoading = true; // Add this variable
  // Add Data To Supabase
  final List<Map<String, dynamic>> product = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController nameController = TextEditingController();
  late TextEditingController priceController = TextEditingController();
  late TextEditingController stockController = TextEditingController();

  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> fetchProducts() async {
    try {
      final response = await supabase.from('product').select();

      if (mounted) {
        setState(() {
          product.clear();
          product.addAll((response as List<dynamic>).map((product) {
            return {
              'id': product['ProductID'],
              'name': product['NamaProduct'],
              'price': product['Harga'],
              'stock': product['Stock'],
            };
          }).toList());
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil produk: $e')),
        );
      }
    }
  }

  Future<void> createProduct(String name, String price, String stock) async {
    try {
      await supabase.from('product').insert({
        'NamaProduct': name,
        'Harga': price,
        'Stock': stock,
      });

      await fetchProducts(); // Ambil ulang data setelah penambahan
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produk berhasil ditambahkan'),
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

  // Fungsi untuk menghapus data dari Supabase
  Future<void> deleteProduct(int id) async {
    try {
      // Pastikan id bertipe int
      await supabase.from('product').delete().eq('ProductID', id);

      // Refresh data setelah penghapusan
      await fetchProducts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produk berhasil dihapus'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus produk: $e'),
          ),
        );
      }
    }
  }

   void addProduk() {
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
                    'Tambah Produk',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama produk tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Nama Produk',
                      prefixIcon: const Icon(Icons.inventory_2_outlined),
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
                    controller: priceController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harga tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Harga',
                      prefixIcon: Icon(Icons.monetization_on_rounded),
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
                    controller: stockController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Stock tidak boleh kosong';
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Stock hanya boleh berisi angka';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Stock',
                      prefixIcon: const Icon(Icons.numbers),
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
                              final name = nameController.text;
                              final price = priceController.text;
                              final stock = stockController.text;

                              createProduct(name, price, stock);
                              Navigator.of(context).pop();
                              nameController.clear();
                              priceController.clear();
                              stockController.clear();
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

  String searchQuery = '';
  String selectedFilter = 'All';
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> getFilteredProducts() {
    if (searchQuery.isEmpty) return product;
    return product.where((item) {
      return item['name']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    await fetchProducts();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = getFilteredProducts();

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Basicappbar(
          title: 'List Item',
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.lightPurple.withOpacity(0.3),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.primaryPurple),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) =>
                            setState(() => searchQuery = value),
                        decoration: const InputDecoration(
                          hintText: 'Search products...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    if (searchQuery.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          setState(() => searchQuery = '');
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text(
                '${filteredProducts.length} Products Ditemukan',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.darkPurple,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              // Product List
              Expanded(
                child: ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final item = filteredProducts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 4, // Increased elevation for a floating effect
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          // Handle card tap if needed
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryPurple,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.coffee,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // Product Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'] ?? 'Nama Produk',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.darkPurple,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Rp ${item['price']}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.primaryPurple,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Stock Indicator & Actions
                                  Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: item['stock'] > 0
                                              ? Colors.green.withOpacity(0.1)
                                              : Colors.red.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          'Stock: ${item['stock']}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: item['stock'] > 0
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      // IconButton(
                                      //   onPressed: () {
                                      //     final int productId =
                                      //         int.parse(item['id'].toString());
                                      //     showDeleteConfirmationDialog(
                                      //         productId);
                                      //   },
                                      //   icon: const Icon(Icons.delete),
                                      //   color: Colors.red,
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.edit,
                                        size: 18, color: Colors.white),
                                    label: const Text('Edit'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryPurple,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      final int productId =
                                          int.parse(item['id'].toString());
                                      showDeleteConfirmationDialog(productId);
                                    },
                                    icon: const Icon(Icons.delete,
                                        size: 18, color: Colors.white),
                                    label: const Text('Hapus'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        onPressed: addProduk,
        child: const Icon(Icons.add),
      ),
    );
  }

 
  // void showAddProductDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Tambah Produk Baru'),
  //         content: Form(
  //             key: _formKey,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 TextFormField(
  //                   controller: nameController,
  //                   validator: (value) {
  //                     if (value == null || value.isEmpty) {
  //                       return 'Nama produk tidak boleh kosong';
  //                     }
  //                     return null;
  //                   },
  //                   decoration: const InputDecoration(
  //                     labelText: 'Nama Produk',
  //                     icon: Icon(Icons.label),
  //                   ),
  //                 ),
  //                 TextFormField(
  //                   controller: priceController,
  //                   validator: (value) {
  //                     if (value == null || value.isEmpty) {
  //                       return 'Harga produk tidak boleh kosong';
  //                     }
  //                     return null;
  //                   },
  //                   decoration: const InputDecoration(
  //                     labelText: 'Harga Produk',
  //                     icon: Icon(Icons.price_change),
  //                   ),
  //                   keyboardType: TextInputType.number,
  //                 ),
  //                 TextFormField(
  //                   controller: stockController,
  //                   validator: (value) {
  //                     if (value == null || value.isEmpty) {
  //                       return 'Stock produk tidak boleh kosong';
  //                     }
  //                     return null;
  //                   },
  //                   decoration: const InputDecoration(
  //                     labelText: 'Stock Produk',
  //                     icon: Icon(Icons.production_quantity_limits),
  //                   ),
  //                   keyboardType: TextInputType.number,
  //                 ),
  //               ],
  //             )),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text('Batal'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               if (_formKey.currentState!.validate()) {
  //                 final name = nameController.text;
  //                 final price = priceController.text;
  //                 final stock = stockController.text;

  //                 createProduct(name, price, stock);
  //                 Navigator.of(context).pop();
  //                 nameController.clear();
  //                 priceController.clear();
  //                 stockController.clear();
  //               }
  //             },
  //             child: const Text('Simpan'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Delete Product
  void showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Produk'),
          content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                deleteProduct(id); // Pastikan id adalah integer
                Navigator.of(context).pop(); // Tutup dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Warna tombol hapus
              ),
              child: Text(
                'Hapus',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
