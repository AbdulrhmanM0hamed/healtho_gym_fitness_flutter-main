import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common/custom_app_bar.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/exercise_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WorkoutExercisesDetailScreen extends StatefulWidget {
  final Exercise exercise;
  final VoidCallback? onToggleFavorite;

  const WorkoutExercisesDetailScreen({
    super.key,
    required this.exercise,
    this.onToggleFavorite,
  });

  @override
  State<WorkoutExercisesDetailScreen> createState() =>
      _WorkoutExercisesDetailScreenState();
}

class _WorkoutExercisesDetailScreenState
    extends State<WorkoutExercisesDetailScreen> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.exercise.isFavorite;

    // Debug info
    print(
        'DEBUG: Exercise details - ID: ${widget.exercise.id}, Title: ${widget.exercise.title}');
    print('DEBUG: Main image URL: ${widget.exercise.mainImageUrl}');
    print('DEBUG: Gallery image URLs: ${widget.exercise.imageUrl}');
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    widget.onToggleFavorite?.call();
  }

  void _openImageGallery(int initialIndex) {
    // تجميع جميع الصور المتاحة (الرئيسية والمعرض) في قائمة واحدة
    List<String> allImages = [];
    
    // إضافة الصورة الرئيسية إذا كانت موجودة
    if (widget.exercise.mainImageUrl.isNotEmpty) {
      allImages.add(widget.exercise.mainImageUrl);
    }
    
    // إضافة صور المعرض إذا كانت موجودة
    if (widget.exercise.imageUrl.isNotEmpty) {
      // تأكد من عدم تكرار الصورة الرئيسية في صور المعرض
      for (var img in widget.exercise.imageUrl) {
        if (img.isNotEmpty && img != widget.exercise.mainImageUrl) {
          allImages.add(img);
        }
      }
    }
    
    if (allImages.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageGalleryPreview(
          images: allImages,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // تجميع جميع الصور المتاحة (الرئيسية والمعرض) في قائمة واحدة
    List<String> allImages = [];
    
    // إضافة الصورة الرئيسية إذا كانت موجودة
    if (widget.exercise.mainImageUrl.isNotEmpty) {
      allImages.add(widget.exercise.mainImageUrl);
    }
    
    // إضافة صور المعرض إذا كانت موجودة
    if (widget.exercise.imageUrl.isNotEmpty) {
      // تأكد من عدم تكرار الصورة الرئيسية في صور المعرض
      for (var img in widget.exercise.imageUrl) {
        if (img.isNotEmpty && img != widget.exercise.mainImageUrl) {
          allImages.add(img);
        }
      }
    }
    
    // طباعة عدد الصور للتصحيح
    print('DEBUG: Total images: ${allImages.length}');
    for (int i = 0; i < allImages.length; i++) {
      print('DEBUG: Image $i: ${allImages[i]}');
    }
    
    final hasImages = allImages.isNotEmpty;

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.exercise.title,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: context.width * 0.4 + 40,
              child: hasImages
                ? ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if (index >= allImages.length) {
                      return const SizedBox();
                    }
                    
                    String imageUrl = allImages[index];
                    print('DEBUG: Loading image at index $index: $imageUrl');
                    
                    if (imageUrl.isEmpty) {
                      print('DEBUG: Empty image URL at index $index');
                      return Container(
                        width: context.width * 0.7,
                        height: context.width * 0.4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    return GestureDetector(
                      onTap: () => _openImageGallery(index),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: context.width * 0.7,
                          height: context.width * 0.4,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: context.width * 0.7,
                            height: context.width * 0.4,
                            color: Colors.grey[300],
                            child: Center(
                              child: CircularProgressIndicator(
                                color: TColor.primary,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) {
                            print(
                                'DEBUG: Error loading image: $url, Error: $error');
                            return Container(
                              width: context.width * 0.7,
                              height: context.width * 0.4,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.broken_image,
                                size: 40,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                        width: 20,
                      ),
                  itemCount: allImages.length,
                )
                : Container(
                    width: context.width * 0.7,
                    height: context.width * 0.4,
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.exercise.title,
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.exercise.description,
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    "المستوى",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "المستوى ${widget.exercise.level}",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
              ),
            ]),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: _toggleFavorite,
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.grey,
                  size: 25,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {
                Share.share(
                  'اكتشف تمرين ${widget.exercise.title} على تطبيق Healtho Gym',
                );
              },
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.share,
                  color: Colors.grey,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Image Gallery Preview Screen
class ImageGalleryPreview extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const ImageGalleryPreview({
    Key? key,
    required this.images,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<ImageGalleryPreview> createState() => _ImageGalleryPreviewState();
}

class _ImageGalleryPreviewState extends State<ImageGalleryPreview> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: '${_currentIndex + 1}/${widget.images.length}',
        ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.images.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 3.0,
                child: CachedNetworkImage(
                  imageUrl: widget.images[index],
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      color: TColor.primary,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
