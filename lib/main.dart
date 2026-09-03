import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ThreeTrioApp());
}

class ThreeTrioApp extends StatelessWidget {
  const ThreeTrioApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: '3TRIO',
    theme: ThreeTrioTheme.dark,
    home: const AgeGatePage(),
  );
}

class ThreeTrioTheme {
  static const bg = Color(0xFF07080C);
  static const surface = Color(0xFF11131A);
  static const elevated = Color(0xFF181B23);
  static const red = Color(0xFFE5485D);
  static const purple = Color(0xFF8A6CFF);
  static const muted = Color(0xFF9A9DA8);
  static const green = Color(0xFF35C98A);

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        primary: red,
        secondary: purple,
        surface: surface,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Color(0xFF090A0F),
        indicatorColor: Color(0xFF2A141A),
        height: 72,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          backgroundColor: red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: elevated,
        selectedColor: const Color(0xFF35171D),
        side: const BorderSide(color: Color(0xFF292C36)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}

class AppData {
  static const image1 = 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=1200';
  static const image2 = 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=1200';
  static const image3 = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=1200';

  static final profiles = <Profile>[ 
    Profile(id: 'p1', name: 'Maya', age: 28, gender: 'Woman', sexuality: 'Bisexual', area: 'Delhi', distance: '8 km', bio: 'Looking for genuine chemistry, good conversation and people who are clear about what they want.', desires: ['Connection', 'Exploring'], interests: ['Travel', 'Music', 'Rooftops'], photos: [image1], photoVerified: true, idVerified: true, voiceVerified: true),
    Profile(id: 'p2', name: 'Alex & Sam', age: 31, gender: 'Couple', sexuality: 'Queer', area: 'Gurugram', distance: '14 km', bio: 'Two verified people looking to meet interesting, respectful connections.', desires: ['Couples', 'Events'], interests: ['Food', 'Parties', 'Fitness'], photos: [image2], photoVerified: true, idVerified: true, voiceVerified: true),
    Profile(id: 'p3', name: 'Riya', age: 30, gender: 'Woman', sexuality: 'Pansexual', area: 'Noida', distance: '21 km', bio: 'Slow conversations, real-world chemistry and new experiences.', desires: ['Dating', 'Connection'], interests: ['Art', 'Coffee', 'Events'], photos: [image3], photoVerified: true, idVerified: false, voiceVerified: true),
  ];
}

class Profile {
  final String id, name, gender, sexuality, area, distance, bio;
  final int age;
  final List<String> desires, interests, photos;
  final bool photoVerified, idVerified, voiceVerified;
  const Profile({required this.id, required this.name, required this.age, required this.gender, required this.sexuality, required this.area, required this.distance, required this.bio, required this.desires, required this.interests, required this.photos, required this.photoVerified, required this.idVerified, required this.voiceVerified});
}

class AgeGatePage extends StatelessWidget {
  const AgeGatePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Padding(padding: const EdgeInsets.all(26), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Spacer(),
      const Text('3TRIO', style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
      const SizedBox(height: 22),
      const Text('Adults only.', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      const Text('You must be 18 or older to use 3TRIO.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white60, height: 1.45)),
      const Spacer(),
      SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage())), child: const Text('I am 18 or older'))),
      TextButton(onPressed: () {}, child: const Text('I am under 18')),
    ])),
  );
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Padding(padding: const EdgeInsets.all(22), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('Welcome to 3TRIO', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      const Text('Connect authentically. Discover openly.', style: TextStyle(color: Colors.white54)),
      const SizedBox(height: 30),
      _LoginButton(icon: Icons.g_mobiledata, text: 'Continue with Google', onTap: () => _enter(context)),
      _LoginButton(icon: Icons.phone_outlined, text: 'Continue with phone', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PhoneLoginPage()))),
      _LoginButton(icon: Icons.apple, text: 'Continue with Apple', onTap: () => _enter(context)),
      const SizedBox(height: 15),
      const Text('By continuing you confirm that you are 18+ and agree to the terms and safety rules.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white38, fontSize: 11)),
    ])),
  );
  static void _enter(BuildContext context) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VerificationPage()));
}

class _LoginButton extends StatelessWidget {
  final IconData icon; final String text; final VoidCallback onTap;
  const _LoginButton({required this.icon, required this.text, required this.onTap});
  @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 10), child: SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: onTap, icon: Icon(icon), label: Text(text), style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)))));
}

class PhoneLoginPage extends StatefulWidget { const PhoneLoginPage({super.key}); @override State<PhoneLoginPage> createState() => _PhoneLoginState(); }
class _PhoneLoginState extends State<PhoneLoginPage> {
  final phone = TextEditingController(); final otp = TextEditingController(); bool sent = false;
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Phone login')), body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
    TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone number', prefixText: '+ ')),
    if (sent) ...[const SizedBox(height: 12), TextField(controller: otp, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'OTP'))],
    const SizedBox(height: 18), SizedBox(width: double.infinity, child: FilledButton(onPressed: () { if (!sent) { setState(() => sent = true); } else { Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VerificationPage())); } }, child: Text(sent ? 'Verify OTP' : 'Send OTP'))),
  ])));
}

