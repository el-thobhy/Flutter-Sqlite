import 'package:flutter/material.dart';
import 'package:fluttersqlite/helper/dbhelper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PelangganList extends StatefulWidget {
  const PelangganList({Key? key}) : super(key: key);

  @override
  State<PelangganList> createState() => _PelangganListState();
}

class _PelangganListState extends State<PelangganList> {
  RefreshController _refreshController =
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Data Pelanggan')),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: () => refresh(),
        child: ListView(
          children: [for (Map d in lisData) item(d)],
        ),
      ),
    );
  }
}
