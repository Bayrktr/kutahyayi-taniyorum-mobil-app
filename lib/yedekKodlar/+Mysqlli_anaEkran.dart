import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:okulprojesi/101.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:typed_data';
import '202.dart';
import 'package:google_fonts/google_fonts.dart';
import 'function.dart';
import 'package:like_button/like_button.dart';

void main() {
  runApp(dilSecimiEkrani());
}

class dilSecimiEkrani extends StatefulWidget {
  // widget class

  const dilSecimiEkrani({Key? key}) : super(key: key);

  @override
  _dilSecimiEkrani createState() => _dilSecimiEkrani();
}

class _dilSecimiEkrani extends State<dilSecimiEkrani> {
  final dilKaynak Keys = dilKaynak();
  List<bool> dilSecim = [true, false, false];
  String dilSecimYazi = 'Select Language';
  List<String> dilSecimYazilar = ['Devam et', 'Go On', 'Mach Weiter'];
  String secilenDil = '';
  var secilenDilYaziRengi = Colors.white;
  var birincibayrakRengi = LinearGradient(colors: [Colors.white, Colors.red]);
  var ikincibayrakRengi =
  LinearGradient(colors: [Colors.black, Colors.red, Colors.yellow]);
  var ucuncubayrakRengi =
  LinearGradient(colors: [Colors.white, Colors.red, Colors.blueAccent]);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(decoration: new BoxDecoration(color: Colors.white)),
        Positioned(
          left: 60,
          top: 275,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              "Select Language",
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 20,
                  color: Colors.white,
                  decoration: TextDecoration.none),
            ),
            margin: const EdgeInsets.all(10.0),
            width: 250.0,
            height: 50.0,
            decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(20.0)),
          ),
        ),
        Positioned(
            top: 100,
            left: 90,
            child: DefaultTextStyle(
              child: Text("EXPLORE  KUTAHYA"),
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.blue,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            )),
        Positioned(
            top: 155,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: Image.asset(
                'lib/Kaynaklar/anamenu.jpg',
                cacheWidth: 450,
                cacheHeight: 625,
              ),
            )),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(),
            child: FlatButton(
                onPressed: () {
                  setState(() {
                    dilSecimYazi = dilSecimYazilar[0];
                    secilenDil = 'turkiye';
                    secilenDilYaziRengi = Colors.red;
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    dilKaynak.dilResimler[0],
                    height: 75.0,
                    width: 100.0,
                  ),
                )),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: FlatButton(
              onPressed: () {
                setState(() {
                  dilSecimYazi = dilSecimYazilar[2];
                  secilenDil = 'almanya';
                  secilenDilYaziRengi = Colors.red;
                });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  dilKaynak.dilResimler[1],
                  height: 75.0,
                  width: 100.0,
                ),
              )),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: FlatButton(
              onPressed: () {
                setState(() {
                  dilSecimYazi = dilSecimYazilar[1];
                  secilenDil = 'ingiltere';
                  secilenDilYaziRengi = Colors.red;
                });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  dilKaynak.dilResimler[2],
                  height: 75.0,
                  width: 100.0,
                ),
              )),
        ),
        Positioned(
          child: Container(
            alignment: Alignment.center,
            child: FlatButton(
                onPressed: () async {
                  if (secilenDil == '') {
                    setState(() {
                      dilSecimYazi = 'Language Not Selected';
                    });
                  } else {
                    int number = 0;
                    print('dil: $secilenDil   ');
                    dynamic content = await readKutahyaFiles(secilenDil);
                    print(content);
                    final db = await dbConnectSystem();
                    var results = await event_datas(db, secilenDil);
                    for (var x in results) {
                      number += 1;
                    }
                    print(arkaPlanYazilari
                        .kutahyaTanitimEkraniYazilar[secilenDil]);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => anasayfaIki(
                              dil: secilenDil,
                              files: content,
                              anaEkranYazilar: arkaPlanYazilari
                                  .kutahyaTanitimEkraniYazilar[secilenDil],
                              anaEkranKaynaklar: results,
                              number: number,
                            )));
                  }
                },
                child: Text(dilSecimYazi, style: TextStyle(fontSize: 15))),
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: secilenDilYaziRengi,
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          width: 200.0,
          height: 50.0,
          top: 300,
          left: 85,
        )
      ],
    );
  }
}

class anasayfaIki extends StatefulWidget {
  anasayfaIki(
      {Key,
        this.dil,
        this.files,
        this.anaEkranYazilar,
        this.anaEkranKaynaklar,
        this.number});

  final dil;
  final files;
  final anaEkranYazilar;
  final anaEkranKaynaklar;
  final number;

  @override
  _anaSayfaIki createState() => _anaSayfaIki();
}

