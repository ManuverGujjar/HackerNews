import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:news/models/news_item.dart';
import 'package:news/providers/providers.dart';
import 'package:provider/provider.dart';

class CommonUtility {
  static void showSnackbarText(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  static T parse<T>(dynamic value, List<T> values) {
    if (value is T) return value;
    return values.firstWhere((element) => element.toString() == value.toString());
  }

  static void openStory(BuildContext context, NewsItem newsItem) {
    var url = newsItem.url ?? "https://news.ycombinator.com/item?id=${newsItem.id}";
    var openInExternalBroswer = CommonUtility.parse<bool>(context.read<SettingsProvider>().getSetting(SettingsKeys.openInExternalBroswer), [false, true]);

    if (!openInExternalBroswer) {
      Navigator.of(context).pushNamed('/web-view', arguments: url);
    } else {
      FlutterWebBrowser.openWebPage(
        url: url,
        customTabsOptions: const CustomTabsOptions(
          colorScheme: CustomTabsColorScheme.dark,
          toolbarColor: Colors.deepPurple,
          secondaryToolbarColor: Colors.green,
          navigationBarColor: Colors.amber,
          addDefaultShareMenuItem: true,
          instantAppsEnabled: true,
          showTitle: true,
          urlBarHidingEnabled: true,
        ),
        safariVCOptions: const SafariViewControllerOptions(
          barCollapsingEnabled: true,
          preferredBarTintColor: Colors.green,
          preferredControlTintColor: Colors.amber,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
          modalPresentationCapturesStatusBarAppearance: true,
        ),
      );
    }
  }
}
