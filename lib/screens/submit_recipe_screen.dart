import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_theme.dart';
import '../widgets/app_shell.dart';

class SubmitRecipeScreen extends StatefulWidget {
  const SubmitRecipeScreen({super.key});

  @override
  State<SubmitRecipeScreen> createState() => _SubmitRecipeScreenState();
}

class _SubmitRecipeScreenState extends State<SubmitRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _ingredients = TextEditingController();
  final _steps = TextEditingController();
  String _category = 'Dinner';
  bool _submitted = false;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _name.dispose();
    _description.dispose();
    _ingredients.dispose();
    _steps.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final preferences = await SharedPreferences.getInstance();
    final submissions =
        preferences.getStringList('cookmate-submissions') ?? <String>[];
    submissions.add('${_title.text.trim()}|${_name.text.trim()}|$_category');
    await preferences.setStringList('cookmate-submissions', submissions);
    if (!mounted) return;
    setState(() {
      _saving = false;
      _submitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return PagePadding(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: AppTheme.evergreen,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: AppTheme.apricot,
                    child: Icon(Icons.send_rounded, color: Colors.white),
                  ),
                  const SizedBox(height: 22),
                  const SectionEyebrow('Recipe received'),
                  const SizedBox(height: 10),
                  Text(
                    'That belongs in the book.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Thanks for sharing ${_title.text.trim()}. It is safely saved on this device for your next kitchen session.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: .78),
                        ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => setState(() => _submitted = false),
                    child: const Text('Share another recipe'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return PagePadding(
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const SectionEyebrow('The community table'),
            const SizedBox(height: 10),
            Text(
              'Pass the plate.',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'Have a recipe that always works? Give it a home here. Your submission stays right on this device.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 28),
            _Field(
              controller: _title,
              label: 'Recipe title',
              hint: 'The thing you make when...',
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final stacked = constraints.maxWidth < 560;
                return Flex(
                  direction: stacked ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: stacked
                      ? [
                          _Field(
                            controller: _name,
                            label: 'Your name',
                            hint: 'How should we credit you?',
                          ),
                          const SizedBox(height: 16),
                          _CategoryField(
                            value: _category,
                            onChanged: (value) =>
                                setState(() => _category = value),
                          ),
                        ]
                      : [
                          Expanded(
                            child: _Field(
                              controller: _name,
                              label: 'Your name',
                              hint: 'How should we credit you?',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _CategoryField(
                              value: _category,
                              onChanged: (value) =>
                                  setState(() => _category = value),
                            ),
                          ),
                        ],
                );
              },
            ),
            const SizedBox(height: 16),
            _Field(
              controller: _description,
              label: 'The short version',
              hint: 'What makes this recipe worth making?',
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            _Field(
              controller: _ingredients,
              label: 'Ingredients',
              hint: 'One ingredient per line',
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            _Field(
              controller: _steps,
              label: 'Steps',
              hint: 'Walk us through it, one step per line',
              maxLines: 5,
            ),
            const SizedBox(height: 22),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.icon(
                onPressed: _saving ? null : _submit,
                icon: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.arrow_forward_rounded),
                label: Text(_saving ? 'Saving...' : 'Save this recipe'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _CategoryField extends StatelessWidget {
  const _CategoryField({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: const InputDecoration(labelText: 'Category'),
      items: const [
        DropdownMenuItem(value: 'Breakfast', child: Text('Breakfast')),
        DropdownMenuItem(value: 'Lunch', child: Text('Lunch')),
        DropdownMenuItem(value: 'Dinner', child: Text('Dinner')),
      ],
      onChanged: (value) => onChanged(value ?? 'Dinner'),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (value) =>
          value == null || value.trim().isEmpty ? 'Please add $label.' : null,
      decoration: InputDecoration(labelText: label, hintText: hint),
    );
  }
}