class VerificationPage extends StatefulWidget { const VerificationPage({super.key}); @override State<VerificationPage> createState() => _VerificationState(); }
class _VerificationState extends State<VerificationPage> {
  final states = <String, String>{'Photo verification': 'Not started', 'Government ID': 'Not started', 'Voice verification': 'Not started'};
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Verify your profile')), body: ListView(padding: const EdgeInsets.all(18), children: [
    const Text('Verification is required', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
    const SizedBox(height: 8), const Text('Each verification layer is separate. Government ID remains private.', style: TextStyle(color: Colors.white54, height: 1.4)), const SizedBox(height: 20),
    _VerifyTile(title: 'Photo verification', icon: Icons.camera_alt_outlined, status: states['Photo verification']!, onTap: () => _verify('Photo verification')),
    _VerifyTile(title: 'Government ID', icon: Icons.badge_outlined, status: states['Government ID']!, onTap: () => _verify('Government ID')),
    _VerifyTile(title: 'Voice verification', icon: Icons.mic_none, status: states['Voice verification']!, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VoiceVerificationPage()))),
    const SizedBox(height: 25), SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeShell()), (_) => false), child: const Text('Continue to 3TRIO'))),
  ]));
  void _verify(String key) { setState(() => states[key] = 'Pending review'); _toast(context, '$key submitted'); }
}
class _VerifyTile extends StatelessWidget { final String title, status; final IconData icon; final VoidCallback onTap; const _VerifyTile({required this.title, required this.status, required this.icon, required this.onTap}); @override Widget build(BuildContext context) => Card(color: ThreeTrioTheme.surface, child: ListTile(contentPadding: const EdgeInsets.all(12), leading: Icon(icon), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text(status, style: const TextStyle(color: Colors.white54)), trailing: const Icon(Icons.chevron_right), onTap: onTap)); }

class VoiceVerificationPage extends StatefulWidget { const VoiceVerificationPage({super.key}); @override State<VoiceVerificationPage> createState() => _VoiceState(); }
class _VoiceState extends State<VoiceVerificationPage> { bool recording = false; @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Voice verification')), body: Padding(padding: const EdgeInsets.all(22), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.mic_none, size: 72), const SizedBox(height: 20), const Text('Record your voice inside the app', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)), const SizedBox(height: 8), const Text('Arbitrary audio uploads are not accepted for this verification step.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54)), const SizedBox(height: 28), SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () { setState(() => recording = !recording); if (recording) _toast(context, 'Recording started'); else _toast(context, 'Recording submitted for review'); }, icon: Icon(recording ? Icons.stop : Icons.mic), label: Text(recording ? 'Stop recording' : 'Start recording')))])); }

class HomeShell extends StatefulWidget { const HomeShell({super.key}); @override State<HomeShell> createState() => _HomeState(); }
class _HomeState extends State<HomeShell> {
  int index = 0;
  final pages = const [DiscoverPage(), FeedPage(), MapPage(), LikesPage(), MessagesPage()];
  @override Widget build(BuildContext context) => Scaffold(body: IndexedStack(index: index, children: pages), bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (i) => setState(() => index = i), destinations: const [
    NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Discover'),
    NavigationDestination(icon: Icon(Icons.dynamic_feed_outlined), selectedIcon: Icon(Icons.dynamic_feed), label: 'Feed'),
    NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map), label: 'Map'),
    NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Likes'),
    NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Messages'),
  ]));
}

