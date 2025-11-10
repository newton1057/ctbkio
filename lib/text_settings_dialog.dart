import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Resultado del diálogo
class TextSettingsResult {
  final double fontSize;        // en puntos (px lógicos)
  final FontWeight fontWeight;  // weight Flutter (w100..w900)
  const TextSettingsResult({required this.fontSize, required this.fontWeight});
}

/// Muestra el modal centrado con sliders de tamaño y peso.
Future<TextSettingsResult?> showTextSettingsDialog(
  BuildContext context, {
  double initialFontSize = 16,
  int initialFontWeight = 600, // 100..900
}) {
  return showDialog<TextSettingsResult>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.35),
    builder: (_) => _TextSettingsDialog(
      initialFontSize: initialFontSize.clamp(10, 28),
      initialFontWeight: initialFontWeight.clamp(100, 900),
    ),
  );
}

class _TextSettingsDialog extends StatefulWidget {
  final double initialFontSize;
  final int initialFontWeight;
  const _TextSettingsDialog({
    required this.initialFontSize,
    required this.initialFontWeight,
  });

  @override
  State<_TextSettingsDialog> createState() => _TextSettingsDialogState();
}

class _TextSettingsDialogState extends State<_TextSettingsDialog> {
  late double _size;   // 10–28 (puedes ajustar rangos)
  late double _w;      // 100–900 (como double para Slider)

  @override
  void initState() {
    super.initState();
    _size = widget.initialFontSize;
    _w = widget.initialFontWeight.toDouble();
  }

  FontWeight get _weight => _fontWeightFromNum(_w.round());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.transparent, // para poder “flotar” el close
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Card principal
          Container(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 28,
                  color: Color(0x33000000),
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título
                Text(
                  'Text Settings',
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose the font size and weight\nthat feels best for your eyes.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.68),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),

                // ===== SIZE =====
                _SectionLabel('Size'),
                const SizedBox(height: 4),
                _SliderRow(
                  leftPreview: _preview('Aa', 14, FontWeight.w400),
                  rightPreview: _preview('Aa', 24, FontWeight.w700),
                  slider: Slider.adaptive(
                    value: _size,
                    min: 10,
                    max: 28,
                    divisions: 18,
                    label: _size.toStringAsFixed(0),
                    onChanged: (v) => setState(() => _size = v),
                  ),
                ),
                const SizedBox(height: 16),

                // ===== WEIGHT =====
                _SectionLabel('Weight'),
                const SizedBox(height: 4),
                _SliderRow(
                  leftPreview: _preview('Aa', 18, FontWeight.w300),
                  rightPreview: _preview('Aa', 18, FontWeight.w900),
                  slider: Slider.adaptive(
                    value: _w,
                    min: 100,
                    max: 900,
                    divisions: 8, // pasos de 100
                    label: _w.round().toString(),
                    onChanged: (v) => setState(() => _w = v),
                  ),
                ),

                const SizedBox(height: 24),
                // Botón Done
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(TextSettingsResult(
                        fontSize: _size,
                        fontWeight: _weight,
                      ));
                    },
                    child: Text(
                      'Done',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Botón Close flotante
          Positioned(
            top: -20,
            left: 0,
            right: 0,
            child: Center(
              child: Semantics(
                button: true,
                label: 'Close text settings',
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.close, size: 22),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _preview(String t, double size, FontWeight w) => Text(
        t,
        style: GoogleFonts.inter(fontSize: size, fontWeight: w),
      );
}

/// Etiqueta de sección (“Size”, “Weight”)
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black.withOpacity(0.8),
      ),
    );
  }
}

/// Fila con previas izquierda/derecha y el Slider en medio
class _SliderRow extends StatelessWidget {
  final Widget leftPreview;
  final Widget rightPreview;
  final Widget slider;
  const _SliderRow({
    required this.leftPreview,
    required this.rightPreview,
    required this.slider,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 44, child: Center(child: leftPreview)),
        Expanded(child: slider),
        SizedBox(width: 44, child: Center(child: rightPreview)),
      ],
    );
  }
}

/// Map de 100..900 → FontWeight
FontWeight _fontWeightFromNum(int n) {
  switch (n) {
    case 100:
      return FontWeight.w100;
    case 200:
      return FontWeight.w200;
    case 300:
      return FontWeight.w300;
    case 400:
      return FontWeight.w400;
    case 500:
      return FontWeight.w500;
    case 600:
      return FontWeight.w600;
    case 700:
      return FontWeight.w700;
    case 800:
      return FontWeight.w800;
    case 900:
      return FontWeight.w900;
    default:
      return FontWeight.w600;
  }
}