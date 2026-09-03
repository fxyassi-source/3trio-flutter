import 'package:flutter/material.dart';
import 'core/app_constants.dart';
import 'core/design_system.dart';

class AgeGateScreen extends StatelessWidget {
  const AgeGateScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [const Text('3TRIO', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w800)), const SizedBox(height: 12), const Text('Adults 18+ only', style: TextStyle(fontSize: 18)), const SizedBox(height: 28), TrioButton(label: 'I am 18 or older', onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())))]))));
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Sign in')), body: Padding(padding: const EdgeInsets.all(24), child: Column(children: [TrioButton(label: 'Continue with Google', onPressed: () => _open(context, const VerificationScreen())), const SizedBox(height: 12), TrioButton(label: 'Continue with Apple', onPressed: () => _open(context, const VerificationScreen())), const SizedBox(height: 12), TrioButton(label: 'Continue with Phone', onPressed: () => _open(context, const PhoneLoginScreen()))]));
}

class PhoneLoginScreen extends StatelessWidget {
  const PhoneLoginScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Phone login')), body: Padding(padding: const EdgeInsets.all(24), child: Column(children: [const TextField(decoration: InputDecoration(labelText: 'Phone number')), const SizedBox(height: 16), TrioButton(label: 'Send OTP', onPressed: () => _open(context, const VerificationScreen()))]));
}

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});
  @override State<VerificationScreen> createState() => _VerificationScreenState();
}
class _VerificationScreenState extends State<VerificationScreen> {
  final states = <String, String>{'Photo':'Not started','Government ID':'Not started','Voice':'Not started'};
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Verification')), body: ListView(padding: const EdgeInsets.all(20), children: [...states.keys.map((name) => ListTile(title: Text(name), subtitle: Text(states[name]!), trailing: FilledButton(onPressed: () => setState(() => states[name] = name == 'Voice' ? 'Recorded • Pending' : 'Submitted • Pending'), child: Text(name == 'Voice' ? 'Record' : 'Start')))), Padding(padding: const EdgeInsets.only(top: 20), child: TrioButton(label: 'Continue to 3TRIO', onPressed: () => _open(context, const HomeShell())))]));
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override State<HomeShell> createState() => _HomeShellState();
}
class _HomeShellState extends State<HomeShell> {
  int tab = 0;
  final pages = const [DiscoverScreen(), FeedScreen(), MapScreen(), LikesScreen(), MessagesScreen()];
  @override Widget build(BuildContext context) => Scaffold(body: IndexedStack(index: tab, children: pages), bottomNavigationBar: NavigationBar(selectedIndex: tab, onDestinationSelected: (v) => setState(() => tab = v), destinations: AppConstants.bottomTabs.map((x) => NavigationDestination(icon: const Icon(Icons.circle_outlined), label: x)).toList()));
}

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Discover'), actions: [IconButton(onPressed: () => _open(context, const FiltersScreen()), icon: const Icon(Icons.tune)), IconButton(onPressed: () => _open(context, const SettingsScreen()), icon: const Icon(Icons.settings_outlined))]), body: ListView(padding: const EdgeInsets.all(16), children: [_profile(context, 'Alex', 29, 'Curious • Open to connections'), _profile(context, 'Sam', 32, 'Couples • Social • Verified')]));
}
Widget _profile(BuildContext context, String name, int age, String subtitle) => Container(margin: const EdgeInsets.only(bottom: 18), height: 470, decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF17233F), Color(0xFF090B12)])), child: Stack(children: [const Positioned.fill(child: Center(child: Icon(Icons.person, size: 110, color: Colors.white24))), Positioned(left: 18, right: 18, bottom: 18, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('$name, $age', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700)), const SizedBox(height: 5), const Text('Photo verified  •  3 km away'), const SizedBox(height: 8), Text(subtitle), const SizedBox(height: 15), Row(children: [_action(Icons.close, 'Pass'), _action(Icons.bolt, 'Ping'), _action(Icons.favorite, 'Like')])]))]));
Widget _action(IconData icon, String label) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: FilledButton.tonalIcon(onPressed: () {}, icon: Icon(icon), label: Text(label))));

