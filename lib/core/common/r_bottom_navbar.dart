import 'package:cr_app/core/constants/colors.dart';
import 'package:cr_app/features/home/presentation/views/home_screen.dart';
import 'package:cr_app/features/notice/presentation/views/notice_screen.dart';
import 'package:cr_app/features/settings/presentation/views/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


// ── REFACTORED TO STATEFUL WIDGET TO MANAGE ACTIVE INDEX STATE NATIVELY ──
class MainScreen  extends StatefulWidget {
  final int initialIndex;
  const MainScreen ({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // CORE STATE ENGINE INDEX FOR TRACKING MAIN VIEWPORTS
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  // READ-ONLY STATIC COMPONENT STACK CONTAINING SCENE DESTINATIONS
  final List<Widget> _screens = const [
    HomeScreen(),
    NoticeScreen(),
    SettingsScreen(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── FIXED BODY VIEWPORT SWITCH ENGINE utilization INDEXED-STACK ──
      // IT PRESERVES SCROLL POSITIONS AND STATES ACROSS ALL ACTIVE TABS
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // ── PERSISTENT SYSTEM NAVIGATION OVERLAY BAR ──
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 14),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
              bottomLeft: Radius.circular(50)
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.white.withValues(alpha: 0.8),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: UColors.primary,
              unselectedItemColor: UColors.darkerGrey,
              currentIndex: _currentIndex, // BINDS ACTIVE INDEX TO RE-RENDER NAV ITEMS STATE
              onTap: (index) {
                setState(() {
                  _currentIndex = index; // STATE MUTATION TRIGGERS ONLY LOCAL FLUSH RENDER
                });
              },
              items: [
                const BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.house),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_active),
                  label: 'Notice',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: "Settings",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}