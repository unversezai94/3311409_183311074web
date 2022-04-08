import 'package:flutter/material.dart';
import 'package:mobilproje_sezaiunver/parcalar/gorevler.dart';
import 'package:mobilproje_sezaiunver/parcalar/yapilacaklar.dart';
import 'package:mobilproje_sezaiunver/veritabani.dart';
import 'package:mobilproje_sezaiunver/widgets.dart';

class Yapilacaklar_ekrani extends StatefulWidget {
  final Yapilacaklar? yapilacaklar;
  Yapilacaklar_ekrani({@required this.yapilacaklar});

  @override
  State<Yapilacaklar_ekrani> createState() => _Yapilacaklar_ekraniState();
}

class _Yapilacaklar_ekraniState extends State<Yapilacaklar_ekrani> {
  Veri_tabani _db = Veri_tabani();

  int _yapilacak_id = 0;
  String? _yapilacakbaslik = "";
  String? _yapilacakaciklama = "";

  // bir başlığı onayladıktan sonra otomatik diğerine geçmesi için FocusNode
  FocusNode? _baslikFocus;
  FocusNode? _aciklamaFocus;
  FocusNode? _gorevFocus;

  // yeni bir başlık oluştururken olmayan başlıkların görünmez olması için
  bool _gorunurluk = false;

  @override
  void initState() {
    if (widget.yapilacaklar != null) {
      // görünürlüğü true yapma
      _yapilacak_id = widget.yapilacaklar!.id!;
      print(_gorunurluk);
      print(_yapilacakbaslik);
      print(_yapilacakaciklama);
      print(_yapilacak_id);
      _gorunurluk = true;
      _yapilacakbaslik = widget.yapilacaklar?.baslik;
      _yapilacakaciklama = widget.yapilacaklar?.aciklama;
      //_yapilacak_id = widget.yapilacaklar!.id;
    }

    _baslikFocus = FocusNode();
    _aciklamaFocus = FocusNode();
    _gorevFocus = FocusNode();

    super.initState();
  }

  // dizmek için dispose metodu
  @override
  void dispose() {
    _baslikFocus?.dispose();
    _aciklamaFocus?.dispose();
    _gorevFocus?.dispose();

    super.dispose();
  }

  Future<void> gorevEkle(String value) async {
    if (value != "") {
      if (_yapilacak_id != 0) {
        Veri_tabani _db = Veri_tabani();
        Gorevler _yenigorev = Gorevler(
          baslik: value,
          onayla: 0,
          yapilacak_id: _yapilacak_id,
        );
        await _db.GorevEkle(_yenigorev);

        _gorevFocus?.requestFocus();
      } else {
        print(_yapilacak_id);
      }
    } else {
      print("Görev boş");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color(0xFFdeddd9),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // yatay yapılandırma
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24.0,
                      bottom: 2.0,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Image(
                              image: AssetImage(
                                  "assets/resimler/back_arrow_icon.png"),
                            ),
                          ),
                        ),
                        Expanded(
                          // başlık yazmak için input kutusu
                          child: TextField(
                              focusNode: _baslikFocus,
                              onSubmitted: (value) async {
                                if (value != "") {
                                  if (_yapilacak_id == 0) {
                                    Yapilacaklar _yeniyapilacak = Yapilacaklar(
                                      baslik: value,
                                    );
                                    _yapilacak_id =
                                        await _db.YapilacakEkle(_yeniyapilacak)
                                            as int;
                                    setState(() {
                                      _gorunurluk = true;
                                      _yapilacakbaslik = value;
                                      _yapilacak_id = _yapilacak_id;
                                    });
                                    print("Yeni yapilacak id: $_yapilacak_id");
                                  } else {
                                    _db.basligiGuncelle(_yapilacak_id, value);
                                    print("Yapılacak güncellendi.");
                                  }

                                  _aciklamaFocus?.requestFocus();
                                }
                              },
                              controller: TextEditingController()
                                ..text = _yapilacakbaslik!,
                              decoration: InputDecoration(
                                hintText: "Görev başlığını giriniz...",
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              )),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: true,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: TextField(
                        focusNode: _aciklamaFocus,
                        onSubmitted: (value) async {
                          if (value != "") {
                            if (_yapilacak_id != 0) {
                              await _db.aciklamaGuncelle(_yapilacak_id, value);
                              _yapilacakaciklama = value;
                            }
                          }
                          _gorevFocus?.requestFocus();
                        },
                        controller: TextEditingController()
                          ..text = _yapilacakaciklama ?? "",
                        decoration: InputDecoration(
                            hintText: "Görevin ayrıntılarını giriniz...",
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 24.0)),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: true,
                    child: FutureBuilder(
                        initialData: [],
                        future: _db.gorevleri_getir(_yapilacak_id),
                        builder: (context, AsyncSnapshot snapshot) {
                          return Expanded(
                            child: snapshot.connectionState ==
                                    ConnectionState.waiting
                                ? Container()
                                : snapshot.data == null
                                    ? const Text("Görev ekleyiniz")
                                    : ListView.builder(
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () async {
                                              if (snapshot.data[index].onayla ==
                                                  0) {
                                                await _db.gorevguncellemeonayla(
                                                    snapshot.data[index].id, 1);
                                              } else {
                                                await _db.gorevguncellemeonayla(
                                                    snapshot.data[index].id, 0);
                                              }
                                              setState(() {});
                                            },
                                            child: YapilacaklarWidget(
                                              yazi: snapshot.data[index].baslik,
                                              onayla:
                                                  snapshot.data[index].onayla ==
                                                          0
                                                      ? false
                                                      : true,
                                            ),
                                          );
                                        }),
                          );
                        }),
                  ),
                  Visibility(
                    visible: true,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40.0,
                            height: 40.0,
                            margin: EdgeInsets.only(right: 2.0),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Image(
                              image: AssetImage(
                                  "assets/resimler/uncheck_icon.png"),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: _gorevFocus,
                              controller: TextEditingController()..text = "",
                              onSubmitted: (value) => gorevEkle(value),
                              decoration: const InputDecoration(
                                hintText: "Görev ekle..",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: true,
                child: Positioned(
                  // silme tuşunun pozisyonu
                  bottom: 0.0,
                  right: 24.0,
                  // tıklama kontrolü
                  child: GestureDetector(
                    onTap: () async {
                      if (_yapilacak_id != 0) {
                        await _db.yapilacaksil(_yapilacak_id);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      // tuşun yerleşimi
                      width: 80.0,
                      height: 100.0,

                      child: Image(
                        image: AssetImage("assets/resimler/delete_icon.png"),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
