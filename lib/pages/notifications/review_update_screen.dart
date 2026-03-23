import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indhostels/bloc/review/review_bloc.dart';
import 'package:indhostels/data/models/bookings/booking_res.dart';
import 'package:indhostels/utils/helpers/app_toast.dart';
import 'package:indhostels/utils/widgets/authwidgts.dart';

class MyReviewScreen extends StatefulWidget {
  final BookingModel booking;

  const MyReviewScreen({super.key, required this.booking});

  @override
  State<MyReviewScreen> createState() => _MyReviewScreenState();
}

class _MyReviewScreenState extends State<MyReviewScreen> {
  int _selectedRating = 4;
  final TextEditingController _messageController = TextEditingController();

  final List<String> _addedImages = [
    'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=200',
    'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=200',
    'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=200',
    'https://images.unsplash.com/photo-1540541338537-a27de0171e58?w=200',
    'https://images.unsplash.com/photo-1584132967334-10e028bd69f7?w=200',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black87),
        title: const Text(
          'My Review',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: BlocListener<ReviewBloc, ReviewState>(
          listener: (context, state) {
            if (state.createSuccess == true) {
              AppToast.success("created review successfully");
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            }
            if (state.createError != null && state.createError!.isNotEmpty) {
              AppToast.error(state.createError ?? "Something went wrong");
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rate Your stay',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Your feedback helps improve future stays',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              _buildHotelCard(widget.booking.accommodation),
              const SizedBox(height: 24),

              _buildRatingSection(),
              const SizedBox(height: 24),

              _buildMessageSection(),
              const SizedBox(height: 24),

              // _buildAddImagesSection(),
              // const SizedBox(height: 32),
              // PrimaryButton(text: 'Submit Review'),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Submit Review',
                  isLoading: context.watch<ReviewBloc>().state.createLoading,
                  onPressed: () {
                    context.read<ReviewBloc>().add(
                      ReviewCreateRequested(
                        propertyId: widget.booking.accommodation.id,
                        rating: _selectedRating,
                        aboutStay: _messageController.text,
                        verifiedStay: true,
                        stayDate: widget.booking.checkIn.toString(),
                        roomType: "Single",
                      ),
                    );
                  },
                ),
              ),

              // Submit Button
              // SizedBox(
              //   width: double.infinity,
              //   height: 52,
              //   child: ElevatedButton(
              //     onPressed: () {},
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: const Color(0xFF4B3FC8),
              //       foregroundColor: Colors.white,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //       elevation: 0,
              //     ),
              //     child: const Text(
              //       'Submit Review',
              //       style: TextStyle(
              //         fontSize: 16,
              //         fontWeight: FontWeight.w600,
              //         letterSpacing: 0.3,
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 12),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4B3FC8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHotelCard(AccommodationModel accommodation) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Hotel Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              accommodation.imageUrls.first,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 70,
                height: 70,
                color: Colors.teal.shade100,
                child: const Icon(Icons.hotel, color: Colors.teal),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Hotel Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                accommodation.propertyName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                accommodation.location.displayArea,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overall Rating',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(5, (index) {
            final filled = index < _selectedRating;
            return GestureDetector(
              onTap: () => setState(() => _selectedRating = index + 1),
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(
                  filled ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 34,
                  color: filled
                      ? const Color(0xFFFFC107)
                      : Colors.grey.shade400,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Text(
          'Tap a star to rate',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildMessageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Messages',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Share your experience (optional)',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddImagesSection() {
    final int imageCount = _addedImages.length;
    final int maxImages = 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Add Images',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '($imageCount/$maxImages)',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // Add button
            GestureDetector(
              onTap: () {
                // Handle image pick
              },
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 1.5,
                    style: BorderStyle.solid,
                  ),
                  color: Colors.grey.shade50,
                ),
                child: Icon(Icons.add, size: 28, color: Colors.grey.shade500),
              ),
            ),
            // Image thumbnails
            ..._addedImages.map(
              (url) => ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  url,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 72,
                    height: 72,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