class _anaSayfaIki extends State<anasayfaIki> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 65.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        flexibleSpace: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Text(
                  "EXPLORE KUTAHYA",
                  style: TextStyle(
                    color: Colors.blue,
                    fontStyle: FontStyle.italic,
                    wordSpacing: 5,
                    letterSpacing: 1,
                  ),
                ),
                Wrap(
                  spacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    ButtonTheme(
                      minWidth: 12,
                      height: 12,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => tarihiYerler(
                                  dil: widget.dil,
                                  yazilar: widget.anaEkranYazilar[1],
                                )),
                          );
                        },
                        padding: EdgeInsets.all(2.0),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.museum_outlined,
                              size: 20,
                              color: Colors.blue,
                            ),
                            Text(
                              widget.anaEkranYazilar[1],
                              style: TextStyle(fontSize: 8, color: Colors.blue),
                            )
                          ],
                        ),
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 12,
                      height: 12,
                      child: FlatButton(
                        onPressed: () {
                          print("sa");
                        },
                        padding: EdgeInsets.all(3.0),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              MdiIcons.shopping,
                              size: 20,
                              color: Colors.blue,
                            ),
                            Text(
                              widget.anaEkranYazilar[2],
                              style: TextStyle(fontSize: 8, color: Colors.blue),
                            )
                          ],
                        ),
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 12,
                      height: 12,
                      child: FlatButton(
                          onPressed: () {
                            print("sa");
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(
                                MdiIcons.bed,
                                size: 20,
                                color: Colors.blue,
                              ),
                              Text(
                                widget.anaEkranYazilar[3],
                                style:
                                TextStyle(fontSize: 8, color: Colors.blue),
                              )
                            ],
                          )),
                    ),
                    ButtonTheme(
                      minWidth: 12,
                      height: 12,
                      child: FlatButton(
                        onPressed: () {
                          print("sa");
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.fastfood_sharp,
                              size: 20,
                              color: Colors.blue,
                            ),
                            Text(
                              widget.anaEkranYazilar[4],
                              style: TextStyle(fontSize: 8, color: Colors.blue),
                            )
                          ],
                        ),
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 12,
                      height: 12,
                      child: Column(
                        children: <Widget>[
                          Icon(
                            MdiIcons.glassWine,
                            size: 20,
                            color: Colors.blue,
                          ),
                          Text(
                            widget.anaEkranYazilar[5],
                            style: TextStyle(fontSize: 8, color: Colors.blue),
                          )
                        ],
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 12,
                      height: 12,
                      child: FlatButton(
                          onPressed: () {
                            List<String> contents = chooseContents(widget.dil);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => anaSayfa(
                                      dil: 'ingiltere',
                                      yazilar: contents,
                                    )));
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(
                                MdiIcons.school,
                                size: 20,
                                color: Colors.blue,
                              ),
                              Text(
                                widget.anaEkranYazilar[6],
                                style:
                                TextStyle(fontSize: 8, color: Colors.blue),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          SizedBox(
            height: 30,
            child: TextField(
              onChanged: (value) {},
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 2.0),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                labelText:
                '                                                  ${widget.anaEkranYazilar[7]}',
                labelStyle: TextStyle(fontSize: 13, color: Colors.white),
                hintText: '',
                fillColor: Colors.grey,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(13.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            height: 650.0,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.number,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        width: 350,
                        height: 225,
                        alignment: Alignment.center,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => mainPageContents(
                                      kaynaklar:
                                      widget.anaEkranKaynaklar[index],
                                    )));
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                  '${widget.anaEkranKaynaklar[index][3]}',
                                  cacheWidth: 500,
                                  cacheHeight: 250),
                              Padding(padding: EdgeInsets.all(5.0)),
                              Text(
                                "${widget.anaEkranKaynaklar[index][0]}",
                                style: GoogleFonts.fjallaOne(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(5.0))
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class anaSayfa extends StatefulWidget {
  anaSayfa({Key, this.dil, this.kaynak, this.yazilar});

  final dil;
  final kaynak;
  final yazilar;

  @override
  _anaSayfa createState() => _anaSayfa();
}

class _anaSayfa extends State<anaSayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: BackButton(color: Colors.blue),
        toolbarHeight: 65.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Text(
                  "${widget.yazilar[5]}",
                  style: TextStyle(
                    color: Colors.blue,
                    fontStyle: FontStyle.italic,
                    wordSpacing: 5,
                    letterSpacing: 1,
                  ),
                ), // set an icon or image
              ],
            ),
          ),
        ),
      ),
      body: Wrap(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            height: 650.0,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Align(
                  child: Image.asset(
                    'lib/Kaynaklar/NecipFazilResim.jpg',
                    cacheWidth: 400,
                    cacheHeight: 250,
                  ),
                ),
                Text(''),
                Text(
                    '${widget.yazilar[0]}  =  ${arkaPlanYazilari.bilgiler[0]}'),
                Text(''),
                Text(
                    '${widget.yazilar[1]}  =  ${arkaPlanYazilari.bilgiler[1]}'),
                Text(''),
                Text(
                    '${widget.yazilar[2]}  =  ${arkaPlanYazilari.bilgiler[2]}'),
                Text(''),
                Text(
                    '${widget.yazilar[3]}  =  ${arkaPlanYazilari.bilgiler[3]}'),
                Text(''),
                Text(
                    '${widget.yazilar[4]}  =  ${arkaPlanYazilari.bilgiler[4]}'),
                Text(''),
                Align(
                    child: Container(
                      color: Colors.blue,
                      child: FlatButton(
                        onPressed: () {
                          launchURL(
                              'https://www.ortaogretim.net/kutahya-lise-taban-puanlari-ve-yuzdelik-dilimleri/');
                        },
                        child: Text(widget.yazilar[6]),
                      ),
                    )),
                Row(
                  children: [
                    Expanded(
                      child: IconButton(
                          onPressed: () {
                            launchURL(
                                'https://tr-tr.facebook.com/kutahyanecipfazilkisakurekanadolulisesi/');
                          },
                          icon: Icon(Icons.facebook)),
                    ),
                    Expanded(
                      child: IconButton(
                          onPressed: () {
                            launchURL(
                                'https://www.instagram.com/explore/locations/319579138410793/turkey/kutahya/necip-fazl-ksakurek-anadolu-lisesi-kutahya/');
                          },
                          icon: Icon(MdiIcons.instagram)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class tarihiYerler extends StatefulWidget {
  tarihiYerler({Key, this.dil, this.yazilar});

  final yazilar;
  final dil;
  final metinTurkce Keys = metinTurkce();
  final metinIngilizce KeysIki = metinIngilizce();
  final ScrollBarResimler resimler = ScrollBarResimler();

  @override
  _tarihiYerler createState() => _tarihiYerler();
}

class _tarihiYerler extends State<tarihiYerler> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.blue,
              size: 24,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          toolbarHeight: 26,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text('${widget.yazilar}',
              style: TextStyle(color: Colors.blue, fontSize: 17)),
          bottom: TabBar(
            indicatorColor: Colors.blue,
            indicatorWeight: 4,
            labelPadding: EdgeInsets.all(3),
            tabs: [
              Text('${chooseHistoricPlaceTexts(widget.dil)[0]}',
                  style: TextStyle(color: Colors.blue, fontSize: 17)),
              Text('${chooseHistoricPlaceTexts(widget.dil)[1]}',
                  style: TextStyle(color: Colors.blue, fontSize: 17)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            historicPlaceClick(
              dil: widget.dil,
            ),
            MapsPlaceClick(
              dil: widget.dil,
            )
          ],
        ),
      ),
    );
  }
}

class Register extends StatefulWidget {
  Register(
      {Key,
        this.dil,
        this.isim,
        this.kaynak,
        this.resim,
        this.resimIki,
        this.resimUc,
        this.url,
        this.reIsim});

  final kaynak;
  final resim;
  final isim;
  final resimIki;
  final resimUc;
  final dil;
  final url;
  final reIsim;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.blue),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            widget.isim,
            style: TextStyle(
                color: Colors.blue,
                fontStyle: FontStyle.italic,
                wordSpacing: 5,
                letterSpacing: 1,
                fontSize: 14),
          ),
          flexibleSpace: SafeArea(
            child: Container(
              color: Colors.white,
              child: Wrap(
                children: [
                  Padding(padding: EdgeInsets.only(left: 160.0)),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () async {
                        await player.setAsset(
                            'lib/${widget.dil}fon/${deleteSpaceOnWord(widget.reIsim)}.mp3');
                        player.play();
                      },
                      icon: Icon(Icons.record_voice_over),
                      color: Colors.blue,
                      iconSize: 27,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: Wrap(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              height: 650.0,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  Text(
                    '${widget.kaynak}',
                    style: GoogleFonts.robotoSlab(),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    height: 150.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Image.asset(
                          widget.resim,
                          alignment: Alignment.center,
                        ),
                        Padding(padding: EdgeInsets.only(left: 5.0)),
                        Image.asset(
                          widget.resimIki,
                          alignment: Alignment.center,
                        ),
                        Padding(padding: EdgeInsets.only(left: 5.0)),
                        Image.asset(
                          widget.resimUc,
                          alignment: Alignment.center,
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      launchURL(widget.url);
                    },
                    child: Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35.0),
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            )),
                        child: Align(
                            child: Text("${chooseGoogleMapsName(widget.dil)}")),
                        alignment: Alignment.center),
                  ),
                  Padding(padding: EdgeInsets.all(20.0))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

chooseHistoricPlaceTexts(dil) {
  if (dil == 'turkiye') {
    return arkaPlanYazilari.muzeYazilari[0];
  }
  if (dil == 'ingiltere') {
    return arkaPlanYazilari.muzeYazilari[1];
  }
  if (dil == 'almanya') {
    return arkaPlanYazilari.muzeYazilari[2];
  }
}

deleteSpaceOnWord(word) {
  String otherWord = "";
  List<String> words = word.toString().split(" ");
  for (String x in words) {
    otherWord += x;
  }
  print(otherWord);
  return otherWord;
}

readKutahyaFiles(dil) async {
  return await rootBundle.loadString('lib/Kaynaklar/tanitim${dil}.txt');
}

chooseContents(dil) {
  List<String> flag = [];
  if (dil == 'turkiye') {
    return [
      arkaPlanYazilari.anaEkranYazilar[0][0],
      arkaPlanYazilari.anaEkranYazilar[1][0],
      arkaPlanYazilari.anaEkranYazilar[2][0],
      arkaPlanYazilari.anaEkranYazilar[3][0],
      arkaPlanYazilari.anaEkranYazilar[4][0],
      arkaPlanYazilari.anaEkranYazilar[5][0],
      arkaPlanYazilari.anaEkranYazilar[6][0],
    ];
  } else if (dil == 'ingiltere') {
    return [
      arkaPlanYazilari.anaEkranYazilar[0][1],
      arkaPlanYazilari.anaEkranYazilar[1][1],
      arkaPlanYazilari.anaEkranYazilar[2][1],
      arkaPlanYazilari.anaEkranYazilar[3][1],
      arkaPlanYazilari.anaEkranYazilar[4][1],
      arkaPlanYazilari.anaEkranYazilar[5][1],
      arkaPlanYazilari.anaEkranYazilar[6][1],
    ];
  } else if (dil == 'almanya') {
    return [
      arkaPlanYazilari.anaEkranYazilar[0][2],
      arkaPlanYazilari.anaEkranYazilar[1][2],
      arkaPlanYazilari.anaEkranYazilar[2][2],
      arkaPlanYazilari.anaEkranYazilar[3][2],
      arkaPlanYazilari.anaEkranYazilar[4][2],
      arkaPlanYazilari.anaEkranYazilar[5][2],
      arkaPlanYazilari.anaEkranYazilar[6][2],
    ];
  } else {
    for (int i = 0; i < arkaPlanYazilari.anaEkranYazilar.length; i += 1) {
      flag.add('None');
    }
  }
}

Future fetchFileData(place, dil) async {
  return rootBundle
      .loadString('lib/Kaynaklar/${place}/${place}metin${dil}.txt');
}

chooseTitle(dil, index) {
  if (dil == 'turkiye' || dil == 'almanya') {
    return metinTurkce.metinturk[index][0];
  } else {
    return metinIngilizce.metinIngiliz[index][0];
  }
}

chooseGoogleMapsName(dil) {
  if (dil == 'turkiye') {
    return arkaPlanYazilari.yazilar[0];
  } else if (dil == 'almanya') {
    return arkaPlanYazilari.yazilar[2];
  } else if (dil == 'ingiltere') {
    return arkaPlanYazilari.yazilar[1];
  } else {
    return '';
  }
}

void launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print("not working");
  }
}

