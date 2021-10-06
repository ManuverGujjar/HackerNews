import 'package:flutter/material.dart';
import 'package:news/providers/providers.dart';
import 'package:news/utilities/common_utiltiy.dart';
import 'package:provider/provider.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({Key? key}) : super(key: key);

  Widget _getNavigationBarTypeSetting(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Navigation Bar Type',
        ),
        DropdownButton<BottomNavigationBarType>(
          items: BottomNavigationBarType.values.map((value) {
            return DropdownMenuItem<BottomNavigationBarType>(
              value: value,
              child: Text(value.toString().replaceRange(0, value.toString().indexOf('.') + 1, '')),
            );
          }).toList(),
          onChanged: (value) {
            context.read<SettingsProvider>().setSetting(SettingsKeys.navigationBarStyle, value ?? "");
          },
          value: CommonUtility.parse<BottomNavigationBarType>(context.watch<SettingsProvider>().getSetting(SettingsKeys.navigationBarStyle), BottomNavigationBarType.values),
        ),
      ],
    );
  }

  Widget _getBrowserPreference(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Open links in external browser',
        ),
        Switch(
            value: CommonUtility.parse<bool>(context.watch<SettingsProvider>().getSetting(SettingsKeys.openInExternalBroswer), [false, true]),
            onChanged: (value) {
              context.read<SettingsProvider>().setSetting(SettingsKeys.openInExternalBroswer, value);
            })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _getNavigationBarTypeSetting(context),
        const SizedBox(
          height: 8,
        ),
        _getBrowserPreference(context),
      ],
    );
  }
}
