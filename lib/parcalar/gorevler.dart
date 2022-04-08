class Gorevler {
  final int? id;
  final int yapilacak_id;
  final String? baslik;
  final int? onayla;
  Gorevler({this.id, required this.yapilacak_id, this.baslik, this.onayla});

  Map<String, dynamic> saklanacaklar() {
    return {
      "id": id,
      "yapilacak_id": yapilacak_id,
      "baslik": baslik,
      "onayla": onayla,
    };
  }
}
