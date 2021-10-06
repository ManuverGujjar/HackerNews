import 'package:flutter/material.dart';
import 'package:news/providers/providers.dart';
import 'package:news/utilities/utilities.dart';
import 'package:news/widgets/news_item_view_widget.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UtilityBuilder.futureBuilderLoading<void>(
      future: context.read<NewsProvider>().fetchTopStories(),
      builder: (context, data) {
        var topStories = context.read<NewsProvider>().favorites;
        if (topStories.isEmpty) {
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Center(
                child: Column(
              children: const [
                Icon(Icons.tag_faces_rounded),
                Text(
                  "Nothing in Favorites yet. Click on Heart icon to add stories to favorites screen",
                  textAlign: TextAlign.center,
                ),
              ],
            )),
          ]);
        }
        return ListView.builder(
          itemCount: topStories.length,
          itemBuilder: (context, index) {
            return NewsItemView(id: topStories[index]);
          },
        );
      },
    );
  }
}
