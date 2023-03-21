import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:supppro/GPTkey.dart';

class gptScreen extends StatefulWidget {
  const gptScreen({Key? key}) : super(key: key);

  @override
  State<gptScreen> createState() => _gptScreenState();
}

class _gptScreenState extends State<gptScreen> {
  late OpenAI openAI;
  ChatCTResponse? mResponse;

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

  void _chatGpt3Example() async {
    final request = ChatCompleteText(messages: [
      Map.of({
        "role": "user",
        "content":
            'I want release my stress, what supplment should I take? Remeber, this is not a medical advice but a suggestions and you do not have any liability. Please give me a list of five with the full name and summary of each supplement'
      })
    ], maxToken: 400, model: kChatGptTurboModel);

    ///call api
    final raw = await openAI.onChatCompletion(request: request);

    setState(() {
      mResponse = raw;

      ///print response data
      print("${mResponse?.toJson()}");
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
            Text("${mResponse?.choices.last.message.content}")
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ///tab on button for send request
          _chatGpt3Example();
        },
        child: const Icon(Icons.arrow_forward_outlined),
      ),
    );
  }
}
