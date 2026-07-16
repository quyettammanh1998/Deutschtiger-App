import 'package:flutter/material.dart';

import 'widgets/legal_content_widgets.dart';
import 'widgets/legal_scaffold.dart';

/// Chính sách Bảo mật — nội dung port nguyên văn từ web
/// `legal/privacy-policy-page.tsx` (9 mục), giữ tiếng Việt inline như web.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LegalScaffold(
      title: 'Chính sách Bảo mật',
      dateLabel: 'Tháng 3, 2026',
      sections: [
        const LegalSection(
          heading: '1. Giới thiệu',
          body: LegalLinkParagraph(
            before: 'Deutsch Tiger ("chúng tôi") cam kết bảo vệ quyền riêng tư của bạn. '
                'Chính sách này mô tả cách chúng tôi thu thập, sử dụng và bảo vệ thông tin '
                'cá nhân khi bạn sử dụng trang web ',
            linkText: 'deutschtiger.com',
            linkUrl: 'https://deutschtiger.com',
            after: '.',
          ),
        ),
        const LegalSection(
          heading: '2. Thông tin chúng tôi thu thập',
          body: LegalBulletList([
            '**Thông tin tài khoản:** Email, tên hiển thị khi bạn đăng ký.',
            '**Tiến độ học tập:** Kết quả bài thi, flashcard, streak học tập để cá nhân hóa trải nghiệm của bạn.',
            '**Dữ liệu sử dụng:** Các trang bạn truy cập, thời gian học, để cải thiện ứng dụng.',
            '**Dữ liệu kỹ thuật:** Địa chỉ IP, trình duyệt, thiết bị cho mục đích bảo mật và phân tích.',
          ]),
        ),
        const LegalSection(
          heading: '3. Cách chúng tôi sử dụng thông tin',
          body: LegalBulletList([
            'Cung cấp và cải thiện dịch vụ học tiếng Đức.',
            'Lưu tiến độ học tập của bạn để đồng bộ trên nhiều thiết bị.',
            'Gửi thông báo về tính năng mới (nếu bạn đồng ý).',
            'Đảm bảo an toàn và bảo mật hệ thống.',
          ]),
        ),
        LegalSection(
          heading: '4. Chia sẻ thông tin',
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              LegalParagraph(
                'Chúng tôi không bán thông tin cá nhân của bạn. Thông tin chỉ được chia sẻ với:',
              ),
              SizedBox(height: 8),
              LegalBulletList([
                '**Supabase:** Nhà cung cấp cơ sở dữ liệu và xác thực (tuân thủ GDPR).',
                '**Cơ quan pháp luật:** Khi có yêu cầu hợp lệ từ cơ quan có thẩm quyền.',
              ]),
            ],
          ),
        ),
        const LegalSection(
          heading: '5. Bảo mật dữ liệu',
          body: LegalParagraph(
            'Chúng tôi sử dụng HTTPS cho tất cả kết nối, mã hóa dữ liệu nhạy cảm và giới hạn '
            'quyền truy cập vào thông tin cá nhân. Tuy nhiên, không có hệ thống nào hoàn toàn '
            'an toàn — bạn nên sử dụng mật khẩu mạnh và không chia sẻ tài khoản.',
          ),
        ),
        const LegalSection(
          heading: '6. Quyền của bạn',
          body: LegalBulletList([
            '**Truy cập:** Yêu cầu xem dữ liệu chúng tôi lưu về bạn.',
            '**Chỉnh sửa:** Cập nhật thông tin không chính xác.',
            '**Xóa:** Yêu cầu xóa tài khoản và dữ liệu của bạn.',
            '**Rút đồng ý:** Huỷ đăng ký nhận email bất cứ lúc nào.',
          ]),
        ),
        const LegalSection(
          heading: '7. Cookie và Local Storage',
          body: LegalParagraph(
            'Deutsch Tiger sử dụng localStorage để lưu tiến độ học tập và cài đặt giao diện '
            '(chế độ tối/sáng, ngôn ngữ). Chúng tôi không dùng cookie quảng cáo hoặc tracking '
            'từ bên thứ ba.',
          ),
        ),
        const LegalSection(
          heading: '8. Trẻ em',
          body: LegalParagraph(
            'Dịch vụ không dành cho trẻ em dưới 13 tuổi. Nếu bạn phát hiện tài khoản của trẻ '
            'em dưới 13 tuổi, vui lòng liên hệ chúng tôi để xóa.',
          ),
        ),
        const LegalSection(
          heading: '9. Liên hệ',
          body: LegalLinkParagraph(
            before: 'Nếu có câu hỏi về chính sách bảo mật, vui lòng liên hệ qua email: ',
            linkText: 'admin@deutschtiger.com',
            linkUrl: 'mailto:admin@deutschtiger.com',
          ),
        ),
      ],
    );
  }
}
