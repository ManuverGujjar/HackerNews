import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/providers.dart';
import './widgets.dart';
import '../../../utilities/utilities.dart';

class SharedNewsList extends StatelessWidget {
  const SharedNewsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UtilityBuilder.futureBuilderLoading<void>(
      future: context.read<NewsProvider>().fetchTopStories(),
      builder: (context, data) {
        var topStories = context.watch<NewsProvider>().topStories;
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
