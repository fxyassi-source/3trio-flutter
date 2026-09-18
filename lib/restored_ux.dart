import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

const restoredPrimary = Color(0xFFFF3B5C);

class RestoredProfileData {
  final String name, age, gender, bio, photo;
  final bool verified;
  final List<String> interests;
  const RestoredProfileData({
    required this.name, required this.age, required this.gender,
    required this.bio, required this.photo, this.verified = false,
    this.interests = const [],
  });
}

const restoredProfiles = <RestoredProfileData>[
  RestoredProfileData(name:'Alex & Sam',age:'29 · 31',gender:'Couple',bio:'Open-minded, respectful and here for genuine connections.',photo:'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=900',verified:true,interests:['ENM','Travel','Music']),
  RestoredProfileData(name:'Maya',age:'28',gender:'Woman',bio:'Good conversation, travel and new experiences.',photo:'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=900',verified:true,interests:['Travel','Fitness']),
  RestoredProfileData(name:'Jordan',age:'30',gender:'Man',bio:'Looking for genuine connections and good conversation.',photo:'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=900',interests:['Music','Fitness']),
  RestoredProfileData(name:'Taylor',age:'27',gender:'Woman',bio:'Travel, music and respectful connections.',photo:'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=900',verified:true,interests:['Travel','Music']),
];

const lookingForOptions = [
  'Women','Men','Couples (FM)','Couples (FF)','Couples (MM)','Trans Women',
  'Trans Men','Non-binary','Single Women','Single Men','Friends','Dates',
  'New Experiences','Open Relationship','Ethical Non-Monogamy','Polyamory',
  'Swinging','Threesomes','Group Play','Casual Fun','Long-term Connection','Travel Partners'
];

const desireOptions = [
  'Open Relationship','Ethical Non-Monogamy','Polyamory','Swinging','Threesomes',
  'Couples','Group Play','Casual Fun','Dating','Friends','Travel','Music','Fitness',
  'Roleplay','BDSM','Kink Exploration','Dominance / Submission','New Experiences','Good Conversation'
];

class RestoredStartScreen extends StatefulWidget {
  const RestoredStartScreen({super.key});
  @override State<RestoredStartScreen> createState() => _RestoredStartState();
}
class _RestoredStartState extends State<RestoredStartScreen> {
  int step=0, photos=0;
  String gender='', orientation='', name='', age='', bio='';
  final looking=<String>{};
  final desires=<String>{};

  bool get valid {
    if(step==0) return gender.isNotEmpty;
    if(step==1) return name.trim().isNotEmpty && int.tryParse(age)!=null && orientation.isNotEmpty;
    if(step==2) return looking.isNotEmpty;
    if(step==3) return photos>=2;
    return desires.isNotEmpty && bio.trim().isNotEmpty;
  }

