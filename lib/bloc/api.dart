import 'dart:convert';
import 'dart:io';

import 'package:flutter_rx_dart/models/animal.dart';
import 'package:flutter_rx_dart/models/person.dart';
import 'package:flutter_rx_dart/models/thing.dart';

typedef SearchTerm = String;

class Api {
  List<Animal>? _animals;
  List<Person>? _persons;

  Api();

  Future<List<Thing>> searchWord(SearchTerm searchTerm) async {
    final searchableWord = searchTerm.trim().toLowerCase();

    /// going to search in cache first
    final cacheData = _extractItemUsingSearch(searchableWord);
    if (cacheData != null) {
      return cacheData;
    }

    /// when we didn't find any data in cache then call the Api

    /// start calling person api
    final getPersons = await _getJson("")
        .then((json) => json.map((value) => Person.fromJson(value)));
    _persons = getPersons.toList();

    /// start calling animals api
    final getAnimals = await _getJson("")
        .then((json) => json.map((value) => Animal.fromJson(value)));
    _animals = getAnimals.toList();

    /// after cache data is empty we will search the data in api then after we will add to cache then we will return the data from cache
    return _extractItemUsingSearch(searchTerm) ?? [];
  }

  /// this method will search the items from Animals and persons
  List<Thing>? _extractItemUsingSearch(SearchTerm term) {
    final cacheAnimals = _animals;
    final cachePersons = _persons;

    if (cacheAnimals != null && cachePersons != null) {
      List<Thing> result = [];

      /// go through animals
      for (final animals in cacheAnimals) {
        if (animals.name.trimmedContains(term) ||
            animals.type.name.trimmedContains(term)) {
          result.add(animals);
        }
      }

      /// go through persons
      for (final persons in cachePersons) {
        if (persons.name.trimmedContains(term) ||
            persons.age.toString().trimmedContains(term)) {
          result.add(persons);
        }
      }
      return result;
    } else {
      return null;
    }
  }

  Future<List<dynamic>> _getJson(String url) => HttpClient()
      .getUrl(Uri.parse(""))
      .then((req) => req.close())
      .then((res) => res.transform(utf8.decoder).join())
      .then((jsonString) => json.decode(jsonString) as List<dynamic>);
}

/// extension method for taking string and return list but all these things are incase sensitive

extension TrimmedInCaseSensitive on String {
  /// we are actually converting our searchable string to lowercase and trim the word
  bool trimmedContains(String word) =>
      trim().toLowerCase().contains(word.trim().toLowerCase());
}
