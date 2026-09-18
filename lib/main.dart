import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'services/firebase_service.dart';
import 'services/notification_service.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await FirebaseService.init();
    await NotificationService.init();
  } catch (_) {}
  runApp(const TrioApp());
}

class TrioApp extends StatelessWidget {
  const TrioApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '3TRIO',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFFFF3B5C), scaffoldBackgroundColor: Colors.white),
      home: const AgeGate(),
    );
  }
}

class TrioProfile {
  final String name, age, gender, bio, photo;
  final bool verified;
  final List<String> interests;
  const TrioProfile({required this.name, required this.age, required this.gender, required this.bio, required this.photo, this.verified = false, this.interests = const []});
}

const profiles = <TrioProfile>[
  TrioProfile(name: 'Alex & Sam', age: '29 · 31', gender: 'Couple', bio: 'Open-minded, respectful and here for genuine connections.', photo: 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=900', verified: true, interests: ['ENM', 'Travel', 'Music']),
  TrioProfile(name: 'Maya', age: '28', gender: 'Woman', bio: 'Good conversation, travel and new experiences.', photo: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=900', verified: true, interests: ['Travel', 'Fitness']),
  TrioProfile(name: 'Jordan', age: '30', gender: 'Man', bio: 'Looking for genuine connections and good conversation.', photo: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=900', interests: ['Music', 'Fitness']),
  TrioProfile(name: 'Taylor', age: '27', gender: 'Woman', bio: 'Travel, music and respectful connections.', photo: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=900', verified: true, interests: ['Travel', 'Music']),
];

class AgeGate extends StatelessWidget {
  const AgeGate({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Center(child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('3TRIO', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, letterSpacing: 5, color: Color(0xFFFF3B5C))),
        const SizedBox(height: 12),
        const Text('Meet openly. Connect intentionally.', style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
        const SizedBox(height: 16),
        const Chip(label: Text('18+ adults only')),
        const SizedBox(height: 28),
        SizedBox(width: double.infinity, height: 54, child: FilledButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
          child: const Text('I am 18 or older'),
        )),
      ]),
    ))),
  );
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Welcome to 3TRIO')),
    body: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(width: double.infinity, height: 54, child: OutlinedButton.icon(
        icon: const Icon(Icons.g_mobiledata), label: const Text('Continue with Google'),
        onPressed: () async {
          try {
            final result = await AuthService().google();
            if (result != null && context.mounted) Navigator.push(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
          } catch (e) {
            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google sign-in failed: ' + e.toString())));
          }
        },
      )),
      const SizedBox(height: 12),
      SizedBox(width: double.infinity, height: 54, child: OutlinedButton.icon(
        icon: const Icon(Icons.phone), label: const Text('Continue with phone'),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PhoneLoginScreen())),
      )),
    ])),
  );
}

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});
  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginState();
}
class _PhoneLoginState extends State<PhoneLoginScreen> {
  final phone = TextEditingController();
  final otp = TextEditingController();
  String? verificationId;
  bool sent = false;
  bool busy = false;

  Future<void> send() async {
    setState(() => busy = true);
    await AuthService().phone(phone.text.trim(),
      codeSent: (id) { if (mounted) setState(() { verificationId = id; sent = true; busy = false; }); },
      verified: (credential) async {
        await AuthService().auth.signInWithCredential(credential);
        if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
      },
      failed: (e) { if (mounted) { setState(() => busy = false); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'OTP failed'))); } },
    );
  }

  Future<void> verify() async {
    if (verificationId == null) return;
    setState(() => busy = true);
    try {
      await AuthService().verify(verificationId!, otp.text.trim());
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
    } catch (e) {
      if (mounted) { setState(() => busy = false); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid OTP: ' + e.toString()))); }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Phone verification')),
    body: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
      TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone number (+91...)', border: OutlineInputBorder())),
      if (sent) ...[const SizedBox(height: 14), TextField(controller: otp, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: '6 digit OTP', border: OutlineInputBorder()))],
      const SizedBox(height: 16),
      SizedBox(width: double.infinity, height: 52, child: FilledButton(onPressed: busy ? null : (sent ? verify : send), child: Text(busy ? 'Please wait...' : (sent ? 'Verify OTP' : 'Send OTP')))),
    ])),
  );
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingState();
}
class _OnboardingState extends State<OnboardingScreen> {
  int step = 0;
  String name = '', age = '', gender = '', verification = '';
  final interests = <String>{};
  int photos = 0;
  final options = ['Open Relationship','Ethical Non-Monogamy','Polyamory','Swinging','Roleplay','BDSM','Casual Fun','Threesomes','Travel','Music','Fitness'];