  void next() {
    if(!valid) return;
    if(step<4) { setState(()=>step++); }
    else { Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const RestoredHome())); }
  }

  Future<void> pickPhoto() async {
    final x=await ImagePicker().pickImage(source:ImageSource.gallery);
    if(x!=null && photos<5) setState(()=>photos++);
  }

  @override Widget build(BuildContext c)=>Scaffold(
    appBar:AppBar(
      leading:step>0?IconButton(onPressed:()=>setState(()=>step--),icon:const Icon(Icons.arrow_back)):null,
      title:Text('3TRIO · ${step+1}/5'),
    ),
    body:SafeArea(child:Padding(
      padding:const EdgeInsets.fromLTRB(22,0,22,18),
      child:Column(children:[
        LinearProgressIndicator(value:(step+1)/5,color:restoredPrimary),
        const SizedBox(height:24),
        Expanded(child:SingleChildScrollView(child:_body())),
        const SizedBox(height:14),
        SizedBox(width:double.infinity,height:54,child:FilledButton(
          onPressed:valid?next:null,
          style:FilledButton.styleFrom(backgroundColor:restoredPrimary),
          child:Text(step==4?'Create Profile':'Continue'),
        )),
      ]),
    )),
  );

  Widget _body() {
    if(step==0) return _choices('I am a...',const ['Man','Woman','Non-binary','Couple'],gender,(x)=>setState(()=>gender=x));
    if(step==1) return Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      const Text('A few extra details',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900)),
      const SizedBox(height:20),
      TextField(onChanged:(v)=>name=v,decoration:const InputDecoration(labelText:'First name',border:OutlineInputBorder())),
      const SizedBox(height:14),
      TextField(onChanged:(v)=>age=v,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'Age',border:OutlineInputBorder())),
      const SizedBox(height:18),
      const Text('Sexuality / orientation',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold)),
      const SizedBox(height:10),
      Wrap(spacing:8,runSpacing:8,children:['Straight','Bi','Gay','Lesbian','Pansexual','Queer'].map((x)=>ChoiceChip(label:Text(x),selected:orientation==x,onSelected:(_)=>setState(()=>orientation=x))).toList()),
    ]);
    if(step==2) return _chips('What are you looking for?',lookingForOptions,looking,8);
    if(step==3) return Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      const Text('Your photos',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900)),
      const SizedBox(height:8),const Text('At least 2 · maximum 5'),
      const SizedBox(height:20),
      GridView.count(crossAxisCount:3,shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),crossAxisSpacing:10,mainAxisSpacing:10,children:List.generate(5,(i)=>InkWell(
        onTap:pickPhoto,
        child:Container(height:110,decoration:BoxDecoration(color:Colors.grey.shade200,borderRadius:BorderRadius.circular(16)),child:Icon(i<photos?Icons.check_circle:Icons.add_a_photo,color:i<photos?Colors.green:Colors.grey,size:30)),
      ))),
    ]);
    return Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      _chips('Desires',desireOptions,desires,8),
      const SizedBox(height:20),
      const Text('Bio',style:TextStyle(fontWeight:FontWeight.bold,fontSize:18)),
      const SizedBox(height:8),
      TextField(maxLines:5,onChanged:(v)=>bio=v,decoration:const InputDecoration(hintText:'Tell people about you / us...',border:OutlineInputBorder())),
    ]);
  }

  Widget _choices(String title,List<String> xs,String selected,ValueChanged<String> onPick)=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Text(title,style:const TextStyle(fontSize:32,fontWeight:FontWeight.w900)),
    const SizedBox(height:8),const Text('Choose your profile type'),const SizedBox(height:22),
    ...xs.map((x)=>Padding(padding:const EdgeInsets.only(bottom:12),child:SizedBox(width:double.infinity,height:62,child:OutlinedButton(
      onPressed:()=>onPick(x),
      style:OutlinedButton.styleFrom(side:BorderSide(color:selected==x?restoredPrimary:Colors.grey,width:selected==x?2:1),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(17))),
      child:Row(children:[Icon(selected==x?Icons.radio_button_checked:Icons.radio_button_off,color:selected==x?restoredPrimary:Colors.grey),const SizedBox(width:12),Text(x)]),
    )))),
  ]);

  Widget _chips(String title,List<String> xs,Set<String> selected,int max)=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Text(title,style:const TextStyle(fontSize:30,fontWeight:FontWeight.w900)),
    const SizedBox(height:7),Text('Pick up to $max'),const SizedBox(height:18),
    Wrap(spacing:8,runSpacing:8,children:xs.map((x)=>FilterChip(
      label:Text(x),selected:selected.contains(x),
      onSelected:(v)=>setState(()=>v?(selected.length<max?selected.add(x):null):selected.remove(x)),
    )).toList()),
  ]);
}

class RestoredHome extends StatefulWidget {
  const RestoredHome({super.key});
  @override State<RestoredHome> createState()=>_RestoredHomeState();
}
class _RestoredHomeState extends State<RestoredHome>{
  int tab=0;
  @override Widget build(BuildContext c){
    final pages=<Widget>[const RestoredExplore(),const RestoredMatch(),const RestoredFeed(),const RestoredMessages(),const RestoredMe()];
    return Scaffold(
      body:IndexedStack(index:tab,children:pages),
      bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),destinations:const[
        NavigationDestination(icon:Icon(Icons.explore_outlined),selectedIcon:Icon(Icons.explore),label:'Explore'),
        NavigationDestination(icon:Icon(Icons.favorite_border),selectedIcon:Icon(Icons.favorite),label:'Match'),
        NavigationDestination(icon:Icon(Icons.dynamic_feed_outlined),selectedIcon:Icon(Icons.dynamic_feed),label:'Feed'),
        NavigationDestination(icon:Icon(Icons.chat_bubble_outline),selectedIcon:Icon(Icons.chat_bubble),label:'Chat'),
        NavigationDestination(icon:Icon(Icons.person_outline),selectedIcon:Icon(Icons.person),label:'Me'),
      ]),
    );
  }
}

