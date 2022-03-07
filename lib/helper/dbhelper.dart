import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  // ignore: constant_identifier_names
  static const String QUERY_TABLE_PELANGGAN = """
  CREATE TABLE pelanggan(
    id INTEGER PRIMARY KEY,
    nama TEXT,
    gender TEXT,
    tgl_lahir TEXT
  )""";

  //method static untuk akses variabel _db
  static Future<Database?> db() async {
    return _db ??= (await DBHelper().connectDB());
  }

  //method untuk koneksi ke file database sqlite
  Future<Database> connectDB() async {
    return await openDatabase('dbsaya.db', version: 1, onCreate: (db, version) {
      db.execute(QUERY_TABLE_PELANGGAN);
    });
  }
}
