# 飯店訂房網站關聯式資料庫設計 - ER圖說明

## 實體關係圖概述

本文檔描述了飯店訂房網站的關聯式資料庫設計實體關係圖（ER圖）。此設計包含20個主要實體，它們之間的關係及基數關係如下所述。

## 主要實體與屬性

### 1. 飯店實體 (Hotel)
- **主鍵**: HotelID
- **主要屬性**: Name, Address, City, Country, PostalCode, Phone, Email, Website, Description, StarRating, CheckinTime, CheckoutTime
- **描述**: 儲存飯店的基本資訊，是整個系統的核心實體。

### 2. 飯店設施 (HotelAmenity)
- **主鍵**: AmenityID
- **主要屬性**: Name, Description, Icon
- **描述**: 定義飯店可能提供的各種設施或服務。

### 3. 飯店與設施關聯 (HotelHasAmenity)
- **主鍵**: (HotelID, AmenityID)
- **外鍵**: HotelID 參考 Hotel, AmenityID 參考 HotelAmenity
- **描述**: 多對多關係表，連接飯店與其提供的設施。

### 4. 飯店圖片 (HotelImage)
- **主鍵**: ImageID
- **外鍵**: HotelID 參考 Hotel
- **主要屬性**: ImageURL, Caption, IsPrimary, DisplayOrder
- **描述**: 儲存與飯店相關的圖片。

### 5. 房型 (RoomType)
- **主鍵**: RoomTypeID
- **外鍵**: HotelID 參考 Hotel
- **主要屬性**: Name, Description, BasePrice, BaseCurrency, MaxOccupancy, BedConfiguration, RoomSize
- **描述**: 定義飯店提供的不同房型及其基本屬性。

### 6. 房型設施 (RoomAmenity)
- **主鍵**: AmenityID
- **主要屬性**: Name, Description, Icon
- **描述**: 定義房間可能提供的各種設施或服務。

### 7. 房型與設施關聯 (RoomTypeHasAmenity)
- **主鍵**: (RoomTypeID, AmenityID)
- **外鍵**: RoomTypeID 參考 RoomType, AmenityID 參考 RoomAmenity
- **描述**: 多對多關係表，連接房型與其提供的設施。

### 8. 房型圖片 (RoomTypeImage)
- **主鍵**: ImageID
- **外鍵**: RoomTypeID 參考 RoomType
- **主要屬性**: ImageURL, Caption, IsPrimary, DisplayOrder
- **描述**: 儲存與房型相關的圖片。

### 9. 客房 (Room)
- **主鍵**: RoomID
- **外鍵**: HotelID 參考 Hotel, RoomTypeID 參考 RoomType
- **主要屬性**: RoomNumber, Floor, Status, Notes
- **描述**: 代表飯店的實際物理房間，包含房間號碼、樓層和狀態。

### 10. 用戶 (User)
- **主鍵**: UserID
- **主要屬性**: Email, PasswordHash, FirstName, LastName, Phone, Address, City, Country, PostalCode, DateOfBirth, Gender, Nationality, PassportNumber, UserType, RegistrationDate, LastLoginDate, IsVerified, IsActive
- **描述**: 儲存系統使用者的資訊，包括客戶、管理員和員工。

### 11. 價格方案 (PricePlan)
- **主鍵**: PricePlanID
- **外鍵**: RoomTypeID 參考 RoomType
- **主要屬性**: Name, Description, ValidFrom, ValidTo, DayOfWeekBitmask, Price, Currency, IsBreakfastIncluded, IsRefundable, RefundPercentage, MinStayLength, MaxStayLength, AdvanceBookingDays
- **描述**: 定義房型在特定時間段的價格方案。

### 12. 促銷活動 (Promotion)
- **主鍵**: PromotionID
- **主要屬性**: Name, Description, DiscountType, DiscountValue, ValidFrom, ValidTo, PromotionCode, MinimumStay, MinimumAmount, ApplicableRoomTypes, ApplicableHotels, MaxUsageCount, CurrentUsageCount
- **描述**: 儲存各種促銷活動或折扣方案的資訊。

### 13. 預訂 (Booking)
- **主鍵**: BookingID
- **外鍵**: UserID 參考 User, PromotionID 參考 Promotion
- **主要屬性**: BookingReference, BookingDate, CheckInDate, CheckOutDate, AdultCount, ChildCount, SpecialRequests, TotalAmount, DiscountAmount, TaxAmount, FinalAmount, Currency, BookingStatus, PaymentStatus, CancellationDate, CancellationReason, RefundAmount, BookingSource
- **描述**: 儲存客戶的預訂資訊。

### 14. 預訂明細 (BookingDetail)
- **主鍵**: BookingDetailID
- **外鍵**: BookingID 參考 Booking, RoomID 參考 Room, RoomTypeID 參考 RoomType, PricePlanID 參考 PricePlan
- **主要屬性**: DateFrom, DateTo, DailyRate, TaxRate, TotalAmount, GuestFirstName, GuestLastName, Status, Notes
- **描述**: 儲存預訂中的每個房間的詳細資訊。

### 15. 付款 (Payment)
- **主鍵**: PaymentID
- **外鍵**: BookingID 參考 Booking
- **主要屬性**: Amount, Currency, PaymentDate, PaymentMethod, PaymentStatus, TransactionID, CardType, Last4Digits, Notes
- **描述**: 儲存與預訂相關的付款記錄。