class RestoredExplore extends StatefulWidget {
  const RestoredExplore({super.key});
  @override State<RestoredExplore> createState()=>_RestoredExploreState();
}
class _RestoredExploreState extends State<RestoredExplore>{
  bool mapOn=true; int mode=0;
  @override Widget build(BuildContext c)=>Scaffold(
    appBar:AppBar(title:const Text('Explore'),actions:[
      Row(mainAxisSize:MainAxisSize.min,children:[const Text('Map'),Switch(value:mapOn,activeColor:restoredPrimary,onChanged:(v)=>setState(()=>mapOn=v))]),
      IconButton(onPressed:()=>showModalBottomSheet(context:c,isScrollControlled:true,builder:(_)=>const _RestoredFilters()),icon:const Icon(Icons.tune)),
    ]),
    body:Column(children:[
      Padding(padding:const EdgeInsets.all(12),child:Row(children:[
        Expanded(child:_TabButton(text:'Map',selected:mode==0,onTap:()=>setState(()=>mode=0))),
        const SizedBox(width:8),
        Expanded(child:_TabButton(text:'City Search',selected:mode==1,onTap:()=>setState(()=>mode=1))),
      ])),
      if(mode==0 && mapOn) const Padding(padding:EdgeInsets.symmetric(horizontal:16,vertical:4),child:Row(children:[
        Text('12 people nearby',style:TextStyle(color:restoredPrimary,fontWeight:FontWeight.bold)),
        Spacer(),Text('Approx. locations',style:TextStyle(color:Colors.grey,fontSize:11)),
      ])),
      Expanded(child:mode==0 && mapOn?const RestoredMap():const RestoredCitySearch()),
    ]),
  );
}
class _TabButton extends StatelessWidget{
  final String text; final bool selected; final VoidCallback onTap;
  const _TabButton({required this.text,required this.selected,required this.onTap});
  @override Widget build(BuildContext c)=>InkWell(onTap:onTap,child:Container(alignment:Alignment.center,padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:selected?restoredPrimary:Colors.grey.shade200,borderRadius:BorderRadius.circular(24)),child:Text(text,style:TextStyle(color:selected?Colors.white:Colors.grey,fontWeight:FontWeight.bold))));
}
class _RestoredFilters extends StatefulWidget{const _RestoredFilters();@override State<_RestoredFilters>createState()=>_RestoredFiltersState();}
class _RestoredFiltersState extends State<_RestoredFilters>{
  RangeValues ages=const RangeValues(18,60); double distance=50;
  @override Widget build(BuildContext c)=>SafeArea(child:Padding(padding:const EdgeInsets.all(22),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[
    const Text('Filter Matches',style:TextStyle(fontSize:25,fontWeight:FontWeight.w900)),
    Text('Age Range ${ages.start.round()} – ${ages.end.round()}'),
    RangeSlider(values:ages,min:18,max:80,onChanged:(v)=>setState(()=>ages=v)),
    Text('Maximum Distance ${distance.round()} km'),
    Slider(value:distance,min:5,max:100,onChanged:(v)=>setState(()=>distance=v)),
    const SizedBox(height:8),const Text('Interests: Couples · Dating · Friends · Travel'),
    const SizedBox(height:16),SizedBox(width:double.infinity,child:FilledButton(onPressed:()=>Navigator.pop(c),child:const Text('Apply Filters'))),
  ])));
}

