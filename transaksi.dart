import 'package:aplikasi_kasir/pages/components/BasicAppbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    fetchTransaction();
  }

  Future<void> fetchTransaction() async {
    try {
      final response = await supabase
          .from('penjualan')
          .select(
              '*, pelanggan(NamaPelanggan), detail_penjualan(*, product(NamaProduct))')
          .order('TanggalPenjualan', ascending: false);

      if (mounted) {
        setState(() {
          transactions = (response as List<dynamic>).map((transaction) {
            return {
              'penjualanID': transaction['PenjualanID'],
              'pelanggan': transaction['pelanggan']['NamaPelanggan'],
              'totalHarga': transaction['TotalHarga'],
              'tanggal': transaction['TanggalPenjualan'],
              'details': (transaction['detail_penjualan'] as List<dynamic>)
                  .map((detail) {
                return {
                  'NamaProduct': detail['product']['NamaProduct'],
                  'Jumlah': detail['JumlahProduk'],
                  'Subtotal': detail['Subtotal']
                };
              }).toList(),
            };
          }).toList();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil data transaksi: $e')),
        );
      }
    }
  }

  Future<void> deleteTransaction(int id) async {
    try {
      await supabase.from('detail_penjualan').delete().eq('PenjualanID', id);
      await supabase.from('penjualan').delete().eq('PenjualanID', id);
      await fetchTransaction();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaksi berhasil dihapus')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal Menghapus Transaksi: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Basicappbar(title: 'Riwayat Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: RefreshIndicator(
          onRefresh: fetchTransaction,
          child: transactions.isEmpty
              ? Center(
                  child: Text(
                    'Belum ada transaksi.',
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    transaction['pelanggan'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    transaction['tanggal'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Divider(color: Colors.grey[300]),
                              const SizedBox(height: 8),
                              ...transaction['details'].map<Widget>((detail) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${detail['NamaProduct']} x ${detail['Jumlah']}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Rp ${detail['Subtotal']}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total:',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Rp ${transaction['totalHarga']}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    deleteTransaction(
                                        transaction['penjualanID']);
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: Text(
                                    'Hapus Transaksi',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
