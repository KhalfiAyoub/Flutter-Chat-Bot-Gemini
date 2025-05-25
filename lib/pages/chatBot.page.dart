import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class chatBotPage extends StatefulWidget {
  chatBotPage({super.key});

  @override
  State<chatBotPage> createState() => _chatBotPageState();
}

class _chatBotPageState extends State<chatBotPage> {
  var messages =[

  ];

  TextEditingController userController = TextEditingController();
  ScrollController  scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    print("Build ..............");
    return Scaffold(
      appBar: AppBar(
        title: Text("DWM ChatBot",
        style: TextStyle(color: Theme.of(context).indicatorColor)
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pop();
            Navigator.pushNamed(context, "/");
          }, icon: Icon(Icons.logout,
          color: Theme.of(context).indicatorColor))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
                itemBuilder: (context, index){
                  return Column(
                    children: [
                      Row(
                        children: [
                          messages[index]['role']=='user'
                              ? SizedBox(width: 80,)
                              :SizedBox(width: 0,),
                          Expanded(
                            child: Card.outlined(
                              margin: EdgeInsets.all(6),
                              color: messages[index]['role']=='user'
                                ?Color.fromARGB(30, 0, 255, 0)
                                :Colors.white
                              ,
                              child: ListTile(
                                title: Text(" ${messages[index]['content']}"),
                              ),
                            ),
                          ),
                          messages[index]['type']=='assistant'
                              ? SizedBox(width: 80,)
                              :SizedBox(width: 0,),
                        ],
                      ),
                      Divider()
                    ],
                  );
                },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: userController,
                    decoration: InputDecoration(
                        hintText: "Your userName",
                        //icon: Icon(Icons.lock),
                        //prefixIcon: Icon(Icons.lock),
                        suffixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor
                            )
                        )
                    ),
                  ),
                ),
                IconButton(onPressed: (){
                  String question = userController.text;

                  setState(() {
                    messages.add({"role": "user", "content": question});
                  });

                  Uri uri = Uri.parse(
                      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyD3xrpvii5tzmnd13n1mjDlBDW2oI6bUFQ");


                  var headers = {
                    "Content-Type": "application/json",
                  };

                  var body = {
                    "contents": [
                      {
                        "parts": messages.map((msg) => {"text": msg['content']}).toList()
                      }
                    ]
                  };

                  http.post(uri, headers: headers, body: jsonEncode(body)).then((resp) {
                    var data = jsonDecode(resp.body);
                    try {
                      String answer = data['candidates'][0]['content']['parts'][0]['text'];
                      setState(() {
                        messages.add({"role": "assistant", "content": answer});
                        scrollController.jumpTo(scrollController.position.maxScrollExtent + 800);
                      });
                    } catch (e) {
                      print("Parsing error: $e");
                      print("Full response: $data");
                      setState(() {
                        messages.add({"type": "assistant", "content": "Erreur dans la réponse de l'API Gemini."});
                      });
                    }
                    userController.text = "";
                  }).catchError((error) {
                    print("Request failed: $error");
                    setState(() {
                      messages.add({"type": "assistant", "content": "Erreur de connexion au serveur Gemini."});
                    });
                  });


                },
                    icon: Icon(Icons.send)
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}
