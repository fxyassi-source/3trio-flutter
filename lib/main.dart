import 'package:flutter/material.dart';
import 'theme.dart';

void main() => runApp(const ThreeTrioApp());

class ThreeTrioApp extends StatelessWidget {
  const ThreeTrioApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: '3TRIO',
        debugShowCheckedModeBanner: false,
        theme: buildThreeTrioTheme(),
        home: const AgeGateScreen(),
      );
}

class AgeGateScreen extends StatelessWidget {
  const AgeGateScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('3TRIO', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w800, letterSpacing: 3)),
              const SizedBox(height: 12),
              const Text('Meet openly. Connect intentionally.', textAlign: TextAlign.center, style: TextStyle(fontSize: 17)),
              const SizedBox(height: 30),
              const Text('Adults only · 18+', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 24),
              SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())), child: const Text('I am 18 or older'))),
            ]),
          ),
        ),
      );
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Welcome to 3TRIO')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            _Action(label: 'Continue with Google', icon: Icons.g_mobiledata, onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeShell()))),
            _Action(label: 'Continue with Apple', icon: Icons.apple, onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeShell()))),
            _Action(label: 'Continue with phone', icon: Icons.phone, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PhoneLoginScreen()))),
            const SizedBox(height: 16),
            const Text('Verification is required for every member.', textAlign: TextAlign.center),
          ]),
        ),
      );
}

class PhoneLoginScreen extends StatelessWidget {
  const PhoneLoginScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Phone verification')),
        body: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
          const TextField(keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: 'Phone number', prefixText: '+ ')),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeShell())), child: const Text('Send OTP'))),
        ])),
      );
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override State<HomeShell> createState() => _HomeShellState();
}
class _HomeShellState extends State<HomeShell> {
  int index = 0;
  final pages = const [DiscoverScreen(), FeedScreen(), MapScreen(), LikesScreen(), MessagesScreen()];
  @override
  Widget build(BuildContext context) => Scaffold(
        body: pages[index],
        bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (v) => setState(() => index = v), destinations: const [
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Discover'),
          NavigationDestination(icon: Icon(Icons.dynamic_feed_outlined), selectedIcon: Icon(Icons.dynamic_feed), label: 'Feed'),
          NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map), label: 'Map'),
          NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Likes'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Messages'),
        ]),
      );
}

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Discover'), actions: [IconButton(icon: const Icon(Icons.tune), onPressed: () => _open(context, 'Filters'))]), body: ListView(padding: const EdgeInsets.all(16), children: [
    const _ProfileCard(name: 'Alex & Sam', age: '29 · 31', desire: 'Open to explore', image: 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=900'),
    const _ProfileCard(name: 'Maya', age: '28', desire: 'Connections', image: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=900'),
  ]));
}

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Feed'), actions: [IconButton(icon: const Icon(Icons.add), onPressed: () => _open(context, 'Create Post'))]), body: ListView(padding: const EdgeInsets.all(16), children: const [
    _Post(name: '3TRIO Community', text: 'Weekend social. Meet new people, keep it respectful and consensual.', image: 'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=900'),
    _Post(name: 'Jordan', text: 'Looking for genuine connections and good conversation.', image: 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=900'),
  ]));
}

class MapScreen extends StatefulWidget { const MapScreen({super.key}); @override State<MapScreen> createState()=>_MapScreenState(); }
class _MapScreenState extends State<MapScreen> {
  int mode=0;
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Map'), actions: [IconButton(icon: const Icon(Icons.add_location_alt_outlined), onPressed: ()=>_open(context,'Create Activity'))]), body: Column(children: [
    Padding(padding: const EdgeInsets.all(12), child: SegmentedButton<int>(segments: const [ButtonSegment(value:0,label:Text('People')),ButtonSegment(value:1,label:Text('Activities')),ButtonSegment(value:2,label:Text('Both'))], selected: {mode}, onSelectionChanged:(s)=>setState(()=>mode=s.first))),
    Expanded(child: Container(margin: const EdgeInsets.all(12), decoration: BoxDecoration(borderRadius: BorderRadius.circular(28), color: Theme.of(context).colorScheme.surfaceContainerHighest), child: Stack(children: [
      const Center(child: Icon(Icons.map, size: 100)),
      Positioned(left: 18,right: 18,bottom: 18,child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(20)), child: const Text('Approximate locations only. Exact GPS, home and live movement are never exposed.', textAlign: TextAlign.center))),
    ]))),
  ]));
}

