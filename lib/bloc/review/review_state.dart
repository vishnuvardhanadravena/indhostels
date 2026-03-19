part of 'review_bloc.dart';

class ReviewState extends Equatable {
  final bool reviewsLoading;
  final bool reviewsMoreLoading;
  final bool hasReachedMax;
  final String? reviewsError;

  final List<ReviewModel> reviews;

  final double averageRating;
  final int count;
  final int totalRatings;
  final int totalPages;
  final int currentPage;
  final bool createLoading;
  final bool createSuccess;
  final String? createError;

  const ReviewState({
    this.reviewsLoading = false,
    this.reviewsMoreLoading = false,
    this.hasReachedMax = false,
    this.reviewsError,
    this.reviews = const [],
    this.averageRating = 0.0,
    this.count = 0,
    this.totalRatings = 0,
    this.totalPages = 1,
    this.currentPage = 1,

    this.createLoading = false,
    this.createSuccess = false,
    this.createError,
  });

  ReviewState copyWith({
    bool? reviewsLoading,
    bool? reviewsMoreLoading,
    bool? hasReachedMax,
    String? reviewsError,
    List<ReviewModel>? reviews,
    double? averageRating,
    int? count,
    int? totalRatings,
    int? totalPages,
    int? currentPage,
    bool? createLoading,
    bool? createSuccess,
    String? createError,
  }) {
    return ReviewState(
      reviewsLoading: reviewsLoading ?? this.reviewsLoading,
      reviewsMoreLoading: reviewsMoreLoading ?? this.reviewsMoreLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      reviewsError: reviewsError,
      reviews: reviews ?? this.reviews,
      averageRating: averageRating ?? this.averageRating,
      count: count ?? this.count,
      totalRatings: totalRatings ?? this.totalRatings,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      createLoading: createLoading ?? this.createLoading,
      createSuccess: createSuccess ?? this.createSuccess,
      createError: createError,
    );
  }

  @override
  List<Object?> get props => [
    reviewsLoading,
    reviewsMoreLoading,
    hasReachedMax,
    reviewsError,
    reviews,
    averageRating,
    count,
    totalRatings,
    totalPages,
    currentPage,
    createLoading,
    createSuccess,
    createError,
  ];
}