  bool get valid {
    if (step == 0) return name.trim().isNotEmpty && int.tryParse(age) != null;
    if (step == 1) return gender.isNotEmpty;
    if (step == 2) return interests.isNotEmpty;
    if (step == 3) return photos >= 2;
    return verification.isNotEmpty;
  }
  void next() {
    if (!valid) return;
    if (step < 4) setState(() => step++);
    else Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }
  Future<void> pick() async {
    final x = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (x != null && photos < 5) setState(() => photos++);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Profile setup · ' + (step + 1).toString() + '/5')),
    body: Padding(padding: const EdgeInsets.all(22), child: Column(children: [
      LinearProgressIndicator(value: (step + 1) / 5),
      const SizedBox(height: 22),
      Expanded(child: SingleChildScrollView(child: _body())),
      const SizedBox(height: 12),
      SizedBox(width: double.infinity, height: 52, child: FilledButton(onPressed: valid ? next : null, child: Text(step == 4 ? 'Create profile' : 'Continue'))),
    ])),
  );

  Widget _body() {
    if (step == 0) return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('What is your name?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      const SizedBox(height: 14), TextField(onChanged: (v) => name = v, decoration: const InputDecoration(labelText: 'First name', border: OutlineInputBorder())),
      const SizedBox(height: 22), const Text('How old are you?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      const SizedBox(height: 14), TextField(onChanged: (v) => age = v, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder())),
    ]);
    if (step == 1) return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('I am a...', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      const SizedBox(height: 14),
      ...['Man','Woman','Non-binary','Couple'].map((x) => Padding(padding: const EdgeInsets.only(bottom: 10), child: SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => setState(() => gender = x), child: Text(x))))),
    ]);
    if (step == 2) return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('What are you looking for?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      const Text('Pick up to 5', style: TextStyle(color: Colors.grey)),
      const SizedBox(height: 14),
      Wrap(spacing: 7, runSpacing: 7, children: options.map((x) => FilterChip(label: Text(x), selected: interests.contains(x), onSelected: (v) {
        setState(() { if (v && interests.length < 5) interests.add(x); if (!v) interests.remove(x); });
      })).toList()),
    ]);
    if (step == 3) return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Add your photos', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8), const Text('At least 2 photos are required.'),
      const SizedBox(height: 20),
      Wrap(spacing: 8, children: List.generate(5, (i) => Container(width: 58, height: 85, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)), child: Icon(i < photos ? Icons.check_circle : Icons.add_a_photo, color: i < photos ? Colors.green : Colors.grey)))),
      const SizedBox(height: 18), OutlinedButton.icon(onPressed: pick, icon: const Icon(Icons.photo_library), label: const Text('Choose photo')),
    ]);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Verification', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      const Text('At least one verification is required.'),
      const SizedBox(height: 12),
      ...['Photo verification','Government ID','Voice verification'].map((x) => Card(child: ListTile(leading: const Icon(Icons.verified_user), title: Text(x), trailing: verification == x ? const Icon(Icons.check_circle, color: Colors.green) : TextButton(onPressed: () => setState(() => verification = x), child: const Text('Start'))))),
    ]);
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeState();
}
class _HomeState extends State<HomeScreen> {
  int index = 0;
  final pages = const [DiscoverScreen(), MatchScreen(), FeedScreen(), MessagesScreen(), MeScreen()];
  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: index, children: pages),
    bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (v) => setState(() => index = v), destinations: const [
      NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Explore'),
      NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Match'),
      NavigationDestination(icon: Icon(Icons.dynamic_feed_outlined), selectedIcon: Icon(Icons.dynamic_feed), label: 'Feed'),
      NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Chat'),
      NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Me'),
    ]),
  );
}

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Discover'), actions: [
      IconButton(onPressed: () => showModalBottomSheet(context: context, builder: (_) => const FilterSheet()), icon: const Icon(Icons.tune)),
      IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())), icon: const Icon(Icons.settings_outlined)),
    ]),
    body: GridView.builder(
      padding: const EdgeInsets.all(12), itemCount: profiles.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: .68),
      itemBuilder: (context, i) {
        final p = profiles[i];
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileDetailScreen(profile: p))),
          child: ClipRRect(borderRadius: BorderRadius.circular(18), child: Stack(fit: StackFit.expand, children: [
            Image.network(p.photo, fit: BoxFit.cover),
            Align(alignment: Alignment.bottomCenter, child: Container(width: double.infinity, padding: const EdgeInsets.all(10), decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black87])), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.name + (p.verified ? ' ✓' : ''), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Text(p.age + ' · ' + p.gender, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Text('✦ ' + (80 + i).toString() + '% AI Match', style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold)),
            ]))),
          ])),
        );
      },
    ),
  );
}

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});
  @override
  State<MatchScreen> createState() => _MatchState();
}
class _MatchState extends State<MatchScreen> {
  int current = 0;
  final history = <int>[];
  double dx = 0;
  void move(int direction) {
    history.add(current);
    if (direction > 0 && current % 3 == 0) {
      showDialog(context: context, builder: (_) => AlertDialog(
        title: const Text("It's a Match! 💕"),
        content: Text('You and ' + profiles[current].name + ' liked each other.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Keep swiping')), FilledButton(onPressed: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())); }, child: const Text('Message'))],
      ));
    }
    setState(() { current = (current + 1) % profiles.length; dx = 0; });
  }
  void rewind() {
    if (history.isEmpty) return;
    setState(() { current = history.removeLast(); dx = 0; });
  }
  @override
  Widget build(BuildContext context) {
    final p = profiles[current];
    return Scaffold(
      appBar: AppBar(title: const Text('Match'), actions: [IconButton(onPressed: rewind, icon: const Icon(Icons.undo)), IconButton(onPressed: () => showModalBottomSheet(context: context, builder: (_) => const FilterSheet()), icon: const Icon(Icons.tune))]),
      body: Column(children: [
        Expanded(child: GestureDetector(
          onHorizontalDragUpdate: (d) => setState(() => dx += d.delta.dx),
          onHorizontalDragEnd: (_) { if (dx > 100) move(1); else if (dx < -100) move(-1); else setState(() => dx = 0); },
          child: Transform.translate(offset: Offset(dx, 0), child: Transform.rotate(angle: dx / 900, child: Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 8), child: ClipRRect(borderRadius: BorderRadius.circular(24), child: Stack(fit: StackFit.expand, children: [
            Image.network(p.photo, fit: BoxFit.cover),
            Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black87]))),
            Positioned(left: 20, right: 20, bottom: 24, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.name + ', ' + p.age + (p.verified ? ' ✓' : ''), style: const TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold)),
              Text(p.gender + ' · 10 km away', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 7), Text(p.bio, style: const TextStyle(color: Colors.white)), const SizedBox(height: 7),
              const Text('✦ AI Top Match', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
            ])),
            if (dx > 40) const Positioned(top: 30, left: 25, child: SwipeLabel(text: 'LIKE', color: Colors.green)),
            if (dx < -40) const Positioned(top: 30, right: 25, child: SwipeLabel(text: 'NOPE', color: Colors.red)),
          ]))))),
        )),
        Padding(padding: const EdgeInsets.only(bottom: 16), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          CircleAction(icon: Icons.undo, onTap: rewind),
          CircleAction(icon: Icons.close, color: Colors.red, onTap: () => move(-1)),
          CircleAction(icon: Icons.bolt, color: Colors.orange, onTap: () => showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Not Matched Yet!'), content: const Text('Send a Ping for ₹10.'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Ping ₹10'))]))),
          CircleAction(icon: Icons.favorite, color: Colors.green, onTap: () => move(1)),
        ])),
      ]),
    );
  }
}
class SwipeLabel extends StatelessWidget {
  final String text; final Color color;
  const SwipeLabel({super.key, required this.text, required this.color});
  @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(border: Border.all(color: color, width: 3), borderRadius: BorderRadius.circular(8)), child: Text(text, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w900)));
}
class CircleAction extends StatelessWidget {
  final IconData icon; final Color? color; final VoidCallback onTap;
  const CircleAction({super.key, required this.icon, required this.onTap, this.color});
  @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(horizontal: 5), child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(40), child: Container(width: 58, height: 58, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300)), child: Icon(icon, color: color ?? Colors.grey.shade700))));
}

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Community Feed'), actions: [IconButton(onPressed: () => _message(context, 'Create Post', 'Text, photo, video and audio post composer.'), icon: const Icon(Icons.add))]), body: ListView(padding: const EdgeInsets.all(12), children: const [
    PostCard(name: '3TRIO Community', text: 'Meet openly. Connect intentionally. Keep it respectful and consensual.', image: 'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=900'),
    PostCard(name: 'Jordan', text: 'Looking for genuine connections and good conversation.', image: 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=900'),
  ]);
}
class PostCard extends StatefulWidget {
  final String name, text, image;
  const PostCard({super.key, required this.name, required this.text, required this.image});
  @override State<PostCard> createState() => _PostState();
}
class _PostState extends State<PostCard> {
  bool liked = false;
  @override Widget build(BuildContext context) => Card(clipBehavior: Clip.antiAlias, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    ListTile(leading: const CircleAvatar(child: Icon(Icons.person)), title: Text(widget.name), subtitle: const Text('Verified · Today')),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(widget.text)),
    const SizedBox(height: 10), Image.network(widget.image, height: 260, width: double.infinity, fit: BoxFit.cover),
    Row(children: [IconButton(onPressed: () => setState(() => liked = !liked), icon: Icon(liked ? Icons.favorite : Icons.favorite_border, color: liked ? Colors.red : null)), IconButton(onPressed: () => _message(context, 'Comments', 'Comment composer opened.'), icon: const Icon(Icons.comment_outlined)), IconButton(onPressed: () => _message(context, 'Share', 'Share action selected.'), icon: const Icon(Icons.share_outlined))]),
  ]);
}

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Nearby Map')), body: Padding(padding: const EdgeInsets.all(12), child: Column(children: [
    const Text('Approximate locations only · exact GPS is never exposed.'), const SizedBox(height: 12),
    Expanded(child: Container(decoration: BoxDecoration(color: const Color(0xFFE5EAF0), borderRadius: BorderRadius.circular(22)), child: Stack(children: [
      const Center(child: Icon(Icons.map, size: 130, color: Colors.blueGrey)),
      const Positioned(left: 25, top: 90, child: Chip(label: Text('Alex & Sam'))),
      const Positioned(left: 190, top: 180, child: Chip(label: Text('Maya'))),
      const Positioned(left: 95, top: 320, child: Chip(label: Text('Jordan'))),
    ]))),
  ]));
}

