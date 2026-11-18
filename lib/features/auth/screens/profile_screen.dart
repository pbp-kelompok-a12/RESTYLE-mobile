import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  UserProfile? _profile;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  final _stylePersonaController = TextEditingController();
  final _preferredStyleController = TextEditingController();
  final _priorityController = TextEditingController();
  final _wardrobeGoalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _authService.getProfile();

      _stylePersonaController.text = profile.stylePersona;
      _preferredStyleController.text = profile.preferredStyle;
      _priorityController.text = profile.consciousShoppingPriority;
      _wardrobeGoalController.text = profile.wardrobeGoal;

      setState(() {
        _profile = profile;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final updatedProfile = await _authService.updateProfile(
        stylePersona: _stylePersonaController.text.trim(),
        preferredStyle: _preferredStyleController.text.trim(),
        consciousShoppingPriority: _priorityController.text.trim(),
        wardrobeGoal: _wardrobeGoalController.text.trim(),
      );

      setState(() {
        _profile = updatedProfile;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile berhasil diperbarui!')),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _logout() async {
    try {
      await _authService.logout();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  void dispose() {
    _stylePersonaController.dispose();
    _preferredStyleController.dispose();
    _priorityController.dispose();
    _wardrobeGoalController.dispose();
    super.dispose();
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _profile == null
              ? Center(
                  child: Text(_errorMessage ?? 'Profile gagal dimuat'),
                )
              : ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text(
                      _profile!.username,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(_profile!.email),
                    const SizedBox(height: 28),
                    const Text(
                      'Style Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      'Style Persona',
                      _stylePersonaController,
                    ),
                    _buildField(
                      'Preferred Style',
                      _preferredStyleController,
                    ),
                    _buildField(
                      'Conscious Shopping Priority',
                      _priorityController,
                    ),
                    _buildField(
                      'Wardrobe Goal',
                      _wardrobeGoalController,
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _isSaving ? null : _updateProfile,
                      child: _isSaving
                          ? const CircularProgressIndicator()
                          : const Text('Save Changes'),
                    ),
                  ],
                ),
    );
  }
}