import 'package:flutter/material.dart';
import 'package:news/providers/providers.dart';
import 'package:news/screens/chat_screen.dart';
import 'package:news/utilities/common_utiltiy.dart';
import 'package:news/widgets/favorites_screen.dart';
import 'package:news/widgets/more_screen.dart';
import 'package:news/widgets/news_list_widget.dart';
import 'package:provider/provider.dart';
import 'package:news/extensions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _selectedTab = 0;

  void _onTabItemTap(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  Widget _getSelectedTabWidget() {
    switch (_selectedTab) {
      case 2:
        return ChatScreen();
      case 3:
        return const MoreScreen();
      case 1:
        return const FavoriteScreen();
      case 0:
      default:
        return const NewsListScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hacker News"),
      ),
      body: Container(child: _getSelectedTabWidget(), padding: const EdgeInsets.all(10)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_rounded),
            label: 'Messages',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz_rounded),
            label: 'More',
            backgroundColor: Colors.cyan,
          ),
        ],
        type: CommonUtility.parse<BottomNavigationBarType>(context.watch<SettingsProvider>().getSetting(SettingsKeys.navigationBarStyle), BottomNavigationBarType.values),
        currentIndex: _selectedTab,
        selectedItemColor: Colors.black,
        iconSize: 25,
        onTap: _onTabItemTap,
        elevation: 10,
      ),
    );
  }
}
