# 旅館預約管理系統資料庫說明文件

## 資料庫概述

- **資料庫名稱**: test1
- **建立日期**: 2023-04-23 23:11:42
- **相容性等級**: 160
- **定序規則**: Chinese_Taiwan_Stroke_CI
- **狀態**: READ_WRITE

本資料庫系統設計用於管理旅館的預約、客戶資訊和房間管理。系統包含客戶管理、房間管理、預約處理以及歷史記錄功能。

## 資料表結構

### 核心資料表

#### 客戶相關資料表

1. **Client (客戶資料表)**
   - cid (int, PK): 客戶編號
   - caccount (nvarchar(100), NOT NULL): 客戶帳號
   - cpassword (nvarchar(64), NOT NULL): 客戶密碼

2. **ClientInfo (客戶詳細資訊)**
   - cid (int, PK): 客戶編號，對應 Client 表
   - cname (nvarchar(50), NOT NULL): 客戶姓名
   - gender (nvarchar(20)): 性別
   - cbirthday (datetime, NOT NULL): 出生日期
   - emergency (nvarchar(50)): 緊急聯絡人
   - id (char(20), NOT NULL): 身分證號碼

3. **Phone (電話資料表)**
   - id (char(20), NOT NULL, PK): 身分證號碼
   - phone (nvarchar(20), NOT NULL): 電話號碼
   - emergencyphone (nvarchar(20), NOT NULL): 緊急聯絡電話

#### 房間相關資料表

4. **Room (房間資料表)**
   - rid (int, NOT NULL, PK): 房間編號
   - rdesc (nvarchar(200)): 房間描述
   - rlimit (int, NOT NULL): 房間容納人數限制
   - sid (int, NOT NULL): 狀態編號，對應 Status 表
   - tid (int): 房型編號，對應 Type 表

5. **Type (房型資料表)**
   - tid (int, NOT NULL, PK): 房型編號
   - tdesc (nvarchar(50)): 房型描述

6. **Status (狀態資料表)**
   - sid (int, NOT NULL, PK): 狀態編號
   - status (nvarchar(50)): 狀態描述

7. **Price (價格資料表)**
   - rlimit (int, NOT NULL): 房間容納人數限制
   - rprice (int, NOT NULL): 房間價格

#### 預約相關資料表

8. **Reserve (預約資料表)**
   - reid (int, NOT NULL, PK): 預約編號
   - caccount (nvarchar(100), NOT NULL): 客戶帳號，對應 Client 表
   - fee (int): 費用
   - rid (int): 房間編號，對應 Room 表

9. **History (歷史記錄表)**
   - hid (int, NOT NULL, PK): 歷史記錄編號
   - caccount (nvarchar(100)): 客戶帳號，對應 Client 表
   - citime (datetime2): 入住時間
   - cetime (datetime2): 退房時間
   - reid (int): 預約編號，對應 Reserve 表

### 檢視表

1. **dbo.vw_roomView**
   - rid (int, NOT NULL): 房間編號
   - rlimit (int, NOT NULL): 房間容納人數限制
   - status (nvarchar(50)): 狀態
   - rdesc (nvarchar(50)): 房間描述

2. **dbo.vw_cAvailableView**
   - rdesc (nvarchar(200)): 房間描述
   - rid (int, NOT NULL): 房間編號
   - rlimit (int, NOT NULL): 房間容納人數限制
   - status (nvarchar(50)): 狀態
   - tdesc (nvarchar(50)): 房型描述

3. **dbo.vw_clientView**
   - birthday (nvarchar(4000)): 出生日期
   - emergency (nvarchar(50)): 緊急聯絡人
   - emergency_phone (nvarchar(20), NOT NULL): 緊急聯絡電話
   - gender (nvarchar(20)): 性別
   - name (nvarchar(50), NOT NULL): 姓名
   - phone (nvarchar(20), NOT NULL): 電話號碼

## 資料表關係

系統中的外鍵關係如下：

1. **FK_ClientInfo** - Client (cid) → ClientInfo (cid)
2. **FK_Phone** - ClientInfo (id) → Phone (id)
3. **FK_ClientH** - Client (caccount) → History (caccount)
4. **FK_Reserve** - History (reid) → Reserve (reid)
5. **FK_ClientR** - Client (caccount) → Reserve (caccount)
6. **FK_Room** - Reserve (rid) → Room (rid)
7. **FK_Price** - Room (rlimit) → Price (rlimit)
8. **FK_Status** - Room (sid) → Status (sid)
9. **FK_Type** - Room (tid) → Type (tid)

## 資料表參考關係說明

### 客戶相關
- **Client 是核心表格**：其他客戶相關表格參考此表格
  - ClientInfo 表透過 cid 欄位參考 Client 表
  - Reserve 表透過 caccount 欄位參考 Client 表
  - History 表透過 caccount 欄位參考 Client 表

- **ClientInfo 與 Phone 關係**：
  - Phone 表透過 id 欄位參考 ClientInfo 表的身分證號碼

### 房間相關
- **Room 是核心表格**：
  - Room 表透過 sid 欄位參考 Status 表取得房間狀態
  - Room 表透過 tid 欄位參考 Type 表取得房型資訊
  - Room 表透過 rlimit 欄位參考 Price 表取得價格資訊
  - Reserve 表透過 rid 欄位參考 Room 表

### 預約相關
- **Reserve 是預約核心表格**：
  - 記錄客戶(caccount)預約的房間(rid)
  - History 表透過 reid 欄位參考 Reserve 表，記錄預約的入住退房歷史

### 資料流向
1. 客戶註冊：Client → ClientInfo → Phone
2. 客戶預約：Client → Reserve → Room
3. 預約歷史：Reserve → History

## ER圖

系統的ER圖已在專案中提供，顯示了各資料表之間的關係和依賴性。主要實體包括：
- 客戶 (Client)
- 客戶資訊 (ClientInfo)
- 房間 (Room)
- 預約 (Reserve)
- 歷史記錄 (History)

以及它們之間的關聯關係。

## 業務流程說明

1. **客戶註冊流程**：
   - 客戶建立帳號 (Client 表)
   - 填寫個人資訊 (ClientInfo 表)
   - 提供聯絡方式 (Phone 表)

2. **預約流程**：
   - 客戶選擇可用房間 (使用 vw_cAvailableView 檢視)
   - 建立預約記錄 (Reserve 表)
   - 計算費用 (基於 Price 表)

3. **入住和退房流程**：
   - 客戶入住時，記錄入住時間 (History 表的 citime)
   - 客戶退房時，記錄退房時間 (History 表的 cetime)
   - 完成的預約將被保存為歷史記錄

## 系統維護建議

1. **定期備份**：建議每日進行完整備份，每小時進行差異備份。
2. **效能監控**：監控常用查詢的效能，必要時建立適當的索引。
3. **安全措施**：
   - 定期更新資料庫伺服器安全補丁
   - 使用加密保護客戶密碼和敏感資訊
   - 實施適當的存取控制機制

## 系統版本資訊

- 資料庫引擎：Microsoft SQL Server 2022 (RTM) - 16.0.1000.6 (X64)
- 版本：Express Edition (64-bit)
- 作業系統：Windows 10 Pro (Build 19045)
