import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../models/clothing_item.dart';
import '../services/closet_service.dart';

class AddClothingScreen extends StatelessWidget {
  const AddClothingScreen({super.key});

  @override
  Widget build(BuildContext context) => const ClothingFormScreen();
}

class ClothingFormScreen extends StatefulWidget {
  const ClothingFormScreen({this.item, super.key});

  final ClothingItem? item;

  @override
  State<ClothingFormScreen> createState() => _ClothingFormScreenState();
}

class _ClothingFormScreenState extends State<ClothingFormScreen> {
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
  final ImagePicker _imagePicker = ImagePicker();
  final ClosetService _closetService = ClosetService();
  XFile? _selectedImage;
  Uint8List? _selectedImageBytes;
  bool _isPickingImage = false;
  bool _isSubmitting = false;
  bool _isDeleting = false;
  String? _submitError;
  String? _photoError;
  String? _existingPhotoUrl;
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
  void initState() {
    super.initState();
    final item = widget.item;
    if (item != null) {
      _nameController.text = item.name;
      _materialController.text = item.material;
      _storeController.text = item.store;
      _purchaseLinkController.text = item.purchaseLink;
      _priceController.text = item.price?.toString() ?? '';
      _category = item.category;
      _color = item.color;
      _status = item.status;
      _datePurchased = item.datePurchased;
      _selectedStyles.addAll(item.styles);
      _selectedSeasons.addAll(item.seasons);
      _selectedWeather.addAll(item.weather);
      _existingPhotoUrl = _resolveExistingPhotoUrl(item);
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      _recoverLostImage();
    }
  }

  String? _resolveExistingPhotoUrl(ClothingItem item) {
    final value = item.photoUrl?.trim().isNotEmpty == true
        ? item.photoUrl!.trim()
        : item.photo?.trim();
    if (value == null || value.isEmpty) return null;
    final uri = Uri.tryParse(value);
    if (uri == null) return null;
    return uri.hasScheme
        ? value
        : Uri.parse(ApiConstants.baseUrl).resolve(value).toString();
  }

