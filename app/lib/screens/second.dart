import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../mvvm/view.abs.dart';
import '../ui_components.dart';
import '../viewModel/second_view_model.dart';

class SecondPage extends View<SecondPageViewModel> {
const SecondPage({required SecondPageViewModel viewModel, Key? key})
: super.model(viewModel, key: key);

@override
_SecondPageState createState() => _SecondPageState(viewModel);
}

class _SecondPageState extends ViewState<SecondPage, SecondPageViewModel> {
  _SecondPageState(SecondPageViewModel viewModel) : super(viewModel);
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    listenToRoutesSpecs(viewModel.routes);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SecondPageState>(
      stream: viewModel.state,

      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        final state = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Second Page'),
          ),
            body: ListView.builder(
              itemBuilder: (BuildContext, index){
                return Card(
                  child: ListTile(
                    title: Text(state.user),
                    subtitle: Text("${state.user} sukunimi"),
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