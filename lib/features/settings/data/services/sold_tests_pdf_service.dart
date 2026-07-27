import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:quiz_app_grad/features/settings/domain/entity/sold_tests_entity.dart';
import 'dart:ui' as ui;

class SoldTestsPdfService {
  static final PdfColor _primaryColor = PdfColor.fromHex('#5F89FF');

  static final PdfColor _darkTextColor = PdfColor.fromHex('#303640');

  static final PdfColor _secondaryTextColor = PdfColor.fromHex('#7B8190');

  static final PdfColor _borderColor = PdfColor.fromHex('#E1E4EA');

  static final PdfColor _backgroundColor = PdfColor.fromHex('#F7F8FC');

  static final PdfColor _orangeColor = PdfColor.fromHex('#FFC15A');

  static final PdfColor _redColor = PdfColor.fromHex('#FF6262');

  static final PdfColor _greenColor = PdfColor.fromHex('#62DC69');

  Future<String> generateSoldTestsPdf({required SoldTestsEntity report}) async {
    debugPrint(
      '============ SoldTestsPdfService.generateSoldTestsPdf ============',
    );
    debugPrint('→ totalSalesCount: ${report.stats.totalSalesCount}');
    debugPrint('→ sales count: ${report.sales.length}');

    final pdf = pw.Document();

    final regularFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/ElMessiri-Regular.ttf'),
    );

