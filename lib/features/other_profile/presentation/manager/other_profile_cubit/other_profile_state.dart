import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_academic_certificate_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_content_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_folder_details_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_folders_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_overview_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_tests_entity.dart';

enum OtherProfileTab { overview, tests, folder, content }

enum OtherProfileTestsFilter { paid, free, latest, mostTaken }

enum OtherProfileContentFilter { latest, popular, files, images }

enum OtherProfileContentType { image, file }

enum FetchOtherProfileOverviewStatus { initial, loading, success, failure }

enum GetOtherProfileTestsStatus { initial, loading, success, failure }

enum GetMoreOtherProfileTestsStatus { initial, loading, success, failure }

enum GetOtherProfileFoldersStatus { initial, loading, success, failure }

enum GetMoreOtherProfileFoldersStatus { initial, loading, success, failure }

enum GetOtherProfileContentStatus { initial, loading, success, failure }

enum GetMoreOtherProfileContentStatus { initial, loading, success, failure }

enum OtherProfileFollowActionStatus { initial, loading, success, failure }

enum FolderBookmarkActionStatus { initial, loading, success, failure }

enum ContentBookmarkActionStatus { initial, loading, success, failure }

enum GetOtherProfileFolderDetailsStatus { initial, loading, success, failure }

enum OtherProfileShareLinkStatus { initial, loading, success, failure }

enum OtherProfileReceiveStatus { initial, loading, success, failure }

enum GetOtherProfileAcademicCertificateStatus {
  initial,
  loading,
  success,
  failure,
}

class OtherProfileState {
  final OtherProfileTab selectedTab;

  final OtherProfileTestsFilter selectedTestsFilter;

  final OtherProfileContentFilter selectedContentFilter;

  final OtherProfileOverviewEntity? overview;
  final FetchOtherProfileOverviewStatus fetchOverviewStatus;

  final String? errorTitle;
  final String? errorMessage;

  final List<OtherProfileTestItemEntity> tests;
  final OtherProfileTestsMetaEntity? testsMeta;
  final GetOtherProfileTestsStatus getTestsStatus;
  final GetMoreOtherProfileTestsStatus getMoreTestsStatus;

  final OtherProfileFoldersResponseEntity? foldersResponse;
  final GetOtherProfileFoldersStatus getFoldersStatus;
  final GetMoreOtherProfileFoldersStatus getMoreFoldersStatus;

  final OtherProfileContentResponseEntity? contentResponse;
  final GetOtherProfileContentStatus getContentStatus;
  final GetMoreOtherProfileContentStatus getMoreContentStatus;

  final OtherProfileFollowActionStatus followActionStatus;

  final FolderBookmarkActionStatus folderBookmarkActionStatus;
  final int? activeBookmarkFolderId;

  final ContentBookmarkActionStatus contentBookmarkActionStatus;
  final int? activeBookmarkContentId;

  final OtherProfileFolderDetailsEntity? folderDetails;
  final GetOtherProfileFolderDetailsStatus getFolderDetailsStatus;

  final OtherProfileShareLinkStatus shareLinkStatus;
  final String? shareUrl;

  final OtherProfileReceiveStatus receiveStatus;
  final int? receivedUserId;
  final bool? receivedIsThisYourProfile;

  final OtherProfileAcademicCertificateEntity? academicCertificate;
  final GetOtherProfileAcademicCertificateStatus academicCertificateStatus;