### 16. 發票 (Invoice)
- **主鍵**: InvoiceID
- **外鍵**: BookingID 參考 Booking
- **主要屬性**: InvoiceNumber, InvoiceDate, DueDate, Amount, TaxAmount, TotalAmount, Currency, Status, BillingAddress, BillingName, Notes
- **描述**: 儲存與預訂相關的發票資訊。

### 17. 評價 (Review)
- **主鍵**: ReviewID
- **外鍵**: BookingID 參考 Booking, UserID 參考 User, HotelID 參考 Hotel
- **主要屬性**: Rating, Title, Content, ReviewDate, CleanlinessRating, ServiceRating, LocationRating, ValueRating, IsVerified, IsPublished
- **描述**: 儲存客戶對飯店的評價和評分。

### 18. 員工 (Staff)
- **主鍵**: StaffID
- **外鍵**: UserID 參考 User, HotelID 參考 Hotel
- **主要屬性**: FirstName, LastName, Position, Department, HireDate, Phone, Email, Address, IsActive
- **描述**: 儲存飯店員工的資訊。

### 19. 維護記錄 (MaintenanceRecord)
- **主鍵**: RecordID
- **外鍵**: RoomID 參考 Room, ReportedByStaffID 參考 Staff, AssignedToStaffID 參考 Staff
- **主要屬性**: ReportDate, Issue, Priority, Status, StartDate, CompletionDate, Notes
- **描述**: 追蹤房間的維護記錄。

### 20. 清潔記錄 (CleaningRecord)
- **主鍵**: RecordID
- **外鍵**: RoomID 參考 Room, CleanedByStaffID 參考 Staff, VerifiedByStaffID 參考 Staff
- **主要屬性**: CleaningDate, Status, VerificationDate, Notes
- **描述**: 追蹤房間的清潔記錄。

## 實體關係與基數關係

1. **飯店 (1) ↔ 房型 (N)**: 一個飯店可以有多種房型，但每種房型只屬於一個飯店
2. **飯店 (1) ↔ 客房 (N)**: 一個飯店有多個客房，但每個客房只屬於一個飯店
3. **房型 (1) ↔ 客房 (N)**: 一種房型可以有多個客房，但每個客房只屬於一種房型
4. **飯店 (M) ↔ 飯店設施 (N)**: 多對多關係，一個飯店可提供多種設施，一種設施可以出現在多個飯店中
5. **房型 (M) ↔ 房型設施 (N)**: 多對多關係，一種房型可提供多種設施，一種設施可以出現在多種房型中
6. **用戶 (1) ↔ 預訂 (N)**: 一個用戶可以有多筆預訂，但每筆預訂只對應一個用戶
7. **預訂 (1) ↔ 預訂明細 (N)**: 一筆預訂可以包含多筆預訂明細，但每筆預訂明細只對應一筆預訂
8. **客房 (1) ↔ 預訂明細 (N)**: 一個客房可以有多筆預訂明細，但每筆預訂明細只對應一個客房
9. **促銷活動 (1) ↔ 預訂 (N)**: 一個促銷活動可以應用於多筆預訂，但每筆預訂最多使用一個促銷活動
10. **價格方案 (1) ↔ 預訂明細 (N)**: 一個價格方案可以應用於多筆預訂明細，但每筆預訂明細最多使用一個價格方案
11. **預訂 (1) ↔ 付款 (N)**: 一筆預訂可以有多筆付款，但每筆付款只對應一筆預訂
12. **預訂 (1) ↔ 發票 (N)**: 一筆預訂可以有多張發票，但每張發票只對應一筆預訂
13. **預訂 (1) ↔ 評價 (1)**: 一筆預訂最多有一筆評價，每筆評價對應一筆預訂
14. **飯店 (1) ↔ 員工 (N)**: 一個飯店有多名員工，但每名員工只屬於一個飯店
15. **客房 (1) ↔ 維護記錄 (N)**: 一個客房可以有多筆維護記錄，但每筆維護記錄只對應一個客房
16. **客房 (1) ↔ 清潔記錄 (N)**: 一個客房可以有多筆清潔記錄，但每筆清潔記錄只對應一個客房
17. **用戶 (1) ↔ 員工 (1)**: 一個用戶可以關聯到一名員工（如果該用戶是員工），每名員工對應一個用戶

## 資料庫範式

此資料庫設計符合第三範式 (3NF) 標準：
1. 所有表格都有明確的主鍵
2. 所有非鍵屬性都完全依賴於主鍵
3. 所有非鍵屬性都只依賴於主鍵，而非依賴於其他非鍵屬性
4. 透過外鍵關聯建立表格之間的關係，避免資料冗餘

## 特殊考量

1. **預訂流程**：從用戶建立預訂，選擇房型和日期，系統檢查可用性，生成預訂明細，處理付款，發送確認信
2. **房間狀態管理**：跟蹤房間的狀態（可用、已預訂、已入住、清潔中、維護中等）
3. **價格計算**：基於房型基本價格、季節性調整、促銷折扣、會員等級等因素計算最終價格
4. **報表生成**：收入報表、入住率統計、客戶來源分析等

這個資料庫設計可以支持一個完整功能的飯店訂房網站，包括線上預訂、管理預訂、處理付款和發票、管理評價和客房維護。 