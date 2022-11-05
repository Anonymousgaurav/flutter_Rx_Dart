import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_rx_dart/models/thing.dart';

/// we have different states of search
/// 1. no cache availble no api calling
/// 2. user is typing and loading i.e; loading state
/// 3. getting the result is another state

@immutable
abstract class SearchResult {
  const SearchResult();
}

@immutable
class SearchResultLoading implements SearchResult {
  const SearchResultLoading();
}

@immutable
class SearchResultNoResult implements SearchResult {
  const SearchResultNoResult();
}

@immutable
class SearchResultHasError implements SearchResult {
  final Object error;

  const SearchResultHasError(this.error);
}

@immutable
class SearchResultHavingResults implements SearchResult {
  final List<Thing> searchResults;

  const SearchResultHavingResults(this.searchResults);
}