  const OtherProfileState({
    this.selectedTab = OtherProfileTab.overview,

    this.selectedTestsFilter = OtherProfileTestsFilter.paid,

    this.selectedContentFilter = OtherProfileContentFilter.latest,

    this.overview,
    this.fetchOverviewStatus = FetchOtherProfileOverviewStatus.initial,

    this.errorTitle,
    this.errorMessage,

    this.tests = const [],
    this.testsMeta,
    this.getTestsStatus = GetOtherProfileTestsStatus.initial,
    this.getMoreTestsStatus = GetMoreOtherProfileTestsStatus.initial,

    this.foldersResponse,
    this.getFoldersStatus = GetOtherProfileFoldersStatus.initial,
    this.getMoreFoldersStatus = GetMoreOtherProfileFoldersStatus.initial,

    this.contentResponse,
    this.getContentStatus = GetOtherProfileContentStatus.initial,
    this.getMoreContentStatus = GetMoreOtherProfileContentStatus.initial,

    this.followActionStatus = OtherProfileFollowActionStatus.initial,

    this.folderBookmarkActionStatus = FolderBookmarkActionStatus.initial,
    this.activeBookmarkFolderId,

    this.contentBookmarkActionStatus = ContentBookmarkActionStatus.initial,
    this.activeBookmarkContentId,

    this.folderDetails,
    this.getFolderDetailsStatus = GetOtherProfileFolderDetailsStatus.initial,

    this.shareLinkStatus = OtherProfileShareLinkStatus.initial,
    this.shareUrl,

    this.receiveStatus = OtherProfileReceiveStatus.initial,
    this.receivedUserId,
    this.receivedIsThisYourProfile,

    this.academicCertificate,
    this.academicCertificateStatus =
        GetOtherProfileAcademicCertificateStatus.initial,
  });

  bool get isFetchOverviewInitial =>
      fetchOverviewStatus == FetchOtherProfileOverviewStatus.initial;
  bool get isFetchOverviewLoading =>
      fetchOverviewStatus == FetchOtherProfileOverviewStatus.loading;
  bool get isFetchOverviewSuccess =>
      fetchOverviewStatus == FetchOtherProfileOverviewStatus.success;
  bool get isFetchOverviewFailure =>
      fetchOverviewStatus == FetchOtherProfileOverviewStatus.failure;

  bool get isGetTestsInitial =>
      getTestsStatus == GetOtherProfileTestsStatus.initial;
  bool get isGetTestsLoading =>
      getTestsStatus == GetOtherProfileTestsStatus.loading;
  bool get isGetTestsSuccess =>
      getTestsStatus == GetOtherProfileTestsStatus.success;
  bool get isGetTestsFailure =>
      getTestsStatus == GetOtherProfileTestsStatus.failure;
  bool get isGetMoreTestsInitial =>
      getMoreTestsStatus == GetMoreOtherProfileTestsStatus.initial;
  bool get isGetMoreTestsLoading =>
      getMoreTestsStatus == GetMoreOtherProfileTestsStatus.loading;
  bool get isGetMoreTestsSuccess =>
      getMoreTestsStatus == GetMoreOtherProfileTestsStatus.success;
  bool get isGetMoreTestsFailure =>
      getMoreTestsStatus == GetMoreOtherProfileTestsStatus.failure;
  bool get hasMoreTestsPages => testsMeta?.hasMorePages == true;
  String? get nextTestsCursor => testsMeta?.nextCursor;

  List<OtherProfileFolderItemEntity> get profileFolders =>
      foldersResponse?.data ?? [];

  bool get isGetFoldersInitial =>
      getFoldersStatus == GetOtherProfileFoldersStatus.initial;

  bool get isGetFoldersLoading =>
      getFoldersStatus == GetOtherProfileFoldersStatus.loading;
  bool get isGetFoldersSuccess =>
      getFoldersStatus == GetOtherProfileFoldersStatus.success;
  bool get isGetFoldersFailure =>
      getFoldersStatus == GetOtherProfileFoldersStatus.failure;
  bool get isGetMoreFoldersLoading =>
      getMoreFoldersStatus == GetMoreOtherProfileFoldersStatus.loading;
  bool get isGetMoreFoldersFailure =>
      getMoreFoldersStatus == GetMoreOtherProfileFoldersStatus.failure;
  bool get hasMoreFoldersPages => foldersResponse?.meta.hasMorePages == true;
  String? get nextFoldersCursor => foldersResponse?.meta.nextCursor;

