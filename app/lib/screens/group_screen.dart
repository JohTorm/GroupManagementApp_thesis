import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/view.abs.dart';
import '../viewModel/group_view_model.dart';

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
    //viewModel.getUserGroups(context);

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
            title: Text("""Terve ${state.email}"""),
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


                    }
                    else if(value == 1){

                      viewModel.createGroup();
                    }else if(value == 2){

                    }else if(value == 3){

                    }
                  }
              ),

            ],
          ),
            body: ListView.builder(
              itemCount: state.userGroupNames.length,
              shrinkWrap: true,
              padding: EdgeInsets.all(5),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext, index){
                return Card(
                  child: ListTile(
                    title: Text(state.userGroupNames[index]),
                    subtitle: Text("${state.email} "),
                    selected: index == _selectedIndex,
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      viewModel.displayDialogGroup(BuildContext);
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


            ),

        );
      },
    );
  }
}