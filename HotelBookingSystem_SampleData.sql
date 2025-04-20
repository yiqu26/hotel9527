-- 飯店訂房系統示範資料
-- 使用SQL Server

USE HotelBookingSystem;
GO

-- 1. 插入飯店資料
INSERT INTO Hotel (Name, Address, City, Country, PostalCode, Phone, Email, Website, Description, StarRating, CheckinTime, CheckoutTime)
VALUES 
('台北豪華飯店', '中山區中山北路100號', '台北市', '台灣', '10444', '02-25554444', 'info@taipeiluxury.com', 'www.taipeiluxury.com', '位於台北市中心的五星級豪華飯店，靠近捷運站，提供舒適便利的住宿體驗。', 5.0, '15:00', '12:00'),
('高雄海灣度假村', '前鎮區中山四路123號', '高雄市', '台灣', '80145', '07-33345678', 'contact@khbayresort.com', 'www.khbayresort.com', '位於高雄港灣的渡假村，擁有壯麗的海景和舒適的住宿環境。', 4.5, '15:00', '11:00'),
('台中花園飯店', '西區英才路567號', '台中市', '台灣', '40359', '04-23334444', 'booking@tcgardenhotel.com', 'www.tcgardenhotel.com', '位於台中市區的花園主題飯店，環境優雅寧靜。', 4.0, '14:00', '12:00');

-- 2. 插入飯店設施資料
INSERT INTO HotelAmenity (Name, Description, Icon)
VALUES 
('游泳池', '室外游泳池', 'pool-icon'),
('健身中心', '24小時健身房', 'fitness-icon'),
('SPA中心', '提供多種SPA服務', 'spa-icon'),
('免費Wi-Fi', '全館免費高速Wi-Fi', 'wifi-icon'),
('餐廳', '提供中西式美食', 'restaurant-icon'),
('會議室', '可容納100人的會議設施', 'meeting-icon'),
('商務中心', '提供商務服務', 'business-icon'),
('停車場', '室內停車場', 'parking-icon'),
('機場接送', '提供機場接送服務', 'shuttle-icon'),
('早餐', '豐盛的早餐自助餐', 'breakfast-icon');

-- 3. 插入飯店設施關聯資料
INSERT INTO HotelHasAmenity (HotelID, AmenityID)
VALUES 
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8), (1, 9), (1, 10),
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 8), (2, 9), (2, 10),
(3, 2), (3, 4), (3, 5), (3, 7), (3, 8), (3, 10);

-- 4. 插入飯店圖片資料
INSERT INTO HotelImage (HotelID, ImageURL, Caption, IsPrimary, DisplayOrder)
VALUES 
(1, '/images/hotels/taipei-luxury-main.jpg', '飯店外觀', 1, 1),
(1, '/images/hotels/taipei-luxury-lobby.jpg', '豪華大廳', 0, 2),
(1, '/images/hotels/taipei-luxury-pool.jpg', '游泳池', 0, 3),
(2, '/images/hotels/kh-bay-resort-main.jpg', '度假村外觀', 1, 1),
(2, '/images/hotels/kh-bay-resort-beach.jpg', '私人沙灘', 0, 2),
(3, '/images/hotels/tc-garden-hotel-main.jpg', '飯店外觀', 1, 1);

-- 5. 插入房型資料
INSERT INTO RoomType (HotelID, Name, Description, BasePrice, MaxOccupancy, BedConfiguration, RoomSize)
VALUES 
(1, '豪華單人房', '豪華單人房，提供單人床及現代化設施', 3500.00, 1, '一張單人床', '25平方公尺'),
(1, '豪華雙人房', '豪華雙人房，提供雙人床及現代化設施', 4500.00, 2, '一張雙人床', '30平方公尺'),
(1, '豪華家庭房', '豪華家庭房，適合家庭入住', 6000.00, 4, '一張雙人床及兩張單人床', '45平方公尺'),
(1, '總統套房', '頂級總統套房，提供最高級的住宿體驗', 15000.00, 2, '一張特大雙人床', '75平方公尺'),
(2, '海景單人房', '可眺望美麗海景的單人房', 3000.00, 1, '一張單人床', '22平方公尺'),
(2, '海景雙人房', '可眺望美麗海景的雙人房', 4000.00, 2, '一張雙人床', '28平方公尺'),
(2, '豪華套房', '豪華套房，提供獨立客廳和臥室', 6500.00, 2, '一張特大雙人床', '50平方公尺'),
(3, '標準單人房', '舒適的標準單人房', 2500.00, 1, '一張單人床', '20平方公尺'),
(3, '標準雙人房', '舒適的標準雙人房', 3200.00, 2, '兩張單人床', '25平方公尺'),
(3, '商務套房', '商務套房，提供辦公空間', 4500.00, 2, '一張雙人床', '35平方公尺');

