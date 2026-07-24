class SoldTestsEntity {
  final SoldTestsStatsEntity stats;
  final List<SoldTestSaleEntity> sales;

  const SoldTestsEntity({required this.stats, required this.sales});
}

class SoldTestsStatsEntity {
  final int totalSalesCount;
  final int totalSellerNetAmountSyp;

  const SoldTestsStatsEntity({
    required this.totalSalesCount,
    required this.totalSellerNetAmountSyp,
  });
}

class SoldTestSaleEntity {
  final SoldTestPurchaseEntity purchase;
  final SoldTestInfoEntity test;

  const SoldTestSaleEntity({required this.purchase, required this.test});
}

class SoldTestPurchaseEntity {
  final String buyerName;
  final String buyerAvatarUrl;
  final bool buyerIsAcademicallyVerified;

  final String purchasedDate;
  final String purchasedTime;

  final int grossAmount;
  final int platformFeeAmount;
  final int sellerNetAmount;

  const SoldTestPurchaseEntity({
    required this.buyerName,
    required this.buyerAvatarUrl,
    required this.buyerIsAcademicallyVerified,
    required this.purchasedDate,
    required this.purchasedTime,
    required this.grossAmount,
    required this.platformFeeAmount,
    required this.sellerNetAmount,
  });
}

class SoldTestInfoEntity {
  final int id;
  final String title;
  final String description;
  final String targetLevel;
  final int questionCount;
  final num averageRating;
  final List<String> interests;

  const SoldTestInfoEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.targetLevel,
    required this.questionCount,
    required this.averageRating,
    required this.interests,
  });
}
