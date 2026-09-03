import 'package:flutter/material.dart';

/// Phase 1 profile architecture: complete profile sections while keeping
/// sensitive/private content out of public discovery by explicit visibility.
class TrioProfileDetailPage extends StatefulWidget {
  final String name;
  const TrioProfileDetailPage({super.key, required this.name});
  @override State<TrioProfileDetailPage> createState() => _TrioProfileDetailPageState();
}

class _TrioProfileDetailPageState extends State<TrioProfileDetailPage> {
  bool revealBio = false;
  bool fantasyPrivate = true;
  @override Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF07080C),
    appBar: AppBar(title: Text(widget.name), backgroundColor: Colors.transparent),
    body: ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 32), children: [
      Container(height: 420, decoration: BoxDecoration(borderRadius: BorderRadius.circular(28), image: const DecorationImage(
        image: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=1000'), fit: BoxFit.cover))),
      const SizedBox(height: 16),
      Row(children: [Text('${widget.name}, 28', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)), const SizedBox(width: 8), const Icon(Icons.verified, color: Color(0xFFE5485D))]),
      const SizedBox(height: 5),
      const Text('Delhi · approximate distance only  •  She/Her', style: TextStyle(color: Colors.white60)),
      const SizedBox(height: 18),
      const Wrap(spacing: 7, runSpacing: 7, children: [Chip(label: Text('Open-minded')), Chip(label: Text('Dating')), Chip(label: Text('Travel')), Chip(label: Text('Music'))]),
      const SizedBox(height: 22),
      const Text('What I’m looking for', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      const SizedBox(height: 7),
      const Text('Genuine chemistry, respectful conversation and people who are clear about what they want.', style: TextStyle(color: Colors.white70, height: 1.45)),
      const SizedBox(height: 22),
      Row(children: [const Expanded(child: Text('Hidden bio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
        TextButton(onPressed: () => setState(() => revealBio = !revealBio), child: Text(revealBio ? 'Hide' : 'Reveal'))]),
      const SizedBox(height: 7),
      AnimatedContainer(duration: const Duration(milliseconds: 180), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFF11131A), borderRadius: BorderRadius.circular(18)), child: Text(
        revealBio ? 'This private bio is visible only under the member’s chosen reveal condition.' : '••••••••••••••••••••••', style: TextStyle(color: revealBio ? Colors.white70 : Colors.white30, height: 1.4))),
      const SizedBox(height: 22),
      const Text('Desires', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      const Wrap(spacing: 7, children: [Chip(label: Text('Connections')), Chip(label: Text('Curious')), Chip(label: Text('Dating'))]),
      const SizedBox(height: 22),
      const Text('Interests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      const Wrap(spacing: 7, children: [Chip(label: Text('Rooftops')), Chip(label: Text('Fitness')), Chip(label: Text('Events'))]),
      const SizedBox(height: 22),
      Row(children: [const Expanded(child: Text('Fantasy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700))), Switch(value: fantasyPrivate, onChanged: (v) => setState(() => fantasyPrivate = v))]),
      Text(fantasyPrivate ? 'Private' : 'Connections only', style: const TextStyle(color: Colors.white54)),
      const SizedBox(height: 24),
      Row(children: [Expanded(child: FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.favorite), label: const Text('Like'))), const SizedBox(width: 10), Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.bolt), label: const Text('Ping')))])
    ]),
  );
}

class TrioVerificationFlowPage extends StatefulWidget {
  const TrioVerificationFlowPage({super.key});
  @override State<TrioVerificationFlowPage> createState() => _TrioVerificationFlowPageState();
}
class _TrioVerificationFlowPageState extends State<TrioVerificationFlowPage> {
  int step = 0;
  final labels = const ['Photo', 'Government ID', 'Voice'];
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Required verification')),
    body: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Step ${step + 1} of 3', style: const TextStyle(color: Colors.white54)),
      const SizedBox(height: 10),
      LinearProgressIndicator(value: (step + 1) / 3, minHeight: 4),
      const SizedBox(height: 28),
      Icon([Icons.camera_alt_outlined, Icons.badge_outlined, Icons.mic_none_outlined][step], size: 52),
      const SizedBox(height: 18),
      Text('${labels[step]} verification', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      Text(step == 0 ? 'Take a live selfie inside 3TRIO.' : step == 1 ? 'Submit a government ID securely. It is never public.' : 'Record your verification voice clip inside 3TRIO. Arbitrary audio uploads are not accepted.', style: const TextStyle(color: Colors.white65, height: 1.45)),
      const Spacer(),
      SizedBox(width: double.infinity, child: FilledButton(onPressed: () {
        if (step < 2) setState(() => step++); else Navigator.pop(context);
      }, child: Text(step < 2 ? 'Continue' : 'Submit for review'))),
    ])),
  );
}