class DiscoverPage extends StatefulWidget { const DiscoverPage({super.key}); @override State<DiscoverPage> createState() => _DiscoverState(); }
class _DiscoverState extends State<DiscoverPage> {
  int current = 0; final liked = <String>{}; final pinged = <String>{};
  @override Widget build(BuildContext context) { final p = AppData.profiles[current % AppData.profiles.length]; return Scaffold(appBar: AppBar(title: const Text('3TRIO', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.3)), actions: [IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())), icon: const Icon(Icons.settings_outlined))]), body: Column(children: [
    SizedBox(height: 46, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), children: ['Age', 'Distance', 'Gender', 'Sexuality', 'Desires', 'Interests', 'Verified', 'Active'].map((x) => Padding(padding: const EdgeInsets.only(right: 7), child: ActionChip(label: Text(x), onPressed: () => showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => const FilterSheet())))).toList())),
    Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(14, 8, 14, 12), child: Stack(children: [ProfileCard(profile: p, onOpen: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage(profile: p))), onPass: () => setState(() => current++), onPing: () { setState(() => pinged.add(p.id)); _toast(context, 'Ping sent'); }, onLike: () { setState(() => liked.add(p.id)); _toast(context, liked.length > 100 ? 'Like limit reached' : 'Like sent'); })]))),
  ])); }
}
class ProfileCard extends StatelessWidget { final Profile profile; final VoidCallback onOpen, onPass, onPing, onLike; const ProfileCard({super.key, required this.profile, required this.onOpen, required this.onPass, required this.onPing, required this.onLike}); @override Widget build(BuildContext context) => GestureDetector(onTap: onOpen, child: ClipRRect(borderRadius: BorderRadius.circular(28), child: Stack(fit: StackFit.expand, children: [Image.network(profile.photos.first, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: ThreeTrioTheme.elevated)), DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: .88)]))), Positioned(left: 18, top: 18, child: Wrap(spacing: 6, children: [if (profile.photoVerified) const _Badge('Photo verified'), if (profile.voiceVerified) const _Badge('Voice verified')])), Positioned(left: 20, right: 20, bottom: 86, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${profile.name}, ${profile.age}', style: const TextStyle(fontSize: 29, fontWeight: FontWeight.w800)), Text('${profile.gender} · ${profile.sexuality} · ${profile.distance}', style: const TextStyle(color: Colors.white70)), const SizedBox(height: 8), Wrap(spacing: 6, runSpacing: 6, children: [...profile.desires.map((x) => _Pill(x)), ...profile.interests.take(2).map((x) => _Pill(x))]), const SizedBox(height: 8), Text(profile.bio, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, height: 1.35))])), Positioned(left: 18, right: 18, bottom: 15, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_RoundAction(Icons.close, onPass), _RoundAction(Icons.bolt, onPing), _RoundAction(Icons.favorite, onLike)]))])));
}
class _Badge extends StatelessWidget { final String text; const _Badge(this.text); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(30)), child: Text(text, style: const TextStyle(fontSize: 10))); }
class _Pill extends StatelessWidget { final String text; const _Pill(this.text); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(20)), child: Text(text, style: const TextStyle(fontSize: 10))); }
class _RoundAction extends StatelessWidget { final IconData icon; final VoidCallback onTap; const _RoundAction(this.icon, this.onTap); @override Widget build(BuildContext context) => GestureDetector(onTap: onTap, child: Container(width: 54, height: 54, decoration: const BoxDecoration(color: Colors.white12, shape: BoxShape.circle), child: Icon(icon))); }

class ProfilePage extends StatelessWidget { final Profile profile; const ProfilePage({super.key, required this.profile}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Profile')), body: ListView(padding: const EdgeInsets.all(18), children: [ClipRRect(borderRadius: BorderRadius.circular(25), child: Image.network(profile.photos.first, height: 390, fit: BoxFit.cover)), const SizedBox(height: 18), Text('${profile.name}, ${profile.age}', style: const TextStyle(fontSize: 29, fontWeight: FontWeight.w800)), Text('${profile.gender} · ${profile.sexuality} · ${profile.distance}', style: const TextStyle(color: Colors.white60)), const SizedBox(height: 15), VerificationBadges(photo: profile.photoVerified, id: profile.idVerified, voice: profile.voiceVerified), const SizedBox(height: 22), const Text('About', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), const SizedBox(height: 7), Text(profile.bio, style: const TextStyle(color: Colors.white65, height: 1.5)), const SizedBox(height: 22), const Text('Desires', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), Wrap(spacing: 7, children: profile.desires.map((x) => Chip(label: Text(x))).toList()), const SizedBox(height: 18), const Text('Interests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), Wrap(spacing: 7, children: profile.interests.map((x) => Chip(label: Text(x))).toList()), const SizedBox(height: 25), FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.favorite), label: const Text('Like'))])); }
class VerificationBadges extends StatelessWidget { final bool photo, id, voice; const VerificationBadges({super.key, required this.photo, required this.id, required this.voice}); @override Widget build(BuildContext context) => Wrap(spacing: 6, children: [if (photo) const Chip(avatar: Icon(Icons.camera_alt, size: 14), label: Text('Photo verified')), if (id) const Chip(avatar: Icon(Icons.badge_outlined, size: 14), label: Text('ID verified')), if (voice) const Chip(avatar: Icon(Icons.mic, size: 14), label: Text('Voice verified'))]); }

