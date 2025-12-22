import 'dart:convert';

import 'package:realtimekit_core_platform_interface/src/utils/int_to_bool_convertor.dart';

class GridPagesInfo {
  final int pageCount;
  final int currentPageNumber;
  final bool isNextPagePossible;
  final bool isPreviousPagePossible;
  GridPagesInfo({
    required this.pageCount,
    required this.currentPageNumber,
    required this.isNextPagePossible,
    required this.isPreviousPagePossible,
  });

  GridPagesInfo copyWith({
    int? pageCount,
    int? currentPageNumber,
    bool? isNextPagePossible,
    bool? isPreviousPagePossible,
  }) {
    return GridPagesInfo(
      pageCount: pageCount ?? this.pageCount,
      currentPageNumber: currentPageNumber ?? this.currentPageNumber,
      isNextPagePossible: isNextPagePossible ?? this.isNextPagePossible,
      isPreviousPagePossible:
          isPreviousPagePossible ?? this.isPreviousPagePossible,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pageCount': pageCount,
      'currentPageNumber': currentPageNumber,
      'isNextPagePossible': isNextPagePossible,
      'isPreviousPagePossible': isPreviousPagePossible,
    };
  }

  factory GridPagesInfo.fromMap(Map<String, dynamic> map) {
    return GridPagesInfo(
      pageCount: map['pageCount'] as int,
      currentPageNumber: map['currentPageNumber'] as int,
      isNextPagePossible: decodeBool(map['isNextPagePossible']),
      isPreviousPagePossible: decodeBool(map['isPreviousPagePossible']),
    );
  }

  String toJson() => json.encode(toMap());

  factory GridPagesInfo.fromJson(String source) =>
      GridPagesInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GridPagesInfo(pageCount: $pageCount, currentPageNumber: $currentPageNumber, isNextPagePossible: $isNextPagePossible, isPreviousPagePossible: $isPreviousPagePossible)';
  }

  @override
  bool operator ==(covariant GridPagesInfo other) {
    if (identical(this, other)) return true;

    return other.pageCount == pageCount &&
        other.currentPageNumber == currentPageNumber &&
        other.isNextPagePossible == isNextPagePossible &&
        other.isPreviousPagePossible == isPreviousPagePossible;
  }

  @override
  int get hashCode {
    return pageCount.hashCode ^
        currentPageNumber.hashCode ^
        isNextPagePossible.hashCode ^
        isPreviousPagePossible.hashCode;
  }
}
