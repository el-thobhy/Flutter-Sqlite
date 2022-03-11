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
        // onLongPress: (() {
        //   showMenu(
        //     context: context,
        //     position: RelativeRect.fromLTRB(100, MediaQuery.of(context).size.height / 2, 100, 0),
        //     items: [
        //       PopupMenuItem(child: Text('Sunting data Ini'))
        //     ]
        //     );
        // },
        title: Text('${d['nama']}'),
        trailing: Text('${d['gender']}'),
        subtitle: Text('${d['tgl_lahir']}'),
      );
  Widget tombolTambah() => ElevatedButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const PelangganForm()))
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
