import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '101.dart';
import 'package:like_button/like_button.dart';




class MapsPlaceClick extends StatelessWidget {
  MapsPlaceClick({Key, this.dil});

  final dil;

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class historicPlaceClick extends StatelessWidget {
  historicPlaceClick({Key, this.dil});

  final dil;

  @override
  Widget build(BuildContext context) {
    var saveIconColor = Colors.blue;
    return Scaffold(
      body: Scrollbar(
          child: ListView.builder(
        itemBuilder: (context, index) {
          return Material(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(padding: EdgeInsets.all(2.0)),
                Container(
                  height: 220,
                  width: 350,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      )),
                  child: Wrap(
                    spacing: 50,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: FlatButton(
                          onPressed: () async {
                            print(dil);
                            if (dil != '') {
                              dynamic content = await fetchFileData(
                                  deleteSpaceOnWord(
                                      metinTurkce.metinturk[index][0]),
                                  dil);
                              print(content);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Register(
                                          isim: chooseTitle(dil, index),
                                          reIsim: metinTurkce.metinturk[index]
                                              [0],
                                          kaynak: content,
                                          resim: ScrollBarResimler
                                              .resimler[index][0],
                                          resimIki: ScrollBarResimler
                                              .resimler[index][1],
                                          resimUc: ScrollBarResimler
                                              .resimler[index][2],
                                          dil: dil,
                                          url: metinTurkce.metinturk[index][2],
                                        )),
                              );
                            } else {
                              print("");
                            }
                          },
                          child: Image.asset(
                            metinTurkce.metinturk[index][1],
                            cacheHeight: 175,
                            cacheWidth: 350,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LikeButton(
                              size: 40,
                              animationDuration: Duration(milliseconds: 150),
                              likeBuilder: (isLiked) {
                                return Icon(
                                  MdiIcons.contentSave,
                                  color: saveIconColor,
                                );
                              },
                            ),
                            Text(
                              "${chooseTitle(dil, index)}",
                              style: GoogleFonts.fjallaOne(
                                  fontSize: 18, color: Colors.black),
                            ),
                            LikeButton(
                              size: 40,
                              animationDuration: Duration(milliseconds: 150),
                              likeBuilder: (isLiked) {
                                return Icon(
                                  MdiIcons.heart,
                                  color: Colors.blue,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.all(5.0)),
              ],
            ),
          );
        },
        itemCount: metinTurkce.metinturk.length,
      )),
    );
  }
}

class mainPageContents extends StatelessWidget {
  mainPageContents({Key, this.kaynaklar});

  final kaynaklar;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        leading: BackButton(color: Colors.blue),
      ),
    );
  }
}
