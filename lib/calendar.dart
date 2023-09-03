import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:table_calendar/table_calendar.dart';
import 'depression_degree.dart';
import 'sleep_time.dart';
import 'depression_degree_dropdown_menu.dart';
import 'mental_data_store.dart';
import 'ad_banner.dart';

class Calendar extends StatefulWidget {
  @override
  _Calendar createState() => _Calendar();
}

class _Calendar extends State<Calendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime?,List<DepressionDegree>> depressionDegree = {};
  Map<DateTime?,List<SleepTime>> sleepTime= {};

  TextEditingController _depressionDegreeController = TextEditingController();
  TextEditingController _sleepTimeController = TextEditingController();


  late final ValueNotifier<List<DepressionDegree>> _selectedDepressionDegree;
  late final ValueNotifier<List<SleepTime>> _selectedSleepTime;
  @override
  initState()  {
    MentalDataStore().getAllMentalData(depressionDegree, sleepTime);
    super.initState();
    _selectedDay = null;
    _selectedDepressionDegree = ValueNotifier(_getDepressionDegreeForDay(_selectedDay));
    _selectedSleepTime = ValueNotifier(_getSleepTimeForDay(_selectedDay));
  }
  List<DepressionDegree> _getDepressionDegreeForDay(DateTime? day){
    return depressionDegree[day] ?? [];
  }

   List<SleepTime> _getSleepTimeForDay(DateTime? day){
    return sleepTime[day] ?? [];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context){
            if (_selectedDay == null){
              return AlertDialog(
                scrollable: true,
                content: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("日にちを選択してください"),
                ),
              );
            }
            var dropDownMenu = DepressionDegreeDropdownMenu();
            return AlertDialog(
              scrollable:  true,
              content: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text('落ち込み度'),
                    dropDownMenu,
                    Padding(padding: EdgeInsets.all(16)),
                    Text('睡眠時間 [hour]'),
                    TextField(
                    keyboardType: TextInputType.number,
                    controller: _sleepTimeController,
                    )
                  ],
                )
                
              ),
              actions: [
                ElevatedButton(onPressed: (){
                  MentalDataStore().saveMentalData(_selectedDay!,dropDownMenu.isSelectedValue,_sleepTimeController.text);
                  depressionDegree.addAll({
                    _selectedDay!: [DepressionDegree(dropDownMenu.isSelectedValue)]
                  });
                  sleepTime.addAll({
                    _selectedDay!: [SleepTime(_sleepTimeController.text)]
                  });
                  Navigator.of(context).pop();
                  setState(() {
                    _selectedDepressionDegree.value = _getDepressionDegreeForDay(_selectedDay);
                    _selectedSleepTime.value = _getSleepTimeForDay(_selectedDay);
                  });
                 
                  
                  
                }, child: Text("OK")),
              ],
            );

          });
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(_focusedDay.year, _focusedDay.month - 3, _focusedDay.day),
            lastDay: DateTime(_focusedDay.year, _focusedDay.month + 3, _focusedDay.day),
            locale: 'ja_JP',
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            eventLoader: _getDepressionDegreeForDay,
            headerStyle: HeaderStyle(titleTextStyle: TextStyle(fontSize: 20, color: Colors.black, )),
            calendarStyle: CalendarStyle(
              selectedTextStyle: TextStyle(fontSize:20, color: Colors.grey, fontWeight: FontWeight.bold ),
              selectedDecoration: BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 248, 184),
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(fontSize:20, color: Colors.grey, fontWeight: FontWeight.bold )
            ),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {          
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedDepressionDegree.value = _getDepressionDegreeForDay(selectedDay); 
                _selectedSleepTime.value = _getSleepTimeForDay(selectedDay); 
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            height: 30,
            child: Text(
            "はじめにカレンダーをタップ",
            style: TextStyle(
              fontSize:17,
              fontWeight: FontWeight.bold,
              color: Colors.black,
             ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<DepressionDegree>>(valueListenable: _selectedDepressionDegree, builder: (context, value, _){
              return ListView.builder(itemCount: value.length, itemBuilder: (context, index){
                 return Container(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(border:  Border.all(), borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text('落ち込み度 : ${value[index].degree}'),
                  ),
                );
              });
             
            }),
          ),
          Expanded(
            child: ValueListenableBuilder<List<SleepTime>>(valueListenable: _selectedSleepTime, builder: (context, value, _){
              return ListView.builder(itemCount: value.length, itemBuilder: (context, index){
                 return Container(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(border:  Border.all(), borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text('睡眠時間 : ${value[index].time} hour'),
                  ),
                );
              });
             
            }),
          ),
          AdBanner(size: AdSize.largeBanner),
        ],
      )
      
    );
  }
}