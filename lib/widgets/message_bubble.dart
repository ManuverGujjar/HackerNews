import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:news/providers/providers.dart';
import 'package:news/utilities/common_utiltiy.dart';
import 'package:news/utilities/utilities.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message, this.userName, this.isMe, this.key);

  final Key key;
  final String message;
  final String userName;
  final bool isMe;

  Widget _getMessageContent(BuildContext context) {
    if (message.startsWith("manuver-hn://")) {
      int id = int.parse(message.replaceAll("manuver-hn://", ""));
      return UtilityBuilder.futureBuilderLoading<void>(
          future: context.read<NewsProvider>().fetchById(id),
          builder: (context, data) {
            var newsItem = context.watch<NewsProvider>().getById(id)!;
            return FocusedMenuHolder(
              onPressed: () {
                CommonUtility.openStory(context, newsItem);
              },
              menuItems: [
                FocusedMenuItem(
                    title: Text((newsItem.isFavorite ?? false) ? 'Remove from Favorites' : 'Add to Favorites'),
                    trailingIcon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      context.read<NewsProvider>().toggleFavorite(id);
                    }),
                FocusedMenuItem(
                    title: const Text('Copy Link to Clipborad'),
                    trailingIcon: const Icon(
                      Icons.copy,
                    ),
                    onPressed: () {
                      CommonUtility.copyToClipboard(newsItem.url ?? "https://news.ycombinator.com/item?id=${newsItem.id}").then((value) {
                        CommonUtility.showSnackbarText(context, 'Copied to the clipboard');
                      });
                    })
              ],
              child: InkWell(
                  child: Card(
                      child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(newsItem.title, textAlign: TextAlign.start, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("by ${newsItem.by}"), const SizedBox(width: 4), Text("score: ${newsItem.score}")],
                    )
                  ],
                ),
              ))),
            );
          });
    }

    return Text(
      message,
      style: TextStyle(
        color: isMe ? Colors.black : Colors.black,
      ),
      textAlign: isMe ? TextAlign.end : TextAlign.start,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[300] : Colors.amber,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: !isMe ? const Radius.circular(0) : const Radius.circular(12),
              bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
            ),
          ),
          width: 300,
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isMe ? Colors.black : Colors.black,
                ),
              ),
              _getMessageContent(context)
            ],
          ),
        ),
      ],
    );
  }
}
