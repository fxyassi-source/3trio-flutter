import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'services/firebase_service.dart';
import 'services/notification_service.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await FirebaseService.init();
    await NotificationService.init();
  } catch (_) {}
  runApp(const TrioApp());
}

enum TrioThemeMode { light, dark }

class TrioThemeController extends ChangeNotifier {
  TrioThemeMode mode = TrioThemeMode.light;
  TrioThemeController() { _load(); }
  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final value = p.getString('trio_theme') ?? 'light';
    mode = TrioThemeMode.values.firstWhere((e) => e.name == value, orElse: () => TrioThemeMode.light);
    notifyListeners();
  }
  Future<void> setMode(TrioThemeMode value) async {
    mode = value;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setString('trio_theme', value.name);
  }
}

final trioTheme = TrioThemeController();

ThemeData _themeFor(TrioThemeMode mode) {
  final dark = mode == TrioThemeMode.dark;
  return ThemeData(
    useMaterial3: true,
    brightness: dark ? Brightness.dark : Brightness.light,
    scaffoldBackgroundColor: dark ? const Color(0xFF121212) : const Color(0xFFFFFFFF),
    colorScheme: dark
        ? const ColorScheme.dark(
            primary: Color(0xFFFF3B5C),
            secondary: Color(0xFF333333),
            surface: Color(0xFF1E1E1E),
            onSurface: Colors.white,
            onPrimary: Colors.white,
          )
        : const ColorScheme.light(
            primary: Color(0xFFFF3B5C),
            secondary: Color(0xFFEEEEEE),
            surface: Color(0xFFF5F5F5),
            onSurface: Colors.black,
            onPrimary: Colors.white,
          ),
    appBarTheme: AppBarTheme(
      backgroundColor: dark ? const Color(0xFF121212) : Colors.white,
      foregroundColor: dark ? Colors.white : Colors.black,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: dark ? const Color(0xFF1E1E1E) : Colors.white,
      elevation: dark ? 0 : 1,
    ),
    dividerColor: dark ? const Color(0xFF333333) : const Color(0xFFE5E5E5),
  );
}

class TrioApp extends StatelessWidget {
  const TrioApp({super.key});
  @override Widget build(BuildContext context) => AnimatedBuilder(
    animation: trioTheme,
    builder: (_, __) => MaterialApp(debugShowCheckedModeBanner: false, title: '3TRIO', theme: _themeFor(trioTheme.mode), home: const RestoredStartScreen()));
}
class TrioLogo extends StatelessWidget {
  final double size;
  const TrioLogo({super.key, this.size = 64});
  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size.square(size),
    painter: _TrioLogoPainter(),
  );
}

