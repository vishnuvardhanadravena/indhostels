import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indhostels/bloc/support/support_bloc.dart';
import 'package:indhostels/pages/profile/profile.dart';
import 'package:indhostels/utils/theame/app_themes.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<SupportBloc>().add(
      ContactUsSubmitRequested(
        fullName: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        subject: _subjectCtrl.text.trim(),
        message: _messageCtrl.text.trim(),
      ),
    );
  }

  void _resetForm() {
    _nameCtrl.clear();
    _emailCtrl.clear();
    _phoneCtrl.clear();
    _subjectCtrl.clear();
    _messageCtrl.clear();
    _formKey.currentState?.reset();
    context.read<SupportBloc>().add(const ContactUsResetRequested());
  }

  @override
  Widget build(BuildContext context) {
    final r = R(MediaQuery.of(context).size.width);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.arrow_back,
              size: r.backIconSize,
              color: Colors.black87,
            ),
          ),
        ),
        title: Text(
          'Contact Us',
          style: TextStyle(
            fontSize: r.titleFontSize,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ),
      body: BlocConsumer<SupportBloc, SupportState>(
        listenWhen: (p, c) =>
            p.contactUsSuccess != c.contactUsSuccess ||
            p.contactUsError != c.contactUsError,
        listener: (context, state) {
          if (state.contactUsSuccess) {
            _resetForm();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Query submitted successfully! We will get back to you soon.',
                ),
                backgroundColor: const Color(0xFF1A237E),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(top: 0, left: 16, right: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                duration: const Duration(seconds: 3),
              ),
            );
          }
          if (state.contactUsError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.contactUsError!),
                backgroundColor: Colors.red.shade700,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (r.isTablet) {
            return _TabletLayout(
              r: r,
              formKey: _formKey,
              nameCtrl: _nameCtrl,
              emailCtrl: _emailCtrl,
              phoneCtrl: _phoneCtrl,
              subjectCtrl: _subjectCtrl,
              messageCtrl: _messageCtrl,
              isSubmitting: state.contactUsSubmitting,
              onSubmit: _submit,
            );
          }
          return _MobileLayout(
            r: r,
            formKey: _formKey,
            nameCtrl: _nameCtrl,
            emailCtrl: _emailCtrl,
            phoneCtrl: _phoneCtrl,
            subjectCtrl: _subjectCtrl,
            messageCtrl: _messageCtrl,
            isSubmitting: state.contactUsSubmitting,
            onSubmit: _submit,
          );
        },
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final R r;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController subjectCtrl;
  final TextEditingController messageCtrl;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  const _MobileLayout({
    required this.r,
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.subjectCtrl,
    required this.messageCtrl,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: r.screenPadH,
        vertical: r.screenPadV,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Form card
          _FormCard(
            r: r,
            formKey: formKey,
            nameCtrl: nameCtrl,
            emailCtrl: emailCtrl,
            phoneCtrl: phoneCtrl,
            subjectCtrl: subjectCtrl,
            messageCtrl: messageCtrl,
            isSubmitting: isSubmitting,
            onSubmit: onSubmit,
            twoColumnFields: false,
          ),
          SizedBox(height: r.sectionGap),
          _ContactInfoCard(r: r),
          SizedBox(height: r.screenPadV),
        ],
      ),
    );
  }
}

class _TabletLayout extends StatelessWidget {
  final R r;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController subjectCtrl;
  final TextEditingController messageCtrl;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  const _TabletLayout({
    required this.r,
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.subjectCtrl,
    required this.messageCtrl,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: r.screenPadH,
        vertical: r.screenPadV,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: _FormCard(
              r: r,
              formKey: formKey,
              nameCtrl: nameCtrl,
              emailCtrl: emailCtrl,
              phoneCtrl: phoneCtrl,
              subjectCtrl: subjectCtrl,
              messageCtrl: messageCtrl,
              isSubmitting: isSubmitting,
              onSubmit: onSubmit,
              twoColumnFields: true,
            ),
          ),
          SizedBox(width: r.sectionGap * 0.6),
          Expanded(flex: 4, child: _ContactInfoCard(r: r)),
        ],
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  final R r;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController subjectCtrl;
  final TextEditingController messageCtrl;
  final bool isSubmitting;
  final VoidCallback onSubmit;
  final bool twoColumnFields;

