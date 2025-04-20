# 🏨 飯店訂房網站關聯式資料庫設計

## 📊 資料庫設計概述

本系統設計了一個完整、可擴展的飯店訂房網站關聯式資料庫，包含**20個主要實體表格**，涵蓋從飯店管理到客戶訂房的所有必要功能。此設計遵循**第三範式(3NF)**，確保資料一致性與完整性，同時盡量減少資料冗餘。

## 🌟 系統設計理念與目標

此設計不僅僅是一個前端訂房介面的後端支持，而是一個**端到端的整合系統**，致力於：

1. **完整業務流程支持**：從用戶瀏覽到完成訂房、入住和退房的全過程
2. **飯店多維度管理**：支持多家飯店、多種房型與價格策略管理
3. **客戶體驗優化**：通過準確的房間可用性管理和個人化服務提升客戶體驗
4. **營運效率提升**：整合前後台系統，實現資訊即時流通，減少人工操作錯誤
5. **資料分析支持**：提供豐富的資料結構支持業務分析和決策

## 📋 主要資料表分類

### 🏢 飯店與房間管理相關表格

| 類別 | 包含表格 | 設計理由 |
|------|---------|---------|
| 飯店基礎資料 | Hotel, HotelAmenity, HotelHasAmenity, HotelImage | 提供完整的飯店資訊展示，增強客戶預訂體驗 |
| 房型與房間 | RoomType, RoomAmenity, RoomTypeHasAmenity, RoomTypeImage, Room | 細化房間管理，支持精確的可用性檢查和價格差異化 |
| 價格與促銷 | PricePlan, Promotion | 實現靈活的定價策略和促銷活動，提高收益管理能力 |

### 👥 客戶與訂單相關表格

| 類別 | 包含表格 | 設計理由 |
|------|---------|---------|
| 用戶資料 | User | 統一管理用戶資訊，支持不同角色（客戶、員工、管理員） |
| 訂房流程 | Booking, BookingDetail | 分離訂單頭和訂單明細，支持多房間預訂和詳細的訂單追蹤 |
| 財務處理 | Payment, Invoice | 追蹤支付過程和財務記錄，滿足會計需求 |
| 客戶反饋 | Review | 收集和管理客戶評價，提供服務改進依據和新客戶參考 |

### 👷 運營與管理相關表格

| 類別 | 包含表格 | 設計理由 |
|------|---------|---------|
| 員工管理 | Staff | 管理飯店員工資訊，支持權限控制和工作分配 |
| 房間狀態追蹤 | MaintenanceRecord, CleaningRecord | **為何在訂房系統中納入這些表格？** 這些表格直接影響房間可用性和客戶體驗：<br>- 維護記錄追蹤房間設施問題，避免將有問題的房間分配給客戶<br>- 清潔記錄確保房間在客人入住前已完成清潔，提高客戶滿意度<br>- 支持房間狀態的實時更新，減少預訂衝突和超額預訂問題 |

## 💾 核心資料表詳細說明與示例

### 1. 飯店表 (Hotel)
- **主鍵**: HotelID
- **主要屬性**: Name, Address, City, Country, Phone, StarRating, CheckinTime, CheckoutTime
- **描述**: 儲存飯店的基本資訊，是整個系統的核心實體。
- **示例資料**:
  ```
  HotelID: 1
  Name: '陽光海灘度假飯店'
  Address: '海濱路123號'
  City: '墾丁'
  Country: '台灣'
  Phone: '0912345678'
  StarRating: 4.5
  CheckinTime: '15:00'
  CheckoutTime: '11:00'
  ```

### 5. 房型表 (RoomType)
- **主鍵**: RoomTypeID
- **外鍵**: HotelID 參考 Hotel
- **主要屬性**: Name, Description, BasePrice, MaxOccupancy, BedConfiguration
- **描述**: 定義飯店提供的不同房型及其基本屬性。
- **示例資料**:
  ```
  RoomTypeID: 1
  HotelID: 1
  Name: '豪華海景雙人房'
  Description: '寬敞的房間配有陽台，可欣賞迷人的海景'
  BasePrice: 3500.00
  BaseCurrency: 'TWD'
  MaxOccupancy: 2
  BedConfiguration: '1張特大床'
  ```