class _TrioLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 108.0;
    canvas.save();
    canvas.scale(s, s);
    final bg = Paint()..color = const Color(0xFFFF4B4B);
    canvas.drawRect(const Rect.fromLTWH(0, 0, 108, 108), bg);
    final p = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 6;
    final three = Path()..moveTo(35,35)..cubicTo(45,25,55,40,40,50)..cubicTo(55,60,45,75,35,65);
    canvas.drawPath(three,p);
    final t = Path()..moveTo(65,30)..lineTo(65,70)..cubicTo(65,80,55,80,50,75)..moveTo(55,45)..lineTo(75,45);
    canvas.drawPath(t,p);
    final under = Path()..moveTo(35,80)..quadraticBezierTo(54,95,75,80);
    p.strokeWidth=4;
    canvas.drawPath(under,p);
    canvas.restore();
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
        const TrioLogo(size: 88),
        const SizedBox(height: 8),
        const Text('3TRIO', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 5, color: Color(0xFFFF3B5C))),
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
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("It's a Match! 💕"),
          content: Text('You and ${profiles[current].name} liked each other.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Keep swiping'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatScreen()),
                );
              },
              child: const Text('Message'),
            ),
          ],
        ),
      );
    }
    setState(() {
      current = (current + 1) % profiles.length;
      dx = 0;
    });
  }

  void rewind() {
    if (history.isEmpty) return;
    setState(() {
      current = history.removeLast();
      dx = 0;
    });
  }

  void showPing() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Not Matched Yet!'),
        content: const Text('Send a Ping for ₹10.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ping ₹10'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = profiles[current];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match'),
        actions: [
          IconButton(onPressed: rewind, icon: const Icon(Icons.undo)),
          IconButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (_) => const FilterSheet(),
            ),
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onHorizontalDragUpdate: (d) {
                setState(() => dx += d.delta.dx);
              },
              onHorizontalDragEnd: (_) {
                if (dx > 100) {
                  move(1);
                } else if (dx < -100) {
                  move(-1);
                } else {
                  setState(() => dx = 0);
                }
              },
              child: Transform.translate(
                offset: Offset(dx, 0),
                child: Transform.rotate(
                  angle: dx / 900,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(p.photo, fit: BoxFit.cover),
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black87],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            right: 20,
                            bottom: 24,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${p.name}, ${p.age}${p.verified ? ' ✓' : ''}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${p.gender} · 10 km away',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  p.bio,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 7),
                                const Text(
                                  '✦ AI Top Match',
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (dx > 40)
                            const Positioned(
                              top: 30,
                              left: 25,
                              child: SwipeLabel(text: 'LIKE', color: Colors.green),
                            ),
                          if (dx < -40)
                            const Positioned(
                              top: 30,
                              right: 25,
                              child: SwipeLabel(text: 'NOPE', color: Colors.red),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAction(icon: Icons.undo, onTap: rewind),
                CircleAction(
                  icon: Icons.close,
                  color: Colors.red,
                  onTap: () => move(-1),
                ),
                CircleAction(
                  icon: Icons.bolt,
                  color: Colors.orange,
                  onTap: showPing,
                ),
                CircleAction(
                  icon: Icons.favorite,
                  color: Colors.green,
                  onTap: () => move(1),
                ),
              ],
            ),
          ),
        ],
      ),
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
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Community Feed'), actions: [IconButton(onPressed: () => _message(context, 'Create Post', 'Post composer opened.'), icon: const Icon(Icons.add))]),
    body: ListView(padding: const EdgeInsets.all(12), children: const [
      PostCard(name: '3TRIO Community', text: 'Meet openly. Connect intentionally.', image: 'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=900'),
      PostCard(name: 'Jordan', text: 'Looking for genuine connections and good conversation.', image: 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=900'),
    ]),
  );
}
class PostCard extends StatefulWidget {
  final String name, text, image;
  const PostCard({super.key, required this.name, required this.text, required this.image});
  @override State<PostCard> createState() => _PostCardState();
}
class _PostCardState extends State<PostCard> {
  bool liked = false;
  @override Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias, margin: const EdgeInsets.only(bottom: 14),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ListTile(leading: const CircleAvatar(child: Icon(Icons.person)), title: Text(widget.name), subtitle: const Text('Verified · Today')),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(widget.text)),
      const SizedBox(height: 10),
      Image.network(widget.image, height: 260, width: double.infinity, fit: BoxFit.cover),
      Row(children: [
        IconButton(onPressed: () => setState(() => liked = !liked), icon: Icon(liked ? Icons.favorite : Icons.favorite_border, color: liked ? Colors.red : null)),
        IconButton(onPressed: () => _message(context, 'Comments', 'Comments opened.'), icon: const Icon(Icons.comment_outlined)),
        IconButton(onPressed: () => _message(context, 'Share', 'Share opened.'), icon: const Icon(Icons.share_outlined)),
      ]),
    ]),
  );
}
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Nearby Map')),
    body: Padding(padding: const EdgeInsets.all(12), child: Column(children: [
      const Text('Approximate locations only · exact GPS is never exposed.'),
      const SizedBox(height: 12),
      Expanded(child: Container(
        decoration: BoxDecoration(color: const Color(0xFFE5EAF0), borderRadius: BorderRadius.circular(22)),
        child: const Stack(children: [
          Center(child: Icon(Icons.map, size: 130, color: Colors.blueGrey)),
          Positioned(left: 25, top: 90, child: Chip(label: Text('Alex & Sam'))),
          Positioned(left: 190, top: 180, child: Chip(label: Text('Maya'))),
          Positioned(left: 95, top: 320, child: Chip(label: Text('Jordan'))),
        ]),
      )),
    ])),
  );
}
class LikesScreen extends StatelessWidget {
  const LikesScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Likes & Pings')),
    body: ListView(padding: const EdgeInsets.all(12), children: [
      const Card(child: ListTile(leading: Icon(Icons.favorite, color: Colors.red), title: Text('Someone nearby liked you'), subtitle: Text('Premium can reveal more details.'))),
      const Card(child: ListTile(leading: Icon(Icons.bolt), title: Text('Sam sent a Ping'))),
      ListTile(leading: const Icon(Icons.workspace_premium), title: const Text('3TRIO Premium'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumScreen()))),
    ]),
  );
}
class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Messages')),
    body: ListView.builder(itemCount: profiles.length, itemBuilder: (_, i) {
      final p = profiles[i];
      return ListTile(leading: CircleAvatar(backgroundImage: NetworkImage(p.photo)), title: Text(p.name), subtitle: const Text('Protected chat'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(profile: p))));
    }),
  );
}
class ChatScreen extends StatefulWidget {
  final TrioProfile? profile;
  const ChatScreen({super.key, this.profile});
  @override State<ChatScreen> createState() => _ChatState();
}
class _ChatState extends State<ChatScreen> {
  final controller = TextEditingController();
  final messages = <String>['Hey 👋', 'Hi, nice to meet you.'];
  @override void dispose() { controller.dispose(); super.dispose(); }
  Future<void> send() async {
    final value = controller.text.trim();
    if (value.isEmpty) return;
    setState(() { messages.add(value); controller.clear(); });
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final other = widget.profile?.name;
    if (uid != null && other != null) {
      try { await FirestoreService().sendMessage(uid + '_' + other, uid, value); } catch (_) {}
    }
  }
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.profile?.name ?? 'Protected Chat'), actions: [
      IconButton(onPressed: () => _message(context, 'Audio call', 'Audio call flow opened.'), icon: const Icon(Icons.call_outlined)),
      IconButton(onPressed: () => _message(context, 'Video call', 'Video call flow opened.'), icon: const Icon(Icons.videocam_outlined)),
    ]),
    body: Column(children: [
      Expanded(child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: messages.length, itemBuilder: (_, i) {
        final mine = i.isOdd;
        return Align(alignment: mine ? Alignment.centerRight : Alignment.centerLeft, child: Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: mine ? const Color(0xFFFF3B5C) : Colors.grey.shade200, borderRadius: BorderRadius.circular(17)),
          child: Text(messages[i], style: TextStyle(color: mine ? Colors.white : Colors.black)),
        ));
      })),
      SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(10, 4, 10, 8), child: Row(children: [
        Expanded(child: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Message…'))),
        IconButton(onPressed: send, icon: const Icon(Icons.send)),
      ]))),
    ]),
  );
}
class MeScreen extends StatelessWidget {
  const MeScreen({super.key});
  @override Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Me')),
      body: ListView(padding: const EdgeInsets.all(12), children: [
        Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [
          CircleAvatar(radius: 55, backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null, child: user?.photoURL == null ? const Icon(Icons.person, size: 50) : null),
          const SizedBox(height: 10),
          Text(user?.displayName ?? 'My Profile', style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
          Text(user?.email ?? user?.phoneNumber ?? 'Verified member'),
          const SizedBox(height: 10),
          FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OnboardingScreen())), child: const Text('Edit Profile')),
        ]))),
        _menu(context, Icons.favorite, 'Who Likes Me', const LikesScreen()),
        _menu(context, Icons.verified_user, 'Verification', const VerificationScreen()),
        _menu(context, Icons.workspace_premium, 'Premium', const PremiumScreen()),
        _menu(context, Icons.settings, 'Settings', const SettingsScreen()),
      ]),
    );
  }
  Widget _menu(BuildContext context, IconData icon, String title, Widget page) => ListTile(leading: Icon(icon), title: Text(title), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)));
}
class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Verification')),
    body: ListView(padding: const EdgeInsets.all(12), children: [
      _card(context, Icons.camera_alt, 'Photo verification'),
      _card(context, Icons.badge, 'Government ID'),
      _card(context, Icons.mic, 'Voice verification'),
    ]),
  );
  Widget _card(BuildContext c, IconData icon, String title) => Card(child: ListTile(leading: Icon(icon), title: Text(title), trailing: TextButton(onPressed: () => _message(c, title, 'Verification flow opened.'), child: const Text('Start'))));
}
class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('3TRIO Premium')),
    body: ListView(padding: const EdgeInsets.all(18), children: [
      const Text('Go Premium', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
      const Text('Unlimited likes · See who liked you · Rewind · Premium filters'),
      const SizedBox(height: 18),
      _plan(context, 'Monthly · ₹500'), _plan(context, '6 Months · ₹2,500'), _plan(context, 'Yearly · ₹4,000'),
    ]),
  );
  Widget _plan(BuildContext c, String title) => Card(child: ListTile(title: Text(title), trailing: FilledButton(onPressed: () => _message(c, 'Premium', 'Purchase flow opened.'), child: const Text('Choose'))));
}
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override State<SettingsScreen> createState() => _SettingsState();
}
class _SettingsState extends State<SettingsScreen> {
  bool incognito = true, location = true, notifications = true;
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Settings')),
    body: ListView(children: [
      const Padding(padding: EdgeInsets.all(16), child: Text('Appearance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
      RadioListTile<TrioThemeMode>(title: const Text('Light'), value: TrioThemeMode.light, groupValue: trioTheme.mode, onChanged: (v) { if (v != null) trioTheme.setMode(v); }),
      RadioListTile<TrioThemeMode>(title: const Text('Dark'), value: TrioThemeMode.dark, groupValue: trioTheme.mode, onChanged: (v) { if (v != null) trioTheme.setMode(v); }),
      const Divider(),
      const Padding(padding: EdgeInsets.all(16), child: Text('Privacy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
      SwitchListTile(title: const Text('Incognito'), value: incognito, onChanged: (v) => setState(() => incognito = v)),
      SwitchListTile(title: const Text('Map visibility'), value: location, onChanged: (v) => setState(() => location = v)),
      const Divider(),
      SwitchListTile(title: const Text('Push notifications'), value: notifications, onChanged: (v) => setState(() => notifications = v)),
      const Divider(),
      ListTile(leading: const Icon(Icons.block), title: const Text('Blocked users'), onTap: () => _message(context, 'Blocked users', 'Blocked-user management opened.')),
      ListTile(leading: const Icon(Icons.shield), title: const Text('Privacy & Safety'), onTap: () => _message(context, 'Privacy & Safety', 'Safety controls opened.')),
      ListTile(leading: const Icon(Icons.logout), title: const Text('Log out'), onTap: () => AuthService().signOut()),
    ]),
  );
}
class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});
  @override State<FilterSheet> createState() => _FilterState();
}
class _FilterState extends State<FilterSheet> {
  double distance = 50;
  RangeValues age = const RangeValues(18, 60);
  @override Widget build(BuildContext context) => SafeArea(child: Padding(
    padding: const EdgeInsets.all(22), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Discovery filters', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
      Text('Age: ' + age.start.round().toString() + ' – ' + age.end.round().toString()),
      RangeSlider(values: age, min: 18, max: 80, onChanged: (v) => setState(() => age = v)),
      Text('Distance: ' + distance.round().toString() + ' km'),
      Slider(value: distance, min: 1, max: 100, onChanged: (v) => setState(() => distance = v)),
      SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Apply filters'))),
    ]),
  ));
}
class ProfileDetailScreen extends StatelessWidget {
  final TrioProfile profile;
  const ProfileDetailScreen({super.key, required this.profile});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(profile.name)),
    body: ListView(children: [
      Image.network(profile.photo, height: 430, fit: BoxFit.cover),
      Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(profile.name + (profile.verified ? ' ✓' : ''), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        Text(profile.age + ' · ' + profile.gender, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 12), Text(profile.bio),
        const SizedBox(height: 12),
        Wrap(spacing: 6, children: profile.interests.map((x) => Chip(label: Text(x))).toList()),
        const SizedBox(height: 18),
        Row(children: [
          Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Pass'))),
          const SizedBox(width: 10),
          Expanded(child: FilledButton(onPressed: () {
            final uid = FirebaseAuth.instance.currentUser?.uid;
            if (uid != null) FirestoreService().like(uid, profile.name);
            _message(context, 'Like', 'Like sent.');
          }, child: const Text('♥ Like'))),
        ]),
      ])),
    ]),
  );
}
void _message(BuildContext context, String title, String message) {
  showModalBottomSheet(context: context, builder: (_) => SafeArea(child: Padding(padding: const EdgeInsets.all(22), child: Column(mainAxisSize: MainAxisSize.min, children: [
    Text(title, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
    const SizedBox(height: 10), Text(message, textAlign: TextAlign.center), const SizedBox(height: 18),
    FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
  ]))));
}


// RESTORED ORIGINAL UX LAYER
class RestoredStartScreen extends StatefulWidget {
  const RestoredStartScreen({super.key});
  @override State<RestoredStartScreen> createState() => _RestoredStartState();
}
class _RestoredStartState extends State<RestoredStartScreen> {
  int step=0; String gender=''; String bio=''; int photos=0;
  final interests=<String>{}; final desires=<String>{};
  final choices=const ['Man','Woman','Non-binary','Couple'];
  final tags=const ['Open Relationship','Ethical Non-Monogamy','Polyamory','Swinging','Roleplay','BDSM','Dominance/Submission','Casual Fun','Threesomes','Group Play','Kink Exploration','Travel'];
  bool get ready=>step==0?gender.isNotEmpty:step==1?interests.isNotEmpty:step==2?photos>=2:desires.isNotEmpty;
  void next(){if(!ready)return;if(step<3){setState(()=>step++);return;}Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const RestoredHome()));}
  @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(leading:step>0?IconButton(onPressed:()=>setState(()=>step--),icon:const Icon(Icons.arrow_back)):null,title:const Text('3TRIO')),body:Padding(padding:const EdgeInsets.fromLTRB(24,10,24,18),child:Column(children:[LinearProgressIndicator(value:(step+1)/4),const SizedBox(height:30),Expanded(child:SingleChildScrollView(child:_body())),SizedBox(width:double.infinity,height:54,child:FilledButton(onPressed:ready?next:null,child:Text(step==3?'Enter 3TRIO':'Next')))])));
  Widget _body(){
    if(step==0)return Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('I am a...',style:TextStyle(fontSize:32,fontWeight:FontWeight.w900)),const SizedBox(height:8),const Text('Choose your profile type'),const SizedBox(height:22),...choices.map((x)=>Padding(padding:const EdgeInsets.only(bottom:12),child:SizedBox(width:double.infinity,height:62,child:OutlinedButton(style:OutlinedButton.styleFrom(side:BorderSide(color:gender==x?primary:Colors.grey,width:gender==x?2.2:1)),onPressed:()=>setState(()=>gender=x),child:Text(x,style:TextStyle(fontSize:17,fontWeight:FontWeight.w700,color:gender==x?primary:null))))))]);
    if(step==1)return Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('What are you looking for?',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900)),const SizedBox(height:8),const Text('Pick up to 5'),const SizedBox(height:20),Wrap(spacing:8,runSpacing:8,children:tags.map((x)=>FilterChip(label:Text(x),selected:interests.contains(x),onSelected:(v)=>setState((){if(v&&interests.length<5)interests.add(x);if(!v)interests.remove(x);}))).toList())]);
    if(step==2)return Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('Add your photos',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900)),const SizedBox(height:8),const Text('At least 2 photos are required.'),const SizedBox(height:20),Row(children:List.generate(5,(i)=>Expanded(child:Padding(padding:const EdgeInsets.only(right:7),child:AspectRatio(aspectRatio:.72,child:Container(decoration:BoxDecoration(color:Theme.of(context).colorScheme.surfaceContainerHighest,borderRadius:BorderRadius.circular(14)),child:Icon(i<photos?Icons.check_circle:Icons.add_a_photo,color:i<photos?Colors.green:Colors.grey))))))),const SizedBox(height:18),OutlinedButton.icon(onPressed:()async{final x=await ImagePicker().pickImage(source:ImageSource.gallery);if(x!=null&&photos<5)setState(()=>photos++);},icon:const Icon(Icons.photo_library),label:const Text('Choose photo'))]);
    return Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('Desires & bio',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900)),const SizedBox(height:8),const Text('Tell people what you want and who you are.'),const SizedBox(height:18),Wrap(spacing:8,runSpacing:8,children:tags.map((x)=>FilterChip(label:Text(x),selected:desires.contains(x),onSelected:(v)=>setState((){if(v&&desires.length<5)desires.add(x);if(!v)desires.remove(x);}))).toList()),const SizedBox(height:22),const Text('About Me / Us',style:TextStyle(fontSize:19,fontWeight:FontWeight.bold)),const SizedBox(height:8),TextField(maxLines:5,onChanged:(v)=>bio=v,decoration:const InputDecoration(hintText:'Write your bio...',border:OutlineInputBorder()))]);
  }
}