  Future<void> _recoverLostImage() async {
    try {
      final response = await _imagePicker.retrieveLostData();
      if (response.isEmpty) return;
      final files = response.files;
      if (files == null || files.isEmpty) {
        if (!mounted) return;
        setState(() {
          _photoError = 'Foto dari pemilih sebelumnya tidak dapat dipulihkan.';
        });
        return;
      }
      await _loadSelectedImage(files.first);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _photoError = 'Foto dari pemilih sebelumnya tidak dapat dipulihkan.';
      });
    }
  }

  Future<void> _loadSelectedImage(XFile image) async {
    final bytes = await image.readAsBytes();
    if (bytes.isEmpty) {
      throw const FormatException('The selected image is empty.');
    }
    if (!mounted) return;
    setState(() {
      _selectedImage = image;
      _selectedImageBytes = bytes;
      _photoError = null;
    });
  }

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

  Future<void> _pickImage() async {
    if (_isPickingImage) return;
    setState(() {
      _isPickingImage = true;
      _photoError = null;
    });

    try {
      final pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedImage == null) return;

      final bytes = await pickedImage.readAsBytes();
      if (bytes.isEmpty) {
        throw const FormatException('The selected image is empty.');
      }
      if (!mounted) return;
      setState(() {
        _selectedImage = pickedImage;
        _selectedImageBytes = bytes;
        _photoError = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _photoError = 'Gambar gagal dipilih atau dibaca. Silakan coba lagi.';
      });
    } finally {
      if (mounted) setState(() => _isPickingImage = false);
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _selectedImageBytes = null;
      _photoError = null;
    });
  }

  Widget _buildPhotoSection() {
    final bytes = _selectedImageBytes;
    final currentPhotoUrl = _existingPhotoUrl;
    final hasPhoto = bytes != null || currentPhotoUrl != null;
    final ImageProvider? previewImage = bytes != null
        ? MemoryImage(bytes)
        : currentPhotoUrl == null
        ? null
        : NetworkImage(currentPhotoUrl);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.item == null ? 'Photo *' : 'Photo',
          style: const TextStyle(
            color: AppColors.azureMartinique,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        if (!hasPhoto)
          InkWell(
            onTap: _isPickingImage ? null : _pickImage,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.whiteSolid,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.orangePearlBrush),
              ),
              child: Column(
                children: [
                  Icon(
                    _isPickingImage
                        ? Icons.hourglass_top_rounded
                        : Icons.add_photo_alternate_outlined,
                    size: 34,
                    color: AppColors.azure57,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isPickingImage
                        ? 'Opening image picker...'
                        : 'Choose a clothing photo',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.azureDolphin),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _isPickingImage ? null : _pickImage,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Choose photo'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.azureSanMarino,
                      side: const BorderSide(color: AppColors.azureSanMarino),
                      shape: const StadiumBorder(),
                    ),
                  ),
                ],
              ),
            ),
          )
        else ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              height: 230,
              color: AppColors.orangePearlBrush.withValues(alpha: 0.45),
              child: Image(
                image: previewImage!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.broken_image_outlined,
                      size: 42,
                      color: AppColors.azure57,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Preview unavailable. Choose another image.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.azureDolphin),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            bytes == null
                ? 'Current photo'
                : _selectedImage?.name ?? 'Selected photo',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.azureDolphin, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              OutlinedButton.icon(
                onPressed: _isPickingImage ? null : _pickImage,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Change photo'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.azureSanMarino,
                  side: const BorderSide(color: AppColors.azureSanMarino),
                  shape: const StadiumBorder(),
                ),
              ),
              if (bytes != null)
                TextButton.icon(
                  onPressed: _removeImage,
                  icon: const Icon(Icons.undo_rounded),
                  label: Text(
                    currentPhotoUrl == null ? 'Remove' : 'Keep current',
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.redCherry,
                  ),
                ),
            ],
          ),
        ],
        if (_photoError != null) ...[
          const SizedBox(height: 8),
          Text(
            _photoError!,
            style: const TextStyle(color: AppColors.redCherry, fontSize: 13),
          ),
        ],
      ],
    );
  }

  Future<void> _save() async {
    if (_isSubmitting || _isDeleting || !_formKey.currentState!.validate()) {
      return;
    }

    final item = widget.item;
    final image = _selectedImage;
    final imageBytes = _selectedImageBytes;
    if (item == null && (image == null || imageBytes == null)) {
      setState(() => _submitError = 'A photo is required to save this item.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    try {
      if (item == null) {
        await _closetService.createItem(
          name: _nameController.text.trim(),
          category: _category!,
          color: _color!,
          material: _materialController.text.trim(),
          styles: _selectedStyles.toList(),
          seasons: _selectedSeasons.toList(),
          weather: _selectedWeather.toList(),
          store: _storeController.text.trim(),
          purchaseLink: _purchaseLinkController.text.trim(),
          datePurchased: _datePurchased,
          price: _priceController.text.isEmpty
              ? null
              : int.parse(_priceController.text),
          photoBytes: imageBytes!,
          photoFilename: image!.name,
        );
      } else {
        await _closetService.updateItem(
          original: item,
          name: _nameController.text.trim(),
          category: _category!,
          color: _color!,
          material: _materialController.text.trim(),
          styles: _selectedStyles.toList(),
          seasons: _selectedSeasons.toList(),
          weather: _selectedWeather.toList(),
          store: _storeController.text.trim(),
          purchaseLink: _purchaseLinkController.text.trim(),
          datePurchased: _datePurchased,
          price: _priceController.text.isEmpty
              ? null
              : int.parse(_priceController.text),
          photoBytes: imageBytes,
          photoFilename: image?.name,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            item == null
                ? 'Clothing item added to your closet.'
                : 'Clothing item updated.',
          ),
        ),
      );
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _submitError = error.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _deleteItem() async {
    final item = widget.item;
    if (item == null || _isSubmitting || _isDeleting) return;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete clothing item?'),
        content: Text(
          '“${item.name}” will be removed from your Digital Closet.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.redCherry),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !mounted) return;
    setState(() {
      _isDeleting = true;
      _submitError = null;
    });

    try {
      await _closetService.deleteItem(item.id);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Clothing item deleted.')));
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _submitError = error.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
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
        title: Text(widget.item == null ? 'Add Clothing' : 'Edit Clothing'),
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
                        Text(
                          widget.item == null
                              ? 'Add a piece to your wardrobe'
                              : 'Edit your clothing item',
                          style: TextStyle(
                            color: AppColors.azureMartinique,
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.item == null
                              ? 'Tell us a little about this clothing item.'
                              : 'Update the details for this item.',
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
                            if (widget.item == null)
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
                        _buildPhotoSection(),
                        const SizedBox(height: 28),
                        if (_submitError != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            _submitError!,
                            style: const TextStyle(color: AppColors.redCherry),
                          ),
                        ],
                        const SizedBox(height: 12),
                        Wrap(
                          alignment: WrapAlignment.end,
                          spacing: 12,
                          runSpacing: 10,
                          children: [
                            if (widget.item != null)
                              OutlinedButton.icon(
                                onPressed: _isSubmitting || _isDeleting
                                    ? null
                                    : _deleteItem,
                                icon: _isDeleting
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.redCherry,
                                        ),
                                      )
                                    : const Icon(Icons.delete_outline),
                                label: Text(
                                  _isDeleting ? 'Deleting…' : 'Delete',
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.redCherry,
                                  side: const BorderSide(
                                    color: AppColors.redCherry,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 14,
                                  ),
                                  shape: const StadiumBorder(),
                                ),
                              ),
                            OutlinedButton(
                              onPressed: _isSubmitting || _isDeleting
                                  ? null
                                  : () => Navigator.of(context).maybePop(),
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
                              onPressed: _isSubmitting || _isDeleting
                                  ? null
                                  : _save,
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.azureSanMarino,
                                foregroundColor: AppColors.whiteSolid,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 26,
                                  vertical: 14,
                                ),
                                shape: const StadiumBorder(),
                              ),
                              child: _isSubmitting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Save'),
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