class FilterSheet extends StatefulWidget { const FilterSheet({super.key}); @override State<FilterSheet> createState() => _FilterState(); }
class _FilterState extends State<FilterSheet> { RangeValues age = const RangeValues(18, 55); double distance = 25; bool verified = false, active = false; @override Widget build(BuildContext context) => SafeArea(child: Padding(padding: const EdgeInsets.all(20), child: ListView(shrinkWrap: true, children: [const Text('Filters', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)), const SizedBox(height: 15), const Text('Age'), RangeSlider(values: age, min: 18, max: 80, divisions: 62, onChanged: (v) => setState(() => age = v)), Text('${age.start.round()} – ${age.end.round()}'), const SizedBox(height: 15), const Text('Distance'), Slider(value: distance, min: 1, max: 100, divisions: 99, onChanged: (v) => setState(() => distance = v)), Text('${distance.round()} km'), const SizedBox(height: 10), SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('Verified only'), value: verified, onChanged: (v) => setState(() => verified = v)), SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('Recently active'), value: active, onChanged: (v) => setState(() => active = v)), const SizedBox(height: 12), FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Apply filters'))]))); }

class FeedPage extends StatelessWidget { const FeedPage({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Feed', style: TextStyle(fontWeight: FontWeight.w800)), actions: [TextButton(onPressed: () => showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => const CreatePostSheet()), child: const Text('Create'))]), body: RefreshIndicator(onRefresh: () async {}, child: ListView(padding: const EdgeInsets.fromLTRB(14, 8, 14, 20), children: [const StoryStrip(), const SizedBox(height: 10), PostCard(name: 'Maya', time: '12 min', text: 'Sunset rooftop plans tonight. Who is around?', image: 'https://images.unsplash.com/photo-1519671482749-fd09be7ccebf?w=1000', tags: ['Rooftop', 'Social']), PostCard(name: 'Alex & Sam', time: '1 h', text: 'Weekend plans: food, music and good people.', image: 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=1000', tags: ['Food', 'Music'])]))); }
class StoryStrip extends StatelessWidget { const StoryStrip({super.key}); @override Widget build(BuildContext context) => SizedBox(height: 100, child: ListView(scrollDirection: Axis.horizontal, children: ['You', 'Maya', 'Alex', 'Riya', 'Sam'].map((n) => Padding(padding: const EdgeInsets.only(right: 15), child: GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoryViewerPage(name: n))), child: Column(children: [Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(shape: BoxShape.circle, color: ThreeTrioTheme.red), child: CircleAvatar(radius: 29, child: Text(n[0])),), const SizedBox(height: 5), Text(n, style: const TextStyle(fontSize: 11))])))).toList())); }
class StoryViewerPage extends StatelessWidget { final String name; const StoryViewerPage({super.key, required this.name}); @override Widget build(BuildContext context) => Scaffold(backgroundColor: Colors.black, body: SafeArea(child: Stack(fit: StackFit.expand, children: [Image.network(AppData.image1, fit: BoxFit.contain), Positioned(top: 10, left: 12, right: 12, child: Row(children: [Expanded(child: LinearProgressIndicator(value: 1)), IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))])), Positioned(left: 18, bottom: 22, child: Text(name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)))]))); }
class PostCard extends StatelessWidget { final String name, time, text, image; final List<String> tags; const PostCard({super.key, required this.name, required this.time, required this.text, required this.image, required this.tags}); @override Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 15), decoration: BoxDecoration(color: ThreeTrioTheme.surface, borderRadius: BorderRadius.circular(22)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ListTile(leading: CircleAvatar(child: Text(name[0])), title: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text(time, style: const TextStyle(color: Colors.white54)), trailing: const Icon(Icons.more_horiz)), Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(text, style: const TextStyle(height: 1.4))), const SizedBox(height: 10), ClipRRect(borderRadius: BorderRadius.circular(18), child: Image.network(image, height: 230, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox(height: 230))), Padding(padding: const EdgeInsets.all(14), child: Row(children: [for (final t in tags) Padding(padding: const EdgeInsets.only(right: 6), child: _Pill(t)), const Spacer(), const Icon(Icons.favorite_border), const SizedBox(width: 18), const Icon(Icons.mode_comment_outlined), const SizedBox(width: 14), const Icon(Icons.send_outlined)]))])); }
class CreatePostSheet extends StatefulWidget { const CreatePostSheet({super.key}); @override State<CreatePostSheet> createState() => _CreatePostState(); }
class _CreatePostState extends State<CreatePostSheet> { final text = TextEditingController(); int type = 0; @override Widget build(BuildContext context) => SafeArea(child: Padding(padding: EdgeInsets.fromLTRB(18, 18, 18, MediaQuery.viewInsetsOf(context).bottom + 18), child: Column(mainAxisSize: MainAxisSize.min, children: [Row(children: [const Text('Create post', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)), const Spacer(), IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))]), const SizedBox(height: 8), SegmentedButton<int>(segments: const [ButtonSegment(value: 0, label: Text('Text')), ButtonSegment(value: 1, label: Text('Photo')), ButtonSegment(value: 2, label: Text('Video'))], selected: {type}, onSelectionChanged: (v) => setState(() => type = v.first)), const SizedBox(height: 10), TextField(controller: text, minLines: 3, maxLines: 6, decoration: const InputDecoration(hintText: 'Share something…')), if (type != 0) TextButton.icon(onPressed: () async { final picker = ImagePicker(); final file = type == 1 ? await picker.pickImage(source: ImageSource.gallery) : await picker.pickVideo(source: ImageSource.gallery); if (file != null && context.mounted) _toast(context, 'Media selected'); }, icon: const Icon(Icons.add_photo_alternate_outlined), label: const Text('Choose media')), const SizedBox(height: 8), SizedBox(width: double.infinity, child: FilledButton(onPressed: text.text.trim().isEmpty && type == 0 ? null : () => Navigator.pop(context), child: const Text('Publish')))]))); }

