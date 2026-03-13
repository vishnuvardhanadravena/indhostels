import 'package:flutter/material.dart';

class ConfirmationPopup extends StatelessWidget {
  final String illustrationAsset;
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color confirmColor;
  final Color cancelTextColor;
  final bool loading;

  const ConfirmationPopup({
    super.key,
    required this.illustrationAsset,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.confirmColor = const Color(0xFF5A47D1),
    this.cancelTextColor = const Color(0xFF9E9E9E),
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: _PopupCard(
        illustrationAsset: illustrationAsset,
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmColor: confirmColor,
        cancelTextColor: cancelTextColor,
        loading: loading,
      ),
    );
  }
}

class _PopupCard extends StatelessWidget {
  final String illustrationAsset;
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color confirmColor;
  final Color cancelTextColor;
  final loading;

  const _PopupCard({
    required this.illustrationAsset,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    this.onConfirm,
    this.onCancel,
    required this.confirmColor,
    required this.cancelTextColor,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _IllustrationSection(assetPath: illustrationAsset),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E1E2D),
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7A7A9D),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // ── Divider ────────────────────────────────────────────────
          Divider(color: Colors.grey.shade100, height: 1),

          // ── Action buttons ─────────────────────────────────────────
          _ActionButtons(
            cancelLabel: cancelLabel,
            confirmLabel: confirmLabel,
            onCancel: onCancel,
            onConfirm: onConfirm,
            confirmColor: confirmColor,
            cancelTextColor: cancelTextColor,
            loading: loading,
          ),
        ],
      ),
    );
  }
}

class _IllustrationSection extends StatelessWidget {
  final String assetPath;

  const _IllustrationSection({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(0),
      decoration: const BoxDecoration(
        color: Color(0xFFF6F6FF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // child: CustomPaint(
      // painter: _DashedBorderPainter(),
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Image.asset(assetPath, height: 200, fit: BoxFit.contain),
      ),
      // ),[]
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final String cancelLabel;
  final String confirmLabel;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final Color confirmColor;
  final Color cancelTextColor;
  final bool loading;

  const _ActionButtons({
    required this.cancelLabel,
    required this.confirmLabel,
    this.onCancel,
    this.onConfirm,
    required this.confirmColor,
    required this.cancelTextColor,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel ?? () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: cancelTextColor,
                side: BorderSide(color: Colors.grey.shade200),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                cancelLabel,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: cancelTextColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: confirmColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: loading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      confirmLabel,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
