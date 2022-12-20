import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/view.abs.dart';
import '../viewModel/group_events_view_model.dart';

class GroupEventPage extends View<GroupEventPageViewModel> {
const GroupEventPage({required GroupEventPageViewModel viewModel, Key? key})
: super.model(viewModel, key: key);

@override
_GroupEventPageState createState() => _GroupEventPageState(viewModel);
}

class _GroupEventPageState extends ViewState<GroupEventPage, GroupEventPageViewModel> {
  _GroupEventPageState(GroupEventPageViewModel viewModel) : super(viewModel);
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    listenToRoutesSpecs(viewModel.routes);
  }

  @override
  Widget build(BuildContext context) {


    return StreamBuilder<GroupEventPageState>(
      stream: viewModel.state,

      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        final state = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('GroupEventPage'),
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