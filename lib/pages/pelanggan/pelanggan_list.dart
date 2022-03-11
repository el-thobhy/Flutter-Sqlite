import 'package:flutter/material.dart';
import 'package:fluttersqlite/helper/dbhelper.dart';
import 'package:fluttersqlite/pages/pelanggan/pelanggan_form.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PelangganList extends StatefulWidget {
  const PelangganList({Key? key}) : super(key: key);

  @override
  State<PelangganList> createState() => _PelangganListState();
}

class _PelangganListState extends State<PelangganList> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  List lisData = [];

  void refresh() async {
    final _db = await DBHelper.db();
    final query = 'SELECT * FROM pelanggan';
    lisData = (await _db?.rawQuery(query))!;
    _refreshController.refreshCompleted();
    setState(() {});
  }

  Widget item(Map d) => ListTile(
        onLongPress: (() {
          showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                  100, MediaQuery.of(context).size.height / 2, 100, 0),
              items: [
                const PopupMenuItem(
                  child: Text('Sunting data Ini'),
                  value: 'S',
                ),
                const PopupMenuItem(child: Text('Hapus Data Ini'), value: 'H')
              ]).then((value) {
            if (value == 'S') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => PelangganForm(
                            data: d,
                          ))).then((value) {
                if (value == true) refresh();
              });
            } else if (value == 'H') {
              showDialog(
                  context: context,
                  builder: (c) => AlertDialog(
                        content: Text('Pelanggan ${d['nama']} ingin dihapus?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                hapusData(d['id']).then((value) {
                                  if (value == true) refresh();
                                });
                                Navigator.pop(context);
                              },
                              child: const Text('Ya, Saya Yakin Sekali')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Tidak Jadi Hapus"))
                        ],
                      ));
            }
          });
        }),
        title: Text('${d['nama']}'),
        trailing: Text('${d['gender']}'),
        subtitle: Text('${d['tgl_lahir']}'),
        leading: PopupMenuButton(
          itemBuilder: (bc) => [
            PopupMenuItem(
              child: Text('Sunting Data Ini'),
              value: 'S',
            ),
            PopupMenuItem(
              child: Text('Hapus Data Ini'),
              value: 'H',
            ),
          ],
          onSelected: (value) {
            if (value == 'S') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => PelangganForm(
                            data: d,
                          ))).then((value) {
                if (value == true) refresh();
              });
            } else if (value == 'H') {
              showDialog(
                  context: context,
                  builder: (c) => AlertDialog(
                        content: Text('Pelanggan ${d['nama']} ingin dihapus?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                hapusData(d['id']).then((value) {
                                  if (value == true) refresh();
                                });
                                Navigator.pop(context);
                              },
                              child: const Text('Ya, Saya Yakin Sekali')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Tidak Jadi Hapus"))
                        ],
                      ));
            }
          },
        ),
      );
  Future<bool> hapusData(int id) async {
    final _db = await DBHelper.db();
    final count =
        await _db?.delete('pelanggan', where: 'id=?', whereArgs: [id]);
    return count! > 0;
  }

  Widget tombolTambah() => ElevatedButton(
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (c) => PelangganForm()))
              .then((value) {
            if (value == true) {
              refresh();
            }
          });
        },
        child: const Text("Tambah Pelanggan"),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Pelanggan')),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: () => refresh(),
        child: ListView(
          children: [for (Map d in lisData) item(d)],
        ),
      ),
      floatingActionButton: tombolTambah(),
    );
  }
}
