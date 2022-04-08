// veritabanını açmak için flutter.dev den gerekli paketleri import etme

import 'package:mobilproje_sezaiunver/parcalar/gorevler.dart';
import 'package:mobilproje_sezaiunver/parcalar/yapilacaklar.dart';
import "package:path/path.dart";
import "package:sqflite/sqflite.dart";

class Veri_tabani {
  Future<Database> veritabani() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'visso_database.db'),
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE yapilacaklar(id  INTEGER PRIMARY KEY AUTOINCREMENT, baslik TEXT, aciklama INTEGER)");
        await db.execute(
            "CREATE TABLE gorevler(id INTEGER PRIMARY KEY, yapilacak_id INTEGER, baslik TEXT, onayla INTEGER)");
      },
      version: 4,
    );
  }

  // veritabanını aktifleştirme
  Future<int?> YapilacakEkle(Yapilacaklar yapilacaklar) async {
    print("Yapılacakları Ekle");
    int? yapilacak_id = 0;
    Database _db = await veritabani();
    // eğer data çakışması olursa üzerine yazması için conflictalgorithm metodunu kullanma
    await _db
        .insert('Yapilacaklar', yapilacaklar.saklanacaklar(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      yapilacak_id = value;
    });
    return yapilacak_id;
  }

  Future<void> basligiGuncelle(int id, String baslik) async {
    print("Başlıgı Guncelle");
    Database _db = await veritabani();
    await _db.rawUpdate(
        "UPDATE yapilacaklar SET baslik = '$baslik' WHERE id = '$id'");
  }

  Future<void> aciklamaGuncelle(int id, String aciklama) async {
    print("Acıklama Guncelle");
    Database _db = await veritabani();
    await _db.rawUpdate(
        "UPDATE yapilacaklar SET aciklama = '$aciklama' WHERE id = '$id'");
  }

  Future<void> GorevEkle(Gorevler gorevler) async {
    print('Gorev Ekle');
    Database _db = await veritabani();
    // eğer data çakışması olursa üzerine yazması için conflictalgorithm metodunu kullanma
    await _db.insert('Gorevler', gorevler.saklanacaklar(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Yapilacaklar>> yapilacaklari_getir() async {
    print("Yapılacakları Getir");
    Database _db = await veritabani();
    List<Map<String, dynamic>> yapilacak_plani =
        await _db.query('Yapilacaklar');
    return List.generate(yapilacak_plani.length, (index) {
      return Yapilacaklar(
          id: yapilacak_plani[index]['id'],
          baslik: yapilacak_plani[index]['baslik'],
          aciklama: yapilacak_plani[index]['aciklama']);
    });
  }

  Future<List<Gorevler>> gorevleri_getir(int yapilacak_id) async {
    print("Görevleri Getir");
    Database _db = await veritabani();
    List<Map<String, dynamic>> gorev_plani = await _db.query('Gorevler',
        where: "yapilacak_id = ?", whereArgs: [yapilacak_id]);
    /* .rawQuery("SELECT * FROM gorevler WHERE yapilacak_id == $yapilacak_id"); */
    return List.generate(gorev_plani.length, (index) {
      return Gorevler(
          id: gorev_plani[index]['id'],
          baslik: gorev_plani[index]['baslik'],
          yapilacak_id: gorev_plani[index]['yapilacak_id'],
          onayla: gorev_plani[index]['onayla']);
    });
  }

  Future<void> gorevguncellemeonayla(int id, int onayla) async {
    print('Görev Guncelle Onayla');
    Database _db = await veritabani();
    await _db
        .rawUpdate("UPDATE gorevler SET onayla = '$onayla' WHERE id = '$id'");
  }

  Future<void> yapilacaksil(int id) async {
    print("Yapılacak Sil");
    Database _db = await veritabani();
    await _db.rawDelete("DELETE FROM yapilacaklar WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM gorevler WHERE yapilacak_id = '$id'");
  }
}