class dilKaynak {
  static var dilResimler = [
    'lib/Kaynaklar/turkiye.png',
    'lib/Kaynaklar/almanya.png',
    'lib/Kaynaklar/ingiltere.png',
    'lib/Kaynaklar/vazo.jpg'
  ];
}

class arkaPlanYazilari {
  static var yazilar = [
    'Yol tarifi için tıklayınız',
    'Click for directions',
    'Klicken Sie für eine Wegbeschreibung',
  ];
  static var kutahyaTanitimEkraniYazilar = {
    'turkiye': [
      'Profil',
      'Müzeler',
      'Alışveriş',
      'Pansiyon',
      'Yemek',
      'Etkinlikler',
      'Okulumuz',
      'Arama Yap',
      'Kaydedilenler'
    ],
    'almanya': [
      'Profil',
      'Museen',
      'Einkaufen',
      'Herberge',
      'Essen',
      'Aktivität ',
      'Schule',
      'Nachschlagen',
      'Verzeichnet'
    ],
    'ingiltere': [
      'profile',
      'museums',
      'shopping',
      'hostel',
      'food',
      'Events',
      'Own School',
      'Search up',
      'Recorded'
    ],
  };

  static var muzeYazilari = [
    ['Liste', 'Harita'],
    ['List', 'Map'],
    ['Aufführen', 'Karte']
  ];

