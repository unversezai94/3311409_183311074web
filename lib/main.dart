import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobilproje_sezaiunver/ekranlar/anaekran.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          // kullanılacak font seçildi
          textTheme: GoogleFonts.nunitoSansTextTheme(
        Theme.of(context).textTheme,
      )),
      home: AnaEkran(),
    );
  }
}
