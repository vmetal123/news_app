import 'package:flutter/material.dart';
import 'package:informe_pastran_app/blocs/entries_bloc.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          builder: (context) => EntriesBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'News app',
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  EntriesBloc entriesBloc;
  @override
  Widget build(BuildContext context) {
    entriesBloc = Provider.of<EntriesBloc>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          StreamBuilder<bool>(
            stream: entriesBloc.loading,
            builder: (context, loadingSnapshot) {
              return StreamBuilder<List<Entry>>(
                stream: entriesBloc.entries,
                builder: (context, entriesSnapsht) {
                  return Container();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
