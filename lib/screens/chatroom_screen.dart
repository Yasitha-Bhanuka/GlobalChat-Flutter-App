import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ChatroomScreen extends StatefulWidget {
  String chatroomName;
  String chatroomId;

  ChatroomScreen(
      {super.key, required this.chatroomName, required this.chatroomId});

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  var db = FirebaseFirestore.instance;

  TextEditingController messageController = TextEditingController();

  Future<void> sendMessage() async {
    if (messageController.text.isEmpty) {
      return;
    }

    // send message to chatroom
    Map<String, dynamic> messageToSend = {
      "text": messageController.text,
      "send_name": Provider.of<UserProvider>(context, listen: false).userName,
      "chatroom_id": widget.chatroomId,
      "timestamp": FieldValue.serverTimestamp()
    };

    try {
      await db.collection("messages").add(messageToSend);
    } catch (e) {
      print(e);
    }
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.chatroomName),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(color: Colors.white),
            ),
            Container(
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                            hintText: "Type a message here...",
                            border: InputBorder.none),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        sendMessage();
                      },
                      child: Icon(Icons.send),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
