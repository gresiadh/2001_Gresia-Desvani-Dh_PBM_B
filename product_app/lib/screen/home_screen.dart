import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import '../models/product.dart';
import 'add_edit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsRef = FirebaseFirestore.instance.collection('products');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: productsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final products = snapshot.data!.docs.map((doc) {
              return Product.fromFirestore(doc);
            }).toList();

            if (products.isEmpty) {
              return const Center(child: Text('Belum ada produk'));
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: DataTable2(
                      columnSpacing: 24,
                      horizontalMargin: 16,
                      minWidth: 600,
                      headingRowHeight: 56,
                      dataRowHeight: 64,
                      fixedTopRows: 1, // membuat header tetap saat scroll
                      headingRowColor: MaterialStateProperty.resolveWith(
                        (states) => const Color.fromARGB(255, 239, 221, 149),
                      ),
                      columns: const [
                        DataColumn2(
                          label: Text('Nama', style: TextStyle(fontWeight: FontWeight.bold)),
                          size: ColumnSize.L,
                        ),
                        DataColumn2(
                          label: Text('Harga', style: TextStyle(fontWeight: FontWeight.bold)),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('Stok', style: TextStyle(fontWeight: FontWeight.bold)),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('Edit', style: TextStyle(fontWeight: FontWeight.bold)),
                          size: ColumnSize.S,
                        ),
                      ],
                      rows: products.map((p) {
                        return DataRow(cells: [
                          DataCell(Text(p.name, style: const TextStyle(fontSize: 15))),
                          DataCell(Text('Rp ${p.price}', style: const TextStyle(fontSize: 15))),
                          DataCell(Text('${p.stok}', style: const TextStyle(fontSize: 15))),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddEditScreen(product: p),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  productsRef.doc(p.id).delete();
                                },
                              ),
                            ],
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditScreen(),
            ),
          );
        },
      ),
    );
  }
}
