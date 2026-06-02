[02/06/2026 23:03] 🦀 Deutschtiger 😆: Đúng hướng rồi anh Cường. V1 càng ít tính năng càng dễ duyệt, dễ test, dễ không bug. Nhưng “ít” không có nghĩa là wrapper trống rỗng. Phải có vài tính năng native đủ rõ giá trị học tập.

Em đề xuất V1 cho DeutschTiger như này:

Chốt V1 nên có

1. Đăng nhập
2. Home học hôm nay
3. Daily mission / streak
4. Flashcard hoặc vocab review đơn giản
5. WebView cho vài bài học chính
6. Push notification nhắc học
7. Profile / progress cơ bản


Không nên bê hết:
• game
• leaderboard
• community
• AI phức tạp
• speaking recording
• payment in-app
• quá nhiều exam
• chat/social

---

V1 tối giản nhưng dễ được duyệt

1. Native Login

Bắt buộc gần như nên có.

Màn:
Đăng nhập
Đăng ký
Quên mật khẩu


Nếu muốn nhanh hơn, có thể login trong WebView, nhưng App Store nhìn sẽ yếu hơn. Em khuyên có native login nếu làm nghiêm túc.

Sau login vào app.

---

2. Native Home: “Hôm nay học gì?”

Đây là màn quan trọng nhất.

Nội dung:

Xin chào Cường
Hôm nay mục tiêu: 20 phút tiếng Đức

Tiến độ hôm nay:
12 / 20 phút

Việc nên làm:
- Ôn 10 từ vựng
- Đọc 1 bài ngắn
- Hoàn thành 1 mission


Có nút:

Bắt đầu học


Màn này chứng minh app có UX mobile thật, không phải wrapper.

---

3. Daily Mission / Streak

Nên có vì nó là retention.

Màn hoặc card trên Home:

Nhiệm vụ hôm nay
[ ] Ôn 10 từ
[ ] Đọc 1 bài A1
[ ] Luyện viết 5 câu

Streak: 3 ngày


Chỉ cần read từ API hiện có, không cần logic phức tạp.

---

4. Flashcard / Vocab Review đơn giản

Nếu chọn 1 tính năng học native cho V1, em chọn vocab/flashcard.

Vì:
• dễ làm hơn speaking/AI/exam
• giá trị học rõ
• ít rủi ro review
• không cần microphone
• không cần AI moderation
• có thể offline/cache nhẹ sau này
• App Store thấy app có learning function thật

MVP flashcard:

Mặt trước: der Apfel
Mặt sau: quả táo
Button:
- Quên
- Khó
- Tốt
- Dễ


Hoặc đơn giản hơn:

Hiện từ Đức
Bấm xem nghĩa
Đánh dấu đã nhớ/chưa nhớ


V1 chỉ cần review được một deck mặc định / từ đến hạn.

---

5. WebView cho bài học chính

Thay vì native hóa hết, dùng WebView cho:

Reading
Writing
Interview
Exam
AI chat


Nhưng V1 chỉ expose ít mục:

Đọc bài
Luyện viết
Phỏng vấn


Không show 20 feature.

App có thể mở web route nội bộ:
/decks
/reading
/interview
/exams/goethe-b1/writing


---

6. Push notification

Nên có trong V1.

Ví dụ:
20:00 — Hôm nay bạn còn thiếu 10 phút học tiếng Đức.


Push là lý do rất mạnh để có app mobile thay vì chỉ website.

App Store cũng thấy mobile value rõ.

Nhưng V1 chỉ nên có:
• xin quyền notification sau khi user đã vào Home
• 1–2 loại nhắc học
• không spam

---

7. Profile / Progress cơ bản

Màn đơn giản:

Tên
Level CEFR
Streak
XP
Số phút học hôm nay
Đăng xuất


Thêm link:
Privacy Policy
Terms
Contact Support
Delete Account / hướng dẫn xóa tài khoản


Cái này quan trọng cho App Store.

---

Những cái KHÔNG nên đưa vào V1

Không nên có payment trong app

Tránh đau đầu Apple IAP.
[02/06/2026 23:03] 🦀 Deutschtiger 😆: Nếu app có premium web hiện tại, V1 nên:
• không bán trong app
• hoặc chỉ hiển thị trạng thái premium nếu user đã mua trên web
• không đặt nút “mua premium” dẫn ra web một cách lộ liễu nếu là digital content, vì Apple soi.

Tốt nhất V1:
Không có purchase flow.


---

Không nên có AI chat phức tạp ở V1

AI chat có thể gây câu hỏi review:
• content generation
• safety
• user-generated content
• moderation

Nếu cần, để trong WebView và mô tả là “AI German tutor”. Nhưng em vẫn khuyên V1 chưa cần show prominent.

---

Không nên có speaking/microphone ở V1

Microphone khiến review phải khai permission, privacy rõ hơn.

Để V2.

---

Không nên có community/social

Comment, moments, friend, group chat… để sau.

Vì cần moderation/report/block.

---

Không nên có quá nhiều game

Game nhiều dễ bug, dễ bị coi là app giải trí hơn học. V1 chỉ cần học core.

---

V1 navigation em đề xuất

Bottom tabs chỉ 4 tab:

Home
Ôn từ
Bài học
Hồ sơ


Home
• daily goal
• streak
• mission
• continue learning

Ôn từ
• flashcard/vocab review native

Bài học
Danh sách rất ít:

Đọc bài ngắn
Luyện viết B1
Phỏng vấn


Mở bằng WebView.

Hồ sơ
• progress
• settings
• privacy/terms
• logout

---

V1 feature list chuẩn để gửi dev

V1 DeutschTiger Mobile App

Core:
- Native authentication
- Native home dashboard
- Daily study progress
- Daily missions/streak
- Native simple vocab/flashcard review
- WebView for selected existing web learning routes
- Push notification for daily study reminder
- Basic profile/settings
- Privacy Policy, Terms, Support, Logout

Excluded from V1:
- In-app purchase
- AI chat native
- Speaking/microphone
- Community/social
- Leaderboard
- Complex games
- Full exam system native
- Offline mode except light cache


---

V1 App Store positioning

Tên/mô tả nên nói đơn giản:

DeutschTiger helps Vietnamese learners practice German every day with vocabulary review, daily missions, reading, writing and interview preparation.


Không claim:
Đảm bảo đỗ Goethe
Đảm bảo đậu phỏng vấn
AI thay giáo viên hoàn toàn


Nên claim:
Practice German vocabulary, reading and writing with daily learning goals.


---

Nếu muốn ít nhất có thể

Minimum viable but not too weak:

1. Login
2. Home dashboard
3. Flashcard review
4. Daily reminder push
5. Profile/settings
6. WebView bài học


Đây là bản gọn nhất em thấy vẫn có cửa duyệt tốt.

---

Em chốt

V1 đừng tham. Làm app như một daily study companion:

Mở app → biết hôm nay cần học gì → ôn từ nhanh → vào bài học web nếu cần → nhận push nhắc quay lại.

Cốt lõi V1:

Home + Mission + Flashcard + Push


Còn lại để web gánh.

Vậy app vừa nhẹ, vừa dễ duyệt, vừa có giá trị mobile thật. Không biến con hổ Đức thành con voi đội app store review 😼✨