  List<OtherProfileContentItemEntity> get profileContents =>
      contentResponse?.data ?? [];
  bool get isGetContentInitial =>
      getContentStatus == GetOtherProfileContentStatus.initial;
  bool get isGetContentLoading =>
      getContentStatus == GetOtherProfileContentStatus.loading;
  bool get isGetContentSuccess =>
      getContentStatus == GetOtherProfileContentStatus.success;
  bool get isGetContentFailure =>
      getContentStatus == GetOtherProfileContentStatus.failure;
  bool get isGetMoreContentLoading =>
      getMoreContentStatus == GetMoreOtherProfileContentStatus.loading;
  bool get isGetMoreContentFailure =>
      getMoreContentStatus == GetMoreOtherProfileContentStatus.failure;
  bool get hasMoreContentPages => contentResponse?.meta.hasMorePages == true;
  String? get nextContentCursor => contentResponse?.meta.nextCursor;

  bool get isFollowActionLoading =>
      followActionStatus == OtherProfileFollowActionStatus.loading;
  bool get isFollowActionFailure =>
      followActionStatus == OtherProfileFollowActionStatus.failure;
  bool get isFollowActionSuccess =>
      followActionStatus == OtherProfileFollowActionStatus.success;

  bool get isFolderBookmarkLoading =>
      folderBookmarkActionStatus == FolderBookmarkActionStatus.loading;
  bool get isFolderBookmarkFailure =>
      folderBookmarkActionStatus == FolderBookmarkActionStatus.failure;

  bool get isContentBookmarkLoading =>
      contentBookmarkActionStatus == ContentBookmarkActionStatus.loading;
  bool get isContentBookmarkFailure =>
      contentBookmarkActionStatus == ContentBookmarkActionStatus.failure;

  bool get isGetFolderDetailsInitial =>
      getFolderDetailsStatus == GetOtherProfileFolderDetailsStatus.initial;
  bool get isGetFolderDetailsLoading =>
      getFolderDetailsStatus == GetOtherProfileFolderDetailsStatus.loading;
  bool get isGetFolderDetailsSuccess =>
      getFolderDetailsStatus == GetOtherProfileFolderDetailsStatus.success;
  bool get isGetFolderDetailsFailure =>
      getFolderDetailsStatus == GetOtherProfileFolderDetailsStatus.failure;

  bool get isShareLinkLoading =>
      shareLinkStatus == OtherProfileShareLinkStatus.loading;
  bool get isShareLinkSuccess =>
      shareLinkStatus == OtherProfileShareLinkStatus.success;
  bool get isShareLinkFailure =>
      shareLinkStatus == OtherProfileShareLinkStatus.failure;

  bool get isReceiveLoading =>
      receiveStatus == OtherProfileReceiveStatus.loading;
  bool get isReceiveSuccess =>
      receiveStatus == OtherProfileReceiveStatus.success;
  bool get isReceiveFailure =>
      receiveStatus == OtherProfileReceiveStatus.failure;

  bool get isAcademicCertificateLoading =>
      academicCertificateStatus ==
      GetOtherProfileAcademicCertificateStatus.loading;
  bool get isAcademicCertificateSuccess =>
      academicCertificateStatus ==
      GetOtherProfileAcademicCertificateStatus.success;
  bool get isAcademicCertificateFailure =>
      academicCertificateStatus ==
      GetOtherProfileAcademicCertificateStatus.failure;

