import 'package:flutter/material.dart';

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
    theme: ThemeData(useMaterial3: true, brightness: Brightness.dark, scaffoldBackgroundColor: const Color(0xFF07090D), colorScheme: const ColorScheme.dark(primary: Color(0xFFE33A4E))),
    home: const HomeShell(),
  );
}

class HomeShell extends StatefulWidget { const HomeShell({super.key}); @override State<HomeShell> createState() => _HomeShellState(); }
class _HomeShellState extends State<HomeShell> {
  int index = 0;
  static const labels = ['Discover','Feed','Map','Likes','Messages'];
  static const icons = [Icons.explore_outlined,Icons.dynamic_feed_outlined,Icons.map_outlined,Icons.favorite_border,Icons.chat_bubble_outline];
  @override Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: _page()),
    bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (v) => setState(() => index = v), destinations: List.generate(5, (i) => NavigationDestination(icon: Icon(icons[i]), label: labels[i]))),
  );
  Widget _page() => [const DiscoverPage(),const FeedPage(),const MapPage(),const LikesPage(),const MessagesPage()][index];
}

Widget pageShell(String title, Widget child) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Padding(padding: const EdgeInsets.fromLTRB(20,12,20,10), child: Text(title, style: const TextStyle(fontSize:28,fontWeight:FontWeight.w700))), Expanded(child: child)]);

class DiscoverPage extends StatelessWidget { const DiscoverPage({super.key}); @override Widget build(BuildContext context) => pageShell('Discover', Column(children: [SizedBox(height:48, child: ListView(scrollDirection:Axis.horizontal,padding:const EdgeInsets.symmetric(horizontal:16),children:['Desires','Distance','Gender','Sexuality','Verified','Recently active'].map((x)=>Padding(padding:const EdgeInsets.only(right:8),child:FilterChip(label:Text(x),onSelected:(_){ }))).toList())), Expanded(child: Container(margin:const EdgeInsets.all(14),decoration:BoxDecoration(borderRadius:BorderRadius.circular(28),gradient:const LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:[Color(0xFF27232A),Color(0xFF090B10)])),child:const Padding(padding:EdgeInsets.all(22),child:Align(alignment:Alignment.bottomLeft,child:Text('3TRIO\nDiscover real connections\n\nPhoto • ID • Voice verification required',style:TextStyle(fontSize:19,height:1.45))))))])); }
class FeedPage extends StatelessWidget { const FeedPage({super.key}); @override Widget build(BuildContext context) => pageShell('Feed', const Center(child:Text('Stories\n\nText · Photo · Video posts',textAlign:TextAlign.center,style:TextStyle(fontSize:18)))); }
class MapPage extends StatelessWidget { const MapPage({super.key}); @override Widget build(BuildContext context) => pageShell('Map', Column(children:[const Padding(padding:EdgeInsets.symmetric(horizontal:14),child:Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[Chip(label:Text('People')),Chip(label:Text('Activities')),Chip(label:Text('Both'))])),Expanded(child:Container(margin:const EdgeInsets.all(14),decoration:BoxDecoration(color:const Color(0xFF111820),borderRadius:BorderRadius.circular(28)),child:const Center(child:Text('3TRIO MAP\n\nApproximate locations only\nExact GPS is never shown',textAlign:TextAlign.center))))])); }
class LikesPage extends StatelessWidget { const LikesPage({super.key}); @override Widget build(BuildContext context) => pageShell('Likes', const Center(child:Text('Likes · Pings\n\nPremium: unlimited likes + see who liked you',textAlign:TextAlign.center,style:TextStyle(fontSize:18)))); }
class MessagesPage extends StatelessWidget { const MessagesPage({super.key}); @override Widget build(BuildContext context) => pageShell('Messages', const Center(child:Text('Private chat · Groups · Activity chat\n\nAudio & Video calls',textAlign:TextAlign.center,style:TextStyle(fontSize:18)))); }