class RestoredHome extends StatefulWidget{const RestoredHome({super.key});@override State<RestoredHome>createState()=>_RestoredHomeState();}
class _RestoredHomeState extends State<RestoredHome>{int tab=0;@override Widget build(BuildContext c){final pages=const[RestoredExplore(),RestoredMatch(),FeedScreen(),RestoredMessages(),MeScreen()];return Scaffold(body:IndexedStack(index:tab,children:pages),bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),destinations:const[NavigationDestination(icon:Icon(Icons.explore_outlined),selectedIcon:Icon(Icons.explore),label:'Explore'),NavigationDestination(icon:Icon(Icons.favorite_border),selectedIcon:Icon(Icons.favorite),label:'Match'),NavigationDestination(icon:Icon(Icons.dynamic_feed_outlined),selectedIcon:Icon(Icons.dynamic_feed),label:'Feed'),NavigationDestination(icon:Icon(Icons.chat_bubble_outline),selectedIcon:Icon(Icons.chat_bubble),label:'Chat'),NavigationDestination(icon:Icon(Icons.person_outline),selectedIcon:Icon(Icons.person),label:'Me')]));}}

class RestoredExplore extends StatefulWidget{const RestoredExplore({super.key});@override State<RestoredExplore>createState()=>_RestoredExploreState();}
class _RestoredExploreState extends State<RestoredExplore>{int view=0;RangeValues age=const RangeValues(18,60);double distance=50;@override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('Explore'),actions:[IconButton(onPressed:()=>showModalBottomSheet(context:c,builder:(_)=>_RestoredFilter(age:age,distance:distance,onApply:(a,d){setState((){age=a;distance=d;});Navigator.pop(c);}),),icon:const Icon(Icons.tune))]),body:Column(children:[Padding(padding:const EdgeInsets.fromLTRB(20,8,20,14),child:Row(children:[Expanded(child:_TabPill(text:'Map',selected:view==0,onTap:()=>setState(()=>view=0))),const SizedBox(width:10),Expanded(child:_TabPill(text:'City Search',selected:view==1,onTap:()=>setState(()=>view=1)))])),Expanded(child:view==0?const RestoredMap():const RestoredCityGrid())]));}
class _TabPill extends StatelessWidget{final String text;final bool selected;final VoidCallback onTap;const _TabPill({required this.text,required this.selected,required this.onTap});@override Widget build(BuildContext c)=>GestureDetector(onTap:onTap,child:Container(padding:const EdgeInsets.symmetric(vertical:12),decoration:BoxDecoration(color:selected?primary:Theme.of(c).colorScheme.surfaceContainerHighest,borderRadius:BorderRadius.circular(25)),alignment:Alignment.center,child:Text(text,style:TextStyle(color:selected?Colors.white:Colors.grey.shade700,fontWeight:FontWeight.bold))));}
class _RestoredFilter extends StatefulWidget{final RangeValues age;final double distance;final void Function(RangeValues,double)onApply;const _RestoredFilter({required this.age,required this.distance,required this.onApply});@override State<_RestoredFilter>createState()=>_RestoredFilterState();}
class _RestoredFilterState extends State<_RestoredFilter>{late RangeValues a;late double d;@override void initState(){super.initState();a=widget.age;d=widget.distance;}@override Widget build(BuildContext c)=>SafeArea(child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('Filter Matches',style:TextStyle(fontSize:24,fontWeight:FontWeight.bold)),Text('Age Range: '+a.start.round().toString()+' - '+a.end.round().toString()),RangeSlider(values:a,min:18,max:80,onChanged:(v)=>setState(()=>a=v)),Text('Max Distance: '+d.round().toString()+' km'),Slider(value:d,min:5,max:100,onChanged:(v)=>setState(()=>d=v)),SizedBox(width:double.infinity,child:FilledButton(onPressed:()=>widget.onApply(a,d),child:const Text('Apply Filters')))])));}

