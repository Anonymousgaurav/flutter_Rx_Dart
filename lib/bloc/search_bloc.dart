import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_rx_dart/bloc/api.dart';
import 'package:flutter_rx_dart/bloc/search_results.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class SearchBloc {
  final Sink<String> search;
  final Stream<SearchResult?> results;

  factory SearchBloc({required Api api}) {
    final textChanges = BehaviorSubject<String>();
    final results = textChanges
        .distinct()
        .debounceTime(const Duration(milliseconds: 3000))

        /// switchMap Converts each emitted item into a Stream using the given mapper function.
        /// Each Search Term Provides a Stream as SearchResults
        .switchMap<SearchResult?>((String searchTerm) {
      if (searchTerm.isEmpty) {
        /// search is empty in cache
        return Stream<SearchResult?>.value(null);
      } else {
        /// call the api when search is empty
        /// fromCallable Returns a Stream that, when listening to it, calls a function you specify and then emits the
        /// value returned from that function
        return Rx.fromCallable(() => api.searchWord(searchTerm))

            /// to show the results in delay
            .delay(const Duration(seconds: 1))

            /// Transforms each element of this stream into a new stream event.
            // Creates a new stream that converts each element of this stream to a new value
            .map(
              (results) => results.isEmpty
                  ? const SearchResultNoResult()
                  : SearchResultHavingResults(results),
            )
            .startWith(
              const SearchResultLoading(),
            )
            .onErrorReturnWith(
              (error, stackTrace) => SearchResultHasError(error),
            );
      }
    });
    return SearchBloc._(search: textChanges.sink, results: results);
  }

  /// A private constructor in Java ensures that only one object is created at a time.
  const SearchBloc._({required this.results, required this.search});

  void dispose() {
    search.close();
  }
}
