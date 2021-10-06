import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:news/models/models.dart';
import 'package:news/utilities/common_utiltiy.dart';
import 'package:news/utilities/firebase_utility.dart';
import 'package:news/utilities/utilities.dart';
import 'package:provider/provider.dart';
import 'package:news/providers/providers.dart';
import 'package:news/extensions.dart';

class NewsItemView extends StatelessWidget {
  final int id;

  const NewsItemView({required this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UtilityBuilder.futureBuilderLoading<void>(
        future: context.read<NewsProvider>().fetchById(id),
        onLoading: const ListTile(
          title: Text(
            'Loading...',
            textAlign: TextAlign.center,
          ),
        ),
        builder: (context, _) {
          final newsItem = context.watch<NewsProvider>().getById(id);
          return FocusedMenuHolder(
            menuItems: [
              FocusedMenuItem(
                title: const Text('Share'),
                onPressed: () {
                  if (FirebaseAuth.instance.currentUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please login in Messages Tab First to continue")));
                    return;
                  }
                  FirebaseUtility.sendMessage('manuver-hn://$id').then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Shared Successfully')));
                  });
                },
                trailingIcon: const Icon(Icons.share),
              ),
              FocusedMenuItem(
                title: const Text('Copy Link'),
                onPressed: () {
                  CommonUtility.copyToClipboard(newsItem!.url ?? "https://news.ycombinator.com/item?id=${newsItem.id}").then((value) {
                    CommonUtility.showSnackbarText(context, 'Link copied to the Clipboard');
                  });
                },
                trailingIcon: const Icon(Icons.copy),
              ),
            ],
            onPressed: () {
              CommonUtility.openStory(context, newsItem!);
            },
            child: Column(
              children: [
                Dismissible(
                  direction: DismissDirection.startToEnd,
                  key: ValueKey(newsItem!.id.toString()),
                  confirmDismiss: (DismissDirection direction) async {
                    return false;
                  },
                  background: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    color: Theme.of(context).errorColor,
                    alignment: Alignment.centerLeft,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(newsItem.score.toString()),
                      ),
                      title: Text(
                        newsItem.title,
                        style: const TextStyle(letterSpacing: 2),
                      ),
                      trailing: IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: (newsItem.isFavorite ?? false) ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            context.read<NewsProvider>().toggleFavorite(id);
                          }),
                      subtitle: Text('by ${newsItem.by} at ${newsItem.time.formattedDate()}'),
                    ),
                  ),
                ),
                const Divider(
                  height: 2,
                )
              ],
            ),
          );
        });
  }
}