class RestoredMap extends StatelessWidget{const RestoredMap({super.key});@override Widget build(BuildContext c){final pts=[const LatLng(28.42,77.31),const LatLng(28.39,77.34),const LatLng(28.41,77.29),const LatLng(28.44,77.30)];return FlutterMap(options:const MapOptions(initialCenter:LatLng(28.4089,77.3178),initialZoom:11.5),children:[TileLayer(urlTemplate:'https://tile.openstreetmap.org/{z}/{x}/{y}.png',userAgentPackageName:'com.aistudio.threetrio.jxhk'),MarkerLayer(markers:List.generate(profiles.length,(i)=>Marker(point:pts[i],width:100,height:92,child:GestureDetector(onTap:()=>showModalBottomSheet(context:c,builder:(_)=>_MapProfile(p:profiles[i])),child:Column(children:[CircleAvatar(radius:28,backgroundColor:primary,child:CircleAvatar(radius:25,backgroundImage:NetworkImage(profiles[i].photo))),Container(color:Colors.white,padding:const EdgeInsets.symmetric(horizontal:5,vertical:2),child:Text(profiles[i].name+' · '+profiles[i].distance.toString()+' km',style:const TextStyle(fontSize:9,fontWeight:FontWeight.bold)))])))))]);}}
class _MapProfile extends StatelessWidget{final Profile p;const _MapProfile({required this.p});@override Widget build(BuildContext c)=>SafeArea(child:Padding(padding:const EdgeInsets.all(16),child:Column(mainAxisSize:MainAxisSize.min,children:[Row(children:[CircleAvatar(radius:30,backgroundImage:NetworkImage(p.photo)),const SizedBox(width:12),Expanded(child:Text(p.name+', '+p.age+'\n'+p.gender+' · '+p.distance.toString()+' km away',style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold)))]),const SizedBox(height:10),Text(p.bio),const SizedBox(height:10),FilledButton(onPressed:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>RestoredProfile(profile:p))),child:const Text('View Profile'))])));}
class RestoredCityGrid extends StatelessWidget{const RestoredCityGrid({super.key});@override Widget build(BuildContext c)=>GridView.builder(padding:const EdgeInsets.all(12),itemCount:profiles.length,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:10,mainAxisSpacing:10,childAspectRatio:.68),itemBuilder:(_,i)=>GestureDetector(onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>RestoredProfile(profile:profiles[i]))),child:ClipRRect(borderRadius:BorderRadius.circular(18),child:Stack(fit:StackFit.expand,children:[Image.network(profiles[i].photo,fit:BoxFit.cover),const DecoratedBox(decoration:BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[Colors.transparent,Colors.black87]))),Positioned(left:12,right:12,bottom:12,child:Text(profiles[i].name+', '+profiles[i].age+'\n'+profiles[i].gender+' · '+profiles[i].distance.toString()+' km',style:const TextStyle(color:Colors.white,fontWeight:FontWeight.bold,fontSize:15)))]))));}

