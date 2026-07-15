import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';

/// Màn Privacy Policy - bắt buộc cho Apple App Store Review.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.authBackground,
      appBar: AppBar(
        backgroundColor: DesignTokens.authBackground,
        title: const Text(
          'Chính sách bảo mật',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: DesignTokens.tigerOrange,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chính sách bảo mật',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            Text(
              'Cập nhật lần cuối: ${DateTime.now().year}',
              style: DesignTokens.bodySmall.copyWith(
                color: DesignTokens.mutedForeground,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),
            const _Section(
              title: '1. Thông tin chúng tôi thu thập',
              content:
                  'DeutschTiger thu thập thông tin bạn cung cấp khi đăng ký tài khoản, bao gồm: tên, email, và thông tin đăng nhập mạng xã hội (Google, Apple). Chúng tôi cũng thu thập dữ liệu học tập như tiến độ học, từ vựng đã học, và điểm số để cung cấp tính năng Spaced Repetition.',
            ),
            const _Section(
              title: '2. Cách chúng tôi sử dụng thông tin',
              content:
                  'Thông tin được sử dụng để: (a) cung cấp và cải thiện dịch vụ học tiếng Đức; (b) cá nhân hóa trải nghiệm học tập; (c) gửi thông báo nhắc nhở học tập (với sự đồng ý của bạn); (d) phân tích và thống kê để cải thiện ứng dụng.',
            ),
            const _Section(
              title: '3. Lưu trữ và bảo mật dữ liệu',
              content:
                  'Dữ liệu của bạn được lưu trữ an toàn trên server của chúng tôi. Chúng tôi áp dụng các biện pháp bảo mật industry-standard bao gồm mã hóa HTTPS, hash password, và kiểm soát truy cập nghiêm ngặt.',
            ),
            const _Section(
              title: '4. Cookies và công nghệ theo dõi',
              content:
                  'Chúng tôi ghi nhận sự kiện sử dụng dạng mã hành động và số liệu tổng hợp để cải thiện ứng dụng. Khi bạn đăng nhập, các sự kiện này được gửi cùng phiên tài khoản để chúng tôi có thể bảo vệ và cải thiện trải nghiệm của bạn; chúng không được mô tả là dữ liệu ẩn danh. Sự kiện không gửi nội dung học viên, đường dẫn tệp hay URL. Chúng tôi cũng dùng Crashlytics cho chẩn đoán lỗi, chỉ gửi mã lỗi, phiên bản ứng dụng và route; không chủ đích gửi nội dung bản dịch, bài viết hoặc bản ghi âm.',
            ),
            const _Section(
              title: '5. Chia sẻ dữ liệu',
              content:
                  'Chúng tôi KHÔNG bán hoặc chia sẻ thông tin cá nhân của bạn với bên thứ ba cho mục đích tiếp thị. Dữ liệu chỉ được chia sẻ khi: (a) được yêu cầu bởi pháp luật; (b) bảo vệ quyền lợi của chúng tôi; (c) với sự đồng ý rõ ràng của bạn.',
            ),
            const _Section(
              title: '6. Quyền của bạn',
              content:
                  'Bạn có quyền: (a) truy cập dữ liệu cá nhân của mình; (b) sửa đổi thông tin không chính xác; (c) yêu cầu xóa tài khoản và dữ liệu liên quan; (d) yêu cầu bản sao dữ liệu của bạn; (e) phản đối việc xử lý dữ liệu nhất định. Tính năng xuất dữ liệu trong ứng dụng chưa khả dụng; để thực hiện các quyền này, hãy liên hệ support@deutschtiger.com.',
            ),
            const _Section(
              title: '7. Thông báo thay đổi',
              content:
                  'Chúng tôi có thể cập nhật chính sách này định kỳ. Thay đổi sẽ được thông báo qua email hoặc thông báo trong ứng dụng trước khi có hiệu lực. Việc tiếp tục sử dụng ứng dụng sau khi thay đổi có hiệu lực đồng nghĩa với việc bạn chấp nhận chính sách mới.',
            ),
            const _Section(
              title: '8. Liên hệ',
              content:
                  'Nếu bạn có câu hỏi về chính sách bảo mật này, vui lòng liên hệ:\n\n📧 Email: support@deutschtiger.com\n🌐 Website: https://deutschtiger.com',
            ),
            const SizedBox(height: DesignTokens.spacingXl),
            Center(
              child: Text(
                '© ${DateTime.now().year} DeutschTiger. Mọi quyền được bảo lưu.',
                style: DesignTokens.bodySmall.copyWith(
                  color: DesignTokens.mutedForeground,
                ),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),
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
            style: DesignTokens.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Text(
            content,
            style: DesignTokens.bodyMedium.copyWith(
              height: 1.6,
              color: DesignTokens.foreground.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
