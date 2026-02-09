import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:ui';
import 'package:supabase_flutter/supabase_flutter.dart';

// ============================================================================
// MODELS
// ============================================================================

class ProfileModel {
  String name;
  String bio;
  String email;
  String phone;
  String linkedIn;
  String? profileImagePath;
  List<String> skills;
  List<String> hobbies;
  List<String> interests;

  ProfileModel({
    required this.name,
    required this.bio,
    required this.email,
    required this.phone,
    required this.linkedIn,
    this.profileImagePath,
    required this.skills,
    required this.hobbies,
    required this.interests,
  });

  ProfileModel copyWith({
    String? name,
    String? bio,
    String? email,
    String? phone,
    String? linkedIn,
    String? profileImagePath,
    List<String>? skills,
    List<String>? hobbies,
    List<String>? interests,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      bio: bio ?? this.bio,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      linkedIn: linkedIn ?? this.linkedIn,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      skills: skills ?? this.skills,
      hobbies: hobbies ?? this.hobbies,
      interests: interests ?? this.interests,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bio': bio,
      'email': email,
      'phone': phone,
      'linkedIn': linkedIn,
      'profileImagePath': profileImagePath,
      'skills': skills,
      'hobbies': hobbies,
      'interests': interests,
    };
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] ?? '',
      bio: json['bio'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      linkedIn: json['linkedIn'] ?? '',
      profileImagePath: json['profileImagePath'],
      skills: List<String>.from(json['skills'] ?? []),
      hobbies: List<String>.from(json['hobbies'] ?? []),
      interests: List<String>.from(json['interests'] ?? []),
    );
  }

  static ProfileModel defaultProfile() {
    return ProfileModel(
      name: 'Sheila Nicole Cheng',
      bio:
          'A creative and passionate developer with a love for design and technology. '
          'I enjoy crafting beautiful digital experiences that merge art with functionality.',
      email: 'sheilanicoledizon@gmail.com',
      phone: '+63 912 345 6789',
      linkedIn: 'https://www.linkedin.com/in/sheila-nicole-cheng-35982b327/',
      profileImagePath: 'assets/home/Profile_picture.png',
      skills: [
        'Flutter Development',
        'UI/UX Design',
        'Graphic Design',
        'Web Development',
        'Python',
        'JavaScript',
      ],
      hobbies: ['Digital Art', 'Photography', 'Reading', 'Gaming'],
      interests: ['Technology', 'Art & Design', 'Music', 'Travel'],
    );
  }
}

class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String? imageUrl;
  final List<String> technologies;
  final String? link;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.imageUrl,
    required this.technologies,
    this.link,
  });

  static List<ProjectModel> sampleProjects() {
    return [
      ProjectModel(
        id: '1',
        title: 'Web Portfolio',
        description:
            'This website was designed and coded to reflect my personality, interests, and skills. Inspired by underwater glass aesthetics, it focuses on smooth motion, playful interactions, and clarity. Every section was intentionally designed and developed.',
        category: 'Web Development',
        imageUrl: 'assets/logo/Portfolio_logo.png',
        technologies: ['HTML', 'CSS', 'JavaScript'],
      ),
      ProjectModel(
        id: '2',
        title: 'ContextuFile',
        description:
            'ContextuFile uses contextual meaning from file titles to automatically organize files into folders. Instead of manual sorting, the system analyzes keywords and intent to reduce clutter. It\'s built to make file management smarter and less annoying.',
        category: 'AI/Machine Learning',
        imageUrl: 'assets/logo/Contextufile_logo.png',
        technologies: ['Python', 'spaCy', 'HTML', 'JavaScript', 'CSS'],
      ),
      ProjectModel(
        id: '3',
        title: 'VisiTrack',
        description:
            'VisiTrack helps manage visitor data by recording entries in a structured and reliable way. It focuses on accuracy, accountability, and ease of use, making manual tracking less chaotic. The system was designed with both function and clarity in mind.',
        category: 'Business Software',
        imageUrl: 'assets/logo/VisiTrack_logo.png',
        technologies: ['Outsystems'],
      ),
      ProjectModel(
        id: '4',
        title: 'RISE PH Database',
        description:
            'RISE PH Database focuses on data integrity, organization, and efficient retrieval. It was designed to support real-world use cases that require reliable records and reporting. The system emphasizes structure over chaos.',
        category: 'Database Systems',
        imageUrl: 'assets/logo/ArisePH_logo.png',
        technologies: ['Workbook', 'Frappe'],
      ),
    ];
  }
}

class FriendModel {
  final String? id;
  String name;
  String email;
  String? phone;
  String? notes;

  FriendModel({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    this.notes,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'phone': phone,
      'notes': notes,
    };

    if (id != null) {
      data['id'] = id;
    }

    return data;
  }

  FriendModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? notes,
  }) {
    return FriendModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
    );
  }
}

class PosterModel {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String category;

  PosterModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.category,
  });

  static List<PosterModel> samplePosters() {
    return [
      PosterModel(
        id: '1',
        title: 'Blue Ink Poster',
        description:
            'A striking digital artwork featuring blue ink aesthetics and artistic fluid designs.',
        imageUrl: 'assets/posters/blue_ink_poster.png',
        category: 'Digital Art',
      ),
      PosterModel(
        id: '2',
        title: 'Cross The Bridge',
        description:
            'An inspiring visual composition representing journey and transition through artistic elements.',
        imageUrl: 'assets/posters/cross_the_bridge.png',
        category: 'Digital Art',
      ),
      PosterModel(
        id: '3',
        title: 'Nature Collage',
        description:
            'A beautiful collage blending natural elements with contemporary design principles.',
        imageUrl: 'assets/posters/nature_collage.png',
        category: 'Digital Art',
      ),
      PosterModel(
        id: '4',
        title: 'Observe',
        description:
            'A contemplative piece encouraging mindfulness and observation of the world around us.',
        imageUrl: 'assets/posters/Observe.png',
        category: 'Digital Art',
      ),
      PosterModel(
        id: '5',
        title: 'Past Life',
        description:
            'An introspective artwork exploring memories and the echoes of our past.',
        imageUrl: 'assets/posters/Past_life.png',
        category: 'Digital Art',
      ),
      PosterModel(
        id: '6',
        title: 'Universe',
        description:
            'A cosmic-inspired digital artwork celebrating the vastness and wonder of space.',
        imageUrl: 'assets/posters/Universe.png',
        category: 'Digital Art',
      ),
      PosterModel(
        id: '7',
        title: 'Wings of Vigil',
        description:
            'An artistic representation of strength, freedom, and watchful awareness.',
        imageUrl: 'assets/posters/wings_of_vigil.png',
        category: 'Digital Art',
      ),
    ];
  }
}

// ============================================================================
// THEME
// ============================================================================

class OceanColors {
  // Base (unshifted) colors
  static const Color _baseAccent = Color(0xFF64b4dc);
  static const Color _baseAccentLight = Color(0xFF8ed0f0);
  static const Color _baseAccentDark = Color(0xFF4696c0);
  static const Color _baseSurfaceLight = Color(0xFF1a2a4a);
  static const Color _baseSurfaceDark = Color(0xFF0a1428);
  static const Color _baseCardBackground = Color(0xFF0d1a30);
  static const Color _baseOceanBlue = Color(0xFF09173A);
  static const Color _baseDarkNavy = Color(0xFF010c1b);
  static const Color _baseDeepOcean = Color(0xFF00060d);
  static const Color _baseParticleGlow = Color(0x3364b4dc);

  /// Set this from the widget tree so the static getters can shift hue.
  static HueService? _hueService;
  static void bind(HueService service) => _hueService = service;

  static Color _shift(Color c) => _hueService?.shiftColor(c) ?? c;

