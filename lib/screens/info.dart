import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/contact_form.dart';
import '../models/faqs.dart';
import '../widgets/background.dart';

class InfoScreen extends StatefulWidget {
  static const routeName = '/info';

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  List<Faq> _faqs = [];

  @override
  void initState() {
    _faqs = Faqs.faqs;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Over Roylen'),
      ),
      drawer: AppDrawer(),
      body: Stack(
        children: <Widget>[
          Background(),
          SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ContactForm(),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: <Widget>[
                      Text('FAQ', style: Theme.of(context).textTheme.headline6),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              _faqs[index].isExpanded = !isExpanded;
                            });
                          },
                          children: _faqs.map<ExpansionPanel>((Faq faq) {
                            return ExpansionPanel(
                                canTapOnHeader: true,
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return ListTile(title: Text(faq.headerValue));
                                },
                                body: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        18, 0, 18, 18),
                                    child: Text(faq.expandedValue)),
                                isExpanded: faq.isExpanded);
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
