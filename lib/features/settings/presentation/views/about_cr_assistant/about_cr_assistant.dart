import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutCrAssistant extends StatelessWidget {
  const AboutCrAssistant({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),

            // ------------------ Developer profile picture ------------------
            // Replace this CircleAvatar's child with:
            // CircleAvatar(radius: 60, backgroundImage: AssetImage('assets/images/rifat.jpg'))
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: const CircleAvatar(
                radius: 56,
                backgroundColor: Color(0xFF1A1A1A),
                backgroundImage: AssetImage("assets/images/rafsan_profile.jpg"),
              ),
            ),
            const SizedBox(height: 16),

            Text('Rafsanul Rifat', style: tt.headlineSmall),
            const SizedBox(height: 4),
            Text(
              'Full-Stack Developer',
              style: tt.bodyMedium?.copyWith(color: Colors.blue),
            ),
            const SizedBox(height: 24),

            // ------------------ Info card ------------------
            _InfoCard(
              children: [
                _InfoRow(icon: Icons.school_outlined, label: 'University', value: 'Dhaka International University'),
                _InfoRow(icon: Icons.code_outlined, label: 'Department', value: 'CSE'),
                _InfoRow(icon: Icons.security_outlined, label: 'Interested in', value: 'Cybersecurity'),
              ],
            ),
            const SizedBox(height: 20),

            // ------------------ Bio ------------------
            _SectionCard(
              title: 'About the developer',
              child: Text(
                'I build full-stack apps and websites — currently studying '
                    'Computer Science and exploring cybersecurity as my next '
                    'area of focus. This app was built to make life easier for '
                    'CRs and classmates alike.',
                style: tt.bodyMedium?.copyWith(height: 1.5),
              ),
            ),
            const SizedBox(height: 20),

            // ------------------ About the app ------------------
            _SectionCard(
              title: 'About CR Assistant',
              child: Text(
                'CR Assistant helps class representatives share notes, class '
                    'PDFs, and notices with their batch — and lets students '
                    'chat with an AI assistant to instantly find the resources '
                    'they need.',
                style: tt.bodyMedium?.copyWith(height: 1.5),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Version 1.0.0',
              style: tt.bodySmall?.copyWith(color: Colors.white38),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

// ------------------ Reusable pieces ------------------

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 14)),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.white, fontSize: 14.spMin, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}