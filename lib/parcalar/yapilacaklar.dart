class Yapilacaklar {
  final int? id;
  final String? baslik;
  final String? aciklama;

  // constructor oluşturduk id başlık ve açıklamalar için
  Yapilacaklar({this.id, this.baslik, this.aciklama});

  // onları da bir sözlük şeklinde sakladık
  Map<String, dynamic> saklanacaklar() {
    return {
      "id": id,
      "baslik": baslik,
      "aciklama": aciklama,
    };
  }
}
