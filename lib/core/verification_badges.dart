import 'package:flutter/material.dart';

class VerificationBadges extends StatelessWidget {
  final bool photoVerified;
  final bool idVerified;
  final bool voiceVerified;
  const VerificationBadges({super.key, this.photoVerified = false, this.idVerified = false, this.voiceVerified = false});
  @override
  Widget build(BuildContext context) => Wrap(spacing: 6, runSpacing: 6, children: [
    if (photoVerified) const _Badge('Photo verified', Icons.camera_alt_outlined),
    if (idVerified) const _Badge('ID verified', Icons.badge_outlined),
    if (voiceVerified) const _Badge('Voice verified', Icons.mic_outlined),
  ]);
}
class _Badge extends StatelessWidget {
  final String label; final IconData icon;
  const _Badge(this.label, this.icon);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white24)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 14), const SizedBox(width: 5), Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600))]));
}
