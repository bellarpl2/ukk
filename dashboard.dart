import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Colors.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? userEmail;
  String? selectedPelanggan;
  String? username;
  String? role;
  final SupabaseClient supabase = Supabase.instance.client;
  final List<Map<String, dynamic>> product = [];
  final List<Map<String, dynamic>> cart = [];
  final List<Map<String, dynamic>> pelanggan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
      username = prefs.getString('username');
      role = prefs.getString('role');
    });
    await Future.wait([
      _fetchUserEmail(),
      fetchProducts(),
      fetchPelanggan(),
    ]);
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await supabase.from('kasir_produk').select();

      setState(() {
        product.clear();
        product.addAll((response as List<dynamic>).map((product) {
          return {
            'id': product['produkid'],
            'name': product['namaproduk'],
            'price': product['harga'],
            'stock': product['stok'],
          };
        }).toList());
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil produk: $e')),
      );
    }
  }

  Future<void> fetchPelanggan() async {
    try {
      final response = await supabase.from('kasir_pelanggan').select();
      setState(() {
        pelanggan.clear();
        pelanggan.addAll((response as List<dynamic>).map((pelanggan) {
          return {
            'NamaPelanggan': pelanggan['namapelanggan'],
            'Alamat': pelanggan['alamat'],
            'NomorTelepon': pelanggan['nomortelepon'],
          };
        }).toList());
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data pelanggan: $e')),
      );
    }
  }

  Future<void> _fetchUserEmail() async {
    final user = Supabase.instance.client.auth.currentUser;
    setState(() {
      userEmail = user?.email ?? 'Guest';
    });
  }

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      int productIndex = cart.indexWhere((item) => item['id'] == product['id']);

      if (productIndex == -1) {
        cart.add({...product, 'quantity': 1});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${product['name']} telah ditambahkan ke dalam keranjang!'),
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product['name']} sudah ada di dalam keranjang!'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }

  void removeFromCart(int index) {
    setState(() {
      cart.removeAt(index);
    });
  }

  double calculateTotal() {
    return cart.fold(
        0, (total, item) => total + (item['price'] * item['quantity']));
  }

  void updateQuantity(int index, int quantity) {
    setState(() {
      int availableStock =
          cart[index]['stock'];
      if (quantity <= availableStock) {
        cart[index]['quantity'] = quantity;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Jumlah yang tersedia hanya $availableStock'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }

  
  String formatMoney(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    ).format(amount);
  }

  void viewTransaction() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: StatefulBuilder(
              builder: (context, setStateDialog) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detail Transaksi',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedPelanggan,
                          hint: Text(
                            'Pembeli',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down,
                              color: AppColors.primaryPurple),
                          items: pelanggan
                              .map<DropdownMenuItem<String>>((pelanggan) {
                            return DropdownMenuItem<String>(
                              value: pelanggan['NamaPelanggan'],
                              child: Text(
                                pelanggan['NamaPelanggan'] ?? '',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setStateDialog(() {
                              selectedPelanggan = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cart.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = cart[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      formatMoney(
                                          item['price'].toDouble() * item['quantity'].toDouble()),
                                      style: GoogleFonts.poppins(
                                        color: AppColors.primaryPurple,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 18),
                                    onPressed: () {
                                      if (item['quantity'] > 1) {
                                        setStateDialog(() {
                                          updateQuantity(
                                              index, item['quantity'] - 1);
                                        });
                                      }
                                    },
                                  ),
                                  Text(
                                    item['quantity'].toString(),
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 18),
                                    onPressed: () {
                                      setStateDialog(() {
                                        updateQuantity(
                                            index, item['quantity'] + 1);
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: Colors.red.shade400,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setStateDialog(() {
                                        removeFromCart(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            formatMoney(calculateTotal()),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side:
                                    BorderSide(color: AppColors.primaryPurple),
                              ),
                            ),
                            child: Text(
                              'Tutup',
                              style: GoogleFonts.poppins(
                                color: AppColors.primaryPurple,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              addTransaction();
                              Navigator.of(context).pop();
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
                              'Bayar',
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
                );
              },
            ),
          ),
        );
      },
    );
  }
  Future<void> addTransaction() async {
    if (selectedPelanggan == null || selectedPelanggan!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih pelanggan terlebih dahulu!')),
      );
      return;
    }

    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Keranjang kosong! Tambahkan produk terlebih dahulu.')),
      );
      return;
    }

    try {
      final response = await supabase
          .from('pelanggan')
          .select('PelangganID')
          .eq('NamaPelanggan', selectedPelanggan as Object)
          .single();
      int pelangganID = response['PelangganID'];

      final responsePenjualan = await supabase
          .from('penjualan')
          .insert({
            'PelangganID': pelangganID,
            'TotalHarga': calculateTotal(),
            'TanggalPenjualan': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      int penjualanID = responsePenjualan['PenjualanID'];

      await addTransactionDetails(penjualanID);

      for (var item in cart) {
        int newStock = item['stock'] - item['quantity'];

        await supabase.from('product').update({
          'Stock': newStock,
        }).eq('ProductID', item['id']);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.primaryPurple,
          behavior: SnackBarBehavior.floating,
          content: Text('Transaksi Selesai'),
        ),
      );

      setState(() {
        cart.clear();
        selectedPelanggan = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal melakukan transaksi: $e')),
      );
    }
  }

  Future<void> addTransactionDetails(int penjualanID) async {
    try {
      for (var item in cart) {
        await supabase.from('detail_penjualan').insert({
          'PenjualanID': penjualanID,
          'ProductID': item['id'],
          'JumlahProduk': item['quantity'],
          'Subtotal': item['price'] * item['quantity'],
          'created_at': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Selamat bekerja,',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    username ?? 'Loading...',
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Badge(
                                label: Text(cart.length.toString()),
                                child: IconButton(
                                  onPressed: viewTransaction,
                                  icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.darkPurple,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Products',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      product.length.toString(),
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.inventory_2_outlined, color: Colors.white, size: 40),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Menu Kopi Nikmat',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkPurple,
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                 SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return
                         Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: InkWell(
                              onTap: () => product[index]['stock'] > 0
                                  ? addToCart(product[index])
                                  : null,
                              borderRadius: BorderRadius.circular(15),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColors.lightPurple,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          Icons.coffee,
                                          size: 40,
                                          color: AppColors.primaryPurple,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      product[index]['name'] ?? 'Nama Produk',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Rp ${product[index]['price']}',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.primaryPurple,
                                          ),
                                        ),
                                        Text(
                                          'Stock: ${product[index]['stock']}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: product[index]['stock'] > 0
                                                ? Colors.green
                                                : Colors.red,
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
                        childCount: product.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