### 9. 客房表 (Room)
- **主鍵**: RoomID
- **外鍵**: HotelID 參考 Hotel, RoomTypeID 參考 RoomType
- **主要屬性**: RoomNumber, Floor, Status
- **描述**: 代表飯店的實際物理房間，包含房間號碼、樓層和狀態。
- **示例資料**:
  ```
  RoomID: 101
  HotelID: 1
  RoomTypeID: 1
  RoomNumber: '501'
  Floor: '5'
  Status: 'Available'
  ```

### 13. 預訂表 (Booking)
- **主鍵**: BookingID
- **外鍵**: UserID 參考 User, PromotionID 參考 Promotion
- **主要屬性**: BookingReference, CheckInDate, CheckOutDate, AdultCount, TotalAmount, BookingStatus
- **描述**: 儲存客戶的預訂資訊。
- **示例資料**:
  ```
  BookingID: 1001
  BookingReference: 'BK20231215001'
  UserID: 501
  BookingDate: '2023-12-01 14:30:00'
  CheckInDate: '2023-12-15'
  CheckOutDate: '2023-12-17'
  AdultCount: 2
  ChildCount: 0
  TotalAmount: 7000.00
  DiscountAmount: 700.00
  FinalAmount: 6300.00
  BookingStatus: 'Confirmed'
  ```

### 14. 預訂明細表 (BookingDetail)
- **主鍵**: BookingDetailID
- **外鍵**: BookingID 參考 Booking, RoomID 參考 Room, RoomTypeID 參考 RoomType
- **主要屬性**: DateFrom, DateTo, DailyRate, TotalAmount, GuestName
- **描述**: 儲存預訂中的每個房間的詳細資訊。
- **示例資料**:
  ```
  BookingDetailID: 2001
  BookingID: 1001
  RoomID: 101
  RoomTypeID: 1
  DateFrom: '2023-12-15'
  DateTo: '2023-12-17'
  DailyRate: 3500.00
  TotalAmount: 7000.00
  GuestFirstName: '志明'
  GuestLastName: '陳'
  Status: 'Confirmed'
  ```

### 18. 員工表 (Staff)
- **主鍵**: StaffID
- **外鍵**: UserID 參考 User, HotelID 參考 Hotel
- **主要屬性**: FirstName, LastName, Position, Department, HireDate
- **描述**: 儲存飯店員工的資訊。
- **為何需要此表格**: 支援系統後端管理，包括處理訂房、客房服務和問題解決。員工是連接系統和實際服務的關鍵。
- **示例資料**:
  ```
  StaffID: 101
  UserID: 701
  HotelID: 1
  FirstName: '美玲'
  LastName: '林'
  Position: '前台經理'
  Department: '客戶服務'
  HireDate: '2022-03-15'
  ```

### 19. 維護記錄表 (MaintenanceRecord)
- **主鍵**: RecordID
- **外鍵**: RoomID 參考 Room, ReportedByStaffID 參考 Staff
- **主要屬性**: ReportDate, Issue, Priority, Status
- **描述**: 追蹤房間的維護記錄。
- **為何需要此表格**: 
  - 確保房間設施正常運作，提升客戶滿意度
  - 影響訂房系統中房間的可用性狀態
  - 預防將有問題的房間分配給客戶
- **示例資料**:
  ```
  RecordID: 501
  RoomID: 101
  ReportedByStaffID: 102
  ReportDate: '2023-11-30 09:15:00'
  Issue: '空調系統噪音過大'
  Priority: 'High'
  Status: 'In Progress'
  ```

### 20. 清潔記錄表 (CleaningRecord)
- **主鍵**: RecordID
- **外鍵**: RoomID 參考 Room, CleanedByStaffID 參考 Staff
- **主要屬性**: CleaningDate, Status, VerificationDate
- **描述**: 追蹤房間的清潔記錄。
- **為何需要此表格**:
  - 確保房間在客人入住前已完成清潔與消毒
  - 協調清潔工作的排程，優先處理即將入住的房間
  - 實時更新房間狀態，提高運營效率
