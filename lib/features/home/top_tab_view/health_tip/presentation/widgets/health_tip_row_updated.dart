import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/data/models/health_tip_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/presentation/viewmodels/health_tip_cubit.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/presentation/viewmodels/health_tip_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HealthTipRowUpdated extends StatefulWidget {
  final HealthTipModel healthTip;
  final VoidCallback onPressed;

  const HealthTipRowUpdated({
    super.key, 
    required this.healthTip, 
    required this.onPressed
  });

  @override
  State<HealthTipRowUpdated> createState() => _HealthTipRowUpdatedState();
}

class _HealthTipRowUpdatedState extends State<HealthTipRowUpdated> {
  bool _isExpanded = false;
  bool _hasLiked = false;
  final String _prefKey = 'liked_';
  int _displayedLikes = 0; // To track the displayed likes count

  @override
  void initState() {
    super.initState();
    _displayedLikes = widget.healthTip.likes ?? 0;
    _checkIfLiked();
  }

  // Check if the user has already liked this post
  Future<void> _checkIfLiked() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool hasLiked = prefs.getBool('${_prefKey}${widget.healthTip.id}') ?? false;
      
      if (hasLiked != _hasLiked) {
        setState(() {
          _hasLiked = hasLiked;
        });
      }
    } catch (e) {
      debugPrint('Error checking like: $e');
    }
  }

  // Save like state
  Future<void> _saveLikeState(bool liked) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('${_prefKey}${widget.healthTip.id}', liked);
    } catch (e) {
      debugPrint('Error saving like: $e');
    }
  }

  // Handle like/unlike with proper count update
  void _handleLikeToggle(HealthTipCubit cubit) {
    final bool newLikeState = !_hasLiked;
    
    setState(() {
      _hasLiked = newLikeState;
      // Update displayed likes immediately for better UX
      if (newLikeState) {
        _displayedLikes += 1;
      } else {
        _displayedLikes = _displayedLikes > 0 ? _displayedLikes - 1 : 0;
      }
    });
    
    // Save like state
    _saveLikeState(newLikeState);
    
    // Update in the database
    cubit.updateLikes(
      widget.healthTip.id, 
      _displayedLikes
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthTipCubit, HealthTipState>(
      builder: (context, state) {
        // Get cubit from context
        final healthTipCubit = context.read<HealthTipCubit>();
        
        // Update displayed likes if changed in state
        final stateTip = state.healthTips.where((tip) => tip.id == widget.healthTip.id).firstOrNull;
        if (stateTip != null && stateTip.likes != _displayedLikes) {
          _displayedLikes = stateTip.likes ?? 0;
        }
        
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: () {
              _showFullPost(context, healthTipCubit);
            },
            borderRadius: BorderRadius.circular(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Post Header (User info and timestamp)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: TColor.primary.withOpacity(0.1),
                        child: Icon(Icons.tips_and_updates, color: TColor.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "نصيحة صحية",
                              style: TextStyle(
                                color: TColor.primaryText,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 12,
                                  color: TColor.secondaryText,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _formatDate(widget.healthTip.createdAt),
                                  style: TextStyle(
                                    color: TColor.secondaryText,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    widget.healthTip.title,
                    style: TextStyle(
                      color: TColor.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    widget.healthTip.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 14,
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Image
                if (widget.healthTip.imageUrl != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.healthTip.imageUrl! + '?t=${DateTime.now().millisecondsSinceEpoch}',
                      key: ValueKey('${widget.healthTip.id}_${DateTime.now().millisecondsSinceEpoch}'),
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade200,
                        height: 180,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade200,
                        height: 180,
                        child: const Icon(Icons.error),
                      ),
                    ),
                  )
                else
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    child: Image.asset(
                      'assets/img/home_1.png', // Default fallback image
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                
                // Likes Count
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(Icons.favorite, color: Colors.red, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '$_displayedLikes',
                        style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Divider(height: 1),
                
                // Actions (Like, Share)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => _handleLikeToggle(healthTipCubit),
                        child: Icon(
                          _hasLiked ? Icons.favorite : Icons.favorite_border,
                          color: _hasLiked ? Colors.red : TColor.secondaryText,
                          size: 25,
                        ),
                      
                      ),
                      TextButton.icon(
                        onPressed: () {
                          // Share functionality
                          _showShareOptions(context);
                        },
                        icon: Icon(
                          Icons.share,
                          color: TColor.secondary,
                          size: 22,
                        ),
                        label: Text(
                          'مشاركة',
                          style: TextStyle(
                            color: TColor.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  // Helper method to format date
  String _formatDate(DateTime date) {
    // تحديد الفرق بين الوقت الحالي والتاريخ المحدد
    final difference = DateTime.now().difference(date);
    
    // عرض التاريخ والوقت بطريقة مختلفة حسب الفترة المنقضية
    if (difference.inDays > 7) {
      // أكثر من أسبوع، نعرض التاريخ كاملاً
      return '${date.day}/${date.month}/${date.year}, ${_formatTimeOfDay(date)}';
    } else if (difference.inDays > 0) {
      // من يوم إلى أسبوع نعرض عدد الأيام
      return '${difference.inDays} ${difference.inDays == 1 ? 'يوم' : 'أيام'} مضت، ${_formatTimeOfDay(date)}';
    } else if (difference.inHours > 0) {
      // من ساعة الى 24 ساعة، نعرض عدد الساعات
      return '${difference.inHours} ${difference.inHours == 1 ? 'ساعة' : 'ساعات'} مضت';
    } else if (difference.inMinutes > 0) {
      // أقل من ساعة، نعرض عدد الدقائق
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'دقيقة' : 'دقائق'} مضت';
    } else {
      // أقل من دقيقة
      return 'الآن';
    }
  }
  
  // Helper method to format time
  String _formatTimeOfDay(DateTime date) {
    final hour = date.hour;
    final minute = date.minute;
    final period = hour >= 12 ? 'م' : 'ص';
    final formattedHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$formattedHour:${minute.toString().padLeft(2, '0')} $period';
  }
  
  // Show full post in modal dialog
  void _showFullPost(BuildContext context, HealthTipCubit cubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: cubit, // Pass the cubit from parent
        child: DraggableScrollableSheet(
          initialChildSize: 0.93,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Handle
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  
                  // Close button
                  Positioned(
                    top: 10,
                    left: 16,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  
                  // Content
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: ListView(
                      controller: controller,
                      padding: const EdgeInsets.all(0),
                      children: [
                        // Header
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: TColor.primary.withOpacity(0.1),
                                child: Icon(Icons.tips_and_updates, color: TColor.primary, size: 26),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "نصيحة صحية",
                                      style: TextStyle(
                                        color: TColor.primaryText,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time_rounded,
                                          size: 14,
                                          color: TColor.secondaryText,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _formatDate(widget.healthTip.createdAt),
                                          style: TextStyle(
                                            color: TColor.secondaryText,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 12,
                                          color: TColor.secondaryText.withOpacity(0.7),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _formatDateFull(widget.healthTip.createdAt),
                                          style: TextStyle(
                                            color: TColor.secondaryText.withOpacity(0.7),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Title
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            widget.healthTip.title,
                            style: TextStyle(
                              color: TColor.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Image in full size
                        if (widget.healthTip.imageUrl != null)
                          CachedNetworkImage(
                            imageUrl: widget.healthTip.imageUrl! + '?t=${DateTime.now().millisecondsSinceEpoch}',
                            key: ValueKey('${widget.healthTip.id}_${DateTime.now().millisecondsSinceEpoch}'),
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade200,
                              height: 250,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey.shade200,
                              height: 250,
                              child: const Icon(Icons.error),
                            ),
                          )
                        else
                          Image.asset(
                            'assets/img/home_1.png',
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.contain,
                          ),
                        
                        // Full content
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            widget.healthTip.content,
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ),
                        
                        // Likes count
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.favorite, color: Colors.red, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      '$_displayedLikes',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const Divider(),
                        
                        // Actions
                        Builder(
                          builder: (innerContext) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      final cubit = BlocProvider.of<HealthTipCubit>(innerContext);
                                      _handleLikeToggle(cubit);
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: _hasLiked ? Colors.red : Colors.grey,
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    icon: Icon(
                                      _hasLiked ? Icons.favorite : Icons.favorite_border,
                                      size: 20,
                                    ),
                                    label: Text(_hasLiked ? 'إلغاء الإعجاب' : 'إعجاب'),
                                  ),
                                  
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _showShareOptions(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: TColor.secondary,
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.share,
                                      size: 20,
                                    ),
                                    label: const Text('مشاركة'),
                                  ),
                                ],
                              ),
                            );
                          }
                        ),
                        
                        const SizedBox(height: 32),
                      ],
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
  
  // Show share options
  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مشاركة النصيحة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: TColor.primaryText,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _shareOption(context, Icons.facebook, 'فيسبوك', Colors.blue),
                  _shareOption(context, Icons.chat, 'واتساب', Colors.green),
                  _shareOption(context, Icons.message, 'رسالة', Colors.orange),
                  _shareOption(context, Icons.copy, 'نسخ الرابط', Colors.grey.shade700),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
  
  // Helper to build share option item
  Widget _shareOption(BuildContext context, IconData icon, String label, Color color) {
    return InkWell(
      onTap: () {
        // Implement actual sharing functionality
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم مشاركة النصيحة عبر $label'),
            backgroundColor: TColor.primary,
          ),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: TColor.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  // عرض كامل للتاريخ والوقت لصفحة التفاصيل
  String _formatDateFull(DateTime date) {
    // أسماء الأيام بالعربية
    const List<String> weekDays = ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    // أسماء الشهور بالعربية
    const List<String> months = ['يناير', 'فبراير', 'مارس', 'إبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    
    // تحويل weekday (1-7) إلى index (0-6) مع مراعاة أن الأحد هو 7 في DateTime ولكننا وضعناه في آخر المصفوفة
    final dayIndex = date.weekday - 1;
    
    return '${weekDays[dayIndex]} ${date.day} ${months[date.month - 1]} ${date.year}، ${_formatTimeOfDay(date)}';
  }
} 