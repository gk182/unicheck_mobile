import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicheck_mobile/features/leave/view_models/leave_controller.dart';
import 'package:unicheck_mobile/features/leave/widget/leave_form_view.dart';
import 'package:unicheck_mobile/features/leave/widget/leave_status_view.dart';
import 'package:unicheck_mobile/features/leave/widget/leave_toggle.dart';

class LeavePage extends StatelessWidget {
  const LeavePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: GetBuilder<LeaveController>(
        init: LeaveController(),
        builder: (controller) {
          if (controller.isLoading &&
              controller.requests.isEmpty &&
              controller.schedules.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: controller.refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 60),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1C51E6),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Xin nghi phep',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Gui don xin nghi hoc co ly do',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -40),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            if (controller.errorMessage != null)
                              _buildErrorBanner(context, controller),
                            if (controller.errorMessage != null) const SizedBox(height: 14),
                            LeaveToggle(
                              isNewRequest: controller.isNewRequestTab,
                              onToggle: controller.toggleTab,
                            ),
                            const SizedBox(height: 24),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: controller.isNewRequestTab
                                  ? LeaveFormView(
                                      key: const ValueKey('FormView'),
                                      viewModel: controller,
                                    )
                                  : LeaveStatusView(
                                      key: const ValueKey('StatusView'),
                                      viewModel: controller,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorBanner(BuildContext context, LeaveController controller) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              controller.errorMessage ?? 'Khong tai duoc du lieu',
              style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: controller.refreshData,
            child: const Text('Thu lai'),
          ),
        ],
      ),
    );
  }
}
