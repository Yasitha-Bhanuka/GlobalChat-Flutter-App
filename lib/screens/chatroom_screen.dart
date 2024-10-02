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
      "send_id": Provider.of<UserProvider>(context, listen: false).userId,
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

  Widget singleChatItem(
      {required String sender_name,
      required String text,
      required String send_id}) {
    return Column(
      crossAxisAlignment:
          send_id == Provider.of<UserProvider>(context, listen: false).userId
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, right: 6),
          child: Text(
            sender_name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
            decoration: BoxDecoration(
                color: send_id ==
                        Provider.of<UserProvider>(context, listen: false).userId
                    ? Colors.green
                    : Colors.blue,
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: TextStyle(color: Colors.white),
              ),
            )),
        SizedBox(
          height: 8,
        )
      ],
    );
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
              child: StreamBuilder(
                  stream: db
                      .collection("messages")
                      .where("chatroom_id", isEqualTo: widget.chatroomId)
                      .orderBy("timestamp", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Center(child: Text("Some error has occured!"));
                    }
                    var allMessages = snapshot.data?.docs ?? [];

                    if (allMessages.isEmpty) {
                      return Center(child: Text("No messages yet!"));
                    }
                    return ListView.builder(
                        reverse: true,
                        itemCount: allMessages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: singleChatItem(
                                sender_name: allMessages[index]["send_name"],
                                text: allMessages[index]["text"],
                                send_id: allMessages[index]["send_id"]),
                          );
                        });
                  }),
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