class FiltersScreen extends StatelessWidget {
  const FiltersScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Filters')), body: ListView(padding: const EdgeInsets.all(20), children: const [Text('Age'), RangeSlider(values: RangeValues(18, 50), min: 18, max: 80, onChanged: null), ListTile(title: Text('Distance'), subtitle: Text('Use global KM / Miles setting')), ListTile(title: Text('Gender')), ListTile(title: Text('Sexuality / orientation')), ListTile(title: Text('Desires')), ListTile(title: Text('Interests')), ListTile(title: Text('Verified only')), ListTile(title: Text('Recently active'))]));
}

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Feed'), actions: [IconButton(onPressed: () => _open(context, const CreatePostScreen()), icon: const Icon(Icons.add))]), body: ListView(padding: const EdgeInsets.all(16), children: const [Text('Stories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)), SizedBox(height: 14), SizedBox(height: 92, child: Row(children: [CircleAvatar(radius: 34, child: Icon(Icons.add)), SizedBox(width: 12), CircleAvatar(radius: 34, child: Icon(Icons.person)), SizedBox(width: 12), CircleAvatar(radius: 34, child: Icon(Icons.person))])), Divider(), ListTile(title: Text('3TRIO community'), subtitle: Text('Photo verified • 12 min ago'), trailing: Icon(Icons.more_horiz)), Text('A text, photo or video post can appear here.', style: TextStyle(fontSize: 17))]));
}

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Create post')), body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [const TextField(maxLines: 5, decoration: InputDecoration(hintText: 'Write something…')), const SizedBox(height: 12), Row(children: [Expanded(child: FilledButton.tonal(onPressed: () {}, child: const Text('Photo'))), const SizedBox(width: 8), Expanded(child: FilledButton.tonal(onPressed: () {}, child: const Text('Video')))]), const Spacer(), TrioButton(label: 'Publish', onPressed: () => Navigator.pop(context))]));
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override State<MapScreen> createState() => _MapScreenState();
}
class _MapScreenState extends State<MapScreen> {
  String mode = 'People';
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Map'), actions: [IconButton(onPressed: () => _open(context, const MapSettingsScreen()), icon: const Icon(Icons.shield_outlined))]), floatingActionButton: FloatingActionButton(onPressed: () => _open(context, const CreateActivityScreen()), child: const Icon(Icons.add)), body: Column(children: [Padding(padding: const EdgeInsets.all(12), child: SegmentedButton<String>(segments: const [ButtonSegment(value: 'People', label: Text('People')), ButtonSegment(value: 'Activities', label: Text('Activities')), ButtonSegment(value: 'Both', label: Text('Both'))], selected: {mode}, onSelectionChanged: (v) => setState(() => mode = v.first))), Expanded(child: Container(margin: const EdgeInsets.all(12), decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: const Color(0xFF101B30)), child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.location_on_outlined, size: 70), Text('$mode map'), const SizedBox(height: 10), const Text('Approximate areas only • exact GPS is never shown', textAlign: TextAlign.center), const SizedBox(height: 24), FilledButton.tonal(onPressed: () => _open(context, const CrossedPathsScreen()), child: const Text('You crossed paths'))]))))]));
}

class CreateActivityScreen extends StatelessWidget {
  const CreateActivityScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Create Activity')), body: ListView(padding: const EdgeInsets.all(20), children: [const TextField(decoration: InputDecoration(labelText: 'Title')), const TextField(decoration: InputDecoration(labelText: 'Description')), const TextField(decoration: InputDecoration(labelText: 'General location')), const TextField(decoration: InputDecoration(labelText: 'Max participants')), const SizedBox(height: 20), TrioButton(label: 'Create activity', onPressed: () => Navigator.pop(context))]));
}
class CrossedPathsScreen extends StatelessWidget { const CrossedPathsScreen({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('You crossed paths')), body: const Center(child: Text('Approximate area and safe time window only.'))); }

