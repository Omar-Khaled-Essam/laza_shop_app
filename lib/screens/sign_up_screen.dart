import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_event.dart';
import '../l10n/app_strings.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
    required this.onComplete,
    required this.onToggleLocale,
  });

  final VoidCallback onComplete;
  final VoidCallback onToggleLocale;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _validateName(String? input, AppStrings strings) {
    final name = (input ?? '').trim();
    if (!RegExp(r"^[A-Z][A-Za-z\s\-']*$").hasMatch(name)) {
      return strings.t('nameError');
    }
    return null;
  }

  Future<void> _submit(AppStrings strings) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.check_circle_outline, size: 42),
        title: Text(strings.t('accountCreated')),
        content: Text(strings.t('continueMessage')),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(strings.t('continue')),
          ),
        ],
      ),
    );

    if (mounted) widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          tooltip: strings.t('language'),
                          onPressed: widget.onToggleLocale,
                          icon: const Icon(Icons.language),
                        ),
                        IconButton(
                          tooltip: strings.t('theme'),
                          onPressed: () => context.read<ThemeBloc>().add(ToggleTheme()),
                          icon: Icon(
                            Theme.of(context).brightness == Brightness.dark
                                ? Icons.light_mode_outlined
                                : Icons.dark_mode_outlined,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: width < 380 ? 8 : 18),
                    Center(
                      child: Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      strings.t('welcome'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      strings.t('signUpSubtitle'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                      decoration: InputDecoration(
                        labelText: strings.t('fullName'),
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      validator: (value) => _validateName(value, strings),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      decoration: InputDecoration(
                        labelText: strings.t('email'),
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        final email = (value ?? '').trim();
                        return email.contains('@') && email.contains('.')
                            ? null
                            : strings.t('emailError');
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _hidePassword,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newPassword],
                      decoration: InputDecoration(
                        labelText: strings.t('password'),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          tooltip: strings.t('togglePasswordVisibility'),
                          onPressed: () => setState(() => _hidePassword = !_hidePassword),
                          icon: Icon(_hidePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),
                      ),
                      validator: (value) => (value ?? '').length >= 6
                          ? null
                          : strings.t('passwordError'),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _confirmController,
                      obscureText: _hideConfirmPassword,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                      onFieldSubmitted: (_) => _submit(strings),
                      decoration: InputDecoration(
                        labelText: strings.t('confirmPassword'),
                        prefixIcon: const Icon(Icons.lock_reset_outlined),
                        suffixIcon: IconButton(
                          tooltip: strings.t('togglePasswordVisibility'),
                          onPressed: () => setState(
                            () => _hideConfirmPassword = !_hideConfirmPassword,
                          ),
                          icon: Icon(_hideConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),
                      ),
                      validator: (value) => value == _passwordController.text
                          ? null
                          : strings.t('confirmError'),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => _submit(strings),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(strings.t('createAccount')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
