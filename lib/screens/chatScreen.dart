import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:toast/toast.dart';
// import 'package:provider/provider.dart';
import 'package:chat_app/models/message.dart';

import '../component/MessageCard.dart';

String headerTitle = 'Page 2';
// ToastContext.init(context);

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

List<Message> messages = [];

class _ChatScreenState extends State<ChatScreen> {
  late Socket socket;
  final TextEditingController messageInputController = TextEditingController();

  void runSocket() {
    // print("Socket init");
    socket.onConnect((_) {
      socket.emit('user_join', 'flutterDevice');
      // print('connect');
    });

    socket.onDisconnect((_) {
      // print('disconnect');
    });

    socket.on('chat_message', (data) {
      // print(data);
      setState(() {
        messages.add(Message.fromJson(data));
      });
    });

    socket.on("user_leave", (data) {
      // print(data);
      // Toast.show(data + " has left the chat.", duration: Toast.lengthShort, gravity:  Toast.bottom);
    });
  }

  void sendMessage() {
    final String message = messageInputController.text.trim();
    // print(message.isNotEmpty);
    if (message.isNotEmpty) {
      socket.emit(
          'chat_message', {'message': message, 'username': 'flutterDevice'});
      messageInputController.clear();
      setState(() {
        messages.add(Message(message: message, username: 'flutterDevice'));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    socket = io(
        'https://backend-skillup.herokuapp.com/',
        OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
            // .setExtraHeaders({'foo': 'bar'}) // optional
            .build());
    runSocket();
  }

  @override
  void dispose() {
    messageInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return (MessageCard(
                      messages: messages[index].message,
                      username: messages[index].username,
                    ));
                  },
                  itemCount: messages.length),
            ),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Form(
                  // margin
                  // key: _formKey,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          // controller: _messageInputController,
                          controller: messageInputController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Message',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (messageInputController.text.trim().isNotEmpty) {
                              sendMessage();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              // backgroundColor:
                              //     const Color.fromARGB(255, 5, 136, 244),
                              // disabledForegroundColor:
                              //     const Color.fromARGB(255, 233, 240, 239),
                              fixedSize: const Size(50, 50),
                              shape: const CircleBorder()),
                          // child: const Text(""),
                          child: const Icon(Icons.send),
                        ),
                      ),
                      // const ElevatedButton(onPressed: null, child: Text("Sell")),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
