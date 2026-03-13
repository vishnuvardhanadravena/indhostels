import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:indhostels/data/models/Reviews/reviews_res.dart';
import 'package:indhostels/data/repo/reviews_repo.dart';
import 'package:indhostels/exceptions/api_exceptions.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository repository;

  ReviewBloc(this.repository) : super(const ReviewState()) {
    on<ReviewsRequested>(_onReviewsRequested);
    on<ReviewsNextPageRequested>(_onReviewsNextPageRequested);
  }

  Future<void> _onReviewsRequested(
    ReviewsRequested event,
    Emitter<ReviewState> emit,
  ) async {
    emit(
      state.copyWith(
        reviewsLoading: true,
        reviewsError: null,
        hasReachedMax: false,
      ),
    );

    try {
      final response = await repository.getReviews(
        propertyId: event.propertyId,
        page: event.page,
        limit: event.limit,
      );

      if (response.statuscode == 200 && response.data != null) {
        final data = response.data!;
        emit(
          state.copyWith(
            reviewsLoading: false,
            reviews: data.reviews,
            averageRating: data.averageRating,
            count: data.count,
            totalRatings: data.totalRatings,
            totalPages: data.totalPages,
            currentPage: data.page,
            hasReachedMax: data.page >= data.totalPages,
          ),
        );
      } else {
        emit(
          state.copyWith(
            reviewsLoading: false,
            reviewsError: "Failed to fetch reviews",
          ),
        );
      }
    } on ApiException catch (e) {
      emit(state.copyWith(reviewsLoading: false, reviewsError: e.message));
    } catch (_) {
      emit(
        state.copyWith(
          reviewsLoading: false,
          reviewsError: "Something went wrong",
        ),
      );
    }
  }

  Future<void> _onReviewsNextPageRequested(
    ReviewsNextPageRequested event,
    Emitter<ReviewState> emit,
  ) async {
    if (state.hasReachedMax || state.reviewsMoreLoading) return;

    emit(state.copyWith(reviewsMoreLoading: true, reviewsError: null));

    try {
      final response = await repository.getReviews(
        propertyId: event.propertyId,
        page: event.page,
        limit: event.limit,
      );

      if (response.statuscode == 200 && response.data != null) {
        final data = response.data!;

        final updatedReviews = [...state.reviews, ...data.reviews];

        emit(
          state.copyWith(
            reviewsMoreLoading: false,
            reviews: updatedReviews,
            averageRating: data.averageRating,
            count: data.count,
            totalRatings: data.totalRatings,
            totalPages: data.totalPages,
            currentPage: data.page,
            hasReachedMax: data.page >= data.totalPages,
          ),
        );
      } else {
        emit(
          state.copyWith(
            reviewsMoreLoading: false,
            reviewsError: "Failed to load more reviews",
          ),
        );
      }
    } on ApiException catch (e) {
      emit(state.copyWith(reviewsMoreLoading: false, reviewsError: e.message));
    } catch (_) {
      emit(
        state.copyWith(
          reviewsMoreLoading: false,
          reviewsError: "Something went wrong",
        ),
      );
    }
  }
}
