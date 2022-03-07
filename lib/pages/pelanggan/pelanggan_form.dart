import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PelangganForm extends StatefulWidget {
  const PelangganForm({Key? key}) : super(key: key);

  @override
  State<PelangganForm> createState() => _PelangganFormState();
}

class _PelangganFormState extends State<PelangganForm> {
  late TextEditingController txtName, txtID, txtTglLahir;
  String gender = '';

  _PelangganFormState() {
    txtID = TextEditingController();
    txtName = TextEditingController();
    txtTglLahir = TextEditingController();
  }

  Widget txtInputID() => TextFormField(
        controller: txtID,
        readOnly: true,
        decoration: const InputDecoration(labelText: 'ID Pelanggan'),
      );

  Widget txtInputNama() => TextFormField(
        controller: txtID,
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
      onPressed: () {},
      child: const Text(
        'Simpan',
        style: TextStyle(color: Colors.black),
      ));

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
