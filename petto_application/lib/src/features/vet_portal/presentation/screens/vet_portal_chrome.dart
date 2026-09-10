part of 'vet_portal_screen.dart';

class _VetUi {
  static const surface = Color(0xFFFFFCF8);
  static const cream = Color(0xFFFFF4EA);
  static const blush = Color(0xFFFFECE8);
  static const gold = Color(0xFFD3A33B);
  static final border = AppTheme.primaryColor.withValues(alpha: 0.13);
  static final softShadow = AppTheme.primaryColor.withValues(alpha: 0.06);
}

extension on _VetSection {
  String get label => switch (this) {
    _VetSection.dashboard => 'Dashboard',
    _VetSection.patients => 'Patients',
    _VetSection.messages => 'Messages',
    _VetSection.profile => 'Profile',
  };

  IconData get icon => switch (this) {
    _VetSection.dashboard => Icons.space_dashboard_rounded,
    _VetSection.patients => Icons.pets_rounded,
    _VetSection.messages => Icons.forum_rounded,
    _VetSection.profile => Icons.person_rounded,
  };
}

class _VetBackground extends StatelessWidget {
  const _VetBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DotPainter(),
      child: const ColoredBox(color: AppTheme.backgroundColor),
    );
  }
}

class _DotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor.withValues(alpha: 0.035);
    for (double y = 22; y < size.height; y += 36) {
      for (double x = 22; x < size.width; x += 36) {
        canvas.drawCircle(Offset(x, y), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _VetSidebar extends StatelessWidget {
  const _VetSidebar({
    required this.section,
    required this.vetName,
    required this.onSelect,
    required this.onLogout,
  });

  final _VetSection section;
  final String vetName;
  final ValueChanged<_VetSection> onSelect;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 246,
      margin: const EdgeInsets.all(18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _ClinicLogo(),
          const SizedBox(height: 28),
          for (final item in _VetSection.values)
            _SideNavItem(
              item: item,
              selected: item == section,
              onTap: () => onSelect(item),
            ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                const _InitialBadge(initial: 'S', light: true),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vetName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Text(
                        'Veterinarian',
                        style: TextStyle(
                          color: Color(0xFFE8CBCD),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Log out'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClinicLogo extends StatelessWidget {
  const _ClinicLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
          ),
          child: const Icon(
            Icons.favorite_rounded,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PETTO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                fontFamily: AppTheme.displayFontFamily,
              ),
            ),
            Text(
              'CLINICAL',
              style: TextStyle(
                color: Color(0xFFE8CBCD),
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SideNavItem extends StatelessWidget {
  const _SideNavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _VetSection item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Icon(
                item.icon,
                color: selected ? AppTheme.primaryColor : Colors.white,
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                item.label,
                style: TextStyle(
                  color: selected ? AppTheme.primaryColor : Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileHeader extends StatelessWidget {
  const _MobileHeader({
    required this.section,
    required this.vetName,
    required this.onLogout,
  });

  final _VetSection section;
  final String vetName;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
      child: _Panel(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            _TintIcon(icon: section.icon, filled: true, compact: true),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.label,
                    style: const TextStyle(
                      color: AppTheme.secondaryText,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      fontFamily: AppTheme.displayFontFamily,
                    ),
                  ),
                  Text(
                    vetName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppTheme.mutedText,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              tooltip: 'Log out',
              onPressed: onLogout,
              icon: const Icon(Icons.logout_rounded),
              color: AppTheme.primaryColor,
              style: IconButton.styleFrom(
                backgroundColor: _VetUi.blush,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VetBottomNav extends StatelessWidget {
  const _VetBottomNav({required this.section, required this.onSelect});

  final _VetSection section;
  final ValueChanged<_VetSection> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 7, 16, 12),
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: _VetUi.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: _VetUi.border),
        boxShadow: [
          BoxShadow(
            color: _VetUi.softShadow,
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          for (final item in _VetSection.values)
            Expanded(
              child: _BottomItem(
                item: item,
                selected: item == section,
                onTap: () => onSelect(item),
              ),
            ),
        ],
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _VetSection item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(19),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              color: selected ? Colors.white : AppTheme.mutedText,
              size: 21,
            ),
            const SizedBox(height: 3),
            FittedBox(
              child: Text(
                item.label,
                style: TextStyle(
                  color: selected ? Colors.white : AppTheme.mutedText,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
