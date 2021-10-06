import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:news/widgets/message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy(
              'createdAt',
              descending: true,
            )
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs = chatSnapshot.data!.docs;
          return ListView.builder(
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (ctx, index) => MessageBubble(
              chatDocs[index]['text'],
              chatDocs[index]['username'],
              chatDocs[index]['userId'] == currentUser.uid,
              ValueKey(chatDocs[index].id),
            ),
          );
        });
  }
}