class RestoredMatch extends StatefulWidget{const RestoredMatch({super.key});@override State<RestoredMatch>createState()=>_RestoredMatchState();}
class _RestoredMatchState extends State<RestoredMatch>{int current=0;double dx=0;final history=<int>[];void move(int dir){final p=profiles[current];history.add(current);if(dir>0&&current%2==0)showDialog(context:context,builder:(_)=>_RestoredMatchDialog(p:p));setState((){current=(current+1)%profiles.length;dx=0;});}@override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('Match')),body:GestureDetector(onHorizontalDragUpdate:(d)=>setState(()=>dx+=d.delta.dx),onHorizontalDragEnd:(_){if(dx.abs()>110)move(dx>0?1:-1);else setState(()=>dx=0);},child:Stack(alignment:Alignment.center,children:[if(current+1<profiles.length)RestoredSwipeCard(p:profiles[current+1],dx:0),RestoredSwipeCard(p:profiles[current],dx:dx),Positioned(bottom:18,child:Row(children:[_Round(icon:Icons.undo,color:Colors.grey,onTap:()=>history.isNotEmpty?setState(()=>current=history.removeLast()):null),_Round(icon:Icons.close,color:Colors.red,onTap:()=>move(-1)),_Round(icon:Icons.bolt,color:Colors.orange,onTap:()=>_message(c,'Ping','Send a Ping to this profile.')),_Round(icon:Icons.favorite,color:Colors.green,onTap:()=>move(1))]))]));}}
class RestoredSwipeCard extends StatelessWidget{final Profile p;final double dx;const RestoredSwipeCard({super.key,required this.p,required this.dx});@override Widget build(BuildContext c)=>Transform.rotate(angle:dx/1200,child:Card(clipBehavior:Clip.antiAlias,margin:const EdgeInsets.fromLTRB(14,18,14,90),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(24)),child:Stack(fit:StackFit.expand,children:[Image.network(p.photo,fit:BoxFit.cover),const DecoratedBox(decoration:BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[Colors.transparent,Colors.black87]))),Positioned(left:20,right:20,bottom:22,child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(p.name+', '+p.age+(p.verified?' ✓':''),style:const TextStyle(color:Colors.white,fontSize:27,fontWeight:FontWeight.bold)),Text(p.gender+' · '+p.distance.toString()+' km away',style:const TextStyle(color:Colors.white70)),const SizedBox(height:8),Text(p.bio,style:const TextStyle(color:Colors.white)),const SizedBox(height:8),const Text('✦ AI Top Match',style:TextStyle(color:Colors.amber,fontWeight:FontWeight.bold))])),if(dx>45)const Positioned(top:30,left:25,child:SwipeLabel(text:'LIKE',color:Colors.green)),if(dx<-45)const Positioned(top:30,right:25,child:SwipeLabel(text:'NOPE',color:Colors.red))])));}
class _Round extends StatelessWidget{final IconData icon;final Color color;final VoidCallback onTap;const _Round({required this.icon,required this.color,required this.onTap});@override Widget build(BuildContext c)=>Padding(padding:const EdgeInsets.symmetric(horizontal:5),child:InkWell(onTap:onTap,borderRadius:BorderRadius.circular(40),child:Container(width:58,height:58,decoration:BoxDecoration(shape:BoxShape.circle,color:Theme.of(c).colorScheme.surface,border:Border.all(color:Colors.grey.shade300)),child:Icon(icon,color:color))));}
class _RestoredMatchDialog extends StatelessWidget{final Profile p;const _RestoredMatchDialog({required this.p});@override Widget build(BuildContext c)=>AlertDialog(title:const Text("It's a Match! 💕"),content:Column(mainAxisSize:MainAxisSize.min,children:[CircleAvatar(radius:45,backgroundImage:NetworkImage(p.photo)),const SizedBox(height:12),Text('You and '+p.name+' have liked each other.',textAlign:TextAlign.center)]),actions:[FilledButton(onPressed:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>RestoredChat(profile:p))),child:const Text('Send a Message')),TextButton(onPressed:()=>Navigator.pop(c),child:const Text('Keep Exploring'))]);}

