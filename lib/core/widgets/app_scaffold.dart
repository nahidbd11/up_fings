import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import 'role_chip.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final AppUser user;
  final Widget body;
  final Widget? floatingActionButton;
  final List<NavigationItem> navItems;
  final int currentNavIndex;
  final ValueChanged<int>? onNavChanged;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;

  const AppScaffold({
    super.key,
    required this.title,
    this.subtitle,
    required this.user,
    required this.body,
    this.floatingActionButton,
    this.navItems = const [],
    this.currentNavIndex = 0,
    this.onNavChanged,
    this.actions,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop() || context.canPop();
    final hasDrawer = navItems.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: hasDrawer
            ? null // drawer hamburger is shown automatically
            : canPop
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        Navigator.of(context).maybePop();
                      }
                    },
                  )
                : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 15)),
            if (subtitle != null)
              Text(
                subtitle!,
                style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight, fontWeight: FontWeight.w400),
              ),
          ],
        ),
        actions: [
          if (user.notificationCount > 0)
            Stack(
              children: [
                IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                    child: Text(
                      '${user.notificationCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ...?actions,
          const SizedBox(width: 4),
        ],
      ),
      drawer: hasDrawer ? _AppDrawer(user: user, navItems: navItems, currentIndex: currentNavIndex, onItemTapped: onNavChanged) : null,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}

class _AppDrawer extends StatelessWidget {
  final AppUser user;
  final List<NavigationItem> navItems;
  final int currentIndex;
  final ValueChanged<int>? onItemTapped;

  const _AppDrawer({
    required this.user,
    required this.navItems,
    required this.currentIndex,
    this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _DrawerHeader(user: user),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isActive = index == currentIndex;
                return ListTile(
                  leading: Icon(
                    isActive ? item.activeIcon : item.icon,
                    color: isActive ? AppColors.primary : AppColors.textLight,
                    size: 22,
                  ),
                  title: Text(
                    item.label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  tileColor: isActive ? AppColors.primaryLight : null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  onTap: () {
                    Navigator.pop(context);
                    onItemTapped?.call(index);
                    context.go(item.route);
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.textLight, size: 20),
            title: Text(
              'Logout / লগআউট',
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.textLight),
            ),
            onTap: () {
              Navigator.pop(context);
              context.go('/');
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  final AppUser user;

  const _DrawerHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: Text(
                  user.initials,
                  style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.designation,
                      style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'UP@Fingertips',
            style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 0.2),
          ),
          Text(
            'Digital Union Parishad System',
            style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.7), fontSize: 11),
          ),
          const SizedBox(height: 10),
          RoleChip(role: user.role),
        ],
      ),
    );
  }
}
