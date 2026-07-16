import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import 'widgets/legal_content_widgets.dart';
import 'widgets/legal_scaffold.dart';

/// Điều khoản Dịch vụ — nội dung port nguyên văn từ web
/// `legal/terms-of-service-page.tsx` (9 mục), giữ tiếng Việt inline như web.
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LegalScaffold(
      title: 'Điều khoản Dịch vụ',
      dateLabel: 'Tháng 7, 2026',
      sections: [
        const LegalSection(
          heading: '1. Chấp nhận điều khoản',
          body: LegalLinkParagraph(
            before: 'Khi truy cập và sử dụng ',
            linkText: 'deutschtiger.com',
            linkUrl: 'https://deutschtiger.com',
            after: ' ("Dịch vụ"), bạn đồng ý tuân theo các Điều khoản này. Nếu không đồng ý, '
                'vui lòng ngừng sử dụng Dịch vụ.',
          ),
        ),
        const LegalSection(
          heading: '2. Mô tả dịch vụ',
          body: LegalParagraph(
            'Deutsch Tiger là nền tảng học và luyện thi tiếng Đức: flashcard, đề thi mô '
            'phỏng, chấm viết/nói bằng AI, bài đọc, video và trò chơi. Kết quả chấm AI mang '
            'tính tham khảo, hỗ trợ luyện tập; không phải chứng chỉ chính thức và không thay '
            'thế kỳ thi của Goethe/telc/ÖSD.',
          ),
        ),
        const LegalSection(
          heading: '3. Tài khoản',
          body: LegalParagraph(
            'Bạn chịu trách nhiệm bảo mật thông tin đăng nhập và mọi hoạt động dưới tài khoản '
            'của mình. Vui lòng cung cấp thông tin chính xác và thông báo cho chúng tôi nếu '
            'phát hiện truy cập trái phép.',
          ),
        ),
        const LegalSection(
          heading: '4. Gói trả phí, thanh toán và hoàn tiền',
          body: LegalParagraph(
            'Một số tính năng yêu cầu gói trả phí. Giá và quyền lợi được hiển thị tại trang '
            'nâng cấp trước khi thanh toán. Do đặc thù nội dung số được mở khóa ngay sau khi '
            'thanh toán, các giao dịch về nguyên tắc không hoàn lại, trừ trường hợp lỗi kỹ '
            'thuật khiến bạn không sử dụng được Dịch vụ — khi đó vui lòng liên hệ hỗ trợ để '
            'được xử lý theo từng trường hợp.',
          ),
        ),
        const LegalSection(
          heading: '5. Sử dụng hợp lệ',
          body: LegalParagraph(
            'Bạn không được: sao chép, phân phối lại nội dung Dịch vụ vì mục đích thương mại; '
            'cố gắng phá hoại, dò quét hoặc lạm dụng hệ thống; hoặc dùng các tính năng AI cho '
            'mục đích trái pháp luật. Chúng tôi có thể áp dụng giới hạn sử dụng hợp lý '
            '(fair-use) cho các tính năng AI để đảm bảo chất lượng cho mọi người dùng.',
          ),
        ),
        const LegalSection(
          heading: '6. Sở hữu trí tuệ',
          body: LegalParagraph(
            'Nội dung, thương hiệu và mã nguồn của Dịch vụ thuộc quyền sở hữu của Deutsch '
            'Tiger. Ghi chú, thẻ từ và dữ liệu học tập do bạn tạo vẫn thuộc về bạn.',
          ),
        ),
        const LegalSection(
          heading: '7. Miễn trừ trách nhiệm',
          body: LegalParagraph(
            'Dịch vụ được cung cấp "nguyên trạng". Chúng tôi nỗ lực đảm bảo tính chính xác và '
            'sẵn sàng nhưng không cam kết Dịch vụ không gián đoạn hay không có lỗi, và không '
            'chịu trách nhiệm cho kết quả kỳ thi thực tế của bạn.',
          ),
        ),
        const LegalSection(
          heading: '8. Thay đổi điều khoản',
          body: LegalParagraph(
            'Chúng tôi có thể cập nhật Điều khoản này. Bản cập nhật có hiệu lực khi đăng tải; '
            'việc tiếp tục sử dụng Dịch vụ đồng nghĩa bạn chấp nhận thay đổi.',
          ),
        ),
        LegalSection(
          heading: '9. Liên hệ',
          body: Builder(
            builder: (context) {
              final tokens = context.tokens;
              return Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: tokens.mutedForeground,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Mọi thắc mắc về Điều khoản, vui lòng liên hệ qua các kênh hỗ trợ '
                          'của Deutsch Tiger. Xem thêm ',
                    ),
                    TextSpan(
                      text: 'Chính sách Bảo mật',
                      style: TextStyle(color: tokens.primary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.push('/privacy-policy'),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
