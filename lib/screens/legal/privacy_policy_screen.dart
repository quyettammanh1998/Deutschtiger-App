import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Màn Privacy Policy - bắt buộc cho Apple App Store Review.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text(
          'Chính sách bảo mật',
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
              'Chính sách bảo mật',
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
                  'Dữ liệu của bạn được lưu trữ an toàn trên server của chúng tôi sử dụng Supabase (Firebase alternative). Chúng tôi áp dụng các biện pháp bảo mật industry-standard bao gồm mã hóa HTTPS, hash password, và kiểm soát truy cập nghiêm ngặt.',
            ),
            const _Section(
              title: '4. Cookies và công nghệ theo dõi',
              content:
                  'Chúng tôi sử dụng Firebase Analytics để hiểu cách người dùng sử dụng ứng dụng. Dữ liệu này ẩn danh và không liên kết với danh tính cá nhân của bạn. Bạn có thể tắt tính năng phân tích trong phần Cài đặt.',
            ),
            const _Section(
              title: '5. Chia sẻ dữ liệu',
              content:
                  'Chúng tôi KHÔNG bán hoặc chia sẻ thông tin cá nhân của bạn với bên thứ ba cho mục đích tiếp thị. Dữ liệu chỉ được chia sẻ khi: (a) được yêu cầu bởi pháp luật; (b) bảo vệ quyền lợi của chúng tôi; (c) với sự đồng ý rõ ràng của bạn.',
            ),
            const _Section(
              title: '6. Quyền của bạn',
              content:
                  'Bạn có quyền: (a) truy cập dữ liệu cá nhân của mình; (b) sửa đổi thông tin không chính xác; (c) xóa tài khoản và dữ liệu liên quan; (d) xuất dữ liệu của bạn; (e) phản đối việc xử lý dữ liệu nhất định. Để thực hiện quyền này, hãy liên hệ support@deutschtiger.com.',
            ),
            const _Section(
              title: '7. Thông báo thay đổi',
              content:
                  'Chúng tôi có thể cập nhật chính sách này định kỳ. Thay đổi sẽ được thông báo qua email hoặc thông báo trong ứng dụng trước khi có hiệu lực. Việc tiếp tục sử dụng ứng dụng sau khi thay đổi có hiệu lực đồng nghĩa với việc bạn chấp nhận chính sách mới.',
            ),
            const _Section(
              title: '8. Liên hệ',
              content:
                  'Nếu bạn có câu hỏi về chính sách bảo mật này, vui lòng liên hệ:\n\n📧 Email: support@deutschtiger.com\n🌐 Website: https://deutschtiger.com\n📍 Địa chỉ: [Company Address]',
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