  static var anaEkranYazilar = [
    ['Telefon', 'Phone', 'Das Telephon'],
    ['Belgegeçer', 'Documentpass', 'Dokumentenpass'],
    [
      'Eposta',
      'Email',
      'Email',
    ],
    [
      'Web',
      'Web',
      'Web',
    ],
    ['Adres', 'Location', 'Die Anschrift'],
    [
      'Necip Fazıl Kısakurek Anadolu Lisesi',
      'Necip Fazil Kısakurek Anatolian High School',
      'Necip Fazil Kısakurek Anatolisches Gymnasium',
    ],
    [
      'Yüzdelik Dilim ve Taban Puan için tıklayınız',
      'Click for Percentile and Base Score',
      'Klicken Sie für Perzentil und Basiswert',
    ]
  ];
  static var bilgiler = [
    '0274 224 86 78',
    '0274 224 86 79',
    'None',
    'https://kutahyanecipfazil.meb.k12.tr',
    'Cumhuriyet Mah.Mevlana Cad.No 15 Çevre Yolu Yanı / KÜTAHYA',
  ];
}

class metinTurkce {
  static var metinturk = [
    [
      'Ulu Cami',
      'lib/Kaynaklar/UluCami/UluCamiResim.jpg',
      'https://www.google.com/maps/dir/39.418952, 29.986621/kutahya+ulu+cami/@39.4269732,29.9483725,14z/data=!3m1!4b1!4m9!4m8!1m1!4e1!1m5!1m1!1s0x14c94809b50210a3:0xf5367936e8e53ff8!2m2!1d29.9758333!2d39.4172222',
    ],
    [
      'Donenler Cami',
      'lib/Kaynaklar/DonenlerCami/DonenlerCamiResim.jpg',
      'https://www.google.com/maps/dir/39.418952, 29.986621/kutahya+donenler+cami/@39.4269732,29.9483725,14z/data=!3m1!4b1!4m9!4m8!1m1!4e1!1m5!1m1!1s0x14c94809a968f0c1:0x5894904fab71aedf!2m2!1d29.9763075!2d39.4173277?hl=tr'
    ],
    [
      'Vacidiye Medresesi',
      'lib/Kaynaklar/VacidiyeMedresesi/VacidiyeMedresesiResim.jpg',
      'https://www.google.com/maps/dir/39.418952, 29.986621/k%C3%BCtahya+vacidiye+medresesi/@39.4269732,29.9483725,14z/data=!3m1!4b1!4m9!4m8!1m1!4e1!1m5!1m1!1s0x14c9486d6ceb6865:0x5fd1628a25104b91!2m2!1d29.9759574!2d39.4169305'
    ],
    [
      'YakupBey Medresesi',
      'lib/Kaynaklar/YakupBeyMedresesi/YakupBeyMedresesiResim.jpg',
      ''
    ],
    [
      'RustemPasa Medresesi',
      'lib/Kaynaklar/RustemPasaMedresesi/RustemPasaMedresesiResim.jpg',
      'https://www.google.com/maps/dir/39.418952, 29.986621/k%C3%BCtahya+r%C3%BCstem+pa%C5%9Fa+medresesi/@39.4291345,29.9488596,14z/data=!3m1!4b1!4m9!4m8!1m1!4e1!1m5!1m1!1s0x14c9480c72dfc6d1:0x6d2bfc66e53181f3!2m2!1d29.9803483!2d39.4193222?hl=tr',
    ],
    [
      'HisarBey Cami',
      'lib/Kaynaklar/HisarBeyCami/HisarBeyCamiResim.jpg',
      'https://www.google.com/maps/dir/39.418952, 29.986621/hisarbey+cami+kutahya/@39.3097255,28.8592477,9z/data=!3m1!4b1!4m9!4m8!1m1!4e1!1m5!1m1!1s0x14c8220491e48665:0xfa66bd925f20ce43!2m2!1d28.772506!2d39.135646'
    ],
    [
      'KaragozAhmetPasa Cami',
      'lib/Kaynaklar/KaragozAhmetPasaCami/KaragozAhmetPasaCamiResim.jpg',
      'https://www.google.com/maps/dir/39.418952, 29.986621/karag%C3%B6z+ahmet+pa%C5%9Fa+camii+k%C3%BCtahya/@39.4269732,29.9494615,14z/data=!3m1!4b1!4m9!4m8!1m1!4e1!1m5!1m1!1s0x14c9480c1bbcedaf:0x6c9bf6004865499a!2m2!1d29.9808243!2d39.418309?hl=tr'
    ],
    [
      'AliPasa Cami',
      'lib/Kaynaklar/AliPasaCami/AliPasaCamiResim.jpg',
      'https://www.google.com/maps/dir/39.418952, 29.986621/Alipa%C5%9Fa,+K%C3%BCtahya+Ali+Pa%C5%9Fa+Camii,+Karag%C3%B6zpa%C5%9Fa+Sk+No:18,+43020+K%C3%BCtahya+Merkez%2FK%C3%BCtahya/@39.4273177,29.9504959,14z/data=!3m1!4b1!4m12!4m11!1m3!2m2!1d29.95236!2d39.43689!1m5!1m1!1s0x14c9480dbc7a3867:0x553e4fc7f5f5972d!2m2!1d29.9837108!2d39.418824!3e2'
    ],
    [
      'Yesil Cami',
      'lib/Kaynaklar/YesilCami/YesilCamiResim.jpg',
      'https://www.google.com/maps/dir/39.418952, 29.986621/Y%C4%B1ld%C4%B1r%C4%B1m+Beyaz%C4%B1t,+K%C3%BCtahya+Ye%C5%9Fil+Cami,+43300+Tav%C5%9Fanl%C4%B1%2FK%C3%BCtahya/@39.492482,29.4429225,10z/data=!3m1!4b1!4m12!4m11!1m3!2m2!1d29.95236!2d39.43689!1m5!1m1!1s0x14c974babcde5c69:0x59d1793c6d6e87e2!2m2!1d29.4979162!2d39.5492625!3e2?hl=tr'
    ],
    [
      'Hidirlik Mescidi',
      'lib/Kaynaklar/HidirlikMescidi/HidirlikMescidiResim.jpg',
      'https://www.google.com/maps/dir/39.418952, 29.986621/k%C3%BCtahya+h%C4%B1d%C4%B1rl%C4%B1k+mescidi/@39.4255344,29.9530106,14z/data=!3m1!4b1!4m9!4m8!1m1!4e1!1m5!1m1!1s0x14c94807ce1b6ead:0x8ac0b3fbbb55f26!2m2!1d29.9764069!2d39.4138001'
    ],
    [
      'Kutahya Kalesi',
      'lib/Kaynaklar/KutahyaKalesi/KutahyaKalesiResim.jpg',
      'https://www.google.com/maps/dir/39.418952, 29.986621/Maruf,+K%C3%BCtahya+Kalesi,+43050+K%C3%BCtahya+Merkez%2FK%C3%BCtahya/@39.4275403,29.9455707,14z/data=!3m1!4b1!4m12!4m11!1m3!2m2!1d29.95236!2d39.43689!1m5!1m1!1s0x14c947e3a39bbddf:0x840283b901abb7b9!2m2!1d29.970047!2d39.4190826!3e2?hl=tr'
    ],
    [
      'Cinili Cami',
      'lib/Kaynaklar/CiniliCami/CiniliCamiResim.jpg',
      'https://www.google.com/maps/dir/39.418952, 29.986621/Maltepe,+%C3%87inili+Cami,+Avgano%C4%9Flu+Sk.+No:23,+43100+K%C3%BCtahya+Merkez%2FK%C3%BCtahya/@39.4239843,29.9538017,14z/data=!3m1!4b1!4m12!4m11!1m3!2m2!1d29.95236!2d39.43689!1m5!1m1!1s0x14c94810c75a8323:0xd294e5aea1f5a66a!2m2!1d29.9902429!2d39.4116743!3e2?hl=tr'
    ],
    [
      'Menzilhane',
      'lib/Kaynaklar/Menzilhane/MenzilhaneResim.jpg',
      'https://www.google.com/maps/dir/39.418952, 29.986621/Menzilhane+Sk.,+43050+K%C3%BCtahya+Merkez%2FK%C3%BCtahya/@39.4270535,29.9476089,14z/data=!3m1!4b1!4m12!4m11!1m3!2m2!1d29.95236!2d39.43689!1m5!1m1!1s0x14c948091160fd2d:0x7058eec4150a77bb!2m2!1d29.9779264!2d39.4172873!3e2?hl=tr'
    ],
    [
      'Muvakkithane',
      'lib/Kaynaklar/Muvakkithane/MuvakkithaneResim.jpg',
      'https://www.google.com/maps/dir/39.418952, 29.986621/k%C3%BCtahya+muvakkithane/@39.4290257,29.9483725,14z/data=!3m1!4b1!4m9!4m8!1m1!4e1!1m5!1m1!1s0x14c9480b9aa2b359:0x542494ed84a5159!2m2!1d29.9771583!2d39.4202904?hl=tr'
    ],
    [
      'Kutahya Lisesi',
      'lib/Kaynaklar/KutahyaLisesi/KutahyaLisesiResim.jpg',
      'https://www.google.com/maps/dir/39.418952, 29.986621/39.4167913,29.9837892/@39.4270063,29.9532137,14z/data=!3m1!4b1!4m7!4m6!1m3!2m2!1d29.95236!2d39.43689!1m0!3e0?hl=tr'
    ],
    [
      'Macar Evi',
      'lib/Kaynaklar/MacarEvi/MacarEviResim.jpg',
      'https://www.google.com/maps/dir/39.418952, 29.986621/macar+evi+k%C3%BCtahya/@39.4269732,29.9483725,14z/data=!3m1!4b1!4m9!4m8!1m1!4e1!1m5!1m1!1s0x14c947e29f17fe67:0xf67a7b53a9c0582a!2m2!1d29.9737786!2d39.4165006?hl=tr'
    ],
    [
      'Hukumet Konagi',
      'lib/Kaynaklar/HukumetKonagi/HukumetKonagiResim.jpg',
      'https://www.google.com/maps/dir/39.418952, 29.986621/k%C3%BCtahya+h%C3%BCk%C3%BCmet+kona%C4%9F%C4%B1/@39.4322254,29.9378744,13z/data=!3m1!4b1!4m11!4m10!1m3!2m2!1d29.95236!2d39.43689!1m5!1m1!1s0x14c949883c104ee9:0xb781ccb2d73aca1e!2m2!1d29.9887575!2d39.4239306?hl=tr'
    ]
  ];
}

