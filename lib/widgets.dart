import 'package:flutter/material.dart';

class YaziWidget extends StatelessWidget {
  // farklı widgetlara farklı başlıklar ve açıklamalar yazmak için constructor oluşturma
  final String? baslik;
  final String? aciklama;
  YaziWidget({this.baslik, this.aciklama});


  @override
  Widget build(BuildContext context) {
    return Container(
      // kutunun ekranı kaplaması
      width: double.infinity,
      // padding işlemi
      padding: EdgeInsets.symmetric(
        vertical: 32.0,
        horizontal: 24.0,
      ),
      // yazı kutusunun şekli, yeri, rengi gibi işlevleri
      margin: EdgeInsets.only(
        bottom: 20.0
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      // yazının özellikleri
      child: Column(
        // satır başına almak için
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik ?? "(Adsız Görev)",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,

            ),
          ),
          Padding(
            // Başlıkla açıklama arasına daha iyi görünmesi için boşluk
            padding: EdgeInsets.only(
              top: 12.0,
            ),
            child: Text(
                aciklama ?? "Açıklama Yok",
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFFa3a3a0),
                height: 1.2,
              )

            ),
          )
        ],
      ),
    );
  }
}

class YapilacaklarWidget extends StatelessWidget {
  final String? yazi;
  final bool onayla;
  YapilacaklarWidget({this.yazi, required this.onayla});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 5.0,
      ),
      child: Row(
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            margin: EdgeInsets.only(
              right: 2.0
            ),
            decoration: BoxDecoration(
              color :  Colors.transparent,
            ),
            child: Image(
              image: AssetImage(
                onayla ? "assets/resimler/check_icon.png" : "assets/resimler/uncheck_icon.png"
              ),
            ),
          ),
          Flexible(
            child: Text(
                yazi ?? "(Boş Görev)",
                style: TextStyle(
                  color: onayla ?  Colors.black54: Colors.black38,
                  fontSize: 16.0,
                  fontWeight: onayla ? FontWeight.bold : FontWeight.normal,
                )
            ),
          ),
        ],
      ),
    );
  }
}


// ekranı çekerken oluşan mavi parlamaları yok etmek için araştırıp bulduğum kod parçası
class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildviewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }

}
