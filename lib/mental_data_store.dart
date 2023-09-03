import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'depression_degree.dart';
import 'sleep_time.dart';


class MentalDataStore {
  final _db = Localstore.instance;
  final String STORE_NAME = 'mental_data';

  void getAllMentalData(Map<DateTime?,List<DepressionDegree>> depressionDegree, Map<DateTime?,List<SleepTime>> sleepTime) async {
    final items =await _db.collection(STORE_NAME).get();
    if(items == null){
      return;
    }
    items.forEach((key, value) {
      String dateTime = key;
      dateTime = key.replaceAll('/${STORE_NAME}/', '');
      try{
        depressionDegree.addAll({
        DateTime.parse(dateTime) : [DepressionDegree(value['depression_degree'])]
        });
        sleepTime.addAll({
        DateTime.parse(dateTime) : [SleepTime(value['sleep_time'])]
        });
      }
      catch(e){
        print(e);
      }
      
    });

  }

  void saveMentalData(DateTime datetime, String degressionDegree, String sleepTime){
    final String id = datetime.toIso8601String();
    _db.collection(STORE_NAME).doc(id).set({
     'depression_degree': degressionDegree,
     'sleep_time': sleepTime,
    });
  }
}