class RestoredCitySearch extends StatefulWidget{const RestoredCitySearch({super.key});@override State<RestoredCitySearch>createState()=>_RestoredCityState();}
class _RestoredCityState extends State<RestoredCitySearch>{
  String q='';
  @override Widget build(BuildContext c){
    final list=q.isEmpty?restoredProfiles:restoredProfiles.where((p)=>p.name.toLowerCase().contains(q.toLowerCase())||p.gender.toLowerCase().contains(q.toLowerCase())).toList();
    return Column(children:[
      Padding(padding:const EdgeInsets.fromLTRB(16,0,16,8),child:TextField(onChanged:(v)=>setState(()=>q=v),decoration:const InputDecoration(prefixIcon:Icon(Icons.search),hintText:'Search city e.g. Faridabad, Noida, Delhi',border:OutlineInputBorder()))),
      Padding(padding:const EdgeInsets.symmetric(horizontal:16,vertical:4),child:Row(children:[Text('${list.length} results',style:const TextStyle(fontWeight:FontWeight.bold)),const Spacer(),const Text('City / area',style:TextStyle(color:Colors.grey,fontSize:12))])),
      Expanded(child:GridView.builder(padding:const EdgeInsets.all(12),itemCount:list.length,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:10,mainAxisSpacing:10,childAspectRatio:.68),itemBuilder:(_,i)=>_ProfileGrid(profile:list[i]))),
    ]);
  }
}
class _ProfileGrid extends StatelessWidget{
  final RestoredProfileData profile; const _ProfileGrid({required this.profile});
  @override Widget build(BuildContext c)=>GestureDetector(onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>RestoredProfile(profile:profile))),child:ClipRRect(borderRadius:BorderRadius.circular(18),child:Stack(fit:StackFit.expand,children:[
    Image.network(profile.photo,fit:BoxFit.cover),
    const DecoratedBox(decoration:BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[Colors.transparent,Colors.black87]))),
    Positioned(left:10,right:10,bottom:10,child:Text('${profile.name}\n${profile.age} · ${profile.gender}',style:const TextStyle(color:Colors.white,fontWeight:FontWeight.bold))),
  ])));
}

class RestoredMap extends StatefulWidget{
  const RestoredMap({super.key});
  @override State<RestoredMap> createState()=>_RestoredMapState();
}
class _RestoredMapState extends State<RestoredMap>{
  LatLng center=const LatLng(28.4089,77.3178);
  @override void initState(){super.initState(); _locate();}
  Future<void> _locate() async {
    try {
      if(!await Geolocator.isLocationServiceEnabled()) return;
      var permission=await Geolocator.checkPermission();
      if(permission==LocationPermission.denied) permission=await Geolocator.requestPermission();
      if(permission==LocationPermission.always || permission==LocationPermission.whileInUse){
        final position=await Geolocator.getCurrentPosition();
        if(mounted) setState(()=>center=LatLng(position.latitude,position.longitude));
      }
    } catch (_) {}
  }
  @override Widget build(BuildContext c){
    final offsets=<LatLng>[
      const LatLng(.006,.004),const LatLng(-.004,.007),
      const LatLng(.008,-.006),const LatLng(-.007,-.004)
    ];
    final markers=List<Marker>.generate(restoredProfiles.length,(i){
      final p=restoredProfiles[i];
      return Marker(
        point:LatLng(center.latitude+offsets[i].latitude,center.longitude+offsets[i].longitude),
        width:110,height:92,
        child:GestureDetector(
          onTap:()=>showModalBottomSheet(context:c,builder:(_)=>_MapProfileCard(profile:p)),
          child:Column(mainAxisSize:MainAxisSize.min,children:[
            CircleAvatar(radius:27,backgroundImage:NetworkImage(p.photo)),
            Container(
              color:Colors.white,
              padding:const EdgeInsets.symmetric(horizontal:4,vertical:2),
              child:Text('${p.name} · ${10+i*7} km',style:const TextStyle(fontSize:9,fontWeight:FontWeight.bold)),
            ),
          ]),
        ),
      );
    });
    return FlutterMap(
      options:MapOptions(initialCenter:center,initialZoom:11.8),
      children:[
        TileLayer(urlTemplate:'https://tile.openstreetmap.org/{z}/{x}/{y}.png',userAgentPackageName:'com.aistudio.threetrio.jxhk'),
        MarkerLayer(markers:markers),
      ],
    );
  }
}
class _MapProfileCard extends StatelessWidget{
  final RestoredProfileData profile; const _MapProfileCard({required this.profile});
  @override Widget build(BuildContext c)=>SafeArea(child:Padding(padding:const EdgeInsets.all(16),child:Column(mainAxisSize:MainAxisSize.min,children:[
    Row(children:[CircleAvatar(radius:30,backgroundImage:NetworkImage(profile.photo)),const SizedBox(width:12),Expanded(child:Text('${profile.name} · ${profile.age}\n${profile.gender}',style:const TextStyle(fontSize:19,fontWeight:FontWeight.bold)))]),
    const SizedBox(height:10),Text(profile.bio),const SizedBox(height:10),
    FilledButton(onPressed:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>RestoredProfile(profile:profile))),child:const Text('View Profile')),
  ])));
}