class LikesScreen extends StatelessWidget { const LikesScreen({super.key}); @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Likes & Pings')),body:ListView(padding:const EdgeInsets.all(16),children:const [_ListTile(title:'Someone nearby liked you ❤️',sub:'Open Likes to see who connected with you.'),_ListTile(title:'Sam sent a Ping',sub:'You can respond from this screen.')]); }
class MessagesScreen extends StatelessWidget { const MessagesScreen({super.key}); @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Messages')),body:ListView(children:[ListTile(leading:const CircleAvatar(child:Icon(Icons.person)),title:const Text('Alex & Sam'),subtitle:const Text('Protected chat'),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const ChatScreen()))),const ListTile(leading:CircleAvatar(child:Icon(Icons.groups)),title:Text('Activity chat'),subtitle:Text('Rooftop Social · 5 going'))]); }

class ChatScreen extends StatelessWidget { const ChatScreen({super.key}); @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Protected Chat'),actions:[IconButton(icon:const Icon(Icons.call_outlined),onPressed:()=>_open(context,'Audio Call')),IconButton(icon:const Icon(Icons.videocam_outlined),onPressed:()=>_open(context,'Video Call'))]),body:Column(children:[const Expanded(child:ListView(padding:EdgeInsets.all(16),children:[_Bubble(text:'Hey 👋',mine:false),_Bubble(text:'Hi, nice to meet you.',mine:true),_Bubble(text:'Protected chat · One-view media supported',mine:false)])),SafeArea(child:Row(children:[IconButton(icon:const Icon(Icons.photo_outlined),onPressed:()=>_open(context,'Media')),const Expanded(child:TextField(decoration:InputDecoration(hintText:'Message…'))),IconButton(icon:const Icon(Icons.send),onPressed:()=>_open(context,'Message sent'))]))])); }

class VerificationScreen extends StatelessWidget { const VerificationScreen({super.key}); @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Verification')),body:ListView(padding:const EdgeInsets.all(20),children:const [_Verify(title:'Photo verification',icon:Icons.face_retouching_natural),_Verify(title:'Government ID',icon:Icons.badge_outlined),_Verify(title:'Voice verification',icon:Icons.mic_none)]); }
class PremiumScreen extends StatelessWidget { const PremiumScreen({super.key}); @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('3TRIO Premium')),body:ListView(padding:const EdgeInsets.all(20),children:const [Text('Unlimited likes',style:TextStyle(fontSize:24,fontWeight:FontWeight.bold)),SizedBox(height:8),Text('See who liked you'),SizedBox(height:24),_Plan('Monthly','₹500'),_Plan('6 months','₹2,500'),_Plan('Yearly','₹4,000')]); }
class SettingsScreen extends StatelessWidget { const SettingsScreen({super.key}); @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Settings')),body:ListView(children:const [SwitchListTile(value:true,onChanged:null,title:Text('Incognito')),SwitchListTile(value:true,onChanged:null,title:Text('Map visibility')),SwitchListTile(value:true,onChanged:null,title:Text('Nearby interaction notifications')),ListTile(title:Text('Distance'),subtitle:Text('Kilometres / Miles')),ListTile(title:Text('Privacy & Safety')),ListTile(title:Text('Blocked users'))])); }

class _ProfileCard extends StatelessWidget { final String name,age,desire,image; const _ProfileCard({required this.name,required this.age,required this.desire,required this.image}); @override Widget build(BuildContext context)=>Card(clipBehavior:Clip.antiAlias,margin:const EdgeInsets.only(bottom:18),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Image.network(image,height:420,width:double.infinity,fit:BoxFit.cover,errorBuilder:(_,__,___)=>const SizedBox(height:420,child:Icon(Icons.person,size:80))),Padding(padding:const EdgeInsets.fromLTRB(18,16,18,8),child:Text('$name  $age',style:const TextStyle(fontSize:23,fontWeight:FontWeight.w700))),Padding(padding:const EdgeInsets.symmetric(horizontal:18),child:Wrap(spacing:8,children:[const Chip(label:Text('Photo verified')),Chip(label:Text('♡ Desires'))])),Padding(padding:const EdgeInsets.all(14),child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[IconButton(icon:const Icon(Icons.close),onPressed:()=>_open(context,'Passed')),IconButton(icon:const Icon(Icons.bolt),onPressed:()=>_open(context,'Ping sent')),IconButton(icon:const Icon(Icons.favorite),onPressed:()=>_open(context,'Liked'))]))])); }
class _Post extends StatelessWidget { final String name,text,image; const _Post({required this.name,required this.text,required this.image}); @override Widget build(BuildContext context)=>Card(margin:const EdgeInsets.only(bottom:16),clipBehavior:Clip.antiAlias,child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[ListTile(title:Text(name),subtitle:const Text('Today')),Padding(padding:const EdgeInsets.symmetric(horizontal:16),child:Text(text)),const SizedBox(height:12),Image.network(image,height:260,width:double.infinity,fit:BoxFit.cover),const ListTile(leading:Icon(Icons.favorite_border),title:Text('Like   ·   Comment   ·   Share'))])); }
class _Action extends StatelessWidget { final String label; final IconData icon; final VoidCallback onTap; const _Action({required this.label,required this.icon,required this.onTap}); @override Widget build(BuildContext context)=>Padding(padding:const EdgeInsets.only(bottom:12),child:SizedBox(width:double.infinity,height:52,child:OutlinedButton.icon(onPressed:onTap,icon:Icon(icon),label:Text(label)))); }
class _ListTile extends StatelessWidget { final String title,sub; const _ListTile({required this.title,required this.sub}); @override Widget build(BuildContext context)=>ListTile(title:Text(title),subtitle:Text(sub),leading:const Icon(Icons.favorite_border)); }
class _Bubble extends StatelessWidget { final String text; final bool mine; const _Bubble({required this.text,required this.mine}); @override Widget build(BuildContext context)=>Align(alignment:mine?Alignment.centerRight:Alignment.centerLeft,child:Container(margin:const EdgeInsets.only(bottom:10),padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:mine?Theme.of(context).colorScheme.primaryContainer:Theme.of(context).colorScheme.surfaceContainerHighest,borderRadius:BorderRadius.circular(16)),child:Text(text))); }
class _Verify extends StatelessWidget { final String title; final IconData icon; const _Verify({required this.title,required this.icon}); @override Widget build(BuildContext context)=>Card(child:ListTile(leading:Icon(icon),title:Text(title),subtitle:const Text('Required · private verification data'),trailing:const Icon(Icons.chevron_right))); }
class _Plan extends StatelessWidget { final String title,price; const _Plan(this.title,this.price); @override Widget build(BuildContext context)=>Card(child:ListTile(title:Text(title),subtitle:Text(price),trailing:FilledButton(onPressed:null,child:Text('Choose')))); }
void _open(BuildContext context,String title)=>showModalBottomSheet(context:context,builder:(_)=>SafeArea(child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,children:[Text(title,style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold)),const SizedBox(height:12),const Text('This flow is wired into the standalone Flutter UI and can be connected to production services without mixing the legacy Kotlin project.'),const SizedBox(height:16),FilledButton(onPressed:()=>Navigator.pop(context),child:const Text('Close'))]))));