  static Color get darkNavy => _shift(_baseDarkNavy);
  static Color get oceanBlue => _shift(_baseOceanBlue);
  static Color get deepOcean => _shift(_baseDeepOcean);
  static Color get accent => _shift(_baseAccent);
  static Color get accentLight => _shift(_baseAccentLight);
  static Color get accentDark => _shift(_baseAccentDark);
  static Color get surfaceLight => _shift(_baseSurfaceLight);
  static Color get surfaceDark => _shift(_baseSurfaceDark);
  static Color get cardBackground => _shift(_baseCardBackground);
  static Color get particleGlow => _shift(_baseParticleGlow);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textMuted = Color(0xFF808080);
  static const Color error = Color(0xFFE0380B);
  static const Color success = Color(0xFF4CAF50);
}

class OceanTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: OceanColors.accent,
        secondary: OceanColors.accentLight,
        surface: OceanColors.oceanBlue,
        error: OceanColors.error,
        onPrimary: OceanColors.darkNavy,
        onSecondary: OceanColors.darkNavy,
        onSurface: OceanColors.textPrimary,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: OceanColors.darkNavy,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: OceanColors.textPrimary,
        ),
        iconTheme: IconThemeData(color: OceanColors.accent),
      ),
      cardTheme: CardThemeData(
        color: OceanColors.cardBackground,
        elevation: 8,
        shadowColor: OceanColors.accent.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: OceanColors.accent.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: OceanColors.accent,
          foregroundColor: OceanColors.darkNavy,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: OceanColors.accent,
          textStyle: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: OceanColors.accent,
          side: BorderSide(color: OceanColors.accent, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: OceanColors.surfaceDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: OceanColors.accent.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: OceanColors.accent.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: OceanColors.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: OceanColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: OceanColors.error, width: 2),
        ),
        labelStyle: GoogleFonts.roboto(color: OceanColors.textSecondary),
        hintStyle: GoogleFonts.roboto(color: OceanColors.textMuted),
        errorStyle: GoogleFonts.roboto(color: OceanColors.error),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: OceanColors.accent,
        foregroundColor: OceanColors.darkNavy,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: OceanColors.oceanBlue,
        selectedItemColor: OceanColors.accent,
        unselectedItemColor: OceanColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 16,
        selectedLabelStyle: GoogleFonts.roboto(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.roboto(),
      ),
      drawerTheme: DrawerThemeData(backgroundColor: OceanColors.oceanBlue),
      dialogTheme: DialogThemeData(
        backgroundColor: OceanColors.cardBackground,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: OceanColors.accent.withValues(alpha: 0.3)),
        ),
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: OceanColors.textPrimary,
        ),
        contentTextStyle: GoogleFonts.roboto(
          fontSize: 16,
          color: OceanColors.textSecondary,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: OceanColors.surfaceLight,
        selectedColor: OceanColors.accent,
        labelStyle: GoogleFonts.roboto(color: OceanColors.textPrimary),
        secondaryLabelStyle: GoogleFonts.roboto(color: OceanColors.darkNavy),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: OceanColors.accent.withValues(alpha: 0.2),
        iconColor: OceanColors.accent,
        textColor: OceanColors.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerTheme: DividerThemeData(
        color: OceanColors.accent.withValues(alpha: 0.2),
        thickness: 1,
      ),
      iconTheme: IconThemeData(color: OceanColors.accent, size: 24),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: OceanColors.textPrimary,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: OceanColors.textPrimary,
        ),
        displaySmall: GoogleFonts.playfairDisplay(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: OceanColors.textPrimary,
        ),
        headlineLarge: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: OceanColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: OceanColors.textPrimary,
        ),
        headlineSmall: GoogleFonts.playfairDisplay(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: OceanColors.textPrimary,
        ),
        titleLarge: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: OceanColors.textPrimary,
        ),
        titleMedium: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: OceanColors.textPrimary,
        ),
        titleSmall: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: OceanColors.textSecondary,
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 16,
          color: OceanColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 14,
          color: OceanColors.textSecondary,
        ),
        bodySmall: GoogleFonts.roboto(
          fontSize: 12,
          color: OceanColors.textMuted,
        ),
        labelLarge: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: OceanColors.textPrimary,
        ),
        labelMedium: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: OceanColors.textSecondary,
        ),
        labelSmall: GoogleFonts.roboto(
          fontSize: 10,
          color: OceanColors.textMuted,
        ),
      ),
    );
  }
}

class OceanGradients {
  static LinearGradient get backgroundGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      OceanColors.darkNavy,
      OceanColors.oceanBlue,
      OceanColors.deepOcean,
    ],
  );

  static LinearGradient get cardGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [OceanColors.surfaceLight, OceanColors.cardBackground],
  );
}

// ============================================================================
// SERVICES
// ============================================================================

class DataService extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  List<FriendModel> _friends = [];
  List<FriendModel> get friends => _friends;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ProfileModel _profile = ProfileModel.defaultProfile();
  ProfileModel get profile => _profile;

  DataService() {
    loadProfile();
    fetchFriends();
  }

  Future<void> fetchFriends() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase
          .from('friends')
          .select()
          .order('created_at', ascending: false);

      final data = response as List<dynamic>;
      _friends = data.map((json) => FriendModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching friends: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFriend(FriendModel friend) async {
    try {
      final response = await _supabase
          .from('friends')
          .insert(friend.toJson())
          .select()
          .single();

      final newFriend = FriendModel.fromJson(response);
      _friends.insert(0, newFriend);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding friend: $e');
    }
  }

  Future<void> updateFriend(FriendModel friend) async {
    if (friend.id == null) return;

    try {
      await _supabase
          .from('friends')
          .update(friend.toJson())
          .eq('id', friend.id!);

      final index = _friends.indexWhere((f) => f.id == friend.id);
      if (index != -1) {
        _friends[index] = friend;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating friend: $e');
    }
  }

  Future<void> deleteFriend(String id) async {
    try {
      await _supabase.from('friends').delete().eq('id', id);

      _friends.removeWhere((f) => f.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting friend: $e');
    }
  }

  Future<void> updateProfile(ProfileModel newProfile) async {
    try {
      // Update local profile
      _profile = newProfile;

      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_data', jsonEncode(_profile.toJson()));

      notifyListeners();
    } catch (e) {
      debugPrint('Error updating profile: $e');
      rethrow;
    }
  }

  Future<void> deleteProfileData() async {
    try {
      // Reset to default profile
      _profile = ProfileModel.defaultProfile();

      // Clear from local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('profile_data');

      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting profile data: $e');
      rethrow;
    }
  }

  Future<void> loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString('profile_data');

      if (profileJson != null) {
        _profile = ProfileModel.fromJson(jsonDecode(profileJson));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }
  }
}

class HueService extends ChangeNotifier {
  double _hueShift = 0.0;
  static const double defaultHue = 0.0;

  double get hueShift => _hueShift;

  HueService() {
    _loadHue();
  }

  Future<void> _loadHue() async {
    final prefs = await SharedPreferences.getInstance();
    _hueShift = prefs.getDouble('hue_shift') ?? 0.0;
    notifyListeners();
  }

  Future<void> setHue(double value) async {
    _hueShift = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('hue_shift', value);
  }

  Future<void> resetHue() async {
    _hueShift = defaultHue;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('hue_shift');
  }

  /// Shift any color's hue by the current offset.
  Color shiftColor(Color color) {
    if (_hueShift == 0.0) return color;
    final hsl = HSLColor.fromColor(color);
    final newHue = (hsl.hue + _hueShift) % 360.0;
    return hsl.withHue(newHue).toColor();
  }
}

// ============================================================================
// WIDGETS
// ============================================================================

class OceanBackground extends StatelessWidget {
  final Widget child;
  final bool showParticles;

  const OceanBackground({
    super.key,
    required this.child,
    this.showParticles = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: OceanGradients.backgroundGradient),
      child: Stack(
        children: [
          if (showParticles) const Positioned.fill(child: OceanParticles()),
          child,
        ],
      ),
    );
  }
}

class OceanParticles extends StatefulWidget {
  final int particleCount;

  const OceanParticles({super.key, this.particleCount = 30});

  @override
  State<OceanParticles> createState() => _OceanParticlesState();
}

