class Message {
  final String message;
  final String username;

  Message({required this.message, required this.username});

  factory Message.fromJson(Map<String, dynamic> message) {
    return Message(message: message['message'], username: message['username']);
  }
}
