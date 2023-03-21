import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supppro/providers/app_state.dart';
import 'package:supppro/providers/suppItem.dart';
import 'package:translator/translator.dart';

class ProductCard extends StatefulWidget {
  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  static List<String> lang_list = <String>[
    'es',
    'zh-cn',
    'fr',
    'de',
    'it',
    'ja',
    'la',
    'plR'
  ];
  var _needTranslation = false;
  String translated_txt = "";
  String dropdownValue = lang_list.first;

  @override
  Widget build(BuildContext context) {
    SuppItem suppItem = Provider.of<SuppItems>(context, listen: false)
        .currentSuppItem as SuppItem;
    final marketStatusColor = suppItem.marketStatus == 'Available'
        ? Colors.red
        : Colors.green; // set color based on marketStatus

    return Scaffold(
      body: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              Text(suppItem.productName,
                  style: TextStyle(
                    fontSize: 36,
                    color: Theme.of(context).colorScheme.primary,
                  )
                  //Theme.of(context).textTheme.headline6,
                  ),
              const SizedBox(height: 8),
              Row(children: [
                _buildInfoBox(
                  context,
                  'Brand',
                  suppItem.brandName,
                ),
                const SizedBox(width: 8),
                _buildInfoBox(context, 'Net Contents', suppItem.netContents),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                _buildInfoBox(context, 'Serving Size', suppItem.servingSize),
                const SizedBox(width: 8),
                _buildInfoBox(context, 'Product Type', suppItem.productType),
                const SizedBox(width: 8)
              ]),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildInfoBox(
                      context, 'Supplement Form', suppItem.supplementForm),
                  const SizedBox(width: 8),
                  _buildInfoBox(context, 'Market Status', suppItem.marketStatus,
                      marketStatusColor),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Suggested Use',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(height: 8),
              Text(
                suppItem.suggestedUse,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Row(
                children: [
                  Text("Translate to: "),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Colors.orange,
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _needTranslation = true;
                        dropdownValue = value!;
                      });

                      final translator = GoogleTranslator();
                      translator
                          .translate(suppItem.suggestedUse,
                              from: 'en', to: '$dropdownValue')
                          .then((result) {
                        setState(() {
                          translated_txt = result.toString();
                        });

                        print(translated_txt);
                      });
                      // getTranslation(suppItem.suggestedUse, dropdownValue)
                      //     .then((val) {
                      //   translated_txt = val.toString() as String;
                      //   print(translated_txt);
                      // });
                      print(dropdownValue);
                    },
                    items:
                        lang_list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              (translated_txt == "" && _needTranslation)
                  ? CircularProgressIndicator()
                  : Text(translated_txt)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<SuppItems>(context, listen: false).addItem(suppItem);
          Provider.of<ApplicationState>(context, listen: false)
              .addRecordtoUser(suppItem);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildInfoBox(BuildContext context, String label, String value,
      [Color boxcolor = Colors.grey]) {
    return Container(
      decoration: BoxDecoration(
        color: boxcolor,
        //Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.caption?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