class _OceanParticlesState extends State<OceanParticles>
    with TickerProviderStateMixin {
  late List<Particle> particles;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    particles = List.generate(
      widget.particleCount,
      (index) => Particle.random(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(particles, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  double size;
  double speed;
  double opacity;
  double drift;
  double phase;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.drift,
    required this.phase,
  });

  factory Particle.random() {
    final random = Random();
    return Particle(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: 2 + random.nextDouble() * 6,
      speed: 0.1 + random.nextDouble() * 0.3,
      opacity: 0.2 + random.nextDouble() * 0.5,
      drift: random.nextDouble() * 2 * pi,
      phase: random.nextDouble() * 2 * pi,
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final progress = (animationValue + particle.phase) % 1.0;
      final y = size.height * (1 - progress * particle.speed * 3);
      final driftAmount = sin(progress * 2 * pi + particle.drift) * 30;
      final x = particle.x * size.width + driftAmount;

      // Calculate fade for smoother transitions
      final fadeProgress = progress < 0.1
          ? progress / 0.1
          : progress > 0.9
          ? (1 - progress) / 0.1
          : 1.0;

      // Outer glow
      final paint = Paint()
        ..color = OceanColors.accent.withValues(
          alpha: particle.opacity * fadeProgress,
        )
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, particle.size * 0.5);

      canvas.drawCircle(Offset(x, y), particle.size, paint);

      // Inner bright spot
      final innerPaint = Paint()
        ..color = OceanColors.accentLight.withValues(
          alpha: particle.opacity * fadeProgress * 0.5,
        );

      canvas.drawCircle(Offset(x, y), particle.size * 0.5, innerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}

class OceanCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final double? borderRadius;
  final bool showGlow;

  const OceanCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius,
    this.showGlow = false,
  });

  @override
  State<OceanCard> createState() => _OceanCardState();
}

class _OceanCardState extends State<OceanCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          widget.margin ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
            boxShadow: [
              BoxShadow(
                color: OceanColors.accent.withValues(
                  alpha: (_isHovered || widget.showGlow) ? 0.4 : 0.1,
                ),
                blurRadius: _isHovered ? 25 : 10,
                spreadRadius: _isHovered ? 4 : 0,
              ),
            ],
          ),
          child: Transform.scale(
            scale: _isHovered ? 1.02 : 1.0,
            child: Transform.translate(
              offset: _isHovered ? const Offset(0, -4) : Offset.zero,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? 16,
                  ),
                  splashColor: OceanColors.accent.withValues(alpha: 0.2),
                  child: Container(
                    padding: widget.padding ?? const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: _isHovered
                            ? [
                                OceanColors.surfaceLight.withValues(alpha: 0.9),
                                OceanColors.oceanBlue,
                              ]
                            : [
                                OceanColors.surfaceLight,
                                OceanColors.cardBackground,
                              ],
                      ),
                      borderRadius: BorderRadius.circular(
                        widget.borderRadius ?? 16,
                      ),
                      border: Border.all(
                        color: _isHovered
                            ? OceanColors.accent
                            : OceanColors.accent.withValues(alpha: 0.2),
                        width: _isHovered ? 1.5 : 1,
                      ),
                    ),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OceanChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;

  const OceanChip({
    super.key,
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? OceanColors.accent
              : OceanColors.surfaceLight.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? OceanColors.accent
                : OceanColors.accent.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: selected ? OceanColors.darkNavy : OceanColors.accent,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? OceanColors.darkNavy
                    : OceanColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OceanButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;

  const OceanButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
  });

  @override
  State<OceanButton> createState() => _OceanButtonState();
}

class _OceanButtonState extends State<OceanButton>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _hoverController;
  late AnimationController _pressController;
  late Animation<double> _glowAnimation;
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _hoverController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _onHoverEnter() {
    setState(() => _isHovered = true);
    _hoverController.forward();
  }

  void _onHoverExit() {
    setState(() => _isHovered = false);
    _hoverController.reverse();
  }

  void _onPressed() {
    if (!widget.isLoading) {
      _pressController.forward().then((_) => _pressController.reverse());
      widget.onPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isOutlined) {
      return _buildOutlinedButton();
    }
    return _buildFilledButton();
  }

  Widget _buildOutlinedButton() {
    return MouseRegion(
      onEnter: (_) => _onHoverEnter(),
      onExit: (_) => _onHoverExit(),
      cursor: widget.isLoading
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : (_isHovered ? 1.08 : 1.0),
          duration: const Duration(milliseconds: 150),
          child: OutlinedButton(
            onPressed: widget.isLoading ? null : _onPressed,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: _isHovered
                    ? OceanColors.accentLight
                    : OceanColors.accent,
                width: _isHovered ? 2.5 : 2,
              ),
            ),
            child: _buildButtonContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildFilledButton() {
    return MouseRegion(
      onEnter: (_) => _onHoverEnter(),
      onExit: (_) => _onHoverExit(),
      cursor: widget.isLoading
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _glowAnimation,
            _hoverController,
            _pressController,
          ]),
          builder: (context, child) {
            final scale =
                1.0 +
                (_hoverController.value * 0.08) +
                (_pressController.value * 0.03);
            final glowIntensity = _isHovered
                ? _glowAnimation.value * 1.3
                : _glowAnimation.value;
            final blurAmount = 15 + (_hoverController.value * 15);

            return Transform.scale(
              scale: _isPressed ? 0.95 : scale,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: OceanColors.accent.withValues(
                        alpha: glowIntensity * 0.6,
                      ),
                      blurRadius: blurAmount,
                      spreadRadius: 2 + (_hoverController.value * 3),
                    ),
                    if (_isHovered)
                      BoxShadow(
                        color: OceanColors.accentLight.withValues(
                          alpha: glowIntensity * 0.3,
                        ),
                        blurRadius: blurAmount * 0.5,
                        spreadRadius: 1,
                      ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: widget.isLoading ? null : _onPressed,
                  style: ElevatedButton.styleFrom(
                    elevation: _isHovered ? 12 : 4,
                  ),
                  child: _buildButtonContent(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (widget.isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: 20),
          const SizedBox(width: 8),
        ],
        Text(widget.label),
      ],
    );
  }
}

