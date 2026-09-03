import 'package:flutter/material.dart';

enum VerificationStep { photo, governmentId, voice, complete }

class VerificationFlow extends StatefulWidget {
  const VerificationFlow({super.key});
  @override State<VerificationFlow> createState() => _VerificationFlowState();
}

class _VerificationFlowState extends State<VerificationFlow> {
  VerificationStep step = VerificationStep.photo;
  bool recording = false;
  int seconds = 0;
  final statuses = <String, String>{'Photo verification': 'Required', 'Government ID': 'Required', 'Voice verification': 'Required'};

  void next() => setState(() {
    if (step == VerificationStep.photo) { statuses['Photo verification'] = 'Pending'; step = VerificationStep.governmentId; }
    else if (step == VerificationStep.governmentId) { statuses['Government ID'] = 'Pending'; step = VerificationStep.voice; }
    else if (step == VerificationStep.voice) { statuses['Voice verification'] = 'Pending'; step = VerificationStep.complete; }
  });

  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Verification')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      const Text('All three checks are required', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
      const SizedBox(height: 8), const Text('Your ID and verification media stay private and are never shown on your public profile.', style: TextStyle(color: Colors.white60)),
      const SizedBox(height: 22),
      for (final entry in statuses.entries) ListTile(leading: Icon(entry.value == 'Pending' ? Icons.hourglass_top : Icons.verified_user_outlined), title: Text(entry.key), trailing: Text(entry.value, style: const TextStyle(color: Colors.white60))),
      const Divider(height: 28),
      if (step == VerificationStep.photo) _action('Photo verification', 'Use a live selfie. Gallery uploads are not accepted.', Icons.camera_front_outlined, next),
      if (step == VerificationStep.governmentId) _action('Government ID', 'Capture the requested government ID securely.', Icons.badge_outlined, next),
      if (step == VerificationStep.voice) _voiceStep(),
      if (step == VerificationStep.complete) const Padding(padding: EdgeInsets.only(top: 30), child: Column(children: [Icon(Icons.check_circle_outline, size: 64, color: Colors.greenAccent), SizedBox(height: 14), Text('Submitted for review', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)), SizedBox(height: 8), Text('Verification remains pending until approved.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white60))]))
    ]));

  Widget _action(String title, String text, IconData icon, VoidCallback onTap) => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF11131A), borderRadius: BorderRadius.circular(24)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, size: 34), const SizedBox(height: 12), Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700)), const SizedBox(height: 6), Text(text, style: const TextStyle(color: Colors.white60)), const SizedBox(height: 18), FilledButton(onPressed: onTap, child: const Text('Continue'))]));

  Widget _voiceStep() => _action('Voice verification', recording ? 'Recording inside 3TRIO… ${seconds}s' : 'Record your verification phrase inside the app. Audio uploads are not accepted.', recording ? Icons.mic : Icons.mic_none, () {
    if (!recording) { setState(() { recording = true; seconds = 1; }); Future.delayed(const Duration(seconds: 2), () { if (mounted && recording) setState(() => seconds = 3); }); }
    else { next(); }
  });
}