class LikesScreen extends StatelessWidget {
  const LikesScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Likes & Pings')), body: ListView(padding: const EdgeInsets.all(12), children: [
    const Card(child: ListTile(leading: Icon(Icons.favorite, color: Colors.red), title: Text('Someone nearby liked you'), subtitle: Text('Premium reveals who liked you.'))),
    const Card(child: ListTile(leading: Icon(Icons.bolt), title: Text('Sam sent a Ping'))),
    Card(child: ListTile(leading: const Icon(Icons.workspace_premium), title: const Text('3TRIO Premium'), subtitle: const Text('Unlimited likes · premium filters'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumScreen())))),
  ]);
}

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Messages')), body: ListView(children: [
    ListTile(leading: CircleAvatar(backgroundImage: NetworkImage(profiles[0].photo)), title: Text(profiles[0].name), subtitle: const Text('Protected chat'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()))),
    ListTile(leading: CircleAvatar(backgroundImage: NetworkImage(profiles[1].photo)), title: Text(profiles[1].name), subtitle: const Text('New connection'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()))),
  ]);
}
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override State<ChatScreen> createState() => _ChatState();
}
class _ChatState extends State<ChatScreen> {
  final controller = TextEditingController();
  final messages = <String>['Hey 👋', 'Hi, nice to meet you.'];
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Protected Chat'), actions: [
    IconButton(onPressed: () => _message(context, 'Audio call', 'Audio call integration point.'), icon: const Icon(Icons.call_outlined)),
    IconButton(onPressed: () => _message(context, 'Video call', 'Video call integration point.'), icon: const Icon(Icons.videocam_outlined)),
  ]), body: Column(children: [
    Expanded(child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: messages.length, itemBuilder: (_, i) => Align(alignment: i.isOdd ? Alignment.centerRight : Alignment.centerLeft, child: Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: i.isOdd ? const Color(0xFFFF3B5C) : Colors.grey.shade200, borderRadius: BorderRadius.circular(17)), child: Text(messages[i], style: TextStyle(color: i.isOdd ? Colors.white : Colors.black)))))),
    SafeArea(child: Row(children: [Expanded(child: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Message…'))), IconButton(onPressed: () { if (controller.text.trim().isEmpty) return; setState(() { messages.add(controller.text.trim()); controller.clear(); }); }, icon: const Icon(Icons.send))])),
  ]));
}

