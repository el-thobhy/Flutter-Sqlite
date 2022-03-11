import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttersqlite/helper/dbhelper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PelangganCari extends StatefulWidget {
  const PelangganCari({Key? key}) : super(key: key);

  @override
  State<PelangganCari> createState() => _PelangganCariState();
}

class _PelangganCariState extends State<PelangganCari> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  List listData = [];

  void pencarian(String keyword) async {
    final _db = await DBHelper.db();
    final sql = 'SELECT * FROM pelanggan WHERE nama like ?';
    listData = (await _db?.rawQuery(sql, ['%$keyword%']))!;
    _refreshController.refreshCompleted();
    setState(() {});
  }

  Widget item(Map d) => ListTile(
        title: Text('${d['nama']}'),
        subtitle: Text('${d['tgl_lahir']}'),
        leading: Text('${d['gender']}'),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black54),
        backgroundColor: Colors.white,
        elevation: 1,
        title: CupertinoSearchTextField(
          placeholder: 'Cari Pelanggan',
          onSubmitted: (s) {
            pencarian(s);
          },
        ),
      ),
      body: ListView(
        children: [for (Map d in listData) item(d)],
      ),
    );
  }
}
