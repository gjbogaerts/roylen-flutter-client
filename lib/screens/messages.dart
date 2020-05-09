import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/messages.dart';
import '../utils/server_interface.dart';
import '../widgets/background.dart';

class MessagesScreen extends StatefulWidget {
  static const routeName = '/messages';
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  bool _showRead = true;

  void toggleRead() {
    setState(() {
      _showRead = !_showRead;
    });
  }

  void _markAsRead(String _msgId, bool isRead) async {
    var msgProvider = Provider.of<Messages>(context, listen: false);
    await msgProvider.markAsRead(_msgId, isRead);
  }

  void _startSendReply(String adId, String adTitle, String toId) async {
    bool result = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              content: Builder(
                builder: (context) {
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;
                  var controller = TextEditingController();
                  return Container(
                    padding: EdgeInsets.all(20),
                    height: height / 3,
                    width: width / 1.5,
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Antwoord',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Type hier je boodschap'),
                            maxLines: 3,
                            onChanged: (val) {
                              controller.text = val;
                            },
                          ),
                        ),
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            _sendReply(adId, adTitle, controller.text, toId);
                            Navigator.of(context).pop(true);
                          },
                          child: Text('Verzenden'),
                        )
                      ],
                    ),
                  );
                },
              ),
            ));
    if (result) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          actions: <Widget>[
            FlatButton(
                color: Theme.of(context).accentColor,
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
          content: Text('Je boodschap is verstuurd.'),
        ),
      );
    }
  }

  void _sendReply(
      String adId, String adTitle, String message, String toId) async {
    var msgProvider = Provider.of<Messages>(context, listen: false);
    await msgProvider.sendMessage(
        adId: adId, adTitle: adTitle, message: message, toId: toId);
  }

  @override
  Widget build(BuildContext context) {
    var baseUrl = ServerInterface.getBaseUrl();
    return Scaffold(
      appBar: AppBar(title: Text('Je boodschappen')),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Messages>(context).fetchAndSetMessages(),
        builder: (context, result) {
          return Stack(
            children: <Widget>[
              Background(),
              result.connectionState == ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : result.data.length == 0
                      ? Center(
                          child: Text('Nog geen boodschappen voor je'),
                        )
                      : SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: <Widget>[
                                FlatButton(
                                  textColor: Theme.of(context).primaryColor,
                                  child: Text(_showRead
                                      ? 'Verberg de gelezen berichten'
                                      : 'Toon de gelezen berichten'),
                                  onPressed: toggleRead,
                                ),
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: result.data.length,
                                    itemBuilder: (ctx, idx) {
                                      var _msg = result.data[idx];
                                      if (!_showRead && _msg.isRead) {
                                        return null;
                                      }
                                      return ExpansionTile(
                                        leading: CircleAvatar(
                                          backgroundImage: _msg
                                                      .creator.avatar ==
                                                  null
                                              ? AssetImage(
                                                  'assets/images/image9.jpeg')
                                              : NetworkImage(_msg.creator.avatar
                                                      .startsWith('http')
                                                  ? _msg.creator.avatar
                                                  : '$baseUrl${_msg.creator.avatar}'),
                                          radius: 15,
                                        ),
                                        title: Text(
                                          _msg.creator.screenName,
                                          style: _msg.isRead
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                      decoration: TextDecoration
                                                          .lineThrough)
                                              : Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                        ),
                                        subtitle: Text(
                                          _msg.adTitle,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  _msg.message,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  RaisedButton(
                                                      color: Theme.of(context)
                                                          .canvasColor,
                                                      child: Text(_msg.isRead
                                                          ? 'Markeer als ongelezen'
                                                          : 'Markeer als gelezen'),
                                                      onPressed: () {
                                                        _markAsRead(_msg.id,
                                                            _msg.isRead);
                                                      }),
                                                  RaisedButton(
                                                    child: Text('Antwoord'),
                                                    onPressed: () {
                                                      _startSendReply(
                                                          _msg.adId,
                                                          _msg.adTitle,
                                                          _msg.creator.id);
                                                    },
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ),
            ],
          );
        },
      ),
    );
  }
}