class RestoredMatch extends StatefulWidget{const RestoredMatch({super.key});@override State<RestoredMatch>createState()=>_RestoredMatchState();}
class _RestoredMatchState extends State<RestoredMatch>{
  int index=0; double dx=0; final history=<int>[];
  void move(int direction){
    history.add(index);
    final p=restoredProfiles[index];
    setState(()=>{index=(index+1)%restoredProfiles.length,dx=0});
    if(direction>0) showDialog(context:context,builder:(_)=>AlertDialog(title:const Text("It's a Match! 💕"),content:CircleAvatar(radius:44,backgroundImage:NetworkImage(p.photo)),actions:[
      TextButton(onPressed:()=>Navigator.pop(context),child:const Text('Keep swiping')),
      FilledButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>RestoredChat(profile:p))),child:const Text('Message')),
    ]));
  }
  @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('Match')),body:GestureDetector(
    onHorizontalDragUpdate:(d)=>setState(()=>dx+=d.delta.dx),
    onHorizontalDragEnd:(_){if(dx.abs()>100)move(dx>0?1:-1);},
    child:Stack(alignment:Alignment.center,children:[
      _SwipeCard(profile:restoredProfiles[index],dx:dx),
      Positioned(bottom:16,child:Row(children:[
        _ActionButton(icon:Icons.undo,color:Colors.orange,onTap:()=>history.isNotEmpty?setState(()=>index=history.removeLast()):null),
        _ActionButton(icon:Icons.close,color:Colors.red,onTap:()=>move(-1)),
        _ActionButton(icon:Icons.bolt,color:Colors.orange,onTap:()=>_showMessage(c,'Ping','Ping this profile')),
        _ActionButton(icon:Icons.favorite,color:Colors.green,onTap:()=>move(1)),
      ])),
    ]),
  ));
}
class _SwipeCard extends StatelessWidget{
  final RestoredProfileData profile; final double dx;
  const _SwipeCard({required this.profile,required this.dx});
  @override Widget build(BuildContext c)=>Transform.translate(offset:Offset(dx*.2,0),child:Card(margin:const EdgeInsets.fromLTRB(14,18,14,90),clipBehavior:Clip.antiAlias,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(24)),child:Stack(fit:StackFit.expand,children:[
    Image.network(profile.photo,fit:BoxFit.cover),
    const DecoratedBox(decoration:BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[Colors.transparent,Colors.black87]))),
    Positioned(left:18,right:18,bottom:22,child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text('${profile.name}, ${profile.age}',style:const TextStyle(color:Colors.white,fontSize:27,fontWeight:FontWeight.w900)),
      Text('${profile.gender} · 10 km away',style:const TextStyle(color:Colors.white70)),
      Text(profile.bio,style:const TextStyle(color:Colors.white)),
      const Text('✦ AI Top Match',style:TextStyle(color:Colors.amber,fontWeight:FontWeight.bold)),
    ])),
  ])));
}
class _ActionButton extends StatelessWidget{
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton({required this.icon,required this.color,required this.onTap});
  @override
  Widget build(BuildContext c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey),
            color: Theme.of(c).cardColor,
          ),
          child: Icon(icon, color: color),
        ),
      ),
    );
  }
}

