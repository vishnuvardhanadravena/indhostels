import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indhostels/bloc/support/support_bloc.dart';
import 'package:indhostels/pages/profile/profile.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bookingIdCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  static const _kPrimary = Color(0xFF4B3EFF);
  static const _kFieldBg = Color(0xFFF5F5F5);

  static const _categories = [
    'Booking Issue',
    'Payment Help',
    'Room Issue',
    'General Question',
  ];

  @override
  void dispose() {
    _bookingIdCtrl.dispose();
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    );
    if (!mounted) return;
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (file.path != null) {
        context.read<SupportBloc>().add(
          SupportAttachmentPicked(path: file.path!, name: file.name),
        );
      }
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<SupportBloc>().add(
        SupportSubmitRequested(
          bookingId: _bookingIdCtrl.text.trim(),
          subject: _subjectCtrl.text.trim(),
          message: _messageCtrl.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final r = R(w);

    return BlocListener<SupportBloc, SupportState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Ticket created successfully, will be resolved soon',
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(context).pop();
        } else if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: r.backIconSize),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Help & Support',
            style: TextStyle(
              fontSize: r.titleFontSize,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: r.isTablet ? _buildTabletBody(r) : _buildMobileBody(r),
        ),
      ),
    );
  }

  // ── Tablet: centered max-width container ─────────────────────────────────
  Widget _buildTabletBody(R r) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: _buildScrollContent(r),
      ),
    );
  }

  // ── Mobile: full width ────────────────────────────────────────────────────
  Widget _buildMobileBody(R r) => _buildScrollContent(r);

  Widget _buildScrollContent(R r) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: r.screenPadH,
        vertical: r.screenPadV,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CategoryTabs(r: r, categories: _categories, primary: _kPrimary),
            SizedBox(height: r.sectionGap),
            _FormCard(
              r: r,
              fieldBg: _kFieldBg,
              primary: _kPrimary,
              bookingIdCtrl: _bookingIdCtrl,
              subjectCtrl: _subjectCtrl,
              messageCtrl: _messageCtrl,
              onPickFile: _pickFile,
              onSubmit: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Category tabs ────────────────────────────────────────────────────────────
class _CategoryTabs extends StatelessWidget {
  final R r;
  final List<String> categories;
  final Color primary;

  const _CategoryTabs({
    required this.r,
    required this.categories,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupportBloc, SupportState>(
      buildWhen: (p, c) => p.selectedCategory != c.selectedCategory,
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((cat) {
              final selected = state.selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => context.read<SupportBloc>().add(
                    SupportCategoryChanged(cat),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: r.supportTabPadH,
                      vertical: r.supportTabPadV,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(r.supportTabRadius),
                      border: Border.all(
                        color: selected ? primary : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: r.supportTabFont,
                        fontWeight: FontWeight.w500,
                        color: selected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

// ── Form card ────────────────────────────────────────────────────────────────
class _FormCard extends StatelessWidget {
  final R r;
  final Color fieldBg;
  final Color primary;
  final TextEditingController bookingIdCtrl;
  final TextEditingController subjectCtrl;
  final TextEditingController messageCtrl;
  final VoidCallback onPickFile;
  final VoidCallback onSubmit;

  const _FormCard({
    required this.r,
    required this.fieldBg,
    required this.primary,
    required this.bookingIdCtrl,
    required this.subjectCtrl,
    required this.messageCtrl,
    required this.onPickFile,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.cardPadH,
        vertical: r.cardPadV,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Booking ID
          _FieldLabel(label: 'Booking Id', r: r),
          SizedBox(height: 8),
          _SupportTextField(
            controller: bookingIdCtrl,
            hint: 'Enter your ID',
            r: r,
            fieldBg: fieldBg,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Booking ID is required'
                : null,
          ),
          SizedBox(height: r.fieldGap),

          // Subject
          _FieldLabel(label: 'Subject', r: r),
          SizedBox(height: 8),
          _SupportTextField(
            controller: subjectCtrl,
            hint: 'Enter your Subject',
            r: r,
            fieldBg: fieldBg,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Subject is required' : null,
          ),
          SizedBox(height: r.fieldGap),

          // Message
          _FieldLabel(label: 'Message', r: r),
          SizedBox(height: 8),
          _SupportTextField(
            controller: messageCtrl,
            hint: 'Describe your issue',
            r: r,
            fieldBg: fieldBg,
            maxLines: 5,
            minLines: 5,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Message is required' : null,
          ),
          SizedBox(height: r.fieldGap),

          // Upload Attachment
          _FieldLabel(label: 'Upload Attachment', r: r),
          SizedBox(height: 8),
          _AttachmentPicker(
            r: r,
            fieldBg: fieldBg,
            primary: primary,
            onPickFile: onPickFile,
          ),
          SizedBox(height: r.sectionGap),

          // Send Button
          _SendButton(r: r, primary: primary, onSubmit: onSubmit),
        ],
      ),
    );
  }
}

// ── Field label ──────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String label;
  final R r;
  const _FieldLabel({required this.label, required this.r});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontSize: r.supportLabelFont,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}

// ── Text field ───────────────────────────────────────────────────────────────
class _SupportTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final R r;
  final Color fieldBg;
  final int? maxLines;
  final int? minLines;
  final String? Function(String?)? validator;

  const _SupportTextField({
    required this.controller,
    required this.hint,
    required this.r,
    required this.fieldBg,
    this.maxLines = 1,
    this.minLines,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      style: TextStyle(fontSize: r.supportFieldFont, color: Colors.black87),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: r.supportFieldFont,
          color: Colors.grey.shade400,
        ),
        filled: true,
        fillColor: fieldBg,
        contentPadding: EdgeInsets.symmetric(
          horizontal: r.cardPadH * 0.7,
          vertical: r.cardPadV * 0.6,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.supportFieldRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.supportFieldRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.supportFieldRadius),
          borderSide: const BorderSide(color: Color(0xFF4B3EFF), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.supportFieldRadius),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.supportFieldRadius),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}

// ── Attachment picker ─────────────────────────────────────────────────────────
class _AttachmentPicker extends StatelessWidget {
  final R r;
  final Color fieldBg;
  final Color primary;
  final VoidCallback onPickFile;

  const _AttachmentPicker({
    required this.r,
    required this.fieldBg,
    required this.primary,
    required this.onPickFile,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupportBloc, SupportState>(
      buildWhen: (p, c) => p.attachmentName != c.attachmentName,
      builder: (context, state) {
        final hasFile = state.attachmentName != null;
        return GestureDetector(
          onTap: onPickFile,
          child: Container(
            height: r.supportUploadH,
            decoration: BoxDecoration(
              color: fieldBg,
              borderRadius: BorderRadius.circular(r.supportFieldRadius),
            ),
            child: hasFile
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: r.cardPadH * 0.7),
                    child: Row(
                      children: [
                        Icon(
                          Icons.attach_file,
                          size: r.supportUploadIcon,
                          color: primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.attachmentName!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: r.supportUploadFont,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.read<SupportBloc>().add(
                            const SupportAttachmentCleared(),
                          ),
                          child: Icon(
                            Icons.close,
                            size: r.supportUploadIcon,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.upload_outlined,
                        size: r.supportUploadIcon,
                        color: primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'File Upload',
                        style: TextStyle(
                          fontSize: r.supportUploadFont,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

// ── Send button ───────────────────────────────────────────────────────────────
class _SendButton extends StatelessWidget {
  final R r;
  final Color primary;
  final VoidCallback onSubmit;

  const _SendButton({
    required this.r,
    required this.primary,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupportBloc, SupportState>(
      buildWhen: (p, c) => p.isSubmitting != c.isSubmitting,
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: r.supportBtnHeight,
          child: ElevatedButton(
            onPressed: state.isSubmitting ? null : onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              disabledBackgroundColor: primary.withOpacity(0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(r.supportBtnRadius),
              ),
              elevation: 0,
            ),
            child: state.isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    'Send Message',
                    style: TextStyle(
                      fontSize: r.supportBtnFont,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
