import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.userName,
    required this.imgUrl,
  }) : super(key: key);

  final String userName;
  final String message;
  final bool isMe;
  final String imgUrl;

  final GlobalKey _messageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              key: _messageKey,
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.grey[300]
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15),
                  bottomLeft: isMe
                      ? const Radius.circular(15)
                      : const Radius.circular(0),
                  bottomRight: !isMe
                      ? const Radius.circular(15)
                      : const Radius.circular(0),
                ),
              ),
              // width: MediaQuery.of(context).size.width * 0.7,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: isMe
                        ? const EdgeInsets.only(left: 17)
                        : const EdgeInsets.only(right: 17),
                    child: Text(
                      userName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isMe
                            ? Colors.black
                            : Theme.of(context).textTheme.headline1!.color,
                      ),
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).textTheme.headline1!.color,
                    ),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(imgUrl),
            ),
          ],
        ),
      ],
    );
  }
}
