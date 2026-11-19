import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';

class AddClothingScreen extends StatefulWidget {
  const AddClothingScreen({super.key});

  @override
  State<AddClothingScreen> createState() => _AddClothingScreenState();
}

class _AddClothingScreenState extends State<AddClothingScreen> {
  static const _categories = <String>[
    'top',
    'bottom',
    'shoes',
    'accessories',
    'outerwear',
    'dresses',
  ];
  static const _colors = <String>[
    'white',
    'black',
    'gray',
    'beige',
    'brown',
    'red',
    'orange',
    'yellow',
    'pink',
    'green',
    'blue',
    'purple',
  ];
  static const _materials = <String>[
    'cotton',
    'denim',
    'linen',
    'polyester',
    'wool',
    'rayon',
    'viscose',
    'silk',
    'satin',
    'knit',
    'chiffon',
    'leather',
  ];
  static const _styles = <String>[
    'Casual',
    'Formal',
    'Street',
    'Minimal',
    'Sporty',
    'Party',
    'Cozy',
    'Vintage',
  ];
  static const _seasons = <String>[
    'Spring',
    'Summer',
    'Autumn',
    'Winter',
    'All year round',
  ];
  static const _weather = <String>[
    'Hot',
    'Stormy',
    'Cool',
    'Moderate',
    'Rainy',
    'Drizzle',
    'Thunderstorm',
  ];
  static const _statuses = <String, String>{
    'ready': 'Ready to Wear',
    'washing': 'In the Wash',
  };

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _materialController = TextEditingController();
  final _storeController = TextEditingController();
  final _purchaseLinkController = TextEditingController();
  final _priceController = TextEditingController();

  String? _category;
  String? _color;
  String _status = 'ready';
  DateTime? _datePurchased;
  final Set<String> _selectedStyles = {};
  final Set<String> _selectedSeasons = {};
  final Set<String> _selectedWeather = {};

