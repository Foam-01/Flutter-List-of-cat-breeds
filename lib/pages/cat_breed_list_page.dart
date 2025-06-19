import 'package:flutter/material.dart';
import '../models/cat_breed.dart';
import '../services/api_service.dart';

class CatBreedListPage extends StatefulWidget {
  @override
  _CatBreedListPageState createState() => _CatBreedListPageState();
}

class _CatBreedListPageState extends State<CatBreedListPage> {
  late Future<List<CatBreed>> futureCatBreeds;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureCatBreeds = apiService.fetchCatBreeds();
  }

  void _refreshList() {
    setState(() {
      futureCatBreeds = apiService.fetchCatBreeds();
    });
  }

  void _showAddOrEditDialog({CatBreed? cat}) {
    final nameController = TextEditingController(text: cat?.name ?? '');
    final originController = TextEditingController(text: cat?.origin ?? '');
    final descController = TextEditingController(text: cat?.description ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(cat == null ? 'เพิ่มพันธุ์แมว' : 'แก้ไขพันธุ์แมว'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'ชื่อพันธุ์แมว')),
              TextField(controller: originController, decoration: InputDecoration(labelText: 'แหล่งกำเนิด')),
              TextField(controller: descController, decoration: InputDecoration(labelText: 'คำอธิบาย')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('ยกเลิก')),
          ElevatedButton(
            onPressed: () async {
              final newCat = CatBreed(
                id: cat?.id ?? '',
                name: nameController.text,
                origin: originController.text,
                description: descController.text,
              );

              try {
                if (cat == null) {
                  await apiService.addCatBreed(newCat);
                } else {
                  await apiService.updateCatBreed(newCat);
                }
                _refreshList();
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
              }
            },
            child: Text(cat == null ? 'เพิ่ม' : 'บันทึก'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('ยืนยันการลบ'),
        content: Text('ต้องการลบพันธุ์แมวนี้หรือไม่?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('ยกเลิก')),
          ElevatedButton(
            onPressed: () async {
              try {
                await apiService.deleteCatBreed(id);
                _refreshList();
                Navigator.pop(context);
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
              }
            },
            child: Text('ลบ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายชื่อพันธุ์แมว'),
      ),
      body: FutureBuilder<List<CatBreed>>(
        future: futureCatBreeds,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('ไม่มีข้อมูลพันธุ์แมว'));
          } else {
            final cats = snapshot.data!;
            return ListView.builder(
              itemCount: cats.length,
              itemBuilder: (context, index) {
                final cat = cats[index];
                return ListTile(
                  title: Text(cat.name),
                  subtitle: Text(cat.origin),
                  onTap: () => _showAddOrEditDialog(cat: cat),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(cat.id),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOrEditDialog(),
        child: Icon(Icons.add),
        tooltip: 'เพิ่มพันธุ์แมว',
      ),
    );
  }
}
