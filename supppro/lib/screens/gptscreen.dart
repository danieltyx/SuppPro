import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:provider/provider.dart';
import 'package:supppro/GPTkey.dart';
import 'package:supppro/providers/app_state.dart';
import 'package:supppro/providers/suppItem.dart';

class gptScreen extends StatefulWidget {
  const gptScreen({Key? key}) : super(key: key);

  @override
  State<gptScreen> createState() => _gptScreenState();
}

class _gptScreenState extends State<gptScreen> {
  late OpenAI openAI;
  ChatCTResponse? mResponse;
  String? response = "empty";
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
        "Question:Whether these drugs interact among themselves: ${mymeds.toString().substring(1, mymeds.toString().length - 1)}, ${suppnames.toString().substring(1, suppnames.toString().length - 1)}. Please give me a yes-or-no answer and use one sentence to explain the reason behind. I will not take it as medical advice and I will consult with my doctor.";
    print("###$myprompt");
    return myprompt;
  }

  void _chatGpt3Example(String myprompt) async {
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
      print("@@@@@ $response");
    });
  }

  void _detailexplain(String myprompt) async {
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
      print("@@@@@ $response");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            Text("${mResponse?.choices.last.message.content}"),
            Row(
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
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ///tab on button for send request
          ///

          promptprep().then((value) {
            return _chatGpt3Example(value);
          });
        },
        child: const Icon(Icons.arrow_forward_outlined),
      ),
    );
  }
}
