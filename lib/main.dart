import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:informe_pastran_app/blocs/entries_bloc.dart';
import 'package:informe_pastran_app/common/colors.dart';
import 'package:informe_pastran_app/common/styles.dart';
import 'package:informe_pastran_app/widgets/carousel.dart';
import 'package:provider/provider.dart';

import 'models/entry_model.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    entriesBloc = Provider.of<EntriesBloc>(context);
    entriesBloc.getEntries();
    return Scaffold(
      backgroundColor: secondColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 24.0,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Noticias',
                    style: mainStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.0,),
                  Text(
                    'Informe Pastran'.toUpperCase(),
                    style: dateStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text('Ultimas', style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),),
            ),
            SizedBox(
              height: 16.0,
            ),
            StreamBuilder<bool>(
              stream: entriesBloc.loading,
              builder: (context, loadingSnapshot) {
                return StreamBuilder<List<Entry>>(
                  stream: entriesBloc.latestEntries,
                  builder: (context, latesEntriesSnapshot) {
                    if (loadingSnapshot.hasData &&
                        !loadingSnapshot.data &&
                        latesEntriesSnapshot.hasData) {
                      return Carousel(
                        autoPlay: true,
                        enableInfiniteScroll: true,
                        enlargeCenterPage: true,
                        items: latesEntriesSnapshot.data.map((entry) {
                          return Container(
                            padding: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: entry.imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) {
                                      print(error);
                                      return Icon(Icons.error);
                                    },
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.black,
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [
                                          0.6,
                                          1.0,
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16.0, bottom: 8.0),
                                      child: Text(
                                        '${entry.title}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                );
              },
            ),
            SizedBox(
              height: 16.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text('Todas', style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),),
            ),
            SizedBox(
              height: 16.0,
            ),
            StreamBuilder<bool>(
              stream: entriesBloc.loading,
              builder: (context, loadingSnapshot) {
                return StreamBuilder<List<Entry>>(
                  stream: entriesBloc.entries,
                  builder: (context, entriesSnapsht) {
                    if (loadingSnapshot.hasData &&
                        !loadingSnapshot.data &&
                        entriesSnapsht.hasData) {
                      return Expanded(
                        flex: 3,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: entriesSnapsht.data.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(
                                  left: 16.0, right: 16.0, bottom: 16.0),
                              child: SizedBox(
                                height: 100,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black38,
                                        offset: Offset(0, 0.5),
                                        blurRadius: 0.5,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(4.0),
                                        height: double.infinity,
                                        width: 100.0,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8.0),
                                            bottomLeft: Radius.circular(8.0),
                                            topRight: Radius.circular(8.0),
                                            bottomRight: Radius.circular(8.0),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: entriesSnapsht
                                                .data[index].imageUrl,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Center(
                                                child:
                                                    CircularProgressIndicator()),
                                            errorWidget: (context, url, error) {
                                              print(error);
                                              return Icon(Icons.error);
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '${entriesSnapsht.data[index].title}',
                                                style:
                                                    TextStyle(color: mainColor),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Text(
                                                '${entriesSnapsht.data[index].previewHistory.substring(0, 80)}...',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