class MeScreen extends StatelessWidget {
  const MeScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Me')), body: ListView(padding: const EdgeInsets.all(12), children: [
    Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [CircleAvatar(radius: 55, backgroundImage: NetworkImage(profiles[0].photo)), const SizedBox(height: 10), const Text('My Profile', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)), const Text('Verified member'), const SizedBox(height: 10), FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OnboardingScreen())), child: const Text('Edit Profile'))])),
    ListTile(leading: const Icon(Icons.favorite), title: const Text('Who Likes Me'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LikesScreen()))),
    ListTile(leading: const Icon(Icons.verified_user), title: const Text('Verification'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VerificationScreen()))),
    ListTile(leading: const Icon(Icons.workspace_premium), title: const Text('Premium'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumScreen()))),
    ListTile(leading: const Icon(Icons.settings), title: const Text('Settings'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
  ]));
}

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Verification')), body: ListView(padding: const EdgeInsets.all(12), children: [
    _card(context, Icons.camera_alt, 'Photo verification'), _card(context, Icons.badge, 'Government ID'), _card(context, Icons.mic, 'Voice verification'),
  ]);
}
Widget _card(BuildContext c, IconData icon, String title) => Card(child: ListTile(leading: Icon(icon), title: Text(title), trailing: TextButton(onPressed: () => _message(c, title, 'Verification flow opened.'), child: const Text('Start'))));

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('3TRIO Premium')), body: ListView(padding: const EdgeInsets.all(18), children: [
    const Text('Go Premium', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
    const Text('Unlimited likes · See who liked you · Rewind · Premium filters'),
    const SizedBox(height: 18),
    _plan(context, 'Monthly · ₹500'), _plan(context, '6 Months · ₹2,500'), _plan(context, 'Yearly · ₹4,000'),
  ]);
}
Widget _plan(BuildContext c, String text) => Card(child: ListTile(title: Text(text), trailing: FilledButton(onPressed: () => _message(c, 'Premium', 'Purchase flow opened.'), child: const Text('Choose'))));

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override State<SettingsScreen> createState() => _SettingsState();
}
class _SettingsState extends State<SettingsScreen> {
  bool incognito = true, location = true, notifications = true;
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Settings')), body: ListView(children: [
    const Padding(padding: EdgeInsets.all(16), child: Text('Privacy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    SwitchListTile(title: const Text('Incognito'), subtitle: const Text('Hide your profile from discovery'), value: incognito, onChanged: (v) => setState(() => incognito = v)),
    SwitchListTile(title: const Text('Map visibility'), value: location, onChanged: (v) => setState(() => location = v)),
    const Divider(),
    SwitchListTile(title: const Text('Push notifications'), value: notifications, onChanged: (v) => setState(() => notifications = v)),
    const Divider(),
    ListTile(leading: const Icon(Icons.block), title: const Text('Blocked users'), onTap: () => _message(context, 'Blocked users', 'Blocked-user management opened.')),
    ListTile(leading: const Icon(Icons.shield), title: const Text('Privacy & Safety'), onTap: () => _message(context, 'Privacy & Safety', 'Safety controls opened.')),
    ListTile(leading: const Icon(Icons.logout), title: const Text('Log out'), onTap: () async { await AuthService().signOut(); if (context.mounted) Navigator.pop(context); }),
    ListTile(leading: const Icon(Icons.delete_forever, color: Colors.red), title: const Text('Delete account', style: TextStyle(color: Colors.red)), onTap: () => showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Delete account?'), content: const Text('This cannot be undone.'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Delete'))]))),
  ]));
}

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});
  @override State<FilterSheet> createState() => _FilterState();
}
class _FilterState extends State<FilterSheet> {
  double distance = 50;
  RangeValues age = const RangeValues(18, 60);
  @override Widget build(BuildContext context) => SafeArea(child: Padding(padding: const EdgeInsets.all(22), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('Discovery filters', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
    Text('Age: ' + age.start.round().toString() + ' – ' + age.end.round().toString()),
    RangeSlider(values: age, min: 18, max: 80, onChanged: (v) => setState(() => age = v)),
    Text('Distance: ' + distance.round().toString() + ' km'),
    Slider(value: distance, min: 1, max: 100, onChanged: (v) => setState(() => distance = v)),
    SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Apply filters'))),
  ])));
}