class RestoredMessages extends StatelessWidget{const RestoredMessages({super.key});@override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('Messages')),body:ListView(children:[const Padding(padding:EdgeInsets.fromLTRB(20,14,20,8),child:Text('New Matches',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold))),SizedBox(height:112,child:ListView.separated(scrollDirection:Axis.horizontal,padding:const EdgeInsets.symmetric(horizontal:18),itemCount:profiles.length,separatorBuilder:(_,__)=>const SizedBox(width:14),itemBuilder:(_,i)=>GestureDetector(onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>RestoredChat(profile:profiles[i]))),child:Column(children:[CircleAvatar(radius:34,backgroundImage:NetworkImage(profiles[i].photo)),const SizedBox(height:5),SizedBox(width:72,child:Text(profiles[i].name,textAlign:TextAlign.center,maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(fontSize:11,fontWeight:FontWeight.bold)))]))),const Padding(padding:EdgeInsets.fromLTRB(20,8,20,8),child:Text('Chats',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold))),...profiles.map((p)=>ListTile(leading:CircleAvatar(backgroundImage:NetworkImage(p.photo)),title:Text(p.name),subtitle:const Text('Protected chat'),trailing:const Icon(Icons.chevron_right),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>RestoredChat(profile:p))))]));}
class RestoredChat extends StatefulWidget{final Profile profile;const RestoredChat({super.key,required this.profile});@override State<RestoredChat>createState()=>_RestoredChatState();}
class _RestoredChatState extends State<RestoredChat>{final ctl=TextEditingController();final msgs=<String>['Hey 👋','Hi, nice to meet you.'];@override void dispose(){ctl.dispose();super.dispose();}@override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:Text(widget.profile.name),actions:[IconButton(onPressed:()=>_message(c,'Audio call','Audio call flow opened.'),icon:const Icon(Icons.call_outlined)),IconButton(onPressed:()=>_message(c,'Video call','Video call flow opened.'),icon:const Icon(Icons.videocam_outlined))]),body:Column(children:[Expanded(child:ListView.builder(padding:const EdgeInsets.all(16),itemCount:msgs.length,itemBuilder:(_,i)=>Align(alignment:i.isOdd?Alignment.centerRight:Alignment.centerLeft,child:Container(margin:const EdgeInsets.only(bottom:8),padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:i.isOdd?primary:Colors.grey.shade200,borderRadius:BorderRadius.circular(17)),child:Text(msgs[i],style:TextStyle(color:i.isOdd?Colors.white:Colors.black)))))),SafeArea(child:Padding(padding:const EdgeInsets.all(8),child:Row(children:[Expanded(child:TextField(controller:ctl,decoration:const InputDecoration(hintText:'Message…'))),IconButton(onPressed:(){if(ctl.text.trim().isNotEmpty)setState((){msgs.add(ctl.text.trim());ctl.clear();});},icon:const Icon(Icons.send))])))]));}

