
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rxdart/subjects.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/app_routes.dart';
import '../model/view_model.abs.dart';

import '../model/event.dart';
import '../model/group.dart';



import '../services/webservice.dart';



class SecondPageState {
  final String user;
  final String email;
  final userGroupNames;
  final userEvents;
  final userGroups;
  final groupEvents;


  SecondPageState({
    this.user = '',
    this.email = '',
    this.userGroupNames = List<String>,
    this.userEvents = List<Event>,
    this.groupEvents = List<Event>,
    this.userGroups = List<Group>,

  });

  SecondPageState copyWith({
    String? user,
    List<String>? userGroupNames,
    List<Event>? userEvents,
    List<Event>? groupEvents,
    List<Group>?userGroups,
    String? email,

  }) {
    return SecondPageState(
      user: user ?? this.user,
      email: email ?? this.email,
      userGroupNames: userGroupNames ?? this.userGroupNames,
      userEvents: userEvents ?? this.userEvents,
      userGroups: userGroups ?? this.userGroups,
      groupEvents: groupEvents ?? this.groupEvents,

    );
  }
}

class SecondPageViewModel extends ViewModel {
  final _stateSubject =
  BehaviorSubject<SecondPageState>.seeded(SecondPageState());
  Stream<SecondPageState> get state => _stateSubject;

  final _routesSubject = PublishSubject<AppRouteSpec>();
  Stream<AppRouteSpec> get routes => _routesSubject;

  SecondPageViewModel({required String user, required String email}) {
    _stateSubject.add(SecondPageState(user: user, email: email));
  }
  final List <String> groupNames = <String>[];
  List <Event> eventNames = <Event>[];
  List <Group> groups = <Group>[];
  List <Event> groupEvents = <Event>[];
  List<bool> boolList = List.filled(99, true);
  int _selectedIndex = 0;


  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat calendarFormat = CalendarFormat.month;
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  DateTime? rangeStart;
  DateTime? rangeEnd;