class MapPage extends StatefulWidget { const MapPage({super.key}); @override State<MapPage> createState() => _MapState(); }
class _MapState extends State<MapPage> { int mode = 2; @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Map', style: TextStyle(fontWeight: FontWeight.w800)), actions: [IconButton(onPressed: () => _mapPrivacy(context), icon: const Icon(Icons.shield_outlined))]), body: Stack(children: [Positioned.fill(child: Container(margin: const EdgeInsets.all(14), decoration: BoxDecoration(borderRadius: BorderRadius.circular(28), gradient: const LinearGradient(colors: [Color(0xFF1A2532), Color(0xFF0B1017)])), child: CustomPaint(painter: MapPainter(), child: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.location_on, size: 52, color: ThreeTrioTheme.red), SizedBox(height: 8), Text('Approximate zones only', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)), Text('Exact GPS is never displayed', style: TextStyle(color: Colors.white54))]))))), Positioned(top: 15, left: 25, right: 25, child: SegmentedButton<int>(segments: const [ButtonSegment(value: 0, label: Text('People')), ButtonSegment(value: 1, label: Text('Activities')), ButtonSegment(value: 2, label: Text('Both'))], selected: {mode}, onSelectionChanged: (v) => setState(() => mode = v.first))), Positioned(left: 26, right: 26, bottom: 25, child: Row(children: [Expanded(child: FilledButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateActivityPage())), icon: const Icon(Icons.add), label: const Text('Create Activity'))), const SizedBox(width: 10), FloatingActionButton(onPressed: () => _toast(context, 'Location privacy active'), child: const Icon(Icons.my_location))]))])); }
void _mapPrivacy(BuildContext context) => showModalBottomSheet(context: context, builder: (_) => const SafeArea(child: Padding(padding: EdgeInsets.all(22), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Map privacy', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)), SizedBox(height: 10), Text('3TRIO uses approximate/obfuscated map positions. Exact home, workplace, hotel room, live trail and historical route are never exposed.', style: TextStyle(color: Colors.white60, height: 1.45)), SizedBox(height: 15)])))); }
class MapPainter extends CustomPainter { @override void paint(Canvas c, Size s) { final grid = Paint()..color = Colors.white.withValues(alpha: .045)..strokeWidth = 1; for (double x = 0; x < s.width; x += 45) c.drawLine(Offset(x, 0), Offset(x, s.height), grid); for (double y = 0; y < s.height; y += 45) c.drawLine(Offset(0, y), Offset(s.width, y), grid); final dot = Paint()..color = ThreeTrioTheme.red; for (final p in [Offset(s.width*.25,s.height*.27), Offset(s.width*.72,s.height*.38), Offset(s.width*.38,s.height*.68), Offset(s.width*.77,s.height*.72)]) c.drawCircle(p, 8, dot); } @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false; }

class CreateActivityPage extends StatefulWidget { const CreateActivityPage({super.key}); @override State<CreateActivityPage> createState() => _ActivityFormState(); }
class _ActivityFormState extends State<CreateActivityPage> { final title = TextEditingController(), description = TextEditingController(), area = TextEditingController(); String category = 'Events'; bool privateActivity = false; @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Create activity'), actions: [TextButton(onPressed: () { if (title.text.trim().isEmpty || area.text.trim().isEmpty) { _toast(context, 'Title and area are required'); return; } Navigator.pop(context); }, child: const Text('Create'))]), body: ListView(padding: const EdgeInsets.all(18), children: [TextField(controller: title, decoration: const InputDecoration(labelText: 'Activity title')), const SizedBox(height: 12), TextField(controller: description, maxLines: 4, decoration: const InputDecoration(labelText: 'Description')), const SizedBox(height: 12), DropdownButtonFormField<String>(initialValue: category, decoration: const InputDecoration(labelText: 'Category'), items: ['Restaurants','Cafés','Bars','Clubs','Outdoors','Sports','Culture','Events','Entertainment'].map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(), onChanged: (x) => setState(() => category = x!)), const SizedBox(height: 12), TextField(controller: area, decoration: const InputDecoration(labelText: 'General location / safe area')), SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('Private activity'), subtitle: const Text('Limit discovery to eligible members.'), value: privateActivity, onChanged: (v) => setState(() => privateActivity = v)), const SizedBox(height: 10), const Text('Exact GPS is not published for activities.', style: TextStyle(color: Colors.white54))])); }

class LikesPage extends StatelessWidget { const LikesPage({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Likes', style: TextStyle(fontWeight: FontWeight.w800)), actions: [TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumPage())), child: const Text('Premium'))]), body: ListView(padding: const EdgeInsets.all(14), children: const [_Interaction(name: 'Maya', text: 'Liked you · 8 km', icon: Icons.favorite), _Interaction(name: 'Alex & Sam', text: 'Pinged you · 14 km', icon: Icons.bolt), _Interaction(name: 'Riya', text: 'Liked you · 21 km', icon: Icons.favorite)])); }
class _Interaction extends StatelessWidget { final String name, text; final IconData icon; const _Interaction({required this.name, required this.text, required this.icon}); @override Widget build(BuildContext context) => ListTile(contentPadding: const EdgeInsets.symmetric(vertical: 5), leading: CircleAvatar(radius: 27, child: Text(name[0])), title: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text(text), trailing: IconButton(onPressed: () {}, icon: Icon(icon, color: ThreeTrioTheme.red))); }

class PremiumPage extends StatelessWidget { const PremiumPage({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('3TRIO Premium')), body: ListView(padding: const EdgeInsets.all(20), children: [const Text('More freedom, more discovery.', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800)), const SizedBox(height: 8), const Text('Unlimited likes and see who liked you.', style: TextStyle(color: Colors.white54)), const SizedBox(height: 22), for (final p in const [('Monthly','₹500'),('6 Months','₹2,500'),('Yearly','₹4,000')]) Card(color: ThreeTrioTheme.surface, child: ListTile(contentPadding: const EdgeInsets.all(12), title: Text(p.$1, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: const Text('Unlimited likes · See who liked you'), trailing: FilledButton(onPressed: () {}, child: Text(p.$2))))])); }

class MessagesPage extends StatelessWidget { const MessagesPage({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Messages', style: TextStyle(fontWeight: FontWeight.w800))), body: ListView(padding: const EdgeInsets.all(10), children: [ChatTile(name: 'Maya', message: 'Are you around tonight?', time: '20:14'), ChatTile(name: 'Alex & Sam', message: 'That activity looks great', time: '19:40'), ChatTile(name: 'Riya', message: 'Seen your profile ✨', time: '18:05')])); }
class ChatTile extends StatelessWidget { final String name, message, time; const ChatTile({super.key, required this.name, required this.message, required this.time}); @override Widget build(BuildContext context) => ListTile(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage(name: name))), leading: CircleAvatar(radius: 27, child: Text(name[0])), title: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text(message), trailing: Text(time, style: const TextStyle(color: Colors.white38))); }

class ChatPage extends StatefulWidget { final String name; const ChatPage({super.key, required this.name}); @override State<ChatPage> createState() => _ChatState(); }
class _ChatState extends State<ChatPage> { final controller = TextEditingController(); final messages = <String>['Hey 👋', 'How is your evening going?']; bool oneView = false; @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Row(children: [CircleAvatar(radius: 17, child: Text(widget.name[0])), const SizedBox(width: 9), Text(widget.name)]), actions: [IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CallPage(name: widget.name, video: false))), icon: const Icon(Icons.call_outlined)), IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CallPage(name: widget.name, video: true))), icon: const Icon(Icons.videocam_outlined))]), body: Column(children: [Container(width: double.infinity, padding: const EdgeInsets.all(8), color: const Color(0xFF10131A), child: const Row(children: [Icon(Icons.shield_outlined, size: 15, color: ThreeTrioTheme.green), SizedBox(width: 6), Text('Protected Chat', style: TextStyle(fontSize: 11, color: Colors.white60))])), Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [for (final m in messages) Align(alignment: Alignment.centerRight, child: Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), decoration: BoxDecoration(color: ThreeTrioTheme.elevated, borderRadius: BorderRadius.circular(18)), child: Text(m)))])), if (oneView) const Padding(padding: EdgeInsets.all(5), child: Text('One-view media mode', style: TextStyle(color: ThreeTrioTheme.red, fontSize: 11))), SafeArea(child: Row(children: [IconButton(onPressed: () async { final f = await ImagePicker().pickImage(source: ImageSource.gallery); if (f != null && context.mounted) _toast(context, oneView ? 'One-view image selected' : 'Image selected'); }, icon: const Icon(Icons.photo_outlined)), IconButton(onPressed: () => setState(() => oneView = !oneView), icon: Icon(oneView ? Icons.visibility_off : Icons.visibility)), Expanded(child: TextField(controller: controller, minLines: 1, maxLines: 5, decoration: const InputDecoration(hintText: 'Message', border: InputBorder.none))), IconButton(onPressed: () { final t = controller.text.trim(); if (t.isNotEmpty) setState(() { messages.add(oneView ? 'One-view: $t' : t); controller.clear(); oneView = false; }); }, icon: const Icon(Icons.send_rounded))]))])); }