class ProfileDetailScreen extends StatelessWidget {
  final TrioProfile profile;
  const ProfileDetailScreen({super.key, required this.profile});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(profile.name)), body: ListView(children: [
    Image.network(profile.photo, height: 430, fit: BoxFit.cover),
    Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(profile.name + (profile.verified ? ' ✓' : ''), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      Text(profile.age + ' · ' + profile.gender, style: const TextStyle(color: Colors.grey)),
      const SizedBox(height: 12), Text(profile.bio),
      const SizedBox(height: 12), Wrap(spacing: 6, children: profile.interests.map((x) => Chip(label: Text(x))).toList()),
      const SizedBox(height: 18), Row(children: [Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Pass'))), const SizedBox(width: 10), Expanded(child: FilledButton(onPressed: () => _message(context, 'Like', 'Like sent.'), child: const Text('♥ Like')))]),
    ])),
  ]));
}

void _message(BuildContext context, String title, String message) {
  showModalBottomSheet(context: context, builder: (_) => SafeArea(child: Padding(padding: const EdgeInsets.all(22), child: Column(mainAxisSize: MainAxisSize.min, children: [
    Text(title, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
    const SizedBox(height: 10), Text(message, textAlign: TextAlign.center), const SizedBox(height: 18),
    FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
  ])));
}