class CircleNavButton extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const CircleNavButton({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  State<CircleNavButton> createState() => _CircleNavButtonState();
}

class _CircleNavButtonState extends State<CircleNavButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 768;
    final baseSize = isWeb ? 180.0 : 140.0;
    final hoverSize = isWeb ? 200.0 : 150.0;
    final baseIconSize = isWeb ? 42.0 : 32.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutBack,
              width: _isHovered ? hoverSize : baseSize,
              height: _isHovered ? hoverSize : baseSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _isHovered
                        ? OceanColors.accent.withValues(alpha: 0.6)
                        : OceanColors.accent.withValues(alpha: 0.3),
                    OceanColors.oceanBlue.withValues(alpha: 0.8),
                  ],
                ),
                border: Border.all(
                  color: _isHovered
                      ? OceanColors.accentLight
                      : OceanColors.accent.withValues(alpha: 0.5),
                  width: _isHovered ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: OceanColors.accent.withValues(
                      alpha: _isHovered
                          ? (_glowAnimation.value * 0.7)
                          : (_glowAnimation.value * 0.3),
                    ),
                    blurRadius: _isHovered
                        ? (30 + (_glowAnimation.value * 20))
                        : (20 + (_glowAnimation.value * 10)),
                    spreadRadius: _isHovered
                        ? (5 + (_glowAnimation.value * 3))
                        : (2 + (_glowAnimation.value * 2)),
                  ),
                  if (_isHovered)
                    BoxShadow(
                      color: OceanColors.accentLight.withValues(
                        alpha: _glowAnimation.value * 0.4,
                      ),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedRotation(
                    turns: _isHovered ? 0.08 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: AnimatedScale(
                      scale: _isHovered ? 1.15 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        widget.icon,
                        color: _isHovered ? Colors.white : OceanColors.accent,
                        size: baseIconSize,
                      ),
                    ),
                  ),
                  SizedBox(height: isWeb ? 12 : 8),
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isWeb ? 16 : 14,
                    ),
                  ),
                  SizedBox(height: isWeb ? 6 : 4),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _isHovered ? 1.0 : 0.7,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWeb ? 16 : 12,
                      ),
                      child: Text(
                        widget.description,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: isWeb ? 11 : 9,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class OceanDialogs {
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    IconData? icon,
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isDangerous ? OceanColors.error : OceanColors.accent)
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isDangerous ? OceanColors.error : OceanColors.accent,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: isDangerous
                ? ElevatedButton.styleFrom(backgroundColor: OceanColors.error)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: OceanColors.success.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.check_circle, color: OceanColors.success),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static Future<void> showError({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: OceanColors.error.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.error_outline, color: OceanColors.error),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SCREENS
// ============================================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://esumhbmbcvwoibbowtzp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVzdW1oYm1iY3Z3b2liYm93dHpwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA2MzIwNzEsImV4cCI6MjA4NjIwODA3MX0.Bv5AW17civ5QAuV3AoBG7R-7iXvEVxMMNDzUp0YeiCk',
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataService()),
        ChangeNotifierProvider(create: (_) => HueService()),
      ],
      child: const PortfolioApp(),
    ),
  );
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataService()),
        ChangeNotifierProvider(create: (_) => HueService()),
      ],
      child: Consumer<HueService>(
        builder: (context, hueService, _) {
          OceanColors.bind(hueService);
          return MaterialApp(
            title: 'Portfolio - Sheila Nicole Cheng',
            debugShowCheckedModeBanner: false,
            theme: OceanTheme.theme,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen width and calculate a scaling factor for Web
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWeb = screenWidth > 600;
    // Scale everything up by 1.25x on larger screens
    final double scale = isWeb ? 1.25 : 1.0;

    return Scaffold(
      body: OceanBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(scale), // Pass scale to header
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24 * scale),
                  child: Column(
                    children: [
                      SizedBox(height: 40 * scale),
                      _buildTitleSection(scale), // Pass scale to title
                      SizedBox(height: 60 * scale),
                      _buildNavigationCircles(
                        scale,
                        isWeb,
                      ), // Pass scale to nav
                      SizedBox(height: 40 * scale),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double scale) {
    return Padding(
      padding: EdgeInsets.all(20 * scale),
      child: Row(
        // Changed to end alignment since we removed the left home button
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              _buildSocialButton(Icons.email, 'Email', scale),
              SizedBox(width: 12 * scale),
              _buildSocialButton(Icons.business, 'LinkedIn', scale),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String tooltip, double scale) {
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: EdgeInsets.all(12 * scale),
        decoration: BoxDecoration(
          color: OceanColors.surfaceLight.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12 * scale),
          border: Border.all(color: OceanColors.accent.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: OceanColors.accent, size: 20 * scale),
      ),
    );
  }

  Widget _buildTitleSection(double scale) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            Text(
              'S.CHENG',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize:
                    (Theme.of(context).textTheme.displayLarge?.fontSize ?? 57) *
                    scale,
                letterSpacing: 8 * scale,
                fontWeight: FontWeight.w800,
                shadows: [
                  Shadow(
                    color: OceanColors.accent.withValues(alpha: 0.5),
                    blurRadius: 20 * scale,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16 * scale),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  OceanColors.accent,
                  OceanColors.accentLight,
                  OceanColors.accent,
                ],
              ).createShader(bounds),
              child: Text(
                'Sheila Nicole Cheng',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize:
                      (Theme.of(context).textTheme.headlineMedium?.fontSize ??
                          28) *
                      scale,
                  color: Colors.white,
                  letterSpacing: 2 * scale,
                ),
              ),
            ),
            SizedBox(height: 24 * scale),
            Text(
              'Creative Developer & Designer',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize:
                    (Theme.of(context).textTheme.bodyLarge?.fontSize ?? 16) *
                    scale,
                color: OceanColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCircles(double scale, bool isWeb) {
    final spacing = isWeb ? 40.0 * scale : 20.0;
    final maxWidth = isWeb ? 1000.0 * scale : double.infinity;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Wrap(
              spacing: spacing,
              runSpacing: spacing,
              alignment: WrapAlignment.center,
              children: [
                _buildAnimatedCircle(
                  delay: 0.3,
                  child: Transform.scale(
                    scale: scale, // Scales the entire button widget
                    child: CircleNavButton(
                      title: 'Profile',
                      description: 'Get to know me & what I\'m all about',
                      icon: Icons.person,
                      onTap: () => _navigateTo(const ProfileScreen()),
                    ),
                  ),
                ),
                _buildAnimatedCircle(
                  delay: 0.4,
                  child: Transform.scale(
                    scale: scale,
                    child: CircleNavButton(
                      title: 'Projects',
                      description: 'Explore my creative journey & portfolio',
                      icon: Icons.work,
                      onTap: () => _navigateTo(const ProjectsScreen()),
                    ),
                  ),
                ),
                _buildAnimatedCircle(
                  delay: 0.5,
                  child: Transform.scale(
                    scale: scale,
                    child: CircleNavButton(
                      title: 'Posters',
                      description: 'Vibrant graphics & eye-catching designs',
                      icon: Icons.image,
                      onTap: () => _navigateTo(const PostersScreen()),
                    ),
                  ),
                ),
                _buildAnimatedCircle(
                  delay: 0.6,
                  child: Transform.scale(
                    scale: scale,
                    child: CircleNavButton(
                      title: 'Contacts',
                      description:
                          'Reach out & let\'s create something amazing',
                      icon: Icons.contact_mail,
                      onTap: () => _navigateTo(const ContactsScreen()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedCircle({required double delay, required Widget child}) {
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(delay, delay + 0.3, curve: Curves.easeOutBack),
    );

    return ScaleTransition(
      scale: animation,
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  void _navigateTo(Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OceanBackground(
        child: SafeArea(
          child: Consumer<DataService>(
            builder: (context, dataService, child) {
              final profile = dataService.profile;
              return CustomScrollView(
                slivers: [
                  _buildAppBar(context),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      // LayoutBuilder detects screen width for responsiveness
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 600) {
                            // DESKTOP/WIDE VIEW: Side-by-side layout
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      _buildProfileHeader(context, profile),
                                      const SizedBox(height: 32),
                                      _buildActionButtons(context),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 32),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      _buildBioSection(context, profile),
                                      const SizedBox(height: 24),
                                      _buildContactSection(context, profile),
                                      const SizedBox(height: 24),
                                      _buildSkillsSection(context, profile),
                                      const SizedBox(height: 24),
                                      _buildHobbiesInterestsSection(
                                        context,
                                        profile,
                                      ),
                                      const SizedBox(height: 40),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            // MOBILE VIEW: Original vertical stack
                            return Column(
                              children: [
                                _buildProfileHeader(context, profile),
                                const SizedBox(height: 32),
                                _buildBioSection(context, profile),
                                const SizedBox(height: 24),
                                _buildContactSection(context, profile),
                                const SizedBox(height: 24),
                                _buildSkillsSection(context, profile),
                                const SizedBox(height: 24),
                                _buildHobbiesInterestsSection(context, profile),
                                const SizedBox(height: 24),
                                _buildActionButtons(context),
                                const SizedBox(height: 40),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: OceanColors.surfaceLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.arrow_back, color: OceanColors.accent),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: OceanColors.surfaceLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.settings, color: OceanColors.accent),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingsScreen()),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context, ProfileModel profile) {
    return Column(
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                OceanColors.accent.withValues(alpha: 0.3),
                OceanColors.oceanBlue,
              ],
            ),
            border: Border.all(color: OceanColors.accent, width: 3),
            boxShadow: [
              BoxShadow(
                color: OceanColors.accent.withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipOval(
            child: profile.profileImagePath != null
                ? (profile.profileImagePath!.startsWith('assets/')
                      ? Image.asset(
                          profile.profileImagePath!,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(profile.profileImagePath!),
                          fit: BoxFit.cover,
                        ))
                : Icon(Icons.person, size: 70, color: OceanColors.accent),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          profile.name,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            shadows: [
              Shadow(
                color: OceanColors.accent.withValues(alpha: 0.5),
                blurRadius: 10,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Creative Developer & Designer',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: OceanColors.accent),
        ),
      ],
    );
  }

  Widget _buildBioSection(BuildContext context, ProfileModel profile) {
    return OceanCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: OceanColors.accent),
              const SizedBox(width: 12),
              Text(
                'About Me',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            profile.bio,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context, ProfileModel profile) {
    return OceanCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.contact_mail, color: OceanColors.accent),
              const SizedBox(width: 12),
              Text(
                'Contact Information',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildContactItem(Icons.email, profile.email),
          const SizedBox(height: 12),
          _buildContactItem(Icons.phone, profile.phone),
          const SizedBox(height: 12),
          _buildContactItem(Icons.business, 'LinkedIn Profile'),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: OceanColors.accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: OceanColors.accent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: OceanColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSection(BuildContext context, ProfileModel profile) {
    return OceanCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.code, color: OceanColors.accent),
              const SizedBox(width: 12),
              Text('Skills', style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: profile.skills
                .map((skill) => OceanChip(label: skill))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHobbiesInterestsSection(
    BuildContext context,
    ProfileModel profile,
  ) {
    return Column(
      children: [
        OceanCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.favorite, color: OceanColors.accent),
                  const SizedBox(width: 12),
                  Text(
                    'Hobbies',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: profile.hobbies
                    .map(
                      (hobby) =>
                          OceanChip(label: hobby, icon: Icons.favorite_border),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        OceanCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: OceanColors.accent),
                  const SizedBox(width: 12),
                  Text(
                    'Interests',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: profile.interests
                    .map(
                      (interest) =>
                          OceanChip(label: interest, icon: Icons.star_border),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OceanButton(
            label: 'Edit Profile',
            icon: Icons.edit,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditProfileScreen()),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OceanButton(
            label: 'Friends List',
            icon: Icons.people,
            isOutlined: true,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FriendsScreen()),
            ),
          ),
        ),
      ],
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _linkedInController;
  late TextEditingController _skillsController;
  late TextEditingController _hobbiesController;
  late TextEditingController _interestsController;
  String? _profileImagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final profile = context.read<DataService>().profile;
    _nameController = TextEditingController(text: profile.name);
    _bioController = TextEditingController(text: profile.bio);
    _emailController = TextEditingController(text: profile.email);
    _phoneController = TextEditingController(text: profile.phone);
    _linkedInController = TextEditingController(text: profile.linkedIn);
    _skillsController = TextEditingController(text: profile.skills.join(', '));
    _hobbiesController = TextEditingController(
      text: profile.hobbies.join(', '),
    );
    _interestsController = TextEditingController(
      text: profile.interests.join(', '),
    );
    _profileImagePath = profile.profileImagePath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _linkedInController.dispose();
    _skillsController.dispose();
    _hobbiesController.dispose();
    _interestsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OceanBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                title: const Text('Edit Profile'),
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: OceanColors.surfaceLight.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.arrow_back, color: OceanColors.accent),
                  ),
                  onPressed: () => _handleBack(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfilePictureSection(),
                        const SizedBox(height: 32),
                        _buildSectionTitle('Personal Information'),
                        const SizedBox(height: 16),
                        _buildNameField(),
                        const SizedBox(height: 16),
                        _buildBioField(),
                        const SizedBox(height: 32),
                        _buildSectionTitle('Contact Information'),
                        const SizedBox(height: 16),
                        _buildEmailField(),
                        const SizedBox(height: 16),
                        _buildPhoneField(),
                        const SizedBox(height: 16),
                        _buildLinkedInField(),
                        const SizedBox(height: 32),
                        _buildSectionTitle('Skills & Interests'),
                        const SizedBox(height: 16),
                        _buildSkillsField(),
                        const SizedBox(height: 16),
                        _buildHobbiesField(),
                        const SizedBox(height: 16),
                        _buildInterestsField(),
                        const SizedBox(height: 40),
                        _buildActionButtons(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.headlineMedium?.copyWith(color: OceanColors.accent),
    );
  }

  Widget _buildProfilePictureSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    OceanColors.accent.withValues(alpha: 0.3),
                    OceanColors.oceanBlue,
                  ],
                ),
                border: Border.all(color: OceanColors.accent, width: 3),
              ),
              child: ClipOval(
                child: _profileImagePath != null
                    ? (_profileImagePath!.startsWith('assets/')
                          ? Image.asset(_profileImagePath!, fit: BoxFit.cover)
                          : Image.file(
                              File(_profileImagePath!),
                              fit: BoxFit.cover,
                            ))
                    : Icon(Icons.person, size: 60, color: OceanColors.accent),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Change Photo'),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() => TextFormField(
    controller: _nameController,
    decoration: const InputDecoration(
      labelText: 'Full Name',
      hintText: 'Enter your full name',
      prefixIcon: Icon(Icons.person),
    ),
    validator: (value) {
      if (value == null || value.trim().isEmpty) return 'Name is required';
      if (value.trim().length < 2) return 'Name must be at least 2 characters';
      return null;
    },
    textInputAction: TextInputAction.next,
  );

  Widget _buildBioField() => TextFormField(
    controller: _bioController,
    decoration: const InputDecoration(
      labelText: 'Bio',
      hintText: 'Tell us about yourself',
      prefixIcon: Icon(Icons.info_outline),
      alignLabelWithHint: true,
    ),
    maxLines: 4,
    validator: (value) {
      if (value == null || value.trim().isEmpty) return 'Bio is required';
      if (value.trim().length < 10) return 'Bio must be at least 10 characters';
      return null;
    },
  );

  Widget _buildEmailField() => TextFormField(
    controller: _emailController,
    decoration: const InputDecoration(
      labelText: 'Email',
      hintText: 'Enter your email address',
      prefixIcon: Icon(Icons.email),
    ),
    keyboardType: TextInputType.emailAddress,
    validator: (value) {
      if (value == null || value.trim().isEmpty) return 'Email is required';
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value.trim()))
        return 'Please enter a valid email address';
      return null;
    },
    textInputAction: TextInputAction.next,
  );

  Widget _buildPhoneField() => TextFormField(
    controller: _phoneController,
    decoration: const InputDecoration(
      labelText: 'Phone',
      hintText: 'Enter your phone number',
      prefixIcon: Icon(Icons.phone),
    ),
    keyboardType: TextInputType.phone,
    validator: (value) {
      if (value == null || value.trim().isEmpty)
        return 'Phone number is required';
      return null;
    },
    textInputAction: TextInputAction.next,
  );

  Widget _buildLinkedInField() => TextFormField(
    controller: _linkedInController,
    decoration: const InputDecoration(
      labelText: 'LinkedIn URL',
      hintText: 'Enter your LinkedIn profile URL',
      prefixIcon: Icon(Icons.business),
    ),
    keyboardType: TextInputType.url,
    textInputAction: TextInputAction.next,
  );

  Widget _buildSkillsField() => TextFormField(
    controller: _skillsController,
    decoration: const InputDecoration(
      labelText: 'Skills',
      hintText: 'Enter skills separated by commas',
      prefixIcon: Icon(Icons.code),
      helperText: 'e.g., Flutter, Web Development, UI Design',
    ),
    validator: (value) {
      if (value == null || value.trim().isEmpty)
        return 'Please enter at least one skill';
      return null;
    },
  );

  Widget _buildHobbiesField() => TextFormField(
    controller: _hobbiesController,
    decoration: const InputDecoration(
      labelText: 'Hobbies',
      hintText: 'Enter hobbies separated by commas',
      prefixIcon: Icon(Icons.favorite),
      helperText: 'e.g., Photography, Reading, Gaming',
    ),
  );

  Widget _buildInterestsField() => TextFormField(
    controller: _interestsController,
    decoration: const InputDecoration(
      labelText: 'Interests',
      hintText: 'Enter interests separated by commas',
      prefixIcon: Icon(Icons.star),
      helperText: 'e.g., Technology, Art, Music',
    ),
  );

  Widget _buildActionButtons() => Column(
    children: [
      SizedBox(
        width: double.infinity,
        child: OceanButton(
          label: 'Save Changes',
          icon: Icons.save,
          isLoading: _isLoading,
          onPressed: _saveProfile,
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        width: double.infinity,
        child: OceanButton(
          label: 'Reset to Default',
          icon: Icons.refresh,
          isOutlined: true,
          onPressed: _resetProfile,
        ),
      ),
    ],
  );

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _profileImagePath = image.path);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final dataService = context.read<DataService>();

    final confirmed = await OceanDialogs.showConfirmation(
      context: context,
      title: 'Save Changes',
      message: 'Are you sure you want to save these changes to your profile?',
      icon: Icons.save,
      confirmText: 'Save',
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      final profile = ProfileModel(
        name: _nameController.text.trim(),
        bio: _bioController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        linkedIn: _linkedInController.text.trim(),
        profileImagePath: _profileImagePath,
        skills: _parseCommaSeparated(_skillsController.text),
        hobbies: _parseCommaSeparated(_hobbiesController.text),
        interests: _parseCommaSeparated(_interestsController.text),
      );

      await dataService.updateProfile(profile);

      if (mounted) {
        await OceanDialogs.showSuccess(
          context: context,
          title: 'Success',
          message: 'Your profile has been updated successfully!',
        );
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        await OceanDialogs.showError(
          context: context,
          title: 'Error',
          message: 'Failed to save profile. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetProfile() async {
    final confirmed = await OceanDialogs.showConfirmation(
      context: context,
      title: 'Reset Profile',
      message:
          'Are you sure you want to reset your profile to default values? This action cannot be undone.',
      icon: Icons.refresh,
      confirmText: 'Reset',
      isDangerous: true,
    );

    if (confirmed != true) return;

    final defaultProfile = ProfileModel.defaultProfile();
    setState(() {
      _nameController.text = defaultProfile.name;
      _bioController.text = defaultProfile.bio;
      _emailController.text = defaultProfile.email;
      _phoneController.text = defaultProfile.phone;
      _linkedInController.text = defaultProfile.linkedIn;
      _skillsController.text = defaultProfile.skills.join(', ');
      _hobbiesController.text = defaultProfile.hobbies.join(', ');
      _interestsController.text = defaultProfile.interests.join(', ');
      _profileImagePath = null;
    });
  }

  Future<void> _handleBack() async {
    final confirmed = await OceanDialogs.showConfirmation(
      context: context,
      title: 'Discard Changes?',
      message:
          'Are you sure you want to go back? Any unsaved changes will be lost.',
      icon: Icons.warning,
      confirmText: 'Discard',
      cancelText: 'Stay',
    );

    if (confirmed == true && mounted) Navigator.pop(context);
  }

  List<String> _parseCommaSeparated(String text) {
    return text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }
}

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  Timer? _carouselTimer;
  int _currentPage = 10000;

  // Your 4 projects
  final List<ProjectModel> _projects = ProjectModel.sampleProjects()
      .take(4)
      .toList();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: _currentPage,
    );
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(
      const Duration(seconds: 4),
      (timer) => _moveNext(),
    );
  }

  void _moveNext() {
    if (_pageController.hasClients) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _moveBack() {
    if (_pageController.hasClients) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  // SHOW DETAILS VIEW
  void _showProjectDetails(ProjectModel project) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: OceanColors.darkNavy.withValues(alpha: 0.9),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            border: Border.all(
              color: OceanColors.accent.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: 'title_${project.title}',
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            project.title,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        project.category,
                        style: TextStyle(
                          color: OceanColors.accent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "PROJECT DESCRIPTION",
                        style: TextStyle(
                          color: Colors.white54,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        project.description,
                        style: const TextStyle(
                          color: OceanColors.textSecondary,
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "BUILT WITH",
                        style: TextStyle(
                          color: Colors.white54,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: project.technologies
                            .map(
                              (tech) => Chip(
                                label: Text(
                                  tech,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                backgroundColor: OceanColors.surfaceLight
                                    .withValues(alpha: 0.3),
                                side: BorderSide(
                                  color: OceanColors.accent.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OceanBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context),
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 10, 24, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Featured Work',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'A selection of my recent projects',
                        style: TextStyle(
                          color: OceanColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                // CAROUSEL
                SizedBox(
                  height: 480,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) => _currentPage = index,
                        itemBuilder: (context, index) {
                          final project = _projects[index % _projects.length];
                          return AnimatedBuilder(
                            animation: _pageController,
                            builder: (context, child) {
                              double value = 1.0;
                              if (_pageController.position.haveDimensions) {
                                value = (_pageController.page! - index);
                                value = (1 - (value.abs() * 0.15)).clamp(
                                  0.8,
                                  1.0,
                                );
                              }
                              return Center(
                                child: Transform.scale(
                                  scale: value,
                                  child: _buildProjectCard(project),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      Positioned(
                        left: 10,
                        child: _navArrow(Icons.chevron_left, _moveBack),
                      ),
                      Positioned(
                        right: 10,
                        child: _navArrow(Icons.chevron_right, _moveNext),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),
                const Center(
                  child: Text(
                    " ",
                    style: TextStyle(color: OceanColors.textMuted),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getProjectColor(String projectId) {
    switch (projectId) {
      case '1': // Portfolio
        return const Color(0xFF4A90E2);
      case '2': // ContextuFile
        return const Color(0xFF50C878);
      case '3': // VisiTrack
        return const Color(0xFFE67E22);
      case '4': // RISE PH
        return const Color(0xFFE74C3C);
      default:
        return OceanColors.accent;
    }
  }

  Widget _buildProjectCard(ProjectModel project) {
    final projectColor = _getProjectColor(project.id);
    return GestureDetector(
      onTap: () => _showProjectDetails(project),
      child: OceanCard(
        showGlow: true,
        borderRadius: 24,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      projectColor.withValues(alpha: 0.2),
                      projectColor.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: project.imageUrl != null
                    ? Padding(
                        padding: const EdgeInsets.all(20),
                        child: Image.asset(
                          project.imageUrl!,
                          fit: BoxFit.contain,
                        ),
                      )
                    : Icon(
                        Icons.folder_open_rounded,
                        color: projectColor,
                        size: 50,
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Hero(
              tag: 'title_${project.title}',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  project.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              project.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: OceanColors.textSecondary),
            ),
            const SizedBox(height: 15),
            Text(
              "Tap for details +",
              style: TextStyle(
                color: OceanColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navArrow(IconData icon, VoidCallback action) {
    return Container(
      decoration: BoxDecoration(
        color: OceanColors.oceanBlue.withValues(alpha: 0.7),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: OceanColors.accent, size: 28),
        onPressed: () {
          action();
          _startAutoPlay();
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: OceanColors.accent),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}

class PostersScreen extends StatefulWidget {
  const PostersScreen({super.key});

  @override
  State<PostersScreen> createState() => _PostersScreenState();
}

class _PostersScreenState extends State<PostersScreen>
    with TickerProviderStateMixin {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Digital Art'];
  late AnimationController _fadeInController;

  @override
  void initState() {
    super.initState();
    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeInController.forward();
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    super.dispose();
  }

  List<PosterModel> get _filteredPosters {
    final posters = PosterModel.samplePosters();
    if (_selectedCategory == 'All') return posters;
    return posters.where((p) => p.category == _selectedCategory).toList();
  }

  // Logic to show the full-screen poster
  void _showFullPoster(BuildContext context, PosterModel poster) {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          color: Colors.black.withValues(alpha: 0.9),
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Center(
                child: Hero(
                  tag: 'poster_${poster.title}',
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: poster.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              poster.imageUrl!,
                              fit: BoxFit.contain,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [
                                  OceanColors.accent,
                                  OceanColors.oceanBlue,
                                ],
                              ),
                            ),
                            child: const Icon(
                              Icons.image,
                              size: 200,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final int crossAxisCount = width > 1200 ? 3 : (width > 700 ? 2 : 1);
    final double aspectRatio = width > 700 ? 0.75 : 0.85;

    return Scaffold(
      body: OceanBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Project Showcase',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'A curated collection of my latest creative works',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: OceanColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _buildCategoryFilter()),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: aspectRatio,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final poster = _filteredPosters[index];
                    return FadeTransition(
                      opacity: Tween<double>(begin: 0, end: 1).animate(
                        CurvedAnimation(
                          parent: _fadeInController,
                          curve: Interval(
                            index * 0.1,
                            (index * 0.1) + 0.6,
                            curve: Curves.easeOut,
                          ),
                        ),
                      ),
                      child: _buildProjectCard(context, poster),
                    );
                  }, childCount: _filteredPosters.length),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, PosterModel poster) {
    return GestureDetector(
      onTap: () => _showFullPoster(context, poster),
      child: OceanCard(
        showGlow: true,
        padding: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 80% POSTER IMAGE
              Expanded(
                flex: 8,
                child: Hero(
                  tag: 'poster_${poster.title}',
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          OceanColors.accent.withValues(alpha: 0.3),
                          OceanColors.oceanBlue.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                    child: poster.imageUrl != null
                        ? Image.asset(
                            poster.imageUrl!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Icon(
                              Icons.image,
                              size: 60,
                              color: OceanColors.accent,
                            ),
                          ),
                  ),
                ),
              ),
              // 20% DETAILS
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              poster.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              poster.category,
                              style: TextStyle(
                                color: OceanColors.accent,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.fullscreen_rounded, color: OceanColors.accent),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: OceanColors.surfaceLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.arrow_back, color: OceanColors.accent),
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _categories.map((category) {
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: OceanChip(
              label: category,
              selected: isSelected,
              onTap: () => setState(() => _selectedCategory = category),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeInController;

  @override
  void initState() {
    super.initState();
    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeInController.forward();
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OceanBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Get In Touch',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Reach out & let\'s create something amazing',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: OceanColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildAnimatedContactCard(
                        0,
                        icon: Icons.email,
                        title: 'Email',
                        subtitle: 'sheilanicoledizon@gmail.com',
                        description: 'Feel free to send me an email anytime!',
                        onTap: () =>
                            _launchUrl('mailto:sheilanicoledizon@gmail.com'),
                      ),
                      const SizedBox(height: 16),
                      _buildAnimatedContactCard(
                        1,
                        icon: Icons.business,
                        title: 'LinkedIn',
                        subtitle: 'Sheila Nicole Cheng',
                        description: 'Connect with me on LinkedIn',
                        onTap: () => _launchUrl(
                          'https://www.linkedin.com/in/sheila-nicole-cheng-35982b327/',
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildAnimatedContactCard(
                        2,
                        icon: Icons.phone,
                        title: 'Phone',
                        subtitle: '+63 912 345 6789',
                        description: 'Available during business hours',
                        onTap: () => _launchUrl('tel:+639123456789'),
                      ),
                      const SizedBox(height: 16),
                      _buildAnimatedContactCard(
                        3,
                        icon: Icons.location_on,
                        title: 'Location',
                        subtitle: 'Philippines',
                        description: 'Open to remote opportunities worldwide',
                        onTap: null,
                      ),
                      const SizedBox(height: 40),
                      _buildAnimatedGetInTouchSection(4),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: OceanColors.surfaceLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.arrow_back, color: OceanColors.accent),
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildAnimatedContactCard(
    int index, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    VoidCallback? onTap,
  }) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _fadeInController,
          curve: Interval(
            index * 0.15,
            (index * 0.15) + 0.6,
            curve: Curves.easeOut,
          ),
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _fadeInController,
                curve: Interval(
                  index * 0.15,
                  (index * 0.15) + 0.6,
                  curve: Curves.easeOutCubic,
                ),
              ),
            ),
        child: _buildContactCard(
          context,
          icon: icon,
          title: title,
          subtitle: subtitle,
          description: description,
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildAnimatedGetInTouchSection(int index) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _fadeInController,
          curve: Interval(
            index * 0.15,
            (index * 0.15) + 0.6,
            curve: Curves.easeOut,
          ),
        ),
      ),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1).animate(
          CurvedAnimation(
            parent: _fadeInController,
            curve: Interval(
              index * 0.15,
              (index * 0.15) + 0.6,
              curve: Curves.easeOutBack,
            ),
          ),
        ),
        child: _buildGetInTouchSection(context),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    VoidCallback? onTap,
  }) {
    return OceanCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: OceanColors.accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: OceanColors.accent, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: OceanColors.accent),
                ),
                const SizedBox(height: 4),
                Text(description, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          if (onTap != null)
            const Icon(
              Icons.arrow_forward_ios,
              color: OceanColors.textMuted,
              size: 16,
            ),
        ],
      ),
    );
  }

  Widget _buildGetInTouchSection(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width < 1024;
    final headingSize = isMobile ? 24.0 : (isTablet ? 28.0 : 36.0);
    final bodySize = isMobile ? 14.0 : (isTablet ? 15.0 : 17.0);

    return SizedBox(
      width: double.infinity,
      child: OceanCard(
        showGlow: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    OceanColors.accent.withValues(alpha: 0.3),
                    OceanColors.oceanBlue,
                  ],
                ),
              ),
              child: Icon(
                Icons.waving_hand,
                size: 40,
                color: OceanColors.accent,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Let\'s Work Together!',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: headingSize),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 0 : 16.0,
                  ),
                  child: Text(
                    'I\'m always open to discussing new projects, creative ideas, or opportunities to be part of your vision.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: OceanColors.textSecondary,
                      height: 1.6,
                      fontSize: bodySize,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: OceanColors.accent.withValues(alpha: 0.2),
          border: Border.all(color: OceanColors.accent.withValues(alpha: 0.5)),
        ),
        child: Icon(icon, color: OceanColors.accent),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeInController;

  @override
  void initState() {
    super.initState();
    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeInController.forward();
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OceanBackground(
        child: SafeArea(
          child: Consumer<DataService>(
            builder: (context, dataService, child) {
              final friends = dataService.friends;
              return CustomScrollView(
                slivers: [
                  _buildAppBar(context),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Friends List',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${friends.length} friend${friends.length != 1 ? 's' : ''} added',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: OceanColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (friends.isEmpty)
                    SliverToBoxAdapter(child: _buildEmptyState())
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => FadeTransition(
                            opacity: Tween<double>(begin: 0, end: 1).animate(
                              CurvedAnimation(
                                parent: _fadeInController,
                                curve: Interval(
                                  index * 0.1,
                                  (index * 0.1) + 0.6,
                                  curve: Curves.easeOut,
                                ),
                              ),
                            ),
                            child: SlideTransition(
                              position:
                                  Tween<Offset>(
                                    begin: const Offset(-0.2, 0),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _fadeInController,
                                      curve: Interval(
                                        index * 0.1,
                                        (index * 0.1) + 0.6,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    ),
                                  ),
                              child: _buildFriendCard(friends[index]),
                            ),
                          ),
                          childCount: friends.length,
                        ),
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditFriendDialog(),
        icon: const Icon(Icons.person_add),
        label: const Text('Add Friend'),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: OceanColors.surfaceLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.arrow_back, color: OceanColors.accent),
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: OceanColors.accent.withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.people_outline,
                size: 64,
                color: OceanColors.accent,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Friends Yet',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Start building your network by adding friends!',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: OceanColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendCard(FriendModel friend) {
    return Dismissible(
      key: Key(friend.id ?? 'friend_${friend.hashCode}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await OceanDialogs.showConfirmation(
          context: context,
          title: 'Delete Friend',
          message:
              'Are you sure you want to remove ${friend.name} from your friends list?',
          icon: Icons.delete,
          confirmText: 'Delete',
          isDangerous: true,
        );
      },
      onDismissed: (direction) {
        if (friend.id != null) {
          context.read<DataService>().deleteFriend(friend.id!);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${friend.name} removed'),
            backgroundColor: OceanColors.cardBackground,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: OceanColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: OceanCard(
        margin: const EdgeInsets.symmetric(vertical: 8),
        onTap: () => _showAddEditFriendDialog(friend: friend),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    OceanColors.accent.withValues(alpha: 0.3),
                    OceanColors.oceanBlue,
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  friend.name.isNotEmpty ? friend.name[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: OceanColors.accent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    friend.email,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (friend.phone != null && friend.phone!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      friend.phone!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: OceanColors.accent),
                  onPressed: () => _showAddEditFriendDialog(friend: friend),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: OceanColors.error,
                  ),
                  onPressed: () => _deleteFriend(friend),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddEditFriendDialog({FriendModel? friend}) async {
    final isEditing = friend != null;
    final nameController = TextEditingController(text: friend?.name ?? '');
    final emailController = TextEditingController(text: friend?.email ?? '');
    final phoneController = TextEditingController(text: friend?.phone ?? '');
    final notesController = TextEditingController(text: friend?.notes ?? '');
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Friend' : 'Add Friend'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Name is required';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Email is required';
                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );
                    if (!emailRegex.hasMatch(value.trim()))
                      return 'Please enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone (optional)',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    prefixIcon: Icon(Icons.note),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, true);
              }
            },
            child: Text(isEditing ? 'Save' : 'Add'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      final dataService = context.read<DataService>();

      if (isEditing) {
        final updatedFriend = friend.copyWith(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim().isEmpty
              ? null
              : phoneController.text.trim(),
          notes: notesController.text.trim().isEmpty
              ? null
              : notesController.text.trim(),
        );
        await dataService.updateFriend(updatedFriend);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Friend updated successfully'),
              backgroundColor: OceanColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        final newFriend = FriendModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim().isEmpty
              ? null
              : phoneController.text.trim(),
          notes: notesController.text.trim().isEmpty
              ? null
              : notesController.text.trim(),
        );
        await dataService.addFriend(newFriend);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Friend added successfully'),
              backgroundColor: OceanColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }

    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    notesController.dispose();
  }

  Future<void> _deleteFriend(FriendModel friend) async {
    final confirmed = await OceanDialogs.showConfirmation(
      context: context,
      title: 'Delete Friend',
      message:
          'Are you sure you want to remove ${friend.name} from your friends list?',
      icon: Icons.delete,
      confirmText: 'Delete',
      isDangerous: true,
    );

    if (confirmed == true && mounted && friend.id != null) {
      await context.read<DataService>().deleteFriend(friend.id!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${friend.name} removed'),
            backgroundColor: OceanColors.cardBackground,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OceanBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Manage your app preferences',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: OceanColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildHueSection(context),
                      const SizedBox(height: 24),
                      _buildSection(
                        context,
                        title: 'Account',
                        children: [
                          _buildSettingsItem(
                            context,
                            icon: Icons.person,
                            title: 'Edit Profile',
                            subtitle: 'Update your personal information',
                            onTap: () => Navigator.pop(context),
                          ),
                          _buildSettingsItem(
                            context,
                            icon: Icons.delete_forever,
                            title: 'Reset Profile Data',
                            subtitle: 'Reset all profile data to defaults',
                            isDestructive: true,
                            onTap: () => _resetProfileData(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        context,
                        title: 'About',
                        children: [
                          _buildSettingsItem(
                            context,
                            icon: Icons.info,
                            title: 'About This App',
                            subtitle: 'Version 1.0.0',
                            onTap: () => _showAboutDialog(context),
                          ),
                          _buildSettingsItem(
                            context,
                            icon: Icons.code,
                            title: 'Developer',
                            subtitle: 'Sheila Nicole Cheng',
                            onTap: null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      _buildAppInfoCard(context),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHueSection(BuildContext context) {
    final hueService = context.watch<HueService>();
    final currentHue = hueService.hueShift;
    // Preview color: shift the base accent by the current hue
    final previewColor = hueService.shiftColor(const Color(0xFF64b4dc));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Appearance',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: OceanColors.accent),
          ),
        ),
        OceanCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: previewColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.palette, color: previewColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Theme Hue',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          currentHue == 0
                              ? 'Default Ocean'
                              : 'Shifted ${currentHue.round()}Â°',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (currentHue != 0)
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 20),
                      tooltip: 'Reset to default',
                      color: OceanColors.accent,
                      onPressed: () => hueService.resetHue(),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              // Color preview strip
              Container(
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: List.generate(7, (i) {
                      final hue = (i * 360 / 7);
                      final hsl = HSLColor.fromColor(const Color(0xFF64b4dc));
                      return hsl.withHue((hsl.hue + hue) % 360).toColor();
                    }),
                  ),
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: previewColor,
                  inactiveTrackColor: previewColor.withValues(alpha: 0.2),
                  thumbColor: previewColor,
                  overlayColor: previewColor.withValues(alpha: 0.15),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: currentHue,
                  min: 0,
                  max: 360,
                  onChanged: (value) => hueService.setHue(value),
                ),
              ),
              // Quick preset buttons
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildHuePreset(context, 'Ocean', 0, hueService),
                  _buildHuePreset(context, 'Violet', 60, hueService),
                  _buildHuePreset(context, 'Rose', 120, hueService),
                  _buildHuePreset(context, 'Amber', 180, hueService),
                  _buildHuePreset(context, 'Emerald', 240, hueService),
                  _buildHuePreset(context, 'Teal', 300, hueService),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHuePreset(
    BuildContext context,
    String label,
    double hue,
    HueService hueService,
  ) {
    final previewColor = hueService.shiftColor(const Color(0xFF64b4dc));
    final targetColor = HSLColor.fromColor(const Color(0xFF64b4dc))
        .withHue((HSLColor.fromColor(const Color(0xFF64b4dc)).hue + hue) % 360)
        .toColor();
    final isSelected = (hueService.hueShift - hue).abs() < 1.0;

    return GestureDetector(
      onTap: () => hueService.setHue(hue),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? targetColor.withValues(alpha: 0.3)
              : OceanColors.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? targetColor
                : targetColor.withValues(alpha: 0.4),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: targetColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? targetColor : OceanColors.textSecondary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: OceanColors.surfaceLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.arrow_back, color: OceanColors.accent),
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: OceanColors.accent),
          ),
        ),
        OceanCard(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (isDestructive ? OceanColors.error : OceanColors.accent)
              .withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? OceanColors.error : OceanColors.accent,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(color: isDestructive ? OceanColors.error : null),
      ),
      subtitle: Text(subtitle),
      trailing: onTap != null
          ? const Icon(Icons.arrow_forward_ios, size: 16)
          : null,
      onTap: onTap,
    );
  }

  Widget _buildAppInfoCard(BuildContext context) {
    return OceanCard(
      showGlow: true,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  OceanColors.accent.withValues(alpha: 0.4),
                  OceanColors.oceanBlue,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: OceanColors.accent.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(Icons.water_drop, size: 40, color: OceanColors.accent),
          ),
          const SizedBox(height: 16),
          Text(
            'Portfolio App',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text('Version 1.0.0', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          Text(
            'A Flutter mobile portfolio application with a deep ocean theme, '
            'featuring beautiful animations and a modern design.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: OceanColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: const [
              OceanChip(label: 'Flutter'),
              OceanChip(label: 'Dart'),
              OceanChip(label: 'Material 3'),
              OceanChip(label: 'Provider'),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _resetProfileData(BuildContext context) async {
  final confirmed = await OceanDialogs.showConfirmation(
    context: context,
    title: 'Reset Profile Data',
    message:
        'Are you sure you want to reset all profile data to default values? This action cannot be undone.',
    icon: Icons.delete_forever,
    confirmText: 'Reset',
    isDangerous: true,
  );

  if (confirmed == true && context.mounted) {
    await context.read<DataService>().deleteProfileData();

    if (context.mounted) {
      await OceanDialogs.showSuccess(
        context: context,
        title: 'Reset Complete',
        message: 'Your profile data has been reset to default values.',
      );
    }
  }
}

void _showAboutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: OceanColors.accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.water_drop, color: OceanColors.accent),
          ),
          const SizedBox(width: 12),
          const Text('Portfolio App'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Version 1.0.0'),
          const SizedBox(height: 16),
          const Text(
            'A beautiful portfolio application built with Flutter, '
            'featuring a deep ocean theme with floating particles '
            'and smooth animations.',
          ),
          const SizedBox(height: 16),
          Text(
            'Â© 2026 Sheila Nicole Cheng',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