class CallPage extends StatefulWidget { final String name; final bool video; const CallPage({super.key, required this.name, required this.video}); @override State<CallPage> createState() => _CallState(); }
class _CallState extends State<CallPage> { bool muted = false, camera = true, speaker = false; @override void initState() { super.initState(); WidgetsBinding.instance.addPostFrameCallback((_) => SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky)); } @override void dispose() { SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); super.dispose(); } @override Widget build(BuildContext context) => Scaffold(backgroundColor: Colors.black, body: SafeArea(child: Stack(fit: StackFit.expand, children: [if (widget.video) Container(color: const Color(0xFF0E1118), child: const Center(child: Icon(Icons.person, size: 110, color: Colors.white24))) else const Center(child: CircleAvatar(radius: 58, child: Icon(Icons.person, size: 60))), Positioned(top: 25, left: 20, right: 20, child: Column(children: [Text(widget.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)), const SizedBox(height: 5), const Text('Connecting…', style: TextStyle(color: Colors.white54))])), Positioned(bottom: 30, left: 18, right: 18, child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_CallButton(icon: muted ? Icons.mic_off : Icons.mic, onTap: () => setState(() => muted = !muted)), if (widget.video) _CallButton(icon: camera ? Icons.videocam : Icons.videocam_off, onTap: () => setState(() => camera = !camera)), _CallButton(icon: speaker ? Icons.volume_up : Icons.volume_down, onTap: () => setState(() => speaker = !speaker)), _CallButton(icon: Icons.call_end, danger: true, onTap: () => Navigator.pop(context))]))]))); }
class _CallButton extends StatelessWidget { final IconData icon; final VoidCallback onTap; final bool danger; const _CallButton({required this.icon, required this.onTap, this.danger = false}); @override Widget build(BuildContext context) => IconButton.filled(onPressed: onTap, style: IconButton.styleFrom(backgroundColor: danger ? ThreeTrioTheme.red : Colors.white12, fixedSize: const Size(54,54)), icon: Icon(icon)); }

