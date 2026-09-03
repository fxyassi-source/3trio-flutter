import 'package:flutter/material.dart';

class PrivacyControls extends StatefulWidget {
  const PrivacyControls({super.key});
  @override State<PrivacyControls> createState() => _PrivacyControlsState();
}
class _PrivacyControlsState extends State<PrivacyControls> {
  bool incognito = false, mapVisible = true, privatePhotos = true, hiddenBio = true;
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Privacy')), body: ListView(children: [
    SwitchListTile(title: const Text('Incognito'), subtitle: const Text('Browse without appearing in normal discovery'), value: incognito, onChanged: (v) => setState(() => incognito = v)),
    SwitchListTile(title: const Text('Map visibility'), subtitle: const Text('Use approximate zones only when enabled'), value: mapVisible, onChanged: (v) => setState(() => mapVisible = v)),
    SwitchListTile(title: const Text('Private photos'), subtitle: const Text('Never publish private media to discovery or feed'), value: privatePhotos, onChanged: (v) => setState(() => privatePhotos = v)),
    SwitchListTile(title: const Text('Hidden bio'), subtitle: const Text('Keep the bio blurred until your chosen reveal condition'), value: hiddenBio, onChanged: (v) => setState(() => hiddenBio = v)),
    const ListTile(title: Text('Location safety'), subtitle: Text('Exact GPS, home, workplace, hotel room and live movement are never shown.')),
  ]));
}
