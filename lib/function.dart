import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

var arg = ['event_name','event_text','event_active','event_startline','event_deadline'];

var settingsSystem = new ConnectionSettings(
    host: '10.0.2.2',
    port: 3306,
    user: 'root',
    password: '12345',
    db: 'explore_kutahya');

Future<MySqlConnection> dbConnectSystem() async {
  return await MySqlConnection.connect(settingsSystem);
}

event_datas(db,dil)  async{
  var mainData = [];
  var results = await db.query('select * from main_page_events_$dil');
  for(var x in results){
    var datas = [];
    for(var y in x){
      /*print(y);*/
      datas.add(y);
    }
    mainData.add(datas);
  }
  return mainData;
}