class RestoredProfile extends StatefulWidget{final Profile profile;const RestoredProfile({super.key,required this.profile});@override State<RestoredProfile>createState()=>_RestoredProfileState();}
class _RestoredProfileState extends State<RestoredProfile>{int photo=0;@override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('Profile Details'),actions:[IconButton(onPressed:()=>_message(c,'Block User','This user will be hidden from your feed and map.'),icon:const Icon(Icons.block,color:Colors.red))]),body:Column(children:[Expanded(child:PageView.builder(scrollDirection:Axis.vertical,itemCount:widget.profile.photos.length,onPageChanged:(v)=>setState(()=>photo=v),itemBuilder:(_,i)=>Stack(fit:StackFit.expand,children:[Image.network(widget.profile.photos[i],fit:BoxFit.cover),const DecoratedBox(decoration:BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[Colors.transparent,Colors.black87]))),Positioned(left:18,right:18,bottom:22,child:Text(widget.profile.name+', '+widget.profile.age+'\n'+widget.profile.gender+' · '+widget.profile.distance.toString()+' km away',style:const TextStyle(color:Colors.white,fontSize:27,fontWeight:FontWeight.w900)))]))),Positioned(top:14,right:14,child:Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:6),decoration:BoxDecoration(color:Colors.black54,borderRadius:BorderRadius.circular(16)),child:Text((photo+1).toString()+'/'+widget.profile.photos.length.toString(),style:const TextStyle(color:Colors.white)))),Expanded(child:ListView(padding:const EdgeInsets.fromLTRB(20,16,20,100),children:[Text(widget.profile.name+', '+widget.profile.age,style:const TextStyle(fontSize:28,fontWeight:FontWeight.w900)),Wrap(spacing:7,runSpacing:7,children:widget.profile.interests.map((x)=>Chip(label:Text(x))).toList()),const SizedBox(height:18),InfoCard(title:'Desires / Looking for',children:widget.profile.desires.map((x)=>Text('• '+x)).toList()),const SizedBox(height:12),InfoCard(title:'Basic Info',children:widget.profile.basic.entries.map((e)=>Padding(padding:const EdgeInsets.symmetric(vertical:6),child:Row(children:[Expanded(child:Text(e.key,color:Colors.grey)),Expanded(child:Text(e.value,style:const TextStyle(fontWeight:FontWeight.bold)))]))).toList()),const SizedBox(height:12),InfoCard(title:'About Me / Us',children:[Text(widget.profile.bio,style:const TextStyle(fontSize:16,height:1.45))]),const SizedBox(height:20),Row(children:[Expanded(child:OutlinedButton(onPressed:()=>Navigator.pop(c),child:const Text('Pass'))),const SizedBox(width:10),Expanded(child:FilledButton(onPressed:(){final uid=FirebaseAuth.instance.currentUser?.uid;if(uid!=null)FirestoreService().like(uid,widget.profile.id);_message(c,'Liked','Like sent.');},child:const Text('♥ Like')))])]))]));}
