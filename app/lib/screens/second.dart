import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/view.abs.dart';
import '../model/event.dart';

import '../viewModel/second_view_model.dart';


class SecondPage extends View<SecondPageViewModel> {
const SecondPage({required SecondPageViewModel viewModel, Key? key})
: super.model(viewModel, key: key);

@override
_SecondPageState createState() => _SecondPageState(viewModel);
}

class _SecondPageState extends ViewState<SecondPage, SecondPageViewModel> {
  _SecondPageState(SecondPageViewModel viewModel) : super(viewModel);


  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;


  bool attend = false;
  List<bool> boolList = List.filled(99, true);
  List events = [];

  @override
  void initState() {
    super.initState();
    listenToRoutesSpecs(viewModel.routes);
    viewModel.getUserGroups(context);
    viewModel.getUserEvents(context);


    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return StreamBuilder<SecondPageState>(
      stream: viewModel.state,

      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        final state = snapshot.data!;
        try{
          events = [...state.userEvents];
        }
        catch (e){
          events = [Event(location: 'location', endDate: DateTime.now().toString(), startDate: DateTime.now().toString(), groupName: 'groupName', info: 'info', id: 1, eventName: 'eventName', inParticipants: 0, outParticipants: 0)];
        }




        return MaterialApp(
            home: DefaultTabController(
            length: 3,
            child: Scaffold(

          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.group)),
                Tab(icon: Icon(Icons.calendar_month)),
              ],
            ),
            title: Text("""Hello ${state.user}"""),
            automaticallyImplyLeading: false,
            actions: [

              PopupMenuButton(
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                  itemBuilder: (context){
                    return [


                      PopupMenuItem<int>(
                        value: 1,
                        child: Text("Create new group"),
                      ),

                      PopupMenuItem<int>(
                        value: 4,
                        child: Text("Join a group"),
                      ),


                      PopupMenuItem<int>(
                        value: 2,
                        child: Text("Settings"),
                      ),

                      PopupMenuItem<int>(
                        value: 3,
                        child: Text("Logout"),
                      ),
                    ];
                  },
                  onSelected:(value) async{
                    if(value == 0){
                      print("My groups menu is selected.");

                      await viewModel.getUserEvents(context);

                      _getEventsForDay(DateTime.parse(events[0].startDate));
                    }
                    else if(value == 1){
                      print("Create new group menu is selected.");
                      viewModel.createGroup();
                    }else if(value == 2){
                      print("Settings menu is selected.");
                      await viewModel.getUserGroups(context);
                    }else if(value == 3){
                      viewModel.logOut();
                      print("Logout menu is selected.");
                    }else if(value == 4){


                      viewModel.displayDialogJoinGroup(context);
                      print("Logout menu is selected.");
                    }
                  }
              ),

            ],
          ),
            body: TabBarView(
              children: [
            SingleChildScrollView(
            child: ListBody(
            children: <Widget>[
                    Text('My upcoming events', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 32.0),textAlign: TextAlign.center,),
                    Container(child: viewModel.getEventListView(context)),
              ]
                ),
            ),
            SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                Text('My groups', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 32.0),textAlign: TextAlign.center,),
                    Container(child: viewModel.getGroupListView(context)),

              ],
              )
            ),
            Column(
              children: <Widget>[
                TableCalendar<Event>(
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  calendarFormat: _calendarFormat,
                  rangeSelectionMode: _rangeSelectionMode,
                  eventLoader: (day) => _getEventsForDay(day),
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarStyle: CalendarStyle(
                    // Use `CalendarStyle` to customize the UI
                    outsideDaysVisible: false,
                  ),
                  onDaySelected: _onDaySelected,
                  onRangeSelected: _onRangeSelected,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ValueListenableBuilder<List<Event>>(
                    valueListenable: _selectedEvents,
                    builder: (context, value, _) {
                      return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              onTap: () => {

                                viewModel.displayDialogEvent(context, value[index])
                              },
                              title: Text('${value[index].eventName}'),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            )
          ],
            ),
        ),
        ),
        );
      },
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
     List<Event> e = [];
     for (var i = 0; i < events.length; i++) {
       DateTime dt = DateTime.parse(events[i].startDate);
       var td = DateFormat('yyyy-MM-dd').format(dt);
       var tday = DateFormat('yyyy-MM-dd').format(day);
       if(td == tday) {
         e.add(events[i]);

       }
     }
    return e;
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }


}