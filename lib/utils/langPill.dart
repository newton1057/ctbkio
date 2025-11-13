import 'package:ctbkio/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LangPill extends StatelessWidget {
  final bool padded;
  const LangPill({this.padded = true, super.key});

  static const _border = Color(0xFFE4E7EC);
  static const _text = Color(0xFF101828);

  @override
  Widget build(BuildContext context) {
    final state = KioScope.of(context);
    final current = state.lang;

    return GestureDetector(
      onTap: () => _openLanguageDialog(context),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 16,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _FlagDot(
                flag: current == Language.en ? '🇺🇸' : '🇲🇽',
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                current == Language.en ? 'EN' : 'ES',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openLanguageDialog(BuildContext context) async {
    final state = KioScope.of(context);
    final current = state.lang;

    await showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, c) {
                final isWide = c.maxWidth >= 560;
                final englishCard = _LanguageCard(
                  title: 'English',
                  code: 'EN',
                  flag: '🇺🇸',
                  selected: current == Language.en,
                  onTap: () {
                    state.lang = Language.en;
                    Navigator.pop(context);
                  },
                );

                final spanishCard = _LanguageCard(
                  title: 'Español',
                  code: 'ES',
                  flag: '🇲🇽',
                  selected: current == Language.es,
                  onTap: () {
                    state.lang = Language.es;
                    Navigator.pop(context);
                  },
                );
                return isWide
                    ? Row(
                        children: [
                          Expanded(child: englishCard),
                          const SizedBox(width: 16),
                          Expanded(child: spanishCard),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          englishCard,
                          const SizedBox(height: 12),
                          spanishCard,
                        ],
                      );
              },
            ),
          ),
        );
      },
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String title;
  final String code;
  final String flag;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.title,
    required this.code,
    required this.flag,
    required this.selected,
    required this.onTap,
  });

  static const _border = Color(0xFFE4E7EC);
  static const _text = Color(0xFF101828);
  static const _muted = Color(0xFF667085);
  static const _primary = Color(0xFF175CD3);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? _primary.withOpacity(0.35) : _border,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              _FlagDot(flag: flag, size: 48),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _text,
                      ),
                    ),
                    Text(
                      code,
                      style: GoogleFonts.inter(fontSize: 14, color: _muted),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? _primary.withOpacity(0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: selected ? _primary : _border),
                ),
                child: Row(
                  children: [
                    Icon(
                      selected
                          ? Icons.check_rounded
                          : Icons.arrow_forward_rounded,
                      size: 18,
                      color: selected ? _primary : _muted,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlagDot extends StatelessWidget {
  final String flag;
  final double size;
  const _FlagDot({required this.flag, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      child: Text(flag, style: TextStyle(fontSize: size * 0.75)),
    );
  }
}