class SettingsPage extends StatefulWidget { const SettingsPage({super.key}); @override State<SettingsPage> createState() => _SettingsState(); }
class _SettingsState extends State<SettingsPage> { bool incognito = false, mapVisible = true, haptics = true; String unit = 'KM'; @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Settings')), body: ListView(children: [const _Section('Account'), ListTile(leading: const Icon(Icons.person_outline), title: const Text('Edit profile'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfilePage()))), ListTile(leading: const Icon(Icons.workspace_premium_outlined), title: const Text('Premium'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumPage()))), const _Section('Privacy'), SwitchListTile(title: const Text('Incognito'), value: incognito, onChanged: (v) => setState(() => incognito = v)), SwitchListTile(title: const Text('Map visibility'), subtitle: const Text('Approximate area only'), value: mapVisible, onChanged: (v) => setState(() => mapVisible = v)), ListTile(title: const Text('Blocked users'), trailing: const Icon(Icons.chevron_right), onTap: () {}), const _Section('Distance'), ListTile(title: const Text('Distance unit'), trailing: DropdownButton<String>(value: unit, items: const [DropdownMenuItem(value: 'KM', child: Text('KM')), DropdownMenuItem(value: 'Miles', child: Text('Miles'))], onChanged: (v) => setState(() => unit = v!))), const _Section('Notifications'), SwitchListTile(title: const Text('Haptic feedback'), value: haptics, onChanged: (v) => setState(() => haptics = v)), ListTile(title: const Text('Notification settings'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationSettingsPage()))), const _Section('Safety'), ListTile(title: const Text('Safety center'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SafetyPage()))), ListTile(title: const Text('Pause account'), onTap: () => _toast(context, 'Account pause flow ready')), ListTile(title: const Text('Delete account'), textColor: ThreeTrioTheme.red, onTap: () => _confirmDelete(context))])); }
}
class _Section extends StatelessWidget { final String title; const _Section(this.title); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(18, 22, 18, 7), child: Text(title.toUpperCase(), style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1))); }

