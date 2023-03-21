import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:supppro/providers/suppItem.dart';
import '../providers/app_state.dart';
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
  @override
  List<SuppItem> suppdata = [];
  void didChangeDependencies() async {
    try {
      suppdata = await Provider.of<ApplicationState>(context, listen: false)
          .fetchSupplementData();
    } catch (error) {
      print(error.toString());
    }
    print(suppdata.length);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Supp Pro")),
      body: Column(children: [
        ElevatedButton(
            onPressed: () {
              context.push('/scan-barcode');
            },
            child: Text("Search")),

        ElevatedButton(
            onPressed: () {
              context.push('/profile');
            },
            child: Text("Settings")),
        Container(
          height: 400,
          child: GridView.builder(
            itemCount: suppdata.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(suppdata[index].productName),
                    const SizedBox(height: 10),
                    Text(suppdata[index].productType),
                  ],
                ),
              );
            },
          ),
        )
        // Consumer<ApplicationState>(
        //   builder: (context, appState, _) => AuthFunc(
        //       loggedIn: appState.loggedIn,
        //       signOut: () {
        //         FirebaseAuth.instance.signOut();
        //       }),
        // )
      ]),
    );
  }
}
