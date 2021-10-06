import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/providers.dart';
import '../../../utilities/utilities.dart';
import './widgets.dart';

class NewsListScreen extends StatelessWidget {
  const NewsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UtilityBuilder.futureBuilderLoading<void>(
      future: context.read<NewsProvider>().fetchTopStories(),
      builder: (context, data) {
        var topStories = context.read<NewsProvider>().topStories;
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
