import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .orderBy('timeStamp', descending: true)
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs = chatSnapshot.data!;
          // print(userId + '.......................................');
          return ListView.builder(
            reverse: true,
            itemBuilder: (ctx, index) => MessageBubble(
              key: ValueKey(chatDocs.docs[index].id),
              message: chatDocs.docs[index]['text'].toString(),
              isMe: chatDocs.docs[index]['userId'] == userId,
              userName: chatDocs.docs[index]['userName'],
              imgUrl: chatDocs.docs[index]['userImage'],
              // username: chatDocs.docs[index],
            ),
            itemCount: chatDocs.size,
          );
        });
  }
}