  @override
  void dispose() {
    _nameController.dispose();
    _materialController.dispose();
    _storeController.dispose();
    _purchaseLinkController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: _datePurchased ?? today,
      firstDate: DateTime(1900),
      lastDate: today,
      helpText: 'Select purchase date',
    );
    if (picked != null) setState(() => _datePurchased = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form siap. Penyimpanan ke API belum tersedia.'),
      ),
    );
  }

  String _label(String value) {
    if (value == 'ready' || value == 'washing') return _statuses[value]!;
    return value[0].toUpperCase() + value.substring(1);
  }

  Widget _textField(
    String label,
    TextEditingController controller, {
    String? hint,
    int maxLength = 100,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      maxLength: maxLength,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: _decoration(label, hint: hint),
    );
  }

  InputDecoration _decoration(
    String label, {
    String? hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.whiteSolid,
      counterText: '',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.orangePearlBrush),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.orangePearlBrush),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.azureSanMarino,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _dropdown(
    String label,
    String? value,
    List<String> options,
    ValueChanged<String?> onChanged, {
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: _decoration(label),
      items: options
          .map(
            (option) => DropdownMenuItem(
              value: option,
              child: Text(_label(option), overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _multiSelect(
    String title,
    String helper,
    List<String> options,
    Set<String> selected,
    ValueChanged<String> onToggle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.azureMartinique,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          helper,
          style: const TextStyle(color: AppColors.azureDolphin, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: options.map((option) {
            final isSelected = selected.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (_) => onToggle(option),
              selectedColor: AppColors.orangeDairyCream,
              checkmarkColor: AppColors.azureMartinique,
              side: const BorderSide(color: AppColors.orangePearlBrush),
              labelStyle: TextStyle(
                color: isSelected
                    ? AppColors.azureMartinique
                    : AppColors.azureDolphin,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orangeLinen,
      appBar: AppBar(
        title: const Text('Add Clothing'),
        backgroundColor: AppColors.orangeLinen,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth = constraints.maxWidth >= 760
                ? 720.0
                : constraints.maxWidth;
            final fieldWidth = constraints.maxWidth >= 620
                ? (contentWidth - 16) / 2
                : contentWidth;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: SizedBox(
                  width: contentWidth,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Add a piece to your wardrobe',
                          style: TextStyle(
                            color: AppColors.azureMartinique,
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Tell us a little about this clothing item.',
                          style: TextStyle(color: AppColors.azureDolphin),
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            SizedBox(
                              width: fieldWidth,
                              child: _textField(
                                'Clothing Name *',
                                _nameController,
                                hint: 'e.g. Everyday denim jacket',
                                validator: (value) =>
                                    value == null || value.trim().isEmpty
                                    ? 'Clothing name is required'
                                    : null,
                              ),
                            ),
                            SizedBox(
                              width: fieldWidth,
                              child: _dropdown(
                                'Category *',
                                _category,
                                _categories,
                                (value) => setState(() => _category = value),
                                validator: (value) => value == null
                                    ? 'Please select a category'
                                    : null,
                              ),
                            ),
                            SizedBox(
                              width: fieldWidth,
                              child: _dropdown(
                                'Color *',
                                _color,
                                _colors,
                                (value) => setState(() => _color = value),
                                validator: (value) => value == null
                                    ? 'Please select a color'
                                    : null,
                              ),
                            ),
                            SizedBox(
                              width: fieldWidth,
                              child: _textField(
                                'Material',
                                _materialController,
                                hint: 'e.g. cotton',
                                maxLength: 50,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return null;
                                  }
                                  return _materials.contains(
                                        value.trim().toLowerCase(),
                                      )
                                      ? null
                                      : 'Choose a material supported by the catalog';
                                },
                              ),
                            ),
                            SizedBox(
                              width: fieldWidth,
                              child: _dropdown(
                                'Status',
                                _status,
                                _statuses.keys.toList(),
                                (value) => setState(() => _status = value!),
                              ),
                            ),
                            SizedBox(
                              width: fieldWidth,
                              child: _textField(
                                'Store',
                                _storeController,
                                hint: 'Optional',
                                maxLength: 80,
                              ),
                            ),
                            SizedBox(
                              width: fieldWidth,
                              child: _textField(
                                'Purchase Link',
                                _purchaseLinkController,
                                hint: 'https://',
                                maxLength: 500,
                                keyboardType: TextInputType.url,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return null;
                                  }
                                  final uri = Uri.tryParse(value.trim());
                                  return uri != null &&
                                          (uri.scheme == 'http' ||
                                              uri.scheme == 'https') &&
                                          uri.host.isNotEmpty
                                      ? null
                                      : 'Enter a valid web link';
                                },
                              ),
                            ),
                            SizedBox(
                              width: fieldWidth,
                              child: _textField(
                                'Price',
                                _priceController,
                                hint: 'Optional, whole number',
                                maxLength: 10,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return null;
                                  }
                                  final price = int.tryParse(value);
                                  return price == null
                                      ? 'Enter a whole number'
                                      : price < 0
                                      ? 'Price cannot be negative'
                                      : null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: fieldWidth,
                              child: InkWell(
                                onTap: _pickDate,
                                borderRadius: BorderRadius.circular(14),
                                child: InputDecorator(
                                  decoration: _decoration(
                                    'Date Purchased',
                                    suffixIcon: const Icon(
                                      Icons.calendar_today_rounded,
                                    ),
                                  ),
                                  child: Text(
                                    _datePurchased == null
                                        ? 'Optional'
                                        : '${_datePurchased!.year.toString().padLeft(4, '0')}-${_datePurchased!.month.toString().padLeft(2, '0')}-${_datePurchased!.day.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      color: _datePurchased == null
                                          ? AppColors.azureDolphin
                                          : AppColors.azureMartinique,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _multiSelect(
                          'Styles',
                          'Choose any that apply.',
                          _styles,
                          _selectedStyles,
                          (value) => setState(() {
                            _selectedStyles.contains(value)
                                ? _selectedStyles.remove(value)
                                : _selectedStyles.add(value);
                          }),
                        ),
                        const SizedBox(height: 18),
                        _multiSelect(
                          'Seasons',
                          'Choose any that apply.',
                          _seasons,
                          _selectedSeasons,
                          (value) => setState(() {
                            if (value == 'All year round') {
                              _selectedSeasons
                                ..clear()
                                ..add(value);
                            } else {
                              _selectedSeasons.remove('All year round');
                              _selectedSeasons.contains(value)
                                  ? _selectedSeasons.remove(value)
                                  : _selectedSeasons.add(value);
                            }
                          }),
                        ),
                        const SizedBox(height: 18),
                        _multiSelect(
                          'Weather',
                          'Choose any that apply.',
                          _weather,
                          _selectedWeather,
                          (value) => setState(() {
                            _selectedWeather.contains(value)
                                ? _selectedWeather.remove(value)
                                : _selectedWeather.add(value);
                          }),
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          'Photo (optional)',
                          style: TextStyle(
                            color: AppColors.azureMartinique,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.whiteSolid,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.orangePearlBrush,
                            ),
                          ),
                          child: const Column(
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 34,
                                color: AppColors.azure57,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Photo selection will be available later',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: AppColors.azureDolphin),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        Wrap(
                          alignment: WrapAlignment.end,
                          spacing: 12,
                          runSpacing: 10,
                          children: [
                            OutlinedButton(
                              onPressed: () => Navigator.of(context).maybePop(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.azureSanMarino,
                                side: const BorderSide(
                                  color: AppColors.azureSanMarino,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 14,
                                ),
                                shape: const StadiumBorder(),
                              ),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: _save,
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.azureSanMarino,
                                foregroundColor: AppColors.whiteSolid,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 26,
                                  vertical: 14,
                                ),
                                shape: const StadiumBorder(),
                              ),
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