    final boldFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/ElMessiri-Bold.ttf'),
    );

    final buyerAvatars = await _loadBuyerAvatars(report.sales);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        margin: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        theme: pw.ThemeData.withFont(base: regularFont, bold: boldFont),
        header: (context) {
          if (context.pageNumber == 1) {
            return pw.SizedBox();
          }

          return _buildPageHeader(pageNumber: context.pageNumber);
        },
        footer: (context) {
          return _buildPageFooter(
            pageNumber: context.pageNumber,
            totalPages: context.pagesCount,
          );
        },
        build: (context) {
          return [
            _buildReportHeader(),
            pw.SizedBox(height: 16),

            _buildStatsSection(report.stats),
            pw.SizedBox(height: 22),

            _buildSalesSectionHeader(salesCount: report.sales.length),
            pw.SizedBox(height: 12),

            if (report.sales.isEmpty)
              _buildEmptyReport()
            else
              ...report.sales.asMap().entries.map((entry) {
                final index = entry.key;
                final sale = entry.value;

                return _buildSaleCard(
                  sale: sale,
                  saleNumber: index + 1,
                  buyerAvatarBytes:
                      buyerAvatars[sale.purchase.buyerAvatarUrl.trim()],
                );
              }),
          ];
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();

    final fileName =
        'sold_tests_report_${DateTime.now().millisecondsSinceEpoch}.pdf';

    final file = File('${directory.path}/$fileName');

    await file.writeAsBytes(await pdf.save(), flush: true);

    debugPrint('√ file path: ${file.path}');
    debugPrint(
      '===============================================================',
    );

    return file.path;
  }

  pw.Widget _buildReportHeader() {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(18),
      decoration: pw.BoxDecoration(
        color: _primaryColor,
        borderRadius: pw.BorderRadius.circular(14),
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'تقرير مبيعات الاختبارات',
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  'تقرير شامل لجميع عمليات بيع الاختبارات',
                  textAlign: pw.TextAlign.right,
                  style: const pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 11,
                  ),
                ),
                pw.SizedBox(height: 13),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    borderRadius: pw.BorderRadius.circular(7),
                  ),
                  child: pw.Text(
                    'تاريخ إنشاء التقرير: ${_formatCurrentDate()}',
                    style: pw.TextStyle(
                      color: _primaryColor,
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(width: 18),
          pw.Container(
            width: 80,
            height: 80,
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.circular(16),
            ),
            child: pw.Center(
              child: pw.Text(
                'PDF',
                style: pw.TextStyle(
                  color: _primaryColor,
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildStatsSection(SoldTestsStatsEntity stats) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          title: 'الإحصائيات العامة',
          subtitle: 'ملخص شامل لجميع عمليات المبيعات والأرباح',
        ),
        pw.SizedBox(height: 12),
        pw.Row(
          children: [
            pw.Expanded(
              child: _buildMainStatsCard(
                title: 'إجمالي المبيعات',
                value: '${stats.totalSalesCount}',
                suffix: 'عملية بيع',
                accentColor: _primaryColor,
                backgroundColor: PdfColor.fromHex('#EEF3FF'),
                badgeText: 'مبيعات',
              ),
            ),
            pw.SizedBox(width: 12),
            pw.Expanded(
              child: _buildMainStatsCard(
                title: 'إجمالي صافي الأرباح',
                value: _formatAmount(stats.totalSellerNetAmountSyp),
                suffix: 'ل.س',
                accentColor: _greenColor,
                backgroundColor: PdfColor.fromHex('#EDFAEF'),
                badgeText: 'أرباح',
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildMainStatsCard({
    required String title,
    required String value,
    required String suffix,
    required PdfColor accentColor,
    required PdfColor backgroundColor,
    required String badgeText,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(12),
        border: pw.Border.all(color: _borderColor, width: 0.8),
      ),
      child: pw.Row(
        children: [
          pw.Container(
            width: 54,
            height: 54,
            decoration: pw.BoxDecoration(
              color: backgroundColor,
              borderRadius: pw.BorderRadius.circular(12),
            ),
            child: pw.Center(
              child: pw.Text(
                badgeText,
                style: pw.TextStyle(
                  color: accentColor,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ),
          pw.SizedBox(width: 12),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  title,
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(color: _secondaryTextColor, fontSize: 10),
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      value,
                      style: pw.TextStyle(
                        color: _darkTextColor,
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(width: 5),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 2),
                      child: pw.Text(
                        suffix,
                        style: pw.TextStyle(
                          color: _secondaryTextColor,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSalesSectionHeader({required int salesCount}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'تفاصيل المبيعات',
              style: pw.TextStyle(
                color: _darkTextColor,
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              'جميع عمليات البيع المسجلة',
              style: pw.TextStyle(color: _secondaryTextColor, fontSize: 9),
            ),
          ],
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: pw.BoxDecoration(
            color: PdfColor.fromHex('#EEF3FF'),
            borderRadius: pw.BorderRadius.circular(7),
          ),
          child: pw.Text(
            '$salesCount عملية',
            style: pw.TextStyle(
              color: _primaryColor,
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildSaleCard({
    required SoldTestSaleEntity sale,
    required int saleNumber,
    required Uint8List? buyerAvatarBytes,
  }) {
    return pw.Container(
      width: double.infinity,
      margin: const pw.EdgeInsets.only(bottom: 13),
      padding: const pw.EdgeInsets.all(13),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(13),
        border: pw.Border.all(color: _borderColor, width: 0.8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 4,
                ),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#EEF3FF'),
                  borderRadius: pw.BorderRadius.circular(5),
                ),
                child: pw.Text(
                  'عملية البيع رقم $saleNumber',
                  style: pw.TextStyle(
                    color: _primaryColor,
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                '${sale.purchase.purchasedDate} - '
                '${sale.purchase.purchasedTime}',
                style: pw.TextStyle(color: _secondaryTextColor, fontSize: 8),
              ),
            ],
          ),

          pw.SizedBox(height: 10),

          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: _buildPurchaseInformation(
                  sale: sale,
                  buyerAvatarBytes: buyerAvatarBytes,
                ),
              ),

              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 12),
                child: _buildDashedVerticalDivider(),
              ),

              pw.Expanded(child: _buildTestInformation(sale)),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPurchaseInformation({
    required SoldTestSaleEntity sale,
    required Uint8List? buyerAvatarBytes,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildCardSectionTitle('معلومات الشراء'),
        pw.SizedBox(height: 10),

        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildBuyerAvatar(avatarBytes: buyerAvatarBytes),
            pw.SizedBox(width: 9),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Text(
                          _safeText(sale.purchase.buyerName),
                          maxLines: 1,
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            color: _darkTextColor,
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      if (sale.purchase.buyerIsAcademicallyVerified) ...[
                        pw.SizedBox(width: 5),
                        pw.Container(
                          width: 13,
                          height: 13,
                          decoration: pw.BoxDecoration(
                            color: _primaryColor,
                            shape: pw.BoxShape.circle,
                          ),
                          child: pw.Center(
                            child: pw.Text(
                              '✓',
                              style: const pw.TextStyle(
                                color: PdfColors.white,
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  _buildPurchaseDetail(
                    title: 'تاريخ الشراء',
                    value: sale.purchase.purchasedDate,
                  ),
                  pw.SizedBox(height: 3),
                  _buildPurchaseDetail(
                    title: 'الساعة',
                    value: sale.purchase.purchasedTime,
                  ),
                ],
              ),
            ),
          ],
        ),

        pw.SizedBox(height: 14),

        pw.Row(
          children: [
            pw.Expanded(
              child: _buildFinancialItem(
                title: 'السعر',
                value: sale.purchase.grossAmount,
                color: _orangeColor,
              ),
            ),
            pw.Expanded(
              child: _buildFinancialItem(
                title: 'الضريبة',
                value: sale.purchase.platformFeeAmount,
                color: _redColor,
              ),
            ),
            pw.Expanded(
              child: _buildFinancialItem(
                title: 'الربح',
                value: sale.purchase.sellerNetAmount,
                color: _greenColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildTestInformation(SoldTestSaleEntity sale) {
    final visibleInterests = sale.test.interests.take(2).toList();

    final remainingCount = sale.test.interests.length - visibleInterests.length;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildCardSectionTitle('معلومات الاختبار'),
        pw.SizedBox(height: 10),

        pw.Text(
          _safeText(sale.test.title),
          maxLines: 1,
          textAlign: pw.TextAlign.right,
          style: pw.TextStyle(
            color: _darkTextColor,
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),

        pw.SizedBox(height: 5),

        pw.Text(
          _safeText(sale.test.description),
          maxLines: 2,
          textAlign: pw.TextAlign.right,
          style: pw.TextStyle(
            color: _secondaryTextColor,
            fontSize: 8.5,
            lineSpacing: 2,
          ),
        ),

        pw.SizedBox(height: 10),

        if (sale.test.interests.isEmpty)
          _buildInterestChip('# عام')
        else
          pw.Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              ...visibleInterests.map((interest) {
                return _buildInterestChip('# $interest');
              }),
              if (remainingCount > 0) _buildInterestChip('+$remainingCount'),
            ],
          ),

        pw.SizedBox(height: 15),

        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: _buildTestInfoItem(
                title: 'المستوى',
                value: sale.test.targetLevel,
                valueColor: _levelColor(sale.test.targetLevel),
              ),
            ),
            _buildSmallVerticalDivider(),
            pw.Expanded(
              child: _buildTestInfoItem(
                title: 'الأسئلة',
                value: sale.test.questionCount.toString(),
              ),
            ),
            _buildSmallVerticalDivider(),
            pw.Expanded(
              child: _buildTestInfoItem(
                title: 'التقييم',
                value: sale.test.averageRating.toStringAsFixed(1),
                valueColor: PdfColor.fromHex('#E6A700'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildCardSectionTitle(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Text(
          title,
          textAlign: pw.TextAlign.right,
          style: pw.TextStyle(
            color: _primaryColor,
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Container(height: 0.8, color: PdfColor.fromHex('#DCE6FF')),
      ],
    );
  }

  pw.Widget _buildBuyerAvatar({required Uint8List? avatarBytes}) {
    if (avatarBytes == null || avatarBytes.isEmpty) {
      return _buildDefaultBuyerAvatar();
    }

    try {
      return pw.ClipRRect(
        horizontalRadius: 7,
        verticalRadius: 7,
        child: pw.Image(
          pw.MemoryImage(avatarBytes),
          width: 42,
          height: 42,
          fit: pw.BoxFit.cover,
        ),
      );
    } catch (error) {
      debugPrint('✗ Unable to create PDF avatar image: $error');

      return _buildDefaultBuyerAvatar();
    }
  }

  pw.Widget _buildDefaultBuyerAvatar() {
    return pw.Container(
      width: 42,
      height: 42,
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#ECEEF2'),
        borderRadius: pw.BorderRadius.circular(7),
      ),
      child: pw.Center(
        child: pw.Text(
          'مستخدم',
          style: pw.TextStyle(color: _secondaryTextColor, fontSize: 7),
        ),
      ),
    );
  }

  pw.Widget _buildPurchaseDetail({
    required String title,
    required String value,
  }) {
    return pw.Row(
      children: [
        pw.Text(
          '$title: ',
          style: pw.TextStyle(color: _secondaryTextColor, fontSize: 7.5),
        ),
        pw.Expanded(
          child: pw.Text(
            _safeText(value),
            maxLines: 1,
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(
              color: PdfColor.fromHex('#626975'),
              fontSize: 7.5,
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildFinancialItem({
    required String title,
    required int value,
    required PdfColor color,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: 24,
          height: 24,
          decoration: pw.BoxDecoration(
            color: PdfColor(color.red, color.green, color.blue, 0.18),
            shape: pw.BoxShape.circle,
          ),
          child: pw.Center(
            child: pw.Container(
              width: 7,
              height: 7,
              decoration: pw.BoxDecoration(
                color: color,
                shape: pw.BoxShape.circle,
              ),
            ),
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          title,
          style: pw.TextStyle(
            color: _darkTextColor,
            fontSize: 8.5,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          _formatAmount(value),
          style: pw.TextStyle(color: _secondaryTextColor, fontSize: 7.5),
        ),
        pw.Text(
          'ل.س',
          style: pw.TextStyle(color: _secondaryTextColor, fontSize: 7),
        ),
      ],
    );
  }

  pw.Widget _buildInterestChip(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#EEF3FF'),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Text(
        text,
        style: pw.TextStyle(color: _primaryColor, fontSize: 7),
      ),
    );
  }

  pw.Widget _buildTestInfoItem({
    required String title,
    required String value,
    PdfColor? valueColor,
  }) {
    return pw.Column(
      children: [
        pw.Text(
          title,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            color: _darkTextColor,
            fontSize: 8.5,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Text(
          value.trim().isEmpty ? 'غير محدد' : value,
          maxLines: 2,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            color: valueColor ?? _secondaryTextColor,
            fontSize: 7.5,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildSmallVerticalDivider() {
    return pw.Container(
      width: 0.8,
      height: 31,
      margin: const pw.EdgeInsets.symmetric(horizontal: 6),
      color: _borderColor,
    );
  }

  pw.Widget _buildDashedVerticalDivider() {
    return pw.SizedBox(
      width: 2,
      height: 145,
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: List.generate(16, (index) {
          return pw.Container(
            width: 1.3,
            height: 5,
            color: PdfColor.fromHex('#D6D9DF'),
          );
        }),
      ),
    );
  }

  pw.Widget _buildSectionTitle({
    required String title,
    required String subtitle,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            color: _darkTextColor,
            fontSize: 17,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          subtitle,
          style: pw.TextStyle(color: _secondaryTextColor, fontSize: 9),
        ),
      ],
    );
  }

  pw.Widget _buildEmptyReport() {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(30),
      decoration: pw.BoxDecoration(
        color: _backgroundColor,
        borderRadius: pw.BorderRadius.circular(12),
        border: pw.Border.all(color: _borderColor),
      ),
      child: pw.Center(
        child: pw.Text(
          'لا توجد عمليات بيع لعرضها',
          style: pw.TextStyle(color: _secondaryTextColor, fontSize: 12),
        ),
      ),
    );
  }

  pw.Widget _buildPageHeader({required int pageNumber}) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      padding: const pw.EdgeInsets.only(bottom: 7),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.7),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'تقرير مبيعات الاختبارات',
            style: pw.TextStyle(
              color: _primaryColor,
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            'الصفحة $pageNumber',
            style: pw.TextStyle(color: _secondaryTextColor, fontSize: 8),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPageFooter({
    required int pageNumber,
    required int totalPages,
  }) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 10),
      padding: const pw.EdgeInsets.only(top: 7),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.grey300, width: 0.7),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'تم إنشاء التقرير من تطبيق الاختبارات',
            style: pw.TextStyle(color: _secondaryTextColor, fontSize: 7),
          ),
          pw.Text(
            '$pageNumber / $totalPages',
            style: pw.TextStyle(color: _secondaryTextColor, fontSize: 7),
          ),
        ],
      ),
    );
  }

  Future<Map<String, Uint8List?>> _loadBuyerAvatars(
    List<SoldTestSaleEntity> sales,
  ) async {
    debugPrint(
      '============ SoldTestsPdfService._loadBuyerAvatars ============',
    );

    final avatarUrls = sales
        .map((sale) => sale.purchase.buyerAvatarUrl.trim())
        .where((url) => url.isNotEmpty)
        .toSet();

    debugPrint('→ unique avatar urls: ${avatarUrls.length}');

    final result = <String, Uint8List?>{};

    for (final url in avatarUrls) {
      result[url] = await _downloadImage(url);
    }

    debugPrint('√ avatars loading completed');
    debugPrint('=================================================');

    return result;
  }

  Future<Uint8List?> _downloadImage(String imageUrl) async {
    debugPrint('============ SoldTestsPdfService._downloadImage ============');
    debugPrint('→ imageUrl: $imageUrl');

    HttpClient? client;

    try {
      final normalizedUrl = imageUrl.trim();

      if (normalizedUrl.isEmpty) {
        debugPrint('✗ image url is empty');
        return null;
      }

      final uri = Uri.tryParse(normalizedUrl);

      if (uri == null || (!uri.isScheme('http') && !uri.isScheme('https'))) {
        debugPrint('✗ invalid image url');
        return null;
      }

      client = HttpClient();

      client.connectionTimeout = const Duration(seconds: 15);

      final request = await client.getUrl(uri);

      request.headers.set(HttpHeaders.acceptHeader, 'image/*');

      final response = await request.close();

      debugPrint('→ statusCode: ${response.statusCode}');
      debugPrint('→ contentType: ${response.headers.contentType}');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint(
          '✗ invalid image response status: '
          '${response.statusCode}',
        );

        return null;
      }

      final originalBytes = await consolidateHttpClientResponseBytes(response);

      debugPrint('→ downloaded bytes: ${originalBytes.length}');

      if (originalBytes.isEmpty) {
        debugPrint('✗ downloaded image is empty');
        return null;
      }

      final normalizedBytes = await _convertImageBytesToPng(originalBytes);

      if (normalizedBytes == null) {
        debugPrint('✗ unable to decode image bytes');

        return null;
      }

      debugPrint(
        '√ normalized PNG bytes: '
        '${normalizedBytes.length}',
      );

      return normalizedBytes;
    } catch (error, stackTrace) {
      debugPrint('✗ failed to load buyer avatar: $error');
      debugPrint('✗ stackTrace: $stackTrace');

      return null;
    } finally {
      client?.close(force: true);

      debugPrint('=================================================');
    }
  }

  Future<Uint8List?> _convertImageBytesToPng(Uint8List imageBytes) async {
    debugPrint(
      '============ SoldTestsPdfService._convertImageBytesToPng ============',
    );

    ui.Codec? codec;
    ui.Image? image;

    try {
      codec = await ui.instantiateImageCodec(imageBytes);

      final frameInfo = await codec.getNextFrame();

      image = frameInfo.image;

      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        debugPrint('✗ PNG byteData is null');
        return null;
      }

      final pngBytes = byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      );

      debugPrint('√ image converted to PNG');

      return pngBytes;
    } catch (error, stackTrace) {
      debugPrint('✗ image conversion error: $error');
      debugPrint('✗ stackTrace: $stackTrace');

      return null;
    } finally {
      image?.dispose();
      codec?.dispose();

      debugPrint('=================================================');
    }
  }

  String _safeText(String value) {
    final normalizedValue = value.trim();

    if (normalizedValue.isEmpty) {
      return 'غير محدد';
    }

    return normalizedValue;
  }

  String _formatCurrentDate() {
    final now = DateTime.now();

    final day = now.day.toString().padLeft(2, '0');

    final month = now.month.toString().padLeft(2, '0');

    final hour = now.hour.toString().padLeft(2, '0');

    final minute = now.minute.toString().padLeft(2, '0');

    return '$day/$month/${now.year} - $hour:$minute';
  }

  String _formatAmount(num amount) {
    final value = amount.round().toString();
    final buffer = StringBuffer();

    for (int index = 0; index < value.length; index++) {
      final positionFromEnd = value.length - index;

      buffer.write(value[index]);

      if (positionFromEnd > 1 && positionFromEnd % 3 == 1) {
        buffer.write(',');
      }
    }

    return buffer.toString();
  }

  PdfColor _levelColor(String level) {
    switch (level.trim()) {
      case 'مبتدئ':
      case 'سهل':
        return PdfColor.fromHex('#62DC69');

      case 'متوسط':
        return PdfColor.fromHex('#F4A340');

      case 'متقدم':
      case 'صعب':
        return PdfColor.fromHex('#FF6262');

      default:
        return _secondaryTextColor;
    }
  }
}
