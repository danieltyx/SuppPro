import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:supppro/providers/suppItem.dart';
import '../providers/app_state.dart';
import '../src/ExpandableFab.dart';
import '../src/authentication.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  List<SuppItem> suppdata = [];
  List<String> _medicines = [];
  void didChangeDependencies() async {
    try {
      suppdata = await Provider.of<ApplicationState>(context, listen: false)
          .fetchSupplementData();
      _medicines = await Provider.of<ApplicationState>(context, listen: false)
          .fetchMedData();
      setState(() {
        suppdata;
        _medicines;
      });
      print(suppdata.length);
      super.didChangeDependencies();
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Supp Pro"),
        actions: [
          IconButton(
              onPressed: () {
                context.push('/scan-barcode');
              },
              icon: Icon(Icons.add)),
          IconButton(
              onPressed: () {
                context.push('/profile');
              },
              icon: Icon(Icons.settings)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          suppdata = await Provider.of<ApplicationState>(context, listen: false)
              .fetchSupplementData();
          _medicines =
              await Provider.of<ApplicationState>(context, listen: false)
                  .fetchMedData();
          setState(() {
            suppdata;
            _medicines;
          });
        },
        child: Column(children: [
          Row(children: [
            Text(
              "Supplments",
              style: TextStyle(fontSize: 22),
            ),
            Spacer()
          ]),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 300,
            child: GridView.builder(
              itemCount: suppdata.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Provider.of<SuppItems>(context, listen: false)
                        .setCurrentItem(suppdata[index]);
                    context.push('/view-detail');
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(suppdata[index].productName),
                        const SizedBox(height: 10),
                        Text(suppdata[index].productType),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Row(children: [
            Text(
              "Rx/OTC drugs",
              style: TextStyle(fontSize: 22),
            ),
            Spacer()
          ]),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: GridView.builder(
              itemCount: _medicines.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 3.0,
              ),
              itemBuilder: (context, index) {
                return Card(
                  child: Center(
                    child: Text(_medicines[index]),
                  ),
                );
              },
            ),
          ),
          Spacer(),
          ElevatedButton(
              onPressed: () {
                context.push('/gpt-query');
              },
              child: Text("Check Drug Interactions")),
          Spacer()
        ]),
      ),
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          Row(
            children: [
              Text("Add Rx Drug and OTC"),
              ActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Add Rx/OTC Drugs'),
                        content: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                decoration: InputDecoration(
                                  labelText: 'Add ',
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            SizedBox(
                              height: 48.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _medicines.add(_controller.text);

                                    Provider.of<ApplicationState>(context,
                                            listen: false)
                                        .addMedtoDB(_controller.text);
                                    _controller.clear();
                                  });
                                },
                                child: Text('Add'),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.medical_services_rounded),
              ),
            ],
          ),
          Row(
            children: [
              Text("Lookup/Add Supplments"),
              ActionButton(
                onPressed: () => context.push('/scan-barcode'),
                icon: const Icon(Icons.health_and_safety),
              ),
            ],
          ),
          Row(
            children: [
              Text("Set Goals"),
              ActionButton(
                onPressed: () => context.push('/goal-select'),
                icon: const Icon(Icons.flag),
              ),
            ],
          )
        ],
      ),
    );
  }
}