class RestoredMessages extends StatelessWidget{
  const RestoredMessages({super.key});
  @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('Chat')),body:ListView(children:[
    const Padding(padding:EdgeInsets.fromLTRB(18,14,18,8),child:Text('Matches',style:TextStyle(fontSize:21,fontWeight:FontWeight.w900))),
    SizedBox(height:105,child:ListView.separated(scrollDirection:Axis.horizontal,padding:const EdgeInsets.symmetric(horizontal:18),itemCount:restoredProfiles.length,separatorBuilder:(_,__)=>const SizedBox(width:12),itemBuilder:(_,i)=>GestureDetector(onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>RestoredChat(profile:restoredProfiles[i]))),child:Column(children:[CircleAvatar(radius:32,backgroundImage:NetworkImage(restoredProfiles[i].photo)),Text(restoredProfiles[i].name,style:const TextStyle(fontSize:10,fontWeight:FontWeight.bold))])))),
    const Padding(padding:EdgeInsets.fromLTRB(18,8,18,8),child:Text('Chats',style:TextStyle(fontSize:21,fontWeight:FontWeight.w900))),
    ...restoredProfiles.map((p)=>ListTile(leading:CircleAvatar(backgroundImage:NetworkImage(p.photo)),title:Text(p.name),subtitle:const Text('Matched · Protected chat'),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>RestoredChat(profile:p))))),
  ]));
}
class RestoredChat extends StatefulWidget{
  final RestoredProfileData profile; const RestoredChat({super.key,required this.profile});
  @override State<RestoredChat>createState()=>_RestoredChatState();
}
class _RestoredChatState extends State<RestoredChat>{
  final ctl=TextEditingController(); final msgs=<String>['Hey 👋','Hi, nice to meet you.'];
  @override void dispose(){ctl.dispose();super.dispose();}
  @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:Text(widget.profile.name),actions:[
    IconButton(onPressed:()=>_showMessage(c,'Audio call','Audio call opened.'),icon:const Icon(Icons.call)),
    IconButton(onPressed:()=>_showMessage(c,'Video call','Video call opened.'),icon:const Icon(Icons.videocam)),
  ]),body:Column(children:[
    Expanded(child:ListView.builder(itemCount:msgs.length,itemBuilder:(_,i)=>Align(alignment:i.isOdd?Alignment.centerRight:Alignment.centerLeft,child:Container(margin:const EdgeInsets.all(7),padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:i.isOdd?restoredPrimary:Colors.grey.shade200,borderRadius:BorderRadius.circular(17)),child:Text(msgs[i],style:TextStyle(color:i.isOdd?Colors.white:Colors.black)))))),
    SafeArea(child:Row(children:[Expanded(child:TextField(controller:ctl,decoration:const InputDecoration(hintText:'Message…'))),IconButton(onPressed:(){if(ctl.text.trim().isNotEmpty){setState((){msgs.add(ctl.text.trim());ctl.clear();});}},icon:const Icon(Icons.send))])),
  ]));
}

class RestoredProfile extends StatefulWidget{
  final RestoredProfileData profile; const RestoredProfile({super.key,required this.profile});
  @override State<RestoredProfile>createState()=>_RestoredProfileState();
}
class _RestoredProfileState extends State<RestoredProfile>{
  int page=0;
  @override Widget build(BuildContext c){
    final photos=<String>[widget.profile.photo,'https://images.unsplash.com/photo-1529333166437-7750a6dd5a70?w=1000','https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=1000'];
    return Scaffold(appBar:AppBar(title:const Text('Profile')),body:Column(children:[
      SizedBox(height:430,child:Stack(children:[
        PageView.builder(scrollDirection:Axis.vertical,itemCount:photos.length,onPageChanged:(v)=>setState(()=>page=v),itemBuilder:(_,i)=>Image.network(photos[i],fit:BoxFit.cover,width:double.infinity)),
        Positioned(top:14,right:14,child:Container(color:Colors.black54,padding:const EdgeInsets.all(7),child:Text('${page+1}/${photos.length}',style:const TextStyle(color:Colors.white)))),
        Positioned(bottom:14,left:14,right:14,child:Text('${widget.profile.name}, ${widget.profile.age}\n${widget.profile.gender} · 10 km away',style:const TextStyle(color:Colors.white,fontSize:26,fontWeight:FontWeight.w900))),
      ])),
      Expanded(child:ListView(padding:const EdgeInsets.all(18),children:[
        Text('${widget.profile.name}, ${widget.profile.age}',style:const TextStyle(fontSize:28,fontWeight:FontWeight.w900)),
        Wrap(spacing:7,children:widget.profile.interests.map((x)=>Chip(label:Text(x))).toList()),
        const SizedBox(height:12),
        _InfoCard(title:'Desires / Looking for',child:Wrap(spacing:7,children:['Women','Men','Couples (FM)','Couples (FF)','Couples (MM)','25–45'].map((x)=>Chip(label:Text(x))).toList())),
        const SizedBox(height:12),
        _InfoCard(title:'Basic Info',child:Column(children:[_infoRow('Gender',widget.profile.gender),_infoRow('Location','Delhi NCR'),_infoRow('Distance','10 km away'),_infoRow('Relationship status','Open to explore'),_infoRow('Education','No answer')])),
        const SizedBox(height:12),_InfoCard(title:'About Me / Us',child:Text(widget.profile.bio)),
        const SizedBox(height:18),
        Row(children:[Expanded(child:OutlinedButton(onPressed:()=>Navigator.pop(c),child:const Text('Pass'))),const SizedBox(width:8),Expanded(child:FilledButton(onPressed:()=>_showMessage(c,'Liked','Like sent.'),child:const Text('♥ Like')))]),
      ])),
    ]));
  }
}
Widget _infoRow(String a,String b)=>Padding(padding:const EdgeInsets.symmetric(vertical:6),child:Row(children:[Expanded(child:Text(a,style:const TextStyle(color:Colors.grey))),Expanded(child:Text(b,style:const TextStyle(fontWeight:FontWeight.bold)))]));
class _InfoCard extends StatelessWidget{final String title;final Widget child;const _InfoCard({required this.title,required this.child});@override Widget build(BuildContext c)=>Card(child:Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontSize:19,fontWeight:FontWeight.w900)),const SizedBox(height:10),child])));}