class EditProfilePage extends StatefulWidget { const EditProfilePage({super.key}); @override State<EditProfilePage> createState() => _EditProfileState(); }
class _EditProfileState extends State<EditProfilePage> { final name = TextEditingController(text: 'Yash'); final bio = TextEditingController(); final looking = TextEditingController(); final photos = <String>[]; final desires = <String>{}; final interests = <String>{}; @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Edit profile'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Save'))]), body: ListView(padding: const EdgeInsets.all(18), children: [const Text('Photos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), Text('${photos.length}/5 photos', style: const TextStyle(color: Colors.white54)), const SizedBox(height: 10), GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 7, mainAxisSpacing: 7), itemCount: photos.length + 1, itemBuilder: (_, i) { if (i == photos.length) return InkWell(onTap: photos.length == 5 ? null : _addPhoto, child: Container(decoration: BoxDecoration(color: ThreeTrioTheme.surface, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.add))); return ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.network(photos[i], fit: BoxFit.cover)); }), const SizedBox(height: 24), TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')), const SizedBox(height: 12), TextField(controller: bio, maxLines: 4, decoration: const InputDecoration(labelText: 'Bio')), const SizedBox(height: 12), TextField(controller: looking, maxLines: 3, decoration: const InputDecoration(labelText: 'What are you looking for?')), const SizedBox(height: 20), const Text('Desires', style: TextStyle(fontWeight: FontWeight.w800)), _choices(['Connection','Dating','Exploring','Events','Friends'], desires), const SizedBox(height: 18), const Text('Interests', style: TextStyle(fontWeight: FontWeight.w800)), _choices(['Travel','Music','Food','Fitness','Art','Nightlife'], interests), const SizedBox(height: 22), const Text('Hidden bio', style: TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 7), const Text('Optional private text revealed only according to your privacy rule.', style: TextStyle(color: Colors.white54)), const SizedBox(height: 25)])); }
void _addPhoto() { setState(() { photos.add(AppData.image1); }); } Widget _choices(List<String> values, Set<String> selected) => Wrap(spacing: 7, children: values.map((x) => FilterChip(label: Text(x), selected: selected.contains(x), onSelected: (v) => setState(() => v ? selected.add(x) : selected.remove(x)))).toList()); }

class NotificationSettingsPage extends StatefulWidget { const NotificationSettingsPage({super.key}); @override State<NotificationSettingsPage> createState() => _NotifState(); }
class _NotifState extends State<NotificationSettingsPage> { bool push = true, likes = true, messages = true, nearby = true, activities = true, calls = true; @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Notifications')), body: ListView(children: [SwitchListTile(title: const Text('Push notifications'), value: push, onChanged: (v) => setState(() => push = v)), SwitchListTile(title: const Text('Likes & Pings'), value: likes, onChanged: (v) => setState(() => likes = v)), SwitchListTile(title: const Text('Messages'), value: messages, onChanged: (v) => setState(() => messages = v)), SwitchListTile(title: const Text('Nearby interactions'), subtitle: const Text('“Someone nearby liked you ❤️”'), value: nearby, onChanged: (v) => setState(() => nearby = v)), SwitchListTile(title: const Text('Activities'), value: activities, onChanged: (v) => setState(() => activities = v)), SwitchListTile(title: const Text('Calls'), value: calls, onChanged: (v) => setState(() => calls = v))])); }

class SafetyPage extends StatelessWidget { const SafetyPage({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Safety & privacy')), body: ListView(padding: const EdgeInsets.all(18), children: [const _SafetyItem(icon: Icons.verified_user_outlined, title: 'Verification', text: 'Photo, government ID and voice verification are separate.'), const _SafetyItem(icon: Icons.location_off_outlined, title: 'Location privacy', text: 'Exact GPS and live movement trails are never exposed.'), const _SafetyItem(icon: Icons.block_outlined, title: 'Block', text: 'Block members immediately.'), const _SafetyItem(icon: Icons.flag_outlined, title: 'Report', text: 'Report profiles, posts, activities or messages.'), const _SafetyItem(icon: Icons.emergency_outlined, title: 'Emergency', text: 'If you are in immediate danger, contact local emergency services.')],)); }
class _SafetyItem extends StatelessWidget { final IconData icon; final String title, text; const _SafetyItem({required this.icon, required this.title, required this.text}); @override Widget build(BuildContext context) => Card(color: ThreeTrioTheme.surface, child: ListTile(contentPadding: const EdgeInsets.all(13), leading: Icon(icon), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text(text, style: const TextStyle(color: Colors.white54, height: 1.35)))); }

void _toast(BuildContext context, String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), behavior: SnackBarBehavior.floating));
void _confirmDelete(BuildContext context) => showDialog<void>(context: context, builder: (_) => AlertDialog(title: const Text('Delete account?'), content: const Text('This starts the account deletion flow. Production deletion is handled server-side.'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Continue'))]));

class CreateActivityModel { final String id, title, description, area; final int maxParticipants; final bool privateActivity; const CreateActivityModel({required this.id, required this.title, required this.description, required this.area, required this.maxParticipants, required this.privateActivity}); }
class LocationPrivacy { static const exactGpsPublic = false; static const liveTrailPublic = false; static const homeExactPublic = false; static const historicalRoutePublic = false; static double safeRadiusKm = 1.0; static String nearbyMessage() => 'Someone nearby liked you ❤️'; }
class LikePolicy { static const freeRollingLimit = 100; static bool canLike({required bool premium, required int used}) => premium || used < freeRollingLimit; }
class PremiumPolicy { static const monthly = '₹500'; static const sixMonths = '₹2,500'; static const yearly = '₹4,000'; static const unlimitedLikes = true; static const seeWhoLiked = true; }
class PhotoPolicy { static const maxProfilePhotos = 5; }
class NavigationPolicy { static const tabs = ['Discover','Feed','Map','Likes','Messages']; }
class VerificationPolicy { static const required = true; static const types = ['Photo','Government ID','Voice']; }