-- 6. 插入房型設施資料
INSERT INTO RoomAmenity (Name, Description, Icon)
VALUES 
('空調', '獨立控制空調', 'ac-icon'),
('電視', '平面電視', 'tv-icon'),
('冰箱', '迷你冰箱', 'fridge-icon'),
('保險箱', '電子保險箱', 'safe-icon'),
('浴缸', '獨立浴缸', 'bathtub-icon'),
('淋浴', '淋浴設備', 'shower-icon'),
('吹風機', '高效吹風機', 'hairdryer-icon'),
('熱水壺', '電熱水壺', 'kettle-icon'),
('咖啡機', '膠囊咖啡機', 'coffee-icon'),
('書桌', '工作書桌', 'desk-icon');

-- 7. 插入房型設施關聯資料
INSERT INTO RoomTypeHasAmenity (RoomTypeID, AmenityID)
VALUES 
-- 豪華單人房設施
(1, 1), (1, 2), (1, 3), (1, 4), (1, 6), (1, 7), (1, 8), (1, 10),
-- 豪華雙人房設施
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 6), (2, 7), (2, 8), (2, 10),
-- 豪華家庭房設施
(3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (3, 6), (3, 7), (3, 8), (3, 9), (3, 10),
-- 總統套房設施
(4, 1), (4, 2), (4, 3), (4, 4), (4, 5), (4, 6), (4, 7), (4, 8), (4, 9), (4, 10),
-- 其他房型設施...
(5, 1), (5, 2), (5, 3), (5, 6), (5, 7), (5, 8), (5, 10),
(6, 1), (6, 2), (6, 3), (6, 4), (6, 6), (6, 7), (6, 8), (6, 10),
(7, 1), (7, 2), (7, 3), (7, 4), (7, 5), (7, 6), (7, 7), (7, 8), (7, 9), (7, 10),
(8, 1), (8, 2), (8, 6), (8, 7), (8, 8), (8, 10),
(9, 1), (9, 2), (9, 3), (9, 6), (9, 7), (9, 8), (9, 10),
(10, 1), (10, 2), (10, 3), (10, 4), (10, 6), (10, 7), (10, 8), (10, 9), (10, 10);

-- 8. 插入房間資料
INSERT INTO Room (HotelID, RoomTypeID, RoomNumber, Floor, Status)
VALUES 
-- 台北豪華飯店房間
(1, 1, '301', '3', 'Available'),
(1, 1, '302', '3', 'Available'),
(1, 2, '303', '3', 'Available'),
(1, 2, '304', '3', 'Occupied'),
(1, 3, '501', '5', 'Available'),
(1, 3, '502', '5', 'Maintenance'),
(1, 4, '701', '7', 'Available'),
-- 高雄海灣度假村房間
(2, 5, '201', '2', 'Available'),
(2, 5, '202', '2', 'Available'),
(2, 6, '301', '3', 'Occupied'),
(2, 6, '302', '3', 'Available'),
(2, 7, '501', '5', 'Available'),
-- 台中花園飯店房間
(3, 8, '201', '2', 'Available'),
(3, 8, '202', '2', 'Cleaning'),
(3, 9, '301', '3', 'Available'),
(3, 9, '302', '3', 'Available'),
(3, 10, '401', '4', 'Available');

-- 9. 插入用戶資料
INSERT INTO [User] (Email, PasswordHash, FirstName, LastName, Phone, Address, City, Country, PostalCode, DateOfBirth, Gender, Nationality, UserType, IsVerified, IsActive)
VALUES 
('admin@example.com', 'hashed_password_1', '管理員', '王', '0911111111', '台北市中正區忠孝東路100號', '台北市', '台灣', '10048', '1980-01-01', '男', '台灣', 'Admin', 1, 1),
('staff@example.com', 'hashed_password_2', '員工', '李', '0922222222', '台北市大安區復興南路50號', '台北市', '台灣', '10665', '1985-05-05', '女', '台灣', 'Staff', 1, 1),
('user1@example.com', 'hashed_password_3', '小明', '張', '0933333333', '台北市松山區南京東路200號', '台北市', '台灣', '10550', '1990-10-10', '男', '台灣', 'Customer', 1, 1),
('user2@example.com', 'hashed_password_4', '小花', '陳', '0944444444', '台中市西區美村路100號', '台中市', '台灣', '40360', '1992-12-12', '女', '台灣', 'Customer', 1, 1),
('user3@example.com', 'hashed_password_5', '小華', '林', '0955555555', '高雄市左營區博愛路200號', '高雄市', '台灣', '81368', '1988-08-08', '男', '台灣', 'Customer', 1, 1);

-- 10. 插入價格方案資料
INSERT INTO PricePlan (RoomTypeID, Name, Description, ValidFrom, ValidTo, DayOfWeekBitmask, Price, IsBreakfastIncluded, IsRefundable, MinStayLength)
VALUES 
-- 台北豪華飯店價格方案
(1, '標準價', '單人房標準價格', '2023-01-01', '2023-12-31', 127, 3500.00, 1, 1, 1),
(1, '週末價', '單人房週末價格', '2023-01-01', '2023-12-31', 96, 4000.00, 1, 1, 1),
(2, '標準價', '雙人房標準價格', '2023-01-01', '2023-12-31', 127, 4500.00, 1, 1, 1),
(2, '週末價', '雙人房週末價格', '2023-01-01', '2023-12-31', 96, 5000.00, 1, 1, 1),
(3, '標準價', '家庭房標準價格', '2023-01-01', '2023-12-31', 127, 6000.00, 1, 1, 1),
(4, '標準價', '總統套房標準價格', '2023-01-01', '2023-12-31', 127, 15000.00, 1, 1, 1),
-- 高雄海灣度假村價格方案
(5, '標準價', '海景單人房標準價格', '2023-01-01', '2023-12-31', 127, 3000.00, 1, 1, 1),
(6, '標準價', '海景雙人房標準價格', '2023-01-01', '2023-12-31', 127, 4000.00, 1, 1, 1),
(7, '標準價', '豪華套房標準價格', '2023-01-01', '2023-12-31', 127, 6500.00, 1, 1, 1),
-- 台中花園飯店價格方案
(8, '標準價', '標準單人房標準價格', '2023-01-01', '2023-12-31', 127, 2500.00, 1, 1, 1),
(9, '標準價', '標準雙人房標準價格', '2023-01-01', '2023-12-31', 127, 3200.00, 1, 1, 1),
(10, '標準價', '商務套房標準價格', '2023-01-01', '2023-12-31', 127, 4500.00, 1, 1, 1);

-- 11. 插入促銷活動資料
INSERT INTO Promotion (Name, Description, DiscountType, DiscountValue, ValidFrom, ValidTo, PromotionCode, MinimumStay, IsActive)
VALUES 
('早鳥優惠', '提前30天預訂可享有85折優惠', 'Percentage', 15.00, '2023-01-01', '2023-12-31', 'EARLY', 1, 1),
('長住優惠', '連續住宿3晚以上可享有9折優惠', 'Percentage', 10.00, '2023-01-01', '2023-12-31', 'LONGSTAY', 3, 1),
('週年慶特惠', '飯店週年慶特別優惠', 'Percentage', 20.00, '2023-06-01', '2023-06-30', 'ANNIV', 1, 1),
('平日特惠', '週一至週四入住可享有定價85折', 'Percentage', 15.00, '2023-01-01', '2023-12-31', 'WEEKDAY', 1, 1);

-- 12. 插入預訂資料
INSERT INTO Booking (BookingReference, UserID, BookingDate, CheckInDate, CheckOutDate, AdultCount, ChildCount, SpecialRequests, TotalAmount, DiscountAmount, TaxAmount, FinalAmount, BookingStatus, PromotionID, PaymentStatus)
VALUES 
('BK-20230501-001', 3, '2023-04-15', '2023-05-01', '2023-05-03', 1, 0, '希望有安靜的房間', 7000.00, 700.00, 315.00, 6615.00, 'Confirmed', 2, 'Paid'),
('BK-20230510-002', 4, '2023-04-20', '2023-05-10', '2023-05-12', 2, 1, '需要一個嬰兒床', 9000.00, 0.00, 450.00, 9450.00, 'Confirmed', NULL, 'Paid'),
('BK-20230605-003', 5, '2023-05-20', '2023-06-05', '2023-06-08', 2, 0, '希望有海景房', 12000.00, 2400.00, 480.00, 10080.00, 'Confirmed', 3, 'Paid'),
('BK-20230615-004', 3, '2023-06-01', '2023-06-15', '2023-06-16', 1, 0, NULL, 2500.00, 375.00, 106.25, 2231.25, 'Confirmed', 4, 'Paid');

-- 13. 插入預訂明細資料
INSERT INTO BookingDetail (BookingID, RoomID, RoomTypeID, PricePlanID, DateFrom, DateTo, DailyRate, TaxRate, TotalAmount, GuestFirstName, GuestLastName)
VALUES 
(1, 3, 2, 3, '2023-05-01', '2023-05-03', 4500.00, 5.00, 9450.00, '小明', '張'),
(2, 11, 6, 8, '2023-05-10', '2023-05-12', 4000.00, 5.00, 8400.00, '小花', '陳'),
(3, 12, 7, 9, '2023-06-05', '2023-06-08', 6500.00, 5.00, 20475.00, '小華', '林'),
(4, 13, 8, 10, '2023-06-15', '2023-06-16', 2500.00, 5.00, 2625.00, '小明', '張');

-- 14. 插入付款資料
INSERT INTO Payment (BookingID, Amount, PaymentDate, PaymentMethod, PaymentStatus, TransactionID, CardType, Last4Digits)
VALUES 
(1, 6615.00, '2023-04-15', 'CreditCard', 'Completed', 'TXN-20230415-001', 'Visa', '4321'),
(2, 9450.00, '2023-04-20', 'CreditCard', 'Completed', 'TXN-20230420-002', 'MasterCard', '5678'),
(3, 10080.00, '2023-05-20', 'BankTransfer', 'Completed', 'TXN-20230520-003', NULL, NULL),
(4, 2231.25, '2023-06-01', 'CreditCard', 'Completed', 'TXN-20230601-004', 'Visa', '1234');

-- 15. 插入發票資料
INSERT INTO Invoice (BookingID, InvoiceNumber, InvoiceDate, DueDate, Amount, TaxAmount, TotalAmount, Status, BillingName)
VALUES 
(1, 'INV-20230415-001', '2023-04-15', '2023-04-22', 6300.00, 315.00, 6615.00, 'Paid', '張小明'),
(2, 'INV-20230420-002', '2023-04-20', '2023-04-27', 9000.00, 450.00, 9450.00, 'Paid', '陳小花'),
(3, 'INV-20230520-003', '2023-05-20', '2023-05-27', 9600.00, 480.00, 10080.00, 'Paid', '林小華'),
(4, 'INV-20230601-004', '2023-06-01', '2023-06-08', 2125.00, 106.25, 2231.25, 'Paid', '張小明');

-- 16. 插入評價資料
INSERT INTO Review (BookingID, UserID, HotelID, Rating, Title, Content, ReviewDate, CleanlinessRating, ServiceRating, LocationRating, ValueRating, IsVerified, IsPublished)
VALUES 
(1, 3, 1, 4.5, '舒適的住宿體驗', '房間很舒適，服務也很好，但價格稍高', '2023-05-04', 5.0, 4.5, 4.0, 4.0, 1, 1),
(2, 4, 2, 5.0, '超棒的海景度假村', '房間的海景非常漂亮，服務人員也很親切', '2023-05-13', 5.0, 5.0, 5.0, 4.5, 1, 1),
(3, 5, 2, 4.0, '不錯的住宿選擇', '房間寬敞，設施齊全，但有點吵', '2023-06-09', 4.5, 4.0, 4.0, 3.5, 1, 1);

-- 17. 插入員工資料
INSERT INTO Staff (UserID, HotelID, FirstName, LastName, Position, Department, HireDate, Phone, Email, Address)
VALUES 
(1, 1, '管理員', '王', '總經理', '管理部', '2020-01-01', '0911111111', 'admin@example.com', '台北市中正區忠孝東路100號'),
(2, 1, '員工', '李', '前台經理', '客服部', '2021-05-01', '0922222222', 'staff@example.com', '台北市大安區復興南路50號');

-- 18. 插入維護記錄資料
INSERT INTO MaintenanceRecord (RoomID, ReportedByStaffID, ReportDate, Issue, Priority, Status, AssignedToStaffID, StartDate, CompletionDate)
VALUES 
(6, 1, '2023-04-10', '空調故障', 'High', 'Completed', 2, '2023-04-10', '2023-04-11'),
(14, 2, '2023-05-15', '電視無法開機', 'Medium', 'Completed', 2, '2023-05-15', '2023-05-16');

-- 19. 插入清潔記錄資料
INSERT INTO CleaningRecord (RoomID, CleanedByStaffID, CleaningDate, Status, VerifiedByStaffID, VerificationDate)
VALUES 
(4, 2, '2023-05-03', 'Completed', 1, '2023-05-03'),
(10, 2, '2023-05-12', 'Completed', 1, '2023-05-12'),
(14, 2, '2023-06-01', 'Completed', 1, '2023-06-01'); 