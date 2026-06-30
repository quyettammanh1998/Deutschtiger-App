import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Màn Terms of Service - bắt buộc cho Apple App Store Review.
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text(
          'Điều khoản dịch vụ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Điều khoản sử dụng',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cập nhật lần cuối: ${DateTime.now().year}',
              style: TextStyle(
                color: AppColors.mutedForeground,
              ),
            ),
            const SizedBox(height: 24),
            const _Section(
              title: '1. Chấp nhận điều khoản',
              content:
                  'Bằng việc tải và sử dụng ứng dụng DeutschTiger, bạn đồng ý bị ràng buộc bởi các điều khoản này. Nếu bạn không đồng ý với bất kỳ phần nào của điều khoản, vui lòng không sử dụng ứng dụng.',
            ),
            const _Section(
              title: '2. Mô tả dịch vụ',
              content:
                  'DeutschTiger là ứng dụng học tiếng Đức cung cấp flashcard, bài tập, và nội dung ngữ pháp. Chúng tôi cố gắng cung cấp nội dung chính xác, nhưng không đảm bảo rằng tất cả nội dung đều không có lỗi. Người dùng nên sử dụng phán đoán riêng khi học ngôn ngữ.',
            ),
            const _Section(
              title: '3. Tài khoản người dùng',
              content:
                  'Bạn chịu trách nhiệm bảo mật thông tin tài khoản của mình. Bạn phải đủ 13 tuổi trở lên để tạo tài khoản. Chúng tôi có quyền đình chỉ hoặc xóa tài khoản vi phạm điều khoản này.',
            ),
            const _Section(
              title: '4. Sở hữu trí tuệ',
              content:
                  'Nội dung trong ứng dụng (bao gồm text, hình ảnh, thiết kế) thuộc sở hữu của DeutschTiger hoặc các nhà cung cấp nội dung. Bạn không được sao chép, phân phối, hoặc tạo derivative works mà không có sự cho phép.',
            ),
            const _Section(
              title: '5. Mua hàng trong ứng dụng',
              content:
                  'Nếu ứng dụng có tính năng premium, các giao dịch được xử lý qua App Store/Google Play. Chính sách hoàn tiền của họ sẽ áp dụng. Đăng ký tự động gia hạn trừ khi hủy ít nhất 24 giờ trước cuối kỳ hiện tại.',
            ),
            const _Section(
              title: '6. Giới hạn trách nhiệm',
              content:
                  'Ứng dụng được cung cấp "như có". Chúng tôi không đảm bảo rằng ứng dụng sẽ không bị gián đoạn hoặc không có lỗi. Trong phạm vi tối đa được pháp luật cho phép, chúng tôi không chịu trách nhiệm cho bất kỳ thiệt hại nào phát sinh từ việc sử dụng ứng dụng.',
            ),
            const _Section(
              title: '7. Thay đổi dịch vụ',
              content:
                  'Chúng tôi có quyền thay đổi hoặc ngừng cung cấp dịch vụ (hoặc một phần) bất cứ lúc nào, với hoặc không có thông báo trước.',
            ),
            const _Section(
              title: '8. Luật áp dụng',
              content:
                  'Các điều khoản này được điều chỉnh bởi luật của Việt Nam. Mọi tranh chấp phát sinh sẽ được giải quyết tại tòa án có thẩm quyền tại Việt Nam.',
            ),
            const _Section(
              title: '9. Liên hệ',
              content:
                  'Nếu bạn có câu hỏi về điều khoản này, vui lòng liên hệ:\n\n📧 Email: support@deutschtiger.com\n🌐 Website: https://deutschtiger.com',
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                '© ${DateTime.now().year} DeutschTiger. Mọi quyền được bảo lưu.',
                style: TextStyle(
                  color: AppColors.mutedForeground,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: AppColors.foreground.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
