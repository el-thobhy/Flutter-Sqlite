import 'package:flutter/material.dart';
import 'package:fluttersqlite/helper/dbhelper.dart';
import 'package:intl/intl.dart';

class PelangganForm extends StatefulWidget {
  final Map? data;
  PelangganForm({Key? key, this.data}) : super(key: key);

  @override
  State<PelangganForm> createState() => _PelangganFormState(this.data);
}

class _PelangganFormState extends State<PelangganForm> {
  final Map? data;
  late TextEditingController txtName, txtID, txtTglLahir;
  String gender = '';

  _PelangganFormState(this.data) {
    txtID = TextEditingController(text: '${this.data?['id'] ?? ''}');
    txtName = TextEditingController(text: '${this.data?['nama'] ?? ''}');
    txtTglLahir =
        TextEditingController(text: '${this.data?['tgl_lahir'] ?? ''}');
    gender = this.data?['gender'] ?? '';

    if (this.data == null) {
      lastID().then((value) => {txtID.text = '${value + 1}'});
    }
  }

  Widget txtInputID() => TextFormField(
        controller: txtID,
        readOnly: true,
        decoration: const InputDecoration(labelText: 'ID Pelanggan'),
      );

  Widget txtInputNama() => TextFormField(
        controller: txtName,
        decoration: const InputDecoration(labelText: 'Nama Pelanggan'),
      );

  Widget dropDownGender() => DropdownButtonFormField(
      decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
      isExpanded: true,
      value: gender,
      items: const [
        DropdownMenuItem(
          child: Text('Pilih Gender'),
          value: '',
        ),
        DropdownMenuItem(
          child: Text('Laku-Laki'),
          value: 'L',
        ),
        DropdownMenuItem(
          child: Text('Perempuan'),
          value: 'P',
        ),
      ],
      onChanged: (g) {
        gender = '$g';
      });

  DateTime initTglLahir() {
    try {
      return DateFormat('yyyy-MM-dd').parse(txtTglLahir.value.text);
    } catch (e) {
      return DateTime.now();
    }
  }

  Widget txtInputTglLahir() => TextFormField(
        controller: txtTglLahir,
        readOnly: true,
        decoration: const InputDecoration(labelText: 'Tanggal Lahir'),
        onTap: () async {
          final tgl = await showDatePicker(
              context: context,
              initialDate: initTglLahir(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now());
          if (tgl != null) {
            txtTglLahir.text = DateFormat('yyyy-MM-dd').format(tgl);
          }
        },
      );

  Widget aksiSimpan() => TextButton(
      onPressed: () {
        simpanData().then((h) {
          var pesan = h == true ? 'Sukses Simpan' : 'Gagal Simpan';

          showDialog(
              context: context,
              builder: (bc) => AlertDialog(
                    title: const Text('Simpan Pelanggan'),
                    content: Text('$pesan'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Oke')),
                    ],
                  )).then((value) {
            Navigator.pop(context, h);
          });
          // .then((value) => Navigator.pop(context));
        });
      },
      child: const Text(
        'Simpan',
        style: TextStyle(color: Colors.black),
      ));

  Future<int> lastID() async {
    try {
      final _db = await DBHelper.db();
      const query = 'SELECT MAX(id) as id FROM pelanggan';
      final ls = (await _db?.rawQuery(query))!;

      if (ls.isNotEmpty) {
        return int.tryParse('${ls[0]['id']}') ?? 0;
      }
    } catch (e) {
      print('error lastid $e');
    }
    return 0;
  }

  Future<bool> simpanData() async {
    try {
      final _db = await DBHelper.db();
      var data = {
        'id': txtID.value.text,
        'nama': txtName.value.text,
        'gender': gender,
        'tgl_lahir': txtTglLahir.value.text
      };

      final id = this.data == null
          ? await _db?.insert('pelanggan', data)
          : await _db?.update('pelanggan', data,
              where: 'id=?', whereArgs: [this.data?['id']]);
      return id! > 0;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Pelanggan'),
        actions: [aksiSimpan()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(children: [
          txtInputID(),
          txtInputNama(),
          dropDownGender(),
          txtInputTglLahir()
        ]),
      ),
    );
  }
}
