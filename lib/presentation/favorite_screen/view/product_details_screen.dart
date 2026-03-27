import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pridesys_app/core/colors/app_colors.dart';
import 'package:pridesys_app/presentation/favorite_screen/model/product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final p = widget.product;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            backgroundColor: isDark
                ? AppColors.darkBackground
                : AppColors.lightBackground,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0x33FFFFFF)
                        : const Color(0x22000000),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Main image
                  CachedNetworkImage(
                    imageUrl: p.images.isNotEmpty
                        ? p.images[_selectedImage]
                        : p.thumbnail,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (_, __) => Container(
                      color: isDark
                          ? const Color(0xFF1E1E2A)
                          : const Color(0xFFF0F0F5),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: isDark
                          ? const Color(0xFF1E1E2A)
                          : const Color(0xFFF0F0F5),
                      child: const Icon(Icons.image_not_supported_outlined),
                    ),
                  ),

                  // Discount badge
                  if (p.discountPercentage > 0)
                    Positioned(
                      top: 90,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${p.discountPercentage.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                  // Thumbnail strip
                  if (p.images.length > 1)
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        height: 56,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: p.images.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (_, i) => GestureDetector(
                            onTap: () => setState(() => _selectedImage = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _selectedImage == i
                                      ? AppColors.accent
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: p.images[i],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── Content ─────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withAlpha(20),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      p.category.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Title
                  Text(
                    p.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p.brand,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkTextSub
                          : AppColors.lightTextSub,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Price + rating row
                  Row(
                    children: [
                      Text(
                        '\$${p.discountedPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '\$${p.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 15,
                          decoration: TextDecoration.lineThrough,
                          color: isDark
                              ? AppColors.darkTextSub
                              : AppColors.lightTextSub,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFBBC04),
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${p.rating.toStringAsFixed(1)}  (${p.reviews.length})',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.darkTextSub
                              : AppColors.lightTextSub,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  _SectionTitle('Description', isDark: isDark),
                  const SizedBox(height: 8),
                  Text(
                    p.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: isDark
                          ? AppColors.darkTextSub
                          : AppColors.lightTextSub,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Info chips
                  _SectionTitle('Product Info', isDark: isDark),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _InfoChip(
                        icon: Icons.inventory_2_outlined,
                        label: p.availabilityStatus,
                        isDark: isDark,
                        accent: p.availabilityStatus == 'In Stock'
                            ? AppColors.accent2
                            : AppColors.error,
                      ),
                      _InfoChip(
                        icon: Icons.local_shipping_outlined,
                        label: p.shippingInformation,
                        isDark: isDark,
                      ),
                      _InfoChip(
                        icon: Icons.assignment_return_outlined,
                        label: p.returnPolicy,
                        isDark: isDark,
                      ),
                      _InfoChip(
                        icon: Icons.verified_outlined,
                        label: p.warrantyInformation,
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Reviews
                  _SectionTitle('Reviews', isDark: isDark),
                  const SizedBox(height: 12),
                  ...p.reviews.map(
                    (r) => _ReviewTile(review: r, isDark: isDark),
                  ),

                  const SizedBox(height: 32),

                  // Add to cart button
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.accent, Color(0xFF8B5CF6)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x736C63FF),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Add to Cart',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;
  final bool isDark;
  const _SectionTitle(this.text, {required this.isDark});

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    ),
  );
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final Color? accent;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.isDark,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        accent ?? (isDark ? AppColors.darkTextSub : AppColors.lightTextSub);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2A) : const Color(0xFFF5F5FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final ReviewModel review;
  final bool isDark;
  const _ReviewTile({required this.review, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131A) : const Color(0xFFF8F8FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.accent.withAlpha(30),
                child: Text(
                  review.reviewerName[0],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  review.reviewerName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    Icons.star_rounded,
                    size: 13,
                    color: i < review.rating
                        ? const Color(0xFFFBBC04)
                        : (isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub,
            ),
          ),
        ],
      ),
    );
  }
}