  const _FormCard({
    required this.r,
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.subjectCtrl,
    required this.messageCtrl,
    required this.isSubmitting,
    required this.onSubmit,
    required this.twoColumnFields,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      padding: EdgeInsets.symmetric(
        horizontal: r.cardPadH,
        vertical: r.cardPadV,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row 1: Full Name + Email
            if (twoColumnFields)
              _TwoColumnRow(
                left: _FieldBlock(
                  label: 'Full Name',
                  required: true,
                  child: _InputField(
                    ctrl: nameCtrl,
                    hint: 'Enter your name',
                    r: r,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
                right: _FieldBlock(
                  label: 'Email Address',
                  required: true,
                  child: _InputField(
                    ctrl: emailCtrl,
                    hint: 'you@example.com',
                    r: r,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (!v.contains('@')) return 'Invalid email';
                      return null;
                    },
                  ),
                ),
                gap: r.fieldGap,
              )
            else ...[
              _FieldBlock(
                label: 'Full Name',
                required: true,
                child: _InputField(
                  ctrl: nameCtrl,
                  hint: 'Enter your name',
                  r: r,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
              ),
              SizedBox(height: r.fieldGap),
              _FieldBlock(
                label: 'Email Address',
                required: true,
                child: _InputField(
                  ctrl: emailCtrl,
                  hint: 'you@example.com',
                  r: r,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (!v.contains('@')) return 'Invalid email';
                    return null;
                  },
                ),
              ),
            ],

            SizedBox(height: r.fieldGap),

            // Row 2: Mobile Number + Subject
            if (twoColumnFields)
              _TwoColumnRow(
                left: _FieldBlock(
                  label: 'Mobile Number',
                  required: true,
                  child: _InputField(
                    ctrl: phoneCtrl,
                    hint: 'Enter Mobile number',
                    r: r,
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
                right: _FieldBlock(
                  label: 'Subject',
                  required: true,
                  child: _InputField(
                    ctrl: subjectCtrl,
                    hint: 'Booking query / Feedback',
                    r: r,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
                gap: r.fieldGap,
              )
            else ...[
              _FieldBlock(
                label: 'Mobile Number',
                required: true,
                child: _InputField(
                  ctrl: phoneCtrl,
                  hint: 'Enter Mobile number',
                  r: r,
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
              ),
              SizedBox(height: r.fieldGap),
              _FieldBlock(
                label: 'Subject',
                required: true,
                child: _InputField(
                  ctrl: subjectCtrl,
                  hint: 'Booking query / Feedback',
                  r: r,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
              ),
            ],

            SizedBox(height: r.fieldGap),

            // Message textarea
            _FieldBlock(
              label: 'Your Message',
              required: true,
              child: _InputField(
                ctrl: messageCtrl,
                hint: 'Write your message here…',
                r: r,
                maxLines: 6,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
            ),

            SizedBox(height: r.sectionGap * 0.7),

            // Send Message button
            Center(
              child: SizedBox(
                width: twoColumnFields ? 260 : double.infinity,
                height: r.supportBtnHeight,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: const Color(
                      0xFF1A237E,
                    ).withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        r.supportBtnRadius * 2,
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: isSubmitting
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactInfoCard extends StatelessWidget {
  final R r;
  const _ContactInfoCard({required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(r.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header banner
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: r.cardPadH,
              vertical: r.cardPadV * 0.85,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF1A237E),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(r.cardRadius),
                topRight: Radius.circular(r.cardRadius),
              ),
            ),
            child: Text(
              'Contact Information',
              style: TextStyle(
                fontSize: r.detailTitleFont,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),

          // Info items
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: r.cardPadH,
              vertical: r.cardPadV,
            ),
            child: Column(
              children: [
                _InfoRow(
                  r: r,
                  icon: Icons.phone_outlined,
                  title: 'Call Us',
                  subtitle: '+91 98765 43210 (Mon–Sun, 9AM–9PM)',
                ),
                Divider(
                  color: Colors.white.withOpacity(0.15),
                  height: r.sectionGap,
                ),
                _InfoRow(
                  r: r,
                  icon: Icons.email_outlined,
                  title: 'Email Support',
                  subtitle: 'support@indhostel.com',
                ),
                Divider(
                  color: Colors.white.withOpacity(0.15),
                  height: r.sectionGap,
                ),
                _InfoRow(
                  r: r,
                  icon: Icons.location_on_outlined,
                  title: 'Visit Us',
                  subtitle: '4th Floor, UrbanNest Tower,\nMumbai, India',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final R r;
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoRow({
    required this.r,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: r.iconBox,
          height: r.iconBox,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(r.iconBoxRadius * 1.2),
          ),
          child: Icon(icon, size: r.iconSize, color: Colors.white),
        ),
        SizedBox(width: r.iconGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: r.labelFontSize,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: r.supportFieldFont,
                  color: Colors.white.withOpacity(0.75),
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FieldBlock extends StatelessWidget {
  final String label;
  final bool required;
  final Widget child;

  const _FieldBlock({
    required this.label,
    required this.child,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              if (required)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

/// Two fields side-by-side with equal width
class _TwoColumnRow extends StatelessWidget {
  final Widget left;
  final Widget right;
  final double gap;

  const _TwoColumnRow({
    required this.left,
    required this.right,
    required this.gap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        SizedBox(width: gap),
        Expanded(child: right),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final R r;
  final TextInputType keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  const _InputField({
    required this.ctrl,
    required this.hint,
    required this.r,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(fontSize: r.supportFieldFont, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: r.supportFieldFont,
          color: Colors.grey.shade400,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: r.cardPadH * 0.6,
          vertical: 14,
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.supportFieldRadius),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.supportFieldRadius),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.supportFieldRadius),
          borderSide: const BorderSide(color: Color(0xFF1A237E), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.supportFieldRadius),
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.supportFieldRadius),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
      ),
    );
  }
}