class LikesScreen extends StatelessWidget {
  const LikesScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Likes')), body: ListView(children: const [ListTile(leading: CircleAvatar(child: Icon(Icons.person)), title: Text('Someone liked you'), subtitle: Text('Premium unlocks see-who-liked')), ListTile(title: Text('Pings'), subtitle: Text('Special attention requests appear here'))]));
}

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Messages')), body: ListTile(leading: const CircleAvatar(child: Icon(Icons.person)), title: const Text('Your connection'), subtitle: const Text('Protected Chat'), onTap: () => _open(context, const ChatScreen())));
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Protected Chat'), actions: [IconButton(onPressed: () => _open(context, const CallScreen(video: false)), icon: const Icon(Icons.call)), IconButton(onPressed: () => _open(context, const CallScreen(video: true)), icon: const Icon(Icons.videocam))]), body: Column(children: [const Expanded(child: Center(child: Text('Secure private conversation'))), Row(children: [IconButton(onPressed: () {}, icon: const Icon(Icons.image_outlined)), const Expanded(child: TextField(decoration: InputDecoration(hintText: 'Message…'))), IconButton(onPressed: () {}, icon: const Icon(Icons.send))]), const SafeArea(child: Padding(padding: EdgeInsets.all(8), child: Text('One-view media • Screenshot protection is best-effort')))]));
}

class CallScreen extends StatelessWidget {
  final bool video;
  const CallScreen({super.key, required this.video});
  @override Widget build(BuildContext context) => Scaffold(backgroundColor: Colors.black, body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(video ? Icons.videocam : Icons.call, size: 72), const SizedBox(height: 16), Text(video ? 'Video call' : 'Audio call', style: const TextStyle(fontSize: 26)), const SizedBox(height: 24), const Text('Production WebRTC/signalling integration required.'), const SizedBox(height: 24), FilledButton(onPressed: () => Navigator.pop(context), child: const Text('End call'))])));
}

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('3TRIO Premium')), body: ListView(padding: const EdgeInsets.all(20), children: const [ListTile(title: Text('Monthly'), trailing: Text('₹500')), ListTile(title: Text('Six months'), trailing: Text('₹2,500')), ListTile(title: Text('Yearly'), trailing: Text('₹4,000')), SizedBox(height: 15), Text('Unlimited likes • See who liked you')]));
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Settings')), body: ListView(children: [SwitchListTile(value: true, onChanged: (_) {}, title: const Text('Incognito')), SwitchListTile(value: true, onChanged: (_) {}, title: const Text('Map visibility')), SwitchListTile(value: true, onChanged: (_) {}, title: const Text('Nearby interaction notifications')), SwitchListTile(value: true, onChanged: (_) {}, title: const Text('Haptic feedback')), ListTile(title: const Text('Privacy'), onTap: () => _open(context, const PrivacySettingsScreen())), ListTile(title: const Text('Map / distance'), onTap: () => _open(context, const MapSettingsScreen())), ListTile(title: const Text('Premium'), onTap: () => _open(context, const PremiumScreen())), const ListTile(title: Text('Blocked users')), const ListTile(title: Text('Pause account')), const ListTile(title: Text('Delete account'))]));
}

class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Privacy')), body: ListView(children: const [SwitchListTile(value: true, onChanged: null, title: Text('Profile visibility')), SwitchListTile(value: false, onChanged: null, title: Text('Incognito')), SwitchListTile(value: true, onChanged: null, title: Text('Map visibility')), SwitchListTile(value: true, onChanged: null, title: Text('Private photos')), SwitchListTile(value: true, onChanged: null, title: Text('Hidden bio')), ListTile(title: Text('Exact GPS is never exposed'), subtitle: Text('Map uses approximate/obfuscated locations.'))]));
}

class MapSettingsScreen extends StatelessWidget {
  const MapSettingsScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Map & Distance')), body: ListView(children: const [RadioListTile(value: 'KM', groupValue: 'KM', onChanged: null, title: Text('Kilometres')), RadioListTile(value: 'Miles', groupValue: 'KM', onChanged: null, title: Text('Miles')), SwitchListTile(value: true, onChanged: null, title: Text('Show me on map'))]));
}

class ProfileEditorScreen extends StatelessWidget {
  const ProfileEditorScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Edit Profile')), body: ListView(padding: const EdgeInsets.all(20), children: const [Text('Photos — maximum 5', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), SizedBox(height: 12), TextField(decoration: InputDecoration(labelText: 'Bio')), TextField(decoration: InputDecoration(labelText: 'What are you looking for?')), TextField(decoration: InputDecoration(labelText: 'Desires')), TextField(decoration: InputDecoration(labelText: 'Interests')), TextField(decoration: InputDecoration(labelText: 'Hidden bio')), TextField(decoration: InputDecoration(labelText: 'Fantasy'))]));
}

void _open(BuildContext context, Widget page) => Navigator.push(context, MaterialPageRoute(builder: (_) => page));