class metinIngilizce {
  static var metinIngiliz = [
    [
      'Grand Mosque',
      'lib/Kaynaklar/UluCami/UluCamiResim.jpg',
    ],
    [
      'Donenler Mosque',
      'lib/Kaynaklar/DonenlerCami/DonenlerCamiResim.jpg',
    ],
    [
      'Vacidiye Madrasah',
      'lib/Kaynaklar/VacidiyeMedresesi/VacidiyeMedresesiResim.jpg',
    ],
    [
      'YakupBey Madrasah',
      'lib/Kaynaklar/VacidiyeMedresesi/YakupBeyMedresesiResim.jpg',
    ],
    [
      'RustemPasa Madrasah',
      'lib/Kaynaklar/RustemPasaMedresesi/RustemPasaMedresesiResim.jpg',
    ],
    [
      'HisarBey Mosque',
      'lib/Kaynaklar/HisarBeyCami/HisarBeyCamiResim.jpg',
    ],
    [
      'KaragozAhmetPasha Mosque',
      'lib/Kaynaklar/KaragozAhmetPasaCami/KaragozAhmetPasaCamiResim.jpg',
    ],
    [
      'AliPasha Mosque',
      'lib/Kaynaklar/AliPasaCami/AliPasaCamiResim.jpg',
    ],
    [
      'Yesil Mosque',
      'lib/Kaynaklar/YesilCami/YesilCamiResim.jpg',
    ],
    [
      'Hidirlik Masjid',
      'lib/Kaynaklar/HidirlikMescidi/HidirlikMescidiResim.jpg',
    ],
    [
      'Kutahya Castle',
      'lib/Kaynaklar/KutahyaKalesi/KutahyaKalesiResim.jpg',
    ],
    [
      'Tile Mosque',
      'lib/Kaynaklar/CiniliCami/CiniliCamiResim.jpg',
    ],
    [
      'Menzilhane',
      'lib/Kaynaklar/Menzilhane/MenzilhaneResim.jpg',
    ],
    [
      'Muvakkithane',
      'lib/Kaynaklar/Muvakkithane/MuvakkithaneResim.jpg',
    ],
    [
      'Kutahya HighSchool',
      'lib/Kaynaklar/KutahyaLisesi/KutahyaLisesiResim.jpg',
    ],
    [
      'Hungarian House',
      'lib/Kaynaklar/MacarEvi/MacarEviResim.jpg',
    ],
    [
      'Government Mansion',
      'lib/Kaynaklar/HukumetKonagi/HukumetKonagiResim.jpg',
    ]
  ];
}