class RestoredFeed extends StatelessWidget{
  const RestoredFeed({super.key});
  @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('Feed'),actions:[IconButton(onPressed:()=>_showMessage(c,'Create Post','Photo, video, text and audio posts can be added here.'),icon:const Icon(Icons.add_box_outlined))]),body:ListView(padding:const EdgeInsets.all(14),children:[
    _FeedPost(profile:restoredProfiles[0],text:'Weekend vibes ✨ Looking for respectful new experiences.'),
    _FeedPost(profile:restoredProfiles[1],text:'Travel, music and good conversations.'),
  ]));
}
class _FeedPost extends StatelessWidget{
  final RestoredProfileData profile;final String text;const _FeedPost({required this.profile,required this.text});
  @override Widget build(BuildContext c)=>Card(margin:const EdgeInsets.only(bottom:14),clipBehavior:Clip.antiAlias,child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    ListTile(leading:CircleAvatar(backgroundImage:NetworkImage(profile.photo)),title:Text(profile.name,style:const TextStyle(fontWeight:FontWeight.bold)),subtitle:Text(profile.age)),
    Image.network(profile.photo,height:270,width:double.infinity,fit:BoxFit.cover),
    Padding(padding:const EdgeInsets.all(14),child:Text(text)),
    const ButtonBar(children:[Icon(Icons.favorite_border),Icon(Icons.mode_comment_outlined),Icon(Icons.share_outlined)]),
  ]));
}
class RestoredMe extends StatelessWidget{
  const RestoredMe({super.key});
  @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('Me'),actions:[IconButton(onPressed:()=>_showMessage(c,'Settings','Theme, account, privacy and notifications.'),icon:const Icon(Icons.settings_outlined))]),body:ListView(padding:const EdgeInsets.all(18),children:[
    const SizedBox(height:12),const CircleAvatar(radius:52,child:Icon(Icons.person,size:55)),const SizedBox(height:12),
    const Center(child:Text('Your 3TRIO profile',style:TextStyle(fontSize:22,fontWeight:FontWeight.w900))),
    const SizedBox(height:20),
    const ListTile(leading:Icon(Icons.verified_user_outlined),title:Text('Verification'),subtitle:Text('Photo / ID / voice verification')),
    const ListTile(leading:Icon(Icons.workspace_premium_outlined),title:Text('Premium'),subtitle:Text('Manage premium features')),
    const ListTile(leading:Icon(Icons.block_outlined),title:Text('Blocked users'),subtitle:Text('Manage blocked profiles')),
  ]));
}
void _showMessage(BuildContext c,String title,String msg)=>showModalBottomSheet(context:c,builder:(_)=>SafeArea(child:Padding(padding:const EdgeInsets.all(22),child:Column(mainAxisSize:MainAxisSize.min,children:[Text(title,style:const TextStyle(fontSize:22,fontWeight:FontWeight.w900)),const SizedBox(height:10),Text(msg),const SizedBox(height:18),FilledButton(onPressed:()=>Navigator.pop(c),child:const Text('Close'))]))));
