import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../mvvm/view.abs.dart';
import '../ui_components.dart';
import '../viewModel/event_list_view_model.dart';
import '../viewModel/group_events_view_model.dart';

class GroupPage extends View<GroupPageViewModel> {
const GroupPage({required GroupPageViewModel viewModel, Key? key})
: super.model(viewModel, key: key);

@override
_GroupPageState createState() => _GroupPageState(viewModel);
}

class _GroupPageState extends ViewState<GroupPage, GroupPageViewModel> {
  _GroupPageState(GroupPageViewModel viewModel) : super(viewModel);
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    listenToRoutesSpecs(viewModel.routes);
  }

  @override
  Widget build(BuildContext context) {


    return StreamBuilder<GroupPageState>(
      stream: viewModel.state,

      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        final state = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('GroupPage'),
            actions: [

              PopupMenuButton(
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                  itemBuilder: (context){
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text("My groups"),
                      ),

                      PopupMenuItem<int>(
                        value: 1,
                        child: Text("Create new group"),
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
                  onSelected:(value){
                    if(value == 0){
                      print("My groups menu is selected.");
                    }
                    else if(value == 1){
                      print("Create new group menu is selected.");
                      viewModel.createGroup();
                    }else if(value == 2){
                      print("Settings menu is selected.");
                    }else if(value == 3){
                      print("Logout menu is selected.");
                    }
                  }
              ),

            ],
          ),
            body: ListView.builder(
              itemBuilder: (BuildContext, index){
                return Card(
                  child: ListTile(
                    title: Text(state.group),
                    subtitle: Text("${state.group} sukunimi"),
                    selected: index == _selectedIndex,
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      viewModel.displayDialog(BuildContext);
                    },
                    trailing: Wrap(
                      spacing: 12, // space between two icons
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.add),
                            onPressed: () {
                          //
                      } ), // icon-1
                        IconButton(icon: Icon(Icons.delete),
                            onPressed: () {
                              //
                            } ), // icon-2
                      ],
                    ),
                  ),
                );
              },
              itemCount: 5,
              shrinkWrap: true,
              padding: EdgeInsets.all(5),
              scrollDirection: Axis.vertical,

            )
        );
      },
    );
  }
}