class ScrollBarResimler {
  static var resimler = [
    [
      'lib/Kaynaklar/UluCami/UluCamiResimIki.jpg',
      'lib/Kaynaklar/UluCami/UluCamiUc.jpg',
      'lib/Kaynaklar/UluCami/UluCamiDort.jpg'
    ],
    [
      'lib/Kaynaklar/DonenlerCami/DonenlerCamiIki.jpg',
      'lib/Kaynaklar/DonenlerCami/DonenlerCamiUc.jpg',
      'lib/Kaynaklar/DonenlerCami/DonenlerCamiDort.jpg',
    ],
    [
      'lib/Kaynaklar/VacidiyeMedresesi/VacidiyeMedresesiIki.jpg',
      'lib/Kaynaklar/VacidiyeMedresesi/VacidiyeMedresesiUc.jpg',
      'lib/Kaynaklar/VacidiyeMedresesi/VacidiyeMedresesiDort.jpg',
    ],
    [
      'lib/Kaynaklar/YakupBeyMedresesi/YakupBeyMedresesiIki.jpg',
      'lib/Kaynaklar/YakupBeyMedresesi/YakupBeyMedresesiUc.jpg',
      'lib/Kaynaklar/YakupBeyMedresesi/YakupBeyMedresesiDort.jpg',
    ],
    [
      'lib/Kaynaklar/RustemPasaMedresesi/RustemPasaMedresesiIki.jpg',
      'lib/Kaynaklar/RustemPasaMedresesi/RustemPasaMedresesiUc.jpg',
      'lib/Kaynaklar/RustemPasaMedresesi/RustemPasaMedresesiDort.jpg',
    ],
    [
      'lib/Kaynaklar/HisarBeyCami/HisarBeyCamiIki.jpg',
      'lib/Kaynaklar/HisarBeyCami/HisarBeyCamiUc.jpg',
      'lib/Kaynaklar/HisarBeyCami/HisarBeyCamiDort.jpg',
    ],
    [
      'lib/Kaynaklar/KaragozAhmetPasaCami/KaragozAhmetPasaCamiIki.jpg',
      'lib/Kaynaklar/KaragozAhmetPasaCami/KaragozAhmetPasaCamiUc.jpg',
      'lib/Kaynaklar/KaragozAhmetPasaCami/KaragozAhmetPasaCamiDort.jpg',
    ],
    [
      'lib/Kaynaklar/AliPasaCami/AliPasaCamiIki.jpg',
      'lib/Kaynaklar/AliPasaCami/AliPasaCamiUc.jpg',
      'lib/Kaynaklar/AliPasaCami/AliPasaCamiDort.jpg',
    ],
    [
      'lib/Kaynaklar/YesilCami/YesilCamiIki.jpg',
      'lib/Kaynaklar/YesilCami/YesilCamiUc.jpg',
      'lib/Kaynaklar/YesilCami/YesilCamiDort.jpg',
    ],
    [
      'lib/Kaynaklar/HidirlikMescidi/HidirlikMescidiIki.jpg',
      'lib/Kaynaklar/HidirlikMescidi/HidirlikMescidiUc.jpg',
      'lib/Kaynaklar/HidirlikMescidi/HidirlikMescidiDort.jpg',
    ],
    [
      'lib/Kaynaklar/KutahyaKalesi/KutahyaKalesiIki.jpg',
      'lib/Kaynaklar/KutahyaKalesi/KutahyaKalesiUc.jpg',
      'lib/Kaynaklar/KutahyaKalesi/KutahyaKalesiDort.jpg',
    ],
    [
      'lib/Kaynaklar/CiniliCami/CiniliCamiIki.jpg',
      'lib/Kaynaklar/CiniliCami/CiniliCamiUc.jpg',
      'lib/Kaynaklar/CiniliCami/CiniliCamiDort.jpg',
    ],
    [
      'lib/Kaynaklar/Menzilhane/MenzilhaneIki.jpg',
      'lib/Kaynaklar/Menzilhane/MenzilhaneUc.jpg',
      'lib/Kaynaklar/Menzilhane/MenzilhaneDort.jpg',
    ],
    [
      'lib/Kaynaklar/Muvakkithane/MuvakkithaneIki.jpg',
      'lib/Kaynaklar/Muvakkithane/MuvakkithaneUc.jpg',
      'lib/Kaynaklar/Muvakkithane/MuvakkithaneDort.jpg',
    ],
    [
      'lib/Kaynaklar/KutahyaLisesi/KutahyaLisesiIki.jpg',
      'lib/Kaynaklar/KutahyaLisesi/KutahyaLisesiUc.jpg',
      'lib/Kaynaklar/KutahyaLisesi/KutahyaLisesiDort.jpg',
    ],
    [
      'lib/Kaynaklar/MacarEvi/MacarEviIki.jpg',
      'lib/Kaynaklar/MacarEvi/MacarEviUc.jpg',
      'lib/Kaynaklar/MacarEvi/MacarEviDort.jpg',
    ],
    [
      'lib/Kaynaklar/HukumetKonagi/HukumetKonagiIki.jpg',
      'lib/Kaynaklar/HukumetKonagi/HukumetKonagiUc.jpg',
      'lib/Kaynaklar/HukumetKonagi/HukumetKonagiDort.jpg',
    ]
  ];
}
