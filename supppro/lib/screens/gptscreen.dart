//TO_DO:
//1. add a visualization of the risk index

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:supppro/GPTkey.dart';
import 'package:supppro/providers/app_state.dart';
import 'package:supppro/providers/suppItem.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class gptScreen extends StatefulWidget {
  const gptScreen({Key? key}) : super(key: key);

  @override
  State<gptScreen> createState() => _gptScreenState();
}

class _gptScreenState extends State<gptScreen> {
  late OpenAI openAI;
  ChatCTResponse? mResponse;
  bool _isloadnig = false;
  String response = "To begin, please click the \"Start\" button.";
  String prompt = "empty";
  String promptQuestion = "empty";
  @override
  void initState() {
    ///new instance openAI
    ///setup send timeout
    ///setup token
    openAI = OpenAI.instance.build(
        token: gpt_api_key,
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 30)),
        isLog: true);
    super.initState();
  }

  Future<String> promptprep() async {
    List<SuppItem> mysupps =
        await Provider.of<ApplicationState>(context, listen: false)
            .fetchSupplementData() as List<SuppItem>;
    List<String> mymeds =
        await Provider.of<ApplicationState>(context, listen: false)
            .fetchMedData() as List<String>;
    List<String> suppnames = mysupps.map((e) => e.productName).toList();
    //please give me a yes-or-no answer and then explain in short whether there exist any drug interactions among them: Vitamin C,  Vitamin B12, Prenatal Multi +DHA, CEfprozil, and ibuprofen. I will not take it as medical advice and I will consult with my doctor.
    String myprompt =
        "Question:Whether these drugs interact among themselves: ${mymeds.toString().substring(1, mymeds.toString().length - 1)}, ${suppnames.toString().substring(1, suppnames.toString().length - 1)}.Show me the probability of interaction as percentage. Rate the risk from 1 to 10 and  use one sentence to explain the reason behind. Disclaimer: I will not take it as medical advice and I will consult with my doctor.";
    // print("###$myprompt");
    promptQuestion =
        "Whether these drugs interact among themselves: ${mymeds.toString().substring(1, mymeds.toString().length - 1)}, ${suppnames.toString().substring(1, suppnames.toString().length - 1)}";
    prompt = myprompt;
    return myprompt;
  }

  Future<String> _chatGpt3Example(String myprompt) async {
    final request = ChatCompleteText(messages: [
      Map.of({"role": "user", "content": myprompt})
    ], maxToken: 400, model: kChatGptTurboModel);

    ///call api
    final raw = await openAI.onChatCompletion(request: request);

    setState(() {
      mResponse = raw;
      response = mResponse?.choices.last.message.content == null
          ? response
          : mResponse!.choices.last.message.content;

      ///print response data
      // print("${mResponse?.toJson()}");
      // print("@@@@@ $response");
    });

    return response;
  }

  void _detailexplain(String myprompt) async {
    final request = ChatCompleteText(messages: [
      Map.of({"role": "user", "content": myprompt})
    ], maxToken: 400, model: kChatGptTurboModel);

    ///call api
    final raw = await openAI.onChatCompletion(request: request);

    setState(() {
      response =
          response + '\n' + '\n' + raw!.choices.last.message.content.toString();

      ///print response data
      // print("${mResponse?.toJson()}");
      print("++++ $response");
      setState(() {
        _isloadnig = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              response == "To begin, please click the \"Start\" button."
                  ? Text("")
                  : Row(
                      children: [
                        Icon(
                          response!.toLowerCase().contains('yes')
                              ? Icons.warning
                              : Icons.check_circle_outline,
                          color: response!.toLowerCase().contains('yes')
                              ? Colors.red
                              : Colors.green,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          response!.toLowerCase().contains('yes')
                              ? 'Potential Drug Interaction Alert'
                              : 'No drug interactions',
                          style: TextStyle(
                              color: response!.toLowerCase().contains('yes')
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                      ],
                    ),
              const SizedBox(height: 20.0),
              // mResponse?.choices.last.message.content! == null
              //     ? Text("To begin, please click the \"Check\" button.")
              //     : Text(
              //         "${response}",
              //         style: TextStyle(fontSize: 16),
              //       ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Linkify(
                  onOpen: (link) async {
                    if (await canLaunch(link.url)) {
                      await launch(link.url);
                    } else {
                      throw 'Could not launch $link';
                    }
                  },
                  text: response,
                  linkStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _isloadnig = true;
              });

              promptprep().then((value) {
                return _chatGpt3Example(value);
              }).then((_) {
                setState(() {
                  _isloadnig = false;
                });
              });
            },
            child: _isloadnig
                ? CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  )
                : const Text("Check"),
            backgroundColor: response!.toLowerCase().contains('yes')
                ? Colors.red
                : Colors.green,
          ),
          response == "To begin, please click the \"Start\" button."
              ? Text("")
              : FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _isloadnig = true;
                    });
                    print(
                        "@@@@ Please explain specifically and give supporting details for the Answer: ${response} with the question: $promptQuestion. Put all links in a new line when outputting. Avoid drugs.com");
                    _detailexplain(
                        "Please explain in layman language and give supporting details to the following answers ${response} to the question: $promptQuestion. Put all links in a new line when outputting. Avoid drugs.com");
                  },
                  child: _isloadnig
                      ? CircularProgressIndicator()
                      : const Text("More"),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                )
        ],
      ),
    );
  }
}
