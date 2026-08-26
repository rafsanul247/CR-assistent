import 'dart:async';

import 'package:cr_app/core/network/dio_client.dart';
import 'package:cr_app/core/utils/api_endpoint.dart';
import 'package:cr_app/features/auth/domain/usecases/auth_usecase.dart';
import 'package:cr_app/features/notice/data/models/notice_model.dart';
import 'package:cr_app/injection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoticeController extends GetxController {
  final AuthUseCase _authUseCase = sl<AuthUseCase>();
  final DioClient _dioClient = sl<DioClient>();

  final RxString classCode = ''.obs;
  final RxList<NoticeModel> notices = <NoticeModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  /// Highest notice id we've already seen — used to detect new arrivals
  /// on the next poll and surface a small snackbar.
  int _lastSeenMaxId = 0;

  /// Polling timer to auto-refresh the notice list while the screen is open.
  Timer? _pollTimer;

  /// 15s is a good balance between freshness and server load.
  static const Duration _pollInterval = Duration(seconds: 15);

  @override
  void onInit() {
    super.onInit();
    fetchNotices();
    _startPolling();
  }

  @override
  void onClose() {
    _stopPolling();
    super.onClose();
  }

  void _startPolling() {
    _stopPolling();
    _pollTimer = Timer.periodic(_pollInterval, (_) {
      // Silent re-fetch: no full-screen spinner so polling doesn't flicker
      // while the user is reading.
      refreshNotices(silent: true);
    });
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  Future<void> fetchMyClassCode() async {
    final result = await _authUseCase.getMyClassCode();
    result.fold(
      (failure) => null,
      (code) => classCode.value = code,
    );
  }

  /// Public refresh entry point. Pull-to-refresh and the AppBar refresh
  /// button call this with `silent: false` (default) so the user sees the
  /// loading indicator; the polling timer calls it with `silent: true`.
  Future<void> refreshNotices({bool silent = false}) async {
    if (!silent) {
      isLoading.value = true;
    }
    errorMessage.value = '';
    try {
      final response = await _dioClient.get(ApiEndpoint.notices);
      final List<dynamic> data = response.data as List<dynamic>;
      final fetched =
          data.map((json) => NoticeModel.fromJson(json)).toList();

      // Detect newly arrived notices (compared to what we had before).
      final previousMax = _lastSeenMaxId;
      final newMax = fetched.isEmpty
          ? 0
          : fetched.map((n) => n.id).reduce((a, b) => a > b ? a : b);

      notices.assignAll(fetched);

      // Only announce "new notice" after the very first fetch, so we don't
      // spam a snackbar every time the user opens the screen.
      if (previousMax > 0 && newMax > previousMax) {
        final added = fetched
            .where((n) => n.id > previousMax)
            .toList()
          ..sort((a, b) => b.id.compareTo(a.id));
        if (added.isNotEmpty) {
          _announceNewNotices(added);
        }
      }

      _lastSeenMaxId = newMax;
    } catch (e) {
      if (!silent) {
        errorMessage.value = "Failed to fetch notices";
      }
    } finally {
      if (!silent) {
        isLoading.value = false;
      }
    }
  }

  /// Backwards-compatible alias used by the AppBar refresh icon and
  /// anywhere else that previously called fetchNotices().
  Future<void> fetchNotices() => refreshNotices();

  void _announceNewNotices(List<NoticeModel> added) {
    final count = added.length;
    final preview = added.first.title;
    Get.snackbar(
      count == 1 ? 'New notice' : '$count new notices',
      preview,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      backgroundColor: const Color(0xFF1E2740),
      colorText: const Color(0xFFFFFFFF),
    );
  }

  Future<bool> postNotice(String title, String description) async {
    isLoading.value = true;
    try {
      await _dioClient.post(
        ApiEndpoint.notices,
        data: {
          'title': title,
          'description': description,
        },
      );
      // Refresh fully so the new notice appears in sorted order from the
      // server (most recent first), without us manually inserting it.
      await refreshNotices();
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