- **示例資料**:
  ```
  RecordID: 601
  RoomID: 101
  CleanedByStaffID: 103
  CleaningDate: '2023-12-10 11:30:00'
  Status: 'Completed'
  VerifiedByStaffID: 101
  VerificationDate: '2023-12-10 12:15:00'
  ```

## 🔄 實體關係與基數關係

1. **飯店 (1) ↔ 房型 (N)**: 一個飯店可以有多種房型，但每種房型只屬於一個飯店
2. **飯店 (1) ↔ 客房 (N)**: 一個飯店有多個客房，但每個客房只屬於一個飯店
3. **房型 (1) ↔ 客房 (N)**: 一種房型可以有多個客房，但每個客房只屬於一種房型
4. **飯店 (M) ↔ 飯店設施 (N)**: 多對多關係，一個飯店可提供多種設施，一種設施可以出現在多個飯店中
5. **房型 (M) ↔ 房型設施 (N)**: 多對多關係，一種房型可提供多種設施，一種設施可以出現在多種房型中
6. **用戶 (1) ↔ 預訂 (N)**: 一個用戶可以有多筆預訂，但每筆預訂只對應一個用戶
7. **預訂 (1) ↔ 預訂明細 (N)**: 一筆預訂可以包含多筆預訂明細，但每筆預訂明細只對應一筆預訂
8. **客房 (1) ↔ 預訂明細 (N)**: 一個客房可以有多筆預訂明細，但每筆預訂明細只對應一個客房
9. **預訂 (1) ↔ 付款 (N)**: 一筆預訂可以有多筆付款，但每筆付款只對應一筆預訂
10. **預訂 (1) ↔ 評價 (1)**: 一筆預訂最多有一筆評價，每筆評價對應一筆預訂
11. **飯店 (1) ↔ 員工 (N)**: 一個飯店有多名員工，但每名員工只屬於一個飯店
12. **客房 (1) ↔ 維護記錄 (N)**: 一個客房可以有多筆維護記錄，但每筆維護記錄只對應一個客房
13. **客房 (1) ↔ 清潔記錄 (N)**: 一個客房可以有多筆清潔記錄，但每筆清潔記錄只對應一個客房

## 📝 資料庫範式

此資料庫設計符合**第三範式 (3NF)** 標準，確保：
1. 所有表格都有明確的主鍵
2. 所有非鍵屬性都完全依賴於主鍵
3. 所有非鍵屬性都只依賴於主鍵，而非依賴於其他非鍵屬性
4. 透過外鍵關聯建立表格之間的關係，避免資料冗餘

## 🔄 核心業務流程

### 預訂流程
1. 用戶瀏覽飯店和房型
2. 選擇入住和退房日期
3. 系統檢查所選日期和房型的可用性
4. 用戶提供個人資訊並確認預訂
5. 系統處理付款
6. 生成預訂編號和確認信
7. 記錄相關資訊到預訂和預訂明細表

### 房間狀態管理流程
1. 客人退房後，房間狀態更新為「需清潔」
2. 清潔人員接收清潔任務
3. 完成清潔後，更新清潔記錄
4. 主管驗證清潔質量
5. 房間狀態更新為「可入住」
6. 若發現設施問題，創建維護記錄
7. 維護完成後，房間恢復「可入住」狀態

## 💡 系統優勢與特色

1. **整合性**: 前端訂房和後端管理緊密結合，資訊即時同步
2. **彈性**: 支持多種價格策略和促銷方式
3. **完整性**: 涵蓋從預訂到入住、退房的完整流程
4. **可追溯性**: 詳細記錄每個房間的預訂、清潔和維護歷史
5. **客戶體驗**: 通過房間狀態的準確管理，提供更可靠的預訂體驗

## 🚀 未來擴展方向

1. 會員積分和等級系統
2. 與第三方訂房平台整合
3. 自動化客房分配算法
4. 房間庫存預測和動態定價
5. 客戶行為分析和個人化推薦

---

這個資料庫設計可以支持一個完整功能的飯店訂房網站，包括線上預訂、管理預訂、處理付款和發票、管理評價和客房維護，為用戶提供流暢的預訂體驗，同時為飯店管理者提供有效的營運管理工具。 