  OtherProfileState copyWith({
    OtherProfileTab? selectedTab,

    OtherProfileTestsFilter? selectedTestsFilter,

    OtherProfileContentFilter? selectedContentFilter,

    OtherProfileOverviewEntity? overview,
    FetchOtherProfileOverviewStatus? fetchOverviewStatus,
    String? errorTitle,
    String? errorMessage,
    bool clearError = false,

    List<OtherProfileTestItemEntity>? tests,
    OtherProfileTestsMetaEntity? testsMeta,
    GetOtherProfileTestsStatus? getTestsStatus,
    GetMoreOtherProfileTestsStatus? getMoreTestsStatus,
    bool clearTestsMeta = false,

    OtherProfileFoldersResponseEntity? foldersResponse,
    GetOtherProfileFoldersStatus? getFoldersStatus,
    GetMoreOtherProfileFoldersStatus? getMoreFoldersStatus,
    bool clearFoldersResponse = false,

    OtherProfileContentResponseEntity? contentResponse,
    GetOtherProfileContentStatus? getContentStatus,
    GetMoreOtherProfileContentStatus? getMoreContentStatus,
    bool clearContentResponse = false,

    OtherProfileFollowActionStatus? followActionStatus,

    FolderBookmarkActionStatus? folderBookmarkActionStatus,
    int? activeBookmarkFolderId,
    bool clearActiveBookmarkFolderId = false,

    ContentBookmarkActionStatus? contentBookmarkActionStatus,
    int? activeBookmarkContentId,
    bool clearActiveBookmarkContentId = false,

    OtherProfileFolderDetailsEntity? folderDetails,
    GetOtherProfileFolderDetailsStatus? getFolderDetailsStatus,
    bool clearFolderDetails = false,

    OtherProfileShareLinkStatus? shareLinkStatus,
    String? shareUrl,
    bool clearShareUrl = false,

    OtherProfileReceiveStatus? receiveStatus,
    int? receivedUserId,
    bool? receivedIsThisYourProfile,
    bool clearReceiveData = false,

    OtherProfileAcademicCertificateEntity? academicCertificate,
    GetOtherProfileAcademicCertificateStatus? academicCertificateStatus,
    bool clearAcademicCertificate = false,
  }) {
    return OtherProfileState(
      selectedTab: selectedTab ?? this.selectedTab,

      selectedTestsFilter: selectedTestsFilter ?? this.selectedTestsFilter,

      selectedContentFilter:
          selectedContentFilter ?? this.selectedContentFilter,

      overview: overview ?? this.overview,
      fetchOverviewStatus: fetchOverviewStatus ?? this.fetchOverviewStatus,
      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,

      tests: tests ?? this.tests,
      testsMeta: clearTestsMeta ? null : testsMeta ?? this.testsMeta,
      getTestsStatus: getTestsStatus ?? this.getTestsStatus,
      getMoreTestsStatus: getMoreTestsStatus ?? this.getMoreTestsStatus,

      foldersResponse: clearFoldersResponse
          ? null
          : foldersResponse ?? this.foldersResponse,
      getFoldersStatus: getFoldersStatus ?? this.getFoldersStatus,
      getMoreFoldersStatus: getMoreFoldersStatus ?? this.getMoreFoldersStatus,

      contentResponse: clearContentResponse
          ? null
          : contentResponse ?? this.contentResponse,
      getContentStatus: getContentStatus ?? this.getContentStatus,
      getMoreContentStatus: getMoreContentStatus ?? this.getMoreContentStatus,

      followActionStatus: followActionStatus ?? this.followActionStatus,

      folderBookmarkActionStatus:
          folderBookmarkActionStatus ?? this.folderBookmarkActionStatus,
      activeBookmarkFolderId: clearActiveBookmarkFolderId
          ? null
          : activeBookmarkFolderId ?? this.activeBookmarkFolderId,

      contentBookmarkActionStatus:
          contentBookmarkActionStatus ?? this.contentBookmarkActionStatus,
      activeBookmarkContentId: clearActiveBookmarkContentId
          ? null
          : activeBookmarkContentId ?? this.activeBookmarkContentId,

      folderDetails: clearFolderDetails
          ? null
          : folderDetails ?? this.folderDetails,
      getFolderDetailsStatus:
          getFolderDetailsStatus ?? this.getFolderDetailsStatus,

      shareLinkStatus: shareLinkStatus ?? this.shareLinkStatus,
      shareUrl: clearShareUrl ? null : shareUrl ?? this.shareUrl,

      receiveStatus: receiveStatus ?? this.receiveStatus,
      receivedUserId: clearReceiveData
          ? null
          : receivedUserId ?? this.receivedUserId,
      receivedIsThisYourProfile: clearReceiveData
          ? null
          : receivedIsThisYourProfile ?? this.receivedIsThisYourProfile,

      academicCertificate: clearAcademicCertificate
          ? null
          : academicCertificate ?? this.academicCertificate,

      academicCertificateStatus:
          academicCertificateStatus ?? this.academicCertificateStatus,
    );
  }
}
