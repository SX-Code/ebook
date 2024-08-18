class QueryParam {
  QueryParam({
    this.page,
    this.kind,
    this.query,
    this.sort,
    this.isPromotion,
    this.variables,
  });

  int? page;
  int? kind;
  String? query;
  String? sort;
  bool? isPromotion;
  Map? variables;

  Map toJson() {
    return {
      "page": page,
      "kind": kind,
      "query": query,
      "sort": sort,
      "isPromotion": isPromotion,
    };
  }

  static const ebookQuery =
      '\n    query getFilterWorksList(\$works_ids: [ID!]) {\n      worksList(worksIds: \$works_ids) {\n        \n    id\n    isOrigin\n    isEssay\n    \n    title\n    cover(useSmall: false)\n    url\n    isBundle\n    coverLabel(preferVip: true)\n  \n    \n  url\n  title\n\n    \n  author {\n    name\n    url\n  }\n  origAuthor {\n    name\n    url\n  }\n  translator {\n    name\n    url\n  }\n\n    \n  abstract\n  authorHighlight\n  editorHighlight\n\n    \n    isOrigin\n    kinds {\n      \n    name @skip(if: true)\n    shortName @include(if: true)\n    id\n  \n    }\n    ... on WorksBase @include(if: true) {\n      wordCount\n      wordCountUnit\n    }\n    ... on WorksBase @include(if: false) {\n      inLibraryCount\n    }\n    ... on WorksBase @include(if: false) {\n      \n    isEssay\n    \n    ... on EssayWorks {\n      favorCount\n    }\n  \n    \n    \n    averageRating\n    ratingCount\n    url\n    isColumn\n    isFinished\n  \n  \n  \n    }\n    ... on EbookWorks @include(if: false) {\n      \n    ... on EbookWorks {\n      book {\n        url\n        averageRating\n        ratingCount\n      }\n    }\n  \n    }\n    ... on WorksBase @include(if: false) {\n      isColumn\n      isEssay\n      onSaleTime\n      ... on ColumnWorks {\n        updateTime\n      }\n    }\n    ... on WorksBase @include(if: true) {\n      isColumn\n      ... on ColumnWorks {\n        isFinished\n      }\n    }\n    ... on EssayWorks {\n      essayActivityData {\n        \n    title\n    uri\n    tag {\n      name\n      color\n      background\n      icon2x\n      icon3x\n      iconSize {\n        height\n      }\n      iconPosition {\n        x y\n      }\n    }\n  \n      }\n    }\n    highlightTags {\n      name\n    }\n    ... on WorksBase @include(if: false) {\n      fanfiction {\n        tags {\n          id\n          name\n          url\n        }\n      }\n    }\n  \n    \n  ... on WorksBase {\n    copyrightInfo {\n      newlyAdapted\n      newlyPublished\n      adaptedName\n      publishedName\n    }\n  }\n\n    isInLibrary\n    ... on WorksBase @include(if: false) {\n      \n    fixedPrice\n    salesPrice\n    isRebate\n    realPrice {\n      price\n      priceType\n    }\n  \n    }\n    ... on EbookWorks {\n      \n    fixedPrice\n    salesPrice\n    isRebate\n    realPrice {\n      price\n      priceType\n    }\n  \n    }\n    ... on WorksBase @include(if: true) {\n      ... on EbookWorks {\n        id\n        isPurchased\n        isInWishlist\n      }\n    }\n    ... on WorksBase @include(if: false) {\n      fanfiction {\n        fandoms {\n          title\n          url\n        }\n      }\n    }\n    ... on WorksBase @include(if: false) {\n      fanfiction {\n        kudoCount\n      }\n    }\n  \n      }\n    }\n  ';
}

class SearchParam {
  SearchParam({
    this.page,
    this.query,
    this.q,
    this.sort,
    this.rootKind,
    this.variables,
  });

  Map toJson() {
    return {
      "page": page,
      "q": q,
      "rootKind": rootKind,
      "query": query,
      "sort":  sort,
      "variables": variables,
    };
  }

  int? page;
  String? q;
  String? rootKind;
  String? query;
  String? sort;
  Map? variables;

  static const ebookSearch = QueryParam.ebookQuery;
}

class EBookshelfParam {
  EBookshelfParam({
    required this.query,
    required this.operationName,
    required this.variables,
  });

  String query;
  String operationName;
  Map<String, dynamic> variables;

  Map<String, dynamic> toJson() {
    return {
      "query": query,
      "operationName": operationName,
      "variables": variables,
    };
  }

  static const getWorksIds = "getWorksIds";
  static const getWorksList = "getWorksList";
  static const getProgressWorksList = "getProgressWorksList";
  static const getWorks = "getWorks";

  static const similiarQuery =
      '\n      query getWorks(\$worksId: ID, \$columnId: ID) {\n        works: universalWorks(worksId: \$worksId, columnId: \$columnId) {\n          ... on WorksBase {\n            id\n            similarWorksList(limit: 5) {\n              \n    title\n    cover(useSmall: false)\n    url\n    isBundle\n    coverLabel(preferVip: true)\n  \n              \n  url\n  title\n\n              \n    author {\n      name\n      url\n    }\n    origAuthor {\n      name\n      url\n    }\n  \n              \n    fixedPrice\n    salesPrice\n    isRebate\n    realPrice {\n      price\n      priceType\n    }\n  \n            }\n          }\n        }\n      }\n    ';
  static const bookshelfQuery =
      '\n  query getWorksList(\$worksIds: [ID!]) {\n    worksList(worksIds: \$worksIds) {\n      \n  ... on WorksBase {\n    id\n    title\n    url\n    readerUrl\n    cover\n    author {\n      name\n    }\n    origAuthor {\n      name\n    }\n    wordCount\n    wordCountUnit\n    isOrigin\n    isColumn\n    isFinished\n    isPurchased\n    isOnSale\n    isSticky\n    markAsFinished\n  }\n  ... on EbookWorks {\n    isCopyrightExpireSoon\n  }\n  ... on ColumnWorks {\n    columnId\n    updateTime(format: ISO)\n    rally {\n      season\n      isCurrentSeason\n      writingStarted\n      writingStage: stage(name: "StageWriting") {\n        startTime(format: ISO)\n        isStarted\n      }\n      voteStage: stage(name: "StageVote") {\n        isActive\n      }\n      awardStage: stage(name: "StageAward") {\n        isEnded\n      }\n      iconRally: images(name: "label@3x.png")\n    }\n  }\n  \n  ... on WorksBase {\n    limitedReading {\n      endTime(format: ISO)\n      limitedReadingType\n    }\n  }\n\n\n    }\n  }\n';
  static const bookshelfIdsQuery =
      '\n      query getWorksIds(\$userId: ID!, \$excludeFolder: Boolean, \$isOriginal: Boolean, \$isFinalized: Boolean, \$updatedDays: LibraryUpdatedDaysEnum, \$hasOwned: Boolean, \$vipCanRead: Boolean, \$progress: LibraryProgressEnum, \$markAsFinished: Boolean) {\n        user(userId: \$userId) {\n          bookshelf {\n            libraryList(excludeFolder: \$excludeFolder, isOriginal: \$isOriginal, isFinalized: \$isFinalized, updatedDays: \$updatedDays, hasOwned: \$hasOwned, vipCanRead: \$vipCanRead, progress: \$progress, markAsFinished: \$markAsFinished) {\n              list {\n                worksId\n              }\n            }\n          }\n        }\n      }\n    ';
  static const booshelfProgress =
      '\n  query getProgressWorksList(\$worksIds: [ID!]) {\n    worksList(worksIds: \$worksIds) {\n      \n  ... on WorksBase {\n    id\n    progressRatio\n    showWorksUpdated\n  }\n\n    }\n  }\n';
  static const getWorksQuery =
      '\n        query getWorks(\$worksId: ID, \$columnId: ID) {\n          universalWorks(worksId: \$worksId, columnId: \$columnId) {\n            \n  ... on WorksBase {\n    id\n    title\n    isFanfiction\n    markAsFinished\n    isColumn\n    isFinished\n    isOnSale\n    review {\n      id\n      content\n      ... on Review {\n        title\n        url\n        rating\n      }\n    }\n  }\n  ... on WorksBase @include(if: true) {\n    rating {\n      rating\n    }\n  }\n\n          }\n        }\n      ';
}
