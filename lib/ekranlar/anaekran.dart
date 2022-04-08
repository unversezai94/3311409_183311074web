import 'package:flutter/material.dart';
import 'package:mobilproje_sezaiunver/ekranlar/yapilacaklar_ekrani.dart';
import 'package:mobilproje_sezaiunver/parcalar/yapilacaklar.dart';
import 'package:mobilproje_sezaiunver/veritabani.dart';
import 'package:mobilproje_sezaiunver/widgets.dart';

class AnaEkran extends StatefulWidget {
  const AnaEkran({Key? key}) : super(key: key);

  @override
  State<AnaEkran> createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {
  Veri_tabani _db = Veri_tabani();
  var yapilacaklar;
  @override
  void initState() {
    getTodos();
    super.initState();
  }

  Future<List<Yapilacaklar>> getTodos() async {
    return await _db.yapilacaklari_getir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            // ekranı kaplaması için double
            width: double.infinity,
            // logoyu ekrana yerleştirmek
            padding: EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            // arkaplan rengi belirleme
            color: Color(0xFFdeddd9),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // logonun alt ve üst pencereye uzaklığı ayarlama
                      margin: EdgeInsets.only(
                        top: 30.0,
                        bottom: 30.0,
                      ),
                      child: Image(
                        // logoyu yerleştirme
                        image: AssetImage('assets/resimler/logo.png'),
                      ),
                    ),
                    // listeleme yapmak için genişletme
                    Expanded(
                      child: FutureBuilder(
                        initialData: yapilacaklar,
                        future: getTodos(),
                        builder: (context, AsyncSnapshot snapshot) {
                          return ScrollConfiguration(
                            behavior: NoGlowBehaviour(),
                            child: snapshot.connectionState ==
                                    ConnectionState.waiting
                                ? Container()
                                : ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Yapilacaklar_ekrani(
                                                yapilacaklar:
                                                    snapshot.data[index],
                                              ),
                                            ),
                                          ).then(
                                            (value) {
                                              setState(() {});
                                            },
                                          );
                                        },
                                        child: YaziWidget(
                                          baslik: snapshot.data[index].baslik,
                                          aciklama:
                                              snapshot.data[index].aciklama,
                                        ),
                                      );
                                    },
                                  ),
                          );
                        },
                      ),
                    )
                  ],
                ),
                Positioned(
                  // ekleme tuşunun pozisyonu
                  bottom: 0.0,
                  right: 0.0,
                  // tıklama kontrolü
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Yapilacaklar_ekrani(
                            yapilacaklar: null,
                          ),
                        ),
                      ).then((value) {
                        setState(() {});
                      });
                    },
                    child: Container(
                      // tuşun büyüklüğü
                      width: 80.0,
                      height: 100.0,

                      child: Image(
                        image: AssetImage("assets/resimler/add_icon.png"),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
