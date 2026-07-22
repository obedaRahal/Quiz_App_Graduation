import 'package:flutter/material.dart';

class UserSearchResultCard extends StatelessWidget {
  final int userId;
  final String name;
  final String avatarUrl;
  final String academicLevel;
  final bool isAcademicallyVerified;
  final bool viewerIsFollowing;
  final VoidCallback onTap;
  final VoidCallback onFollowTap;

  const UserSearchResultCard({
    super.key,
    required this.userId,
    required this.name,
    required this.avatarUrl,
    required this.academicLevel,
    required this.isAcademicallyVerified,
    required this.viewerIsFollowing,
    required this.onTap,
    required this.onFollowTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _UserAvatar(avatarUrl: avatarUrl),
            const SizedBox(width: 12),
            Expanded(
              child: _UserInformation(
                name: name,
                academicLevel: academicLevel,
                isAcademicallyVerified: isAcademicallyVerified,
              ),
            ),
            const SizedBox(width: 10),
            _FollowButton(
              isFollowing: viewerIsFollowing,
              onTap: onFollowTap,
              isDark: isDark,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String avatarUrl;

  const _UserAvatar({required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: ClipOval(
        child: Image.network(
          avatarUrl,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.person_outline, size: 30);
          },
        ),
      ),
    );
  }
}

class _UserInformation extends StatelessWidget {
  final String name;
  final String academicLevel;
  final bool isAcademicallyVerified;

  const _UserInformation({
    required this.name,
    required this.academicLevel,
    required this.isAcademicallyVerified,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.rtl,
          children: [
            Flexible(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (isAcademicallyVerified) ...[
              const SizedBox(width: 4),
              Icon(Icons.verified, size: 16, color: colorScheme.primary),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            academicLevel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _FollowButton extends StatelessWidget {
  final bool isFollowing;
  final VoidCallback onTap;
  final bool isDark;
  final ColorScheme colorScheme;

  const _FollowButton({
    required this.isFollowing,
    required this.onTap,
    required this.isDark,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 17),
          backgroundColor: isFollowing
              ? colorScheme.surfaceContainerHighest
              : colorScheme.primary,
          foregroundColor: isFollowing
              ? colorScheme.onSurface
              : colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          isFollowing ? 'متابَع' : 'متابعة',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