  Future<void> getUserGroups(context) async {

    final userGroup = await Webservice().getUserGroups(
        _stateSubject.value.email);

    if (userGroup.length > 0) {
      //if(_stateSubject.value.count == 0) {
      groupNames.clear();
      groups.clear();
        for (var i = 0; i < userGroup["UsersGroups"].length; i++) {

          groupNames.add(userGroup["UsersGroups"][i]["groupName"]);
          Group ryhma = Group.fromJson(userGroup["UsersGroups"][i]);
          groups.add(ryhma);

        }
        updateStateGroups(groups);
        updateStateGroupNames(groupNames);

      //}
        //userGroups();
        //updateStateCount(1);

      //groupNames.clear();

    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  Future<void> getUserEvents(context) async {

    eventNames.clear();
    final userEvents = await Webservice().getUserEvents(
        _stateSubject.value.email);

    if (userEvents.length > 0) {
      //if(_stateSubject.value.count == 0) {


        for (var i = 0; i < userEvents.length; i++) {

        Event tapahtuma = Event.fromJson(userEvents[i]);

        eventNames.add(tapahtuma);

      }


      updateStateEvents(eventNames);


      //}
      //userGroups();
      //updateStateCount(1);

      //groupNames.clear();

    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }


  Future<void> displayDialogEvent(context, event) async {
    Event tapahtuma = event;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tapahtuma.eventName),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(tapahtuma.groupName),
                Text('${tapahtuma.info} '),
                Row(
                  children: <Widget>[
                    Icon(Icons.map),
                    Text(tapahtuma.location),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.calendar_month_outlined ),
                    Text(tapahtuma.startDate.substring(0,10)),
                    Icon(Icons.watch_later_outlined),
                    Text(tapahtuma.endDate.substring(11,19)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.calendar_month ),
                    Text(tapahtuma.startDate.substring(0,10)),
                    Icon(Icons.watch_later ),
                    Text(tapahtuma.endDate.substring(11,19)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.check_box  ),
                    Text(tapahtuma.inParticipants.toString()),
                    Icon(Icons.clear ),
                    Text(tapahtuma.outParticipants.toString()),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Delete this event'),
              onPressed: () {
                deleteEvent(context, tapahtuma.id.toString());
              },
            ),
            TextButton(
              child: const Text('close'),
              onPressed: () {
                Navigator.of(context).pop();

              },
            ),
          ],
            actionsAlignment: MainAxisAlignment.spaceBetween
        );
      },
    );
  }

  Future<void> displayDialogGroup(context, group) async {
    Group ryhma = group;
    List<String> members = [];
    List<int> ids = [];
    List<Event> groupEvents = [];
    final groupMembers = await Webservice().getGroupMembers(
        ryhma.id.toString());

    if (groupMembers.length > 0) {

        for (var i = 0; i < groupMembers.length; i++) {
          members.add(groupMembers[i]["nickname"]);
          ids.add(groupMembers[i]["id"]);
        }
        }

    final groupevents = await Webservice().getGroupEvents(
        ryhma.id.toString(),_stateSubject.value.email);

    if (groupevents.length > 0) {
      groupEvents.clear();
        for (var i = 0; i < groupevents.length; i++) {
          Event tapahtuma = Event.fromJson(groupevents[i]);
          groupEvents.add(tapahtuma);
        }
      }



    return showDialog<void>(
      context: context,
      barrierDismissible: false, // groupName must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${group.name} '),
          content: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Upcoming events'),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: groupEvents.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: groupEvents[index].eventName,
                                  style: DefaultTextStyle.of(context).style,
                                  )
                          ]
                          ),
                          ),
                          subtitle: RichText(
                            text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(Icons.calendar_month_outlined, size: 14),
                                  ),
                                  TextSpan(
                                    text: '${groupEvents[index].startDate.substring(0,10)}\n',
                                    style: DefaultTextStyle.of(context).style,
                                  ),
                                  WidgetSpan(
                                    child: Icon(Icons.watch_later_outlined, size: 14),
                                  ),
                                  TextSpan(
                                    text: '${groupEvents[index].startDate.substring(11,19)}\n',
                                    style: DefaultTextStyle.of(context).style,
                                  ),
                                  WidgetSpan(
                                    child: Icon(Icons.calendar_month, size: 14),
                                  ),
                                  TextSpan(
                                    text: '${groupEvents[index].endDate.substring(0,10)}\n',
                                    style: DefaultTextStyle.of(context).style,
                                  ),
                                  WidgetSpan(
                                    child: Icon(Icons.watch_later, size: 14),
                                  ),
                                  TextSpan(
                                    text: '${groupEvents[index].endDate.substring(11,19)}',
                                    style: DefaultTextStyle.of(context).style,
                                  ),


                                ]
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () { displayDialogEvent(context, groupEvents[index]); },
                          ),
                          isThreeLine: true,
                        );
                      },
                    ),
                  ),
                  Text('Members'),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: members.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(members[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              final deleted = await Webservice().kickUser(group.id.toString(),ids[index].toString());
                              if(deleted == 'User kicked') {
                                getUserGroups(context);
                                getUserEvents(context);

                                Fluttertoast.showToast(
                                    msg: "User kicked from group",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        );
                      },
                    ),

                  ),

                ]
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Create event'),
              onPressed: () {
                createEvent(context, group.name, group.id);
              },
            ),
            TextButton(
              child: const Text('Delete group'),
              onPressed: () {
                deleteGroup(context, ryhma.id.toString());


              },
            ),
            TextButton(
              child: const Text('close'),
              onPressed: () {
                Navigator.of(context).pop();

              },
            ),
          ],
            actionsAlignment: MainAxisAlignment.spaceBetween
        );
      },
    );
  }


  Future<void> createEvent(context, groupName, groupId) async{
    TextEditingController nameController = TextEditingController();
    TextEditingController infoController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    var eventStartDate;
    var eventEndDate;
    showDialog(
      context: context,
      builder: (BuildContext context) {
      return SimpleDialog(
        title: Text('Create Event'),

        children: <Widget>[
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Create Event',
                style: TextStyle(fontSize: 20),
              )
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Event name',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: TextField(
              controller: infoController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Event information',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: TextField(
              controller: locationController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Event location',
              ),
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: ElevatedButton(
              child: const Text('Choose event start date'),
              onPressed: () {
                DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    minTime: DateTime.now(),
                    maxTime: DateTime(2029, 6, 7, 17, 5, 15), onChanged: (date) {
                    }, onConfirm: (date) {
                      eventStartDate = date;
                    }, currentTime: eventEndDate, locale: LocaleType.fi);
              },
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: ElevatedButton(
              child: const Text('Choose event end date'),
              onPressed: () {
                DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    minTime: DateTime.now(),
                    maxTime: DateTime(2029, 6, 7, 17, 5, 15), onChanged: (date) {
                    }, onConfirm: (date) {
                      eventEndDate = date;
                    }, currentTime: eventStartDate, locale: LocaleType.fi);
              },
            ),
          ),
        Container(
        height: 50,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: ElevatedButton(
        child: const Text('Create event'),
        onPressed: () async {
          Event event = new Event(id: 1, location: locationController.text, endDate: eventEndDate.toString(), startDate: eventStartDate.toString(), groupName: groupName, info: infoController.text, eventName: nameController.text, inParticipants: 0, outParticipants: 0);
          final eventCreated = await Webservice().createEvent(event, groupId.toString(),_stateSubject.value.email);

          if(eventCreated == 'Event created!') {
            getUserGroups(context);
            getUserEvents(context);
            Navigator.of(context).pop();
            displayDialogEventCreated(context);
          }



        },
        ),
        ),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: ElevatedButton(
              child: const Text('Close'),
              onPressed: () {
                getUserGroups(context);
                getUserEvents(context);
                Navigator.of(context).pop();
              },
            ),
          ),

        ],
      );
      }
    );
  }


  Future<void> displayDialogEventCreated(context) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Event created'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You have successfully created an event!'),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('close'),
              onPressed: () async {
                getUserGroups(context);
                getUserEvents(context);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> signToEvent(eventId,entrytype,context) async {
    final signing = await Webservice().signToEvent(
        _stateSubject.value.email,eventId,entrytype);

    if (signing.length > 0) {



    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  Future<void> displayDialogJoinGroup(context) async {
    TextEditingController nameController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Join a group',textAlign: TextAlign.center,),

          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Give the password of the group',
                    style: TextStyle(fontSize: 16),
                )
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Group password',
                ),
              ),
            ),

            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: ElevatedButton(
                child: const Text('Join the group'),
                onPressed: () async {
                  final joined = await Webservice().addToGroup(
                      _stateSubject.value.email, nameController.text);

                  if (joined == 'User is added to the group.') {
                    Navigator.of(context).pop();
                    displayDialogJoinGroupSuccess(context);

                  } else {
                    // If the server did not return a 201 CREATED response,
                    // then throw an exception.
                    Navigator.of(context).pop();
                    displayDialogJoinGroupUnsuccess(context);

                    throw Exception('Failed to create album.');

                  }
                  getUserEvents(context);
                  getUserGroups(context);
                  Navigator.of(context).pop();

                },
              ),
            ),


          ],
        );
      },
    );
  }


  Future<void> displayDialogJoinGroupSuccess(context) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Joined to Group'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You have successfully joined to the group!'),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('close'),
              onPressed: () async {
                getUserGroups(context);
                getUserEvents(context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> displayDialogJoinGroupUnsuccess(context) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Joining group failed'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Something went wrong while trying to join the group. Make sure the password you give is correct and you have not joined the group already'),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('close'),
              onPressed: () async {
                getUserGroups(context);
                getUserEvents(context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> displayDialogDeleteSuccess(context) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deleted'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Delete successful!'),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('close'),
              onPressed: () async {
                getUserGroups(context);
                getUserEvents(context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> displayDialogDeleteUnsuccess(context) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Not Deleted'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Delete unsuccessful!'),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('close'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> deleteEvent(context, eventId) async {
    TextEditingController nameController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Delete event',textAlign: TextAlign.center,),

          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Type ´DELETE` to delete the event',
                  style: TextStyle(fontSize: 16),
                )
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '',
                ),
              ),
            ),

            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: ElevatedButton(
                child: const Text('DELETE'),
                onPressed: () async {

                  if (nameController.text == 'DELETE') {
                    final deleted = await Webservice().deleteEvent(eventId);

                    if (deleted == 'Event deleted') {
                      Navigator.of(context).pop();
                      getUserEvents(context);
                      getUserGroups(context);
                      Navigator.of(context).pop();
                      displayDialogDeleteSuccess(context);

                    } else {
                      // If the server did not return a 201 CREATED response,
                      // then throw an exception.
                      Navigator.of(context).pop();
                      getUserEvents(context);
                      getUserGroups(context);
                      Navigator.of(context).pop();
                      displayDialogDeleteUnsuccess(context);

                      throw Exception('Failed to create album.');

                    }
                  }
                  //getUserEvents(context);
                  //getUserGroups(context);
                  Navigator.of(context).pop();

                },
              ),
            ),

        Container(
        height: 50,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: ElevatedButton(
        child: const Text('Close'),
        onPressed: () {
        Navigator.of(context).pop();
        },
        ),
        ),

          ],
        );
      },
    );
  }

  Future<void> deleteGroup(context, groupId) async {
    TextEditingController nameController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Delete group',textAlign: TextAlign.center,),

          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Type ´DELETE` to delete the group',
                  style: TextStyle(fontSize: 16),
                )
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '',
                ),
              ),
            ),

            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: ElevatedButton(
                child: const Text('DELETE'),
                onPressed: () async {

                  if (nameController.text == 'DELETE') {
                    final deleted = await Webservice().deleteGroup(groupId);

                    if (deleted == 'Group deleted') {
                      Navigator.of(context).pop();
                      getUserEvents(context);
                      getUserGroups(context);
                      Navigator.of(context).pop();
                      displayDialogDeleteSuccess(context);

                    } else {
                      // If the server did not return a 201 CREATED response,
                      // then throw an exception.
                      Navigator.of(context).pop();
                      getUserEvents(context);
                      getUserGroups(context);
                      Navigator.of(context).pop();
                      displayDialogDeleteUnsuccess(context);

                      throw Exception('Failed to create album.');

                    }
                  }






                  //getUserEvents(context);
                  //getUserGroups(context);
                  Navigator.of(context).pop();

                },
              ),
            ),

            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: ElevatedButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),

          ],
        );
      },
    );
  }

  Widget getEventListView (context) {
    return eventNames.isNotEmpty ? ListView.builder(
      itemCount:  _stateSubject.value.userEvents.length,
      shrinkWrap: true,
      padding: EdgeInsets.all(5),
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext, index){
        return Card(
          child: ListTile(
            title: Text(_stateSubject.value.userEvents[index].eventName),
            subtitle: Text(' ${_stateSubject.value.userEvents[index].startDate.substring(0,10) }  ${_stateSubject.value.userEvents[index].startDate.substring(11,19)}'),
            selected: index == _selectedIndex,
            onTap: () {

                _selectedIndex = index;

              displayDialogEvent(BuildContext, _stateSubject.value.userEvents[index]);
            },
            trailing: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12, // space between two icons
              children: <Widget>[
                Text('Attendance: '),
                IconButton(
                    icon: (boolList[index])
                        ? Icon(Icons.clear, color: Colors.red)
                        :Icon(Icons.check, color: Colors.green),
                    onPressed: () {


                        boolList[index]  = !boolList[index];
                        int a = !(boolList[index]) ? 1 : 0;

                        signToEvent(_stateSubject.value.userEvents[index].id.toString(), a.toString(), context);
                        getUserEvents(context);

                    } ), // icon-1
              ],
            ),
          ),
        );
      },

    ) : const Center(child: Text('No Upcoming events', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20.0)),);
  }

  Widget getGroupListView (context) {

    return groups.isNotEmpty ? ListView.builder(
      itemCount: groups.length,
      shrinkWrap: true,
      padding: EdgeInsets.all(5),
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext, index){
        return Card(
          child: ListTile(
            title: Text(groups[index].name),
            selected: index == _selectedIndex,
            onTap: () {
                _selectedIndex = index;
              displayDialogGroup(BuildContext, groups[index]);
            },
            trailing: Wrap(
              spacing: 12, // space between two icons
              children: <Widget>[
                IconButton(icon: Icon(Icons.content_copy),
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: groups[index].password));
                      Fluttertoast.showToast(
                          msg: "Group password copied to clipboard",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    } ),
              ],
            ),
          ),
        );
      },
    ) : const Center(child: Text('No groups found', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20.0)),);
  }



  void createGroup() {
    _routesSubject.add(
      AppRouteSpec(
        name: '/createGroup',
        arguments: {
          'email': _stateSubject.value.email,
          'user': _stateSubject.value.user
        },
      ),

    );
  }

  void logOut() {
    _routesSubject.add(
      AppRouteSpec(
        name: '/'
      ),

    );
  }



    void updateStateGroupNames(List<String> groupNames) {
      final state = _stateSubject.value;
      _stateSubject.add(
        state.copyWith(
          userGroupNames: groupNames,
        ),
      );
    }

  void updateStateEvents(List<Event> eventNames) {
    final state = _stateSubject.value;
    _stateSubject.add(
      state.copyWith(
        userEvents: eventNames,
      ),
    );
  }

  void updateStateGroups(List<Group> group) {
    final state = _stateSubject.value;
    _stateSubject.add(
      state.copyWith(
        userGroups: group,
      ),
    );
  }

  void updateStateCount() {
    final state = _stateSubject.value;
    _stateSubject.add(
      state.copyWith(

      ),
    );
  }

  void userGroupss() {
    _routesSubject.add(
      AppRouteSpec(
        name: '/userGroups',
        arguments: {
          'group': groupNames,
        },
      ),

    );
  }

  @override
  void dispose() {
    _stateSubject.close();
    _routesSubject.close();
  }
}