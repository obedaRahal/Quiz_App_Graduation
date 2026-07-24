import 'package:quiz_app_grad/features/settings/domain/entity/sold_tests_entity.dart';

class SoldTestsModel extends SoldTestsEntity {
  const SoldTestsModel({
    required super.stats,
    required super.sales,
  });

  factory SoldTestsModel.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>? ?? const {};

    final statsJson =
        dataJson['stats'] as Map<String, dynamic>? ?? const {};

    final salesJson = dataJson['sales'] as List<dynamic>? ?? const [];

    return SoldTestsModel(
      stats: SoldTestsStatsModel.fromJson(statsJson),
      sales: salesJson
          .whereType<Map<String, dynamic>>()
          .map(SoldTestSaleModel.fromJson)
          .toList(),
    );
  }
}

class SoldTestsStatsModel extends SoldTestsStatsEntity {
  const SoldTestsStatsModel({
    required super.totalSalesCount,
    required super.totalSellerNetAmountSyp,
  });

  factory SoldTestsStatsModel.fromJson(Map<String, dynamic> json) {
    return SoldTestsStatsModel(
      totalSalesCount: _parseInt(json['total_sales_count']),
      totalSellerNetAmountSyp: _parseInt(
        json['total_seller_net_amount_syp'],
      ),
    );
  }
}

class SoldTestSaleModel extends SoldTestSaleEntity {
  const SoldTestSaleModel({
    required super.purchase,
    required super.test,
  });

  factory SoldTestSaleModel.fromJson(Map<String, dynamic> json) {
    final purchaseJson =
        json['purchase'] as Map<String, dynamic>? ?? const {};

    final testJson =
        json['test'] as Map<String, dynamic>? ?? const {};

    return SoldTestSaleModel(
      purchase: SoldTestPurchaseModel.fromJson(purchaseJson),
      test: SoldTestInfoModel.fromJson(testJson),
    );
  }
}

class SoldTestPurchaseModel extends SoldTestPurchaseEntity {
  const SoldTestPurchaseModel({
    required super.buyerName,
    required super.buyerAvatarUrl,
    required super.buyerIsAcademicallyVerified,
    required super.purchasedDate,
    required super.purchasedTime,
    required super.grossAmount,
    required super.platformFeeAmount,
    required super.sellerNetAmount,
  });

  factory SoldTestPurchaseModel.fromJson(Map<String, dynamic> json) {
    return SoldTestPurchaseModel(
      buyerName: json['buyer_name']?.toString() ?? '',
      buyerAvatarUrl: json['buyer_avatar_url']?.toString() ?? '',
      buyerIsAcademicallyVerified:
          json['buyer_is_academically_verified'] == true,
      purchasedDate: json['purchased_date']?.toString() ?? '',
      purchasedTime: json['purchased_time']?.toString() ?? '',
      grossAmount: _parseInt(json['gross_amount']),
      platformFeeAmount: _parseInt(json['platform_fee_amount']),
      sellerNetAmount: _parseInt(json['seller_net_amount']),
    );
  }
}

class SoldTestInfoModel extends SoldTestInfoEntity {
  const SoldTestInfoModel({
    required super.id,
    required super.title,
    required super.description,
    required super.targetLevel,
    required super.questionCount,
    required super.averageRating,
    required super.interests,
  });

  factory SoldTestInfoModel.fromJson(Map<String, dynamic> json) {
    final interestsJson =
        json['interests'] as List<dynamic>? ?? const [];

    return SoldTestInfoModel(
      id: _parseInt(json['id']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      targetLevel: json['target_level']?.toString() ?? '',
      questionCount: _parseInt(json['question_count']),
      averageRating: _parseNum(json['average_rating']),
      interests: interestsJson
          .map((item) => item.toString())
          .where((item) => item.trim().isNotEmpty)
          .toList(),
    );
  }
}

int _parseInt(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}

num _parseNum(dynamic value) {
  if (value is num) {
    return value;
  }

  return num.tryParse(value?.toString() ?? '') ?? 0;
}