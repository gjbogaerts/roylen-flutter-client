import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/categories.dart';

class AdForm extends StatefulWidget {
  @override
  _AdFormState createState() => _AdFormState();
}

class _AdFormState extends State<AdForm> {
  final _formKey = GlobalKey<FormState>();

  var _formData = {
    'title': '',
    'description': '',
    'category': '',
    'virtualPrice': 0,
    'adNature': 'offered',
    'picture': ''
  };

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            TextFormField(
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: 'Ten minste vijf tekens', labelText: 'Titel'),
              validator: (val) {
                if (val.isEmpty || val.length < 5) {
                  return 'Titel moet ten minste vijf tekens lang zijn';
                }
                return null;
              },
              onSaved: (val) {
                _formData['title'] = val;
              },
            ),
            TextFormField(
              autocorrect: true,
              decoration: const InputDecoration(
                  hintText: 'Ten minste dertig tekens',
                  labelText: 'Beschrijving'),
              validator: (val) {
                if (val.isEmpty || val.length < 30) {
                  return 'Beschrijving moet ten minste dertig tekens lang zijn';
                }
                return null;
              },
              onSaved: (val) {
                _formData['description'] = val;
              },
            ),
            DropdownButtonFormField(
                decoration:
                    const InputDecoration(labelText: 'Kies je categorie'),
                items: Categories.categories,
                onChanged: (val) {
                  print('keuze is $val');
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Prijs in nix',
                        hintText: 'Gebruik alleen gehele getallen'),
                    validator: (val) {
                      if (val.isEmpty || int.tryParse(val) < 0) {
                        return 'Voer een prijs in, in positieve gehele getallen.';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _formData['virtualPrice'] = val;
                    },
                  ),
                ),
                Flexible(
                  // width: 200,
                  child: SwitchListTile(
                      title: Text('Gevraagd / aangeboden'),
                      value: _formData['adNature'] == 'offered' ? true : false,
                      onChanged: (bool value) {
                        setState(() {
                          if (value) {
                            _formData['adNature'] = 'offered';
                          } else {
                            _formData['adNature'] = 'wanted';
                          }
                        });
                      }),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
