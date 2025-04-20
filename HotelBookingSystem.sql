-- 飯店訂房系統資料庫設計
-- SQL Server版本

-- 創建資料庫
CREATE DATABASE HotelBookingSystem;
GO

USE HotelBookingSystem;
GO

-- 1. 飯店資訊表
CREATE TABLE Hotel (
    HotelID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    City NVARCHAR(50) NOT NULL,
    Country NVARCHAR(50) NOT NULL,
    PostalCode NVARCHAR(20),
    Phone NVARCHAR(20) NOT NULL,
    Email NVARCHAR(100),
    Website NVARCHAR(100),
    Description NVARCHAR(MAX),
    StarRating DECIMAL(2,1) CHECK (StarRating BETWEEN 1 AND 5),
    CheckinTime TIME NOT NULL DEFAULT '15:00',
    CheckoutTime TIME NOT NULL DEFAULT '12:00',
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    UpdatedDate DATETIME NULL
);

-- 2. 飯店設施表
CREATE TABLE HotelAmenity (
    AmenityID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    Icon NVARCHAR(50)
);

-- 3. 飯店與設施關聯表
CREATE TABLE HotelHasAmenity (
    HotelID INT NOT NULL,
    AmenityID INT NOT NULL,
    PRIMARY KEY (HotelID, AmenityID),
    FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID),
    FOREIGN KEY (AmenityID) REFERENCES HotelAmenity(AmenityID)
);

-- 4. 飯店圖片表
CREATE TABLE HotelImage (
    ImageID INT PRIMARY KEY IDENTITY(1,1),
    HotelID INT NOT NULL,
    ImageURL NVARCHAR(255) NOT NULL,
    Caption NVARCHAR(100),
    IsPrimary BIT NOT NULL DEFAULT 0,
    DisplayOrder INT NOT NULL DEFAULT 0,
    FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID)
);

-- 5. 房型表
CREATE TABLE RoomType (
    RoomTypeID INT PRIMARY KEY IDENTITY(1,1),
    HotelID INT NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    BasePrice DECIMAL(10,2) NOT NULL,
    BaseCurrency NVARCHAR(3) NOT NULL DEFAULT 'TWD',
    MaxOccupancy INT NOT NULL,
    BedConfiguration NVARCHAR(100),
    RoomSize NVARCHAR(50),
    IsActive BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID)
);

-- 6. 房型設施表
CREATE TABLE RoomAmenity (
    AmenityID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    Icon NVARCHAR(50)
);

-- 7. 房型與設施關聯表
CREATE TABLE RoomTypeHasAmenity (
    RoomTypeID INT NOT NULL,
    AmenityID INT NOT NULL,
    PRIMARY KEY (RoomTypeID, AmenityID),
    FOREIGN KEY (RoomTypeID) REFERENCES RoomType(RoomTypeID),
    FOREIGN KEY (AmenityID) REFERENCES RoomAmenity(AmenityID)
);

-- 8. 房型圖片表
CREATE TABLE RoomTypeImage (
    ImageID INT PRIMARY KEY IDENTITY(1,1),
    RoomTypeID INT NOT NULL,
    ImageURL NVARCHAR(255) NOT NULL,
    Caption NVARCHAR(100),
    IsPrimary BIT NOT NULL DEFAULT 0,
    DisplayOrder INT NOT NULL DEFAULT 0,
    FOREIGN KEY (RoomTypeID) REFERENCES RoomType(RoomTypeID)
);

-- 9. 客房表
CREATE TABLE Room (
    RoomID INT PRIMARY KEY IDENTITY(1,1),
    HotelID INT NOT NULL,
    RoomTypeID INT NOT NULL,
    RoomNumber NVARCHAR(20) NOT NULL,
    Floor NVARCHAR(10),
    Status NVARCHAR(20) NOT NULL DEFAULT 'Available', -- Available, Occupied, Maintenance, Cleaning
    Notes NVARCHAR(255),
    IsActive BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID),
    FOREIGN KEY (RoomTypeID) REFERENCES RoomType(RoomTypeID),
    CONSTRAINT UQ_Room_HotelRoom UNIQUE (HotelID, RoomNumber)
);

-- 10. 用戶表
CREATE TABLE [User] (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Email NVARCHAR(100) NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20),
    Address NVARCHAR(255),
    City NVARCHAR(50),
    Country NVARCHAR(50),
    PostalCode NVARCHAR(20),
    DateOfBirth DATE,
    Gender NVARCHAR(10),
    Nationality NVARCHAR(50),
    PassportNumber NVARCHAR(50),
    UserType NVARCHAR(20) NOT NULL DEFAULT 'Customer', -- Customer, Admin, Staff
    RegistrationDate DATETIME NOT NULL DEFAULT GETDATE(),
    LastLoginDate DATETIME,
    IsVerified BIT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT UQ_User_Email UNIQUE (Email)
);

-- 11. 價格方案表
CREATE TABLE PricePlan (
    PricePlanID INT PRIMARY KEY IDENTITY(1,1),
    RoomTypeID INT NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    ValidFrom DATE NOT NULL,
    ValidTo DATE NOT NULL,
    DayOfWeekBitmask INT NOT NULL DEFAULT 127, -- 1=周一, 2=周二, 4=周三, 8=周四, 16=周五, 32=周六, 64=周日
    Price DECIMAL(10,2) NOT NULL,
    Currency NVARCHAR(3) NOT NULL DEFAULT 'TWD',
    IsBreakfastIncluded BIT NOT NULL DEFAULT 0,
    IsRefundable BIT NOT NULL DEFAULT 1,
    RefundPercentage DECIMAL(5,2),
    MinStayLength INT,
    MaxStayLength INT,
    AdvanceBookingDays INT,
    IsActive BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (RoomTypeID) REFERENCES RoomType(RoomTypeID),
    CONSTRAINT CHK_PricePlan_Dates CHECK (ValidTo >= ValidFrom)
);

-- 12. 促銷活動表
CREATE TABLE Promotion (
    PromotionID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    DiscountType NVARCHAR(20) NOT NULL, -- Percentage, FixedAmount
    DiscountValue DECIMAL(10,2) NOT NULL,
    ValidFrom DATETIME NOT NULL,
    ValidTo DATETIME NOT NULL,
    PromotionCode NVARCHAR(20),
    MinimumStay INT,
    MinimumAmount DECIMAL(10,2),
    ApplicableRoomTypes NVARCHAR(255), -- CSV of RoomTypeIDs or NULL for all
    ApplicableHotels NVARCHAR(255), -- CSV of HotelIDs or NULL for all
    MaxUsageCount INT,
    CurrentUsageCount INT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT CHK_Promotion_Dates CHECK (ValidTo >= ValidFrom)
);

-- 13. 預訂表
CREATE TABLE Booking (
    BookingID INT PRIMARY KEY IDENTITY(1,1),
    BookingReference NVARCHAR(20) NOT NULL,
    UserID INT NOT NULL,
    BookingDate DATETIME NOT NULL DEFAULT GETDATE(),
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    AdultCount INT NOT NULL,
    ChildCount INT NOT NULL DEFAULT 0,
    SpecialRequests NVARCHAR(MAX),
    TotalAmount DECIMAL(10,2) NOT NULL,
    DiscountAmount DECIMAL(10,2) NOT NULL DEFAULT 0,
    TaxAmount DECIMAL(10,2) NOT NULL DEFAULT 0,
    FinalAmount DECIMAL(10,2) NOT NULL,
    Currency NVARCHAR(3) NOT NULL DEFAULT 'TWD',
    BookingStatus NVARCHAR(20) NOT NULL DEFAULT 'Confirmed', -- Reserved, Confirmed, Checked In, Checked Out, Cancelled, No-Show
    PromotionID INT,
    PaymentStatus NVARCHAR(20) NOT NULL DEFAULT 'Pending', -- Pending, Partially Paid, Paid, Refunded
    CancellationDate DATETIME,
    CancellationReason NVARCHAR(255),
    RefundAmount DECIMAL(10,2),
    BookingSource NVARCHAR(50) NOT NULL DEFAULT 'Website', -- Website, Phone, Walk-in, Third-party
    FOREIGN KEY (UserID) REFERENCES [User](UserID),
    FOREIGN KEY (PromotionID) REFERENCES Promotion(PromotionID),
    CONSTRAINT CHK_Booking_Dates CHECK (CheckOutDate > CheckInDate),
    CONSTRAINT UQ_Booking_Reference UNIQUE (BookingReference)
);

-- 14. 預訂明細表
CREATE TABLE BookingDetail (
    BookingDetailID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT NOT NULL,
    RoomID INT NOT NULL,
    RoomTypeID INT NOT NULL,
    PricePlanID INT,
    DateFrom DATE NOT NULL,
    DateTo DATE NOT NULL,
    DailyRate DECIMAL(10,2) NOT NULL,
    TaxRate DECIMAL(5,2) NOT NULL DEFAULT 0,
    TotalAmount DECIMAL(10,2) NOT NULL,
    GuestFirstName NVARCHAR(50),
    GuestLastName NVARCHAR(50),
    Status NVARCHAR(20) NOT NULL DEFAULT 'Confirmed', -- Confirmed, Cancelled
    Notes NVARCHAR(255),
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID),
    FOREIGN KEY (RoomID) REFERENCES Room(RoomID),
    FOREIGN KEY (RoomTypeID) REFERENCES RoomType(RoomTypeID),
    FOREIGN KEY (PricePlanID) REFERENCES PricePlan(PricePlanID),
    CONSTRAINT CHK_BookingDetail_Dates CHECK (DateTo >= DateFrom)
);

-- 15. 付款表
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    Currency NVARCHAR(3) NOT NULL DEFAULT 'TWD',
    PaymentDate DATETIME NOT NULL DEFAULT GETDATE(),
    PaymentMethod NVARCHAR(50) NOT NULL, -- CreditCard, DebitCard, BankTransfer, Cash, Paypal
    PaymentStatus NVARCHAR(20) NOT NULL, -- Pending, Completed, Failed, Refunded
    TransactionID NVARCHAR(100),
    CardType NVARCHAR(50),
    Last4Digits NVARCHAR(4),
    Notes NVARCHAR(255),
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID)
);

-- 16. 發票表
CREATE TABLE Invoice (
    InvoiceID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT NOT NULL,
    InvoiceNumber NVARCHAR(50) NOT NULL,
    InvoiceDate DATETIME NOT NULL DEFAULT GETDATE(),
    DueDate DATETIME,
    Amount DECIMAL(10,2) NOT NULL,
    TaxAmount DECIMAL(10,2) NOT NULL DEFAULT 0,
    TotalAmount DECIMAL(10,2) NOT NULL,
    Currency NVARCHAR(3) NOT NULL DEFAULT 'TWD',
    Status NVARCHAR(20) NOT NULL DEFAULT 'Issued', -- Draft, Issued, Paid, Cancelled
    BillingAddress NVARCHAR(255),
    BillingName NVARCHAR(100),
    Notes NVARCHAR(255),
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID),
    CONSTRAINT UQ_Invoice_Number UNIQUE (InvoiceNumber)
);

-- 17. 評價表
CREATE TABLE Review (
    ReviewID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT NOT NULL,
    UserID INT NOT NULL,
    HotelID INT NOT NULL,
    Rating DECIMAL(3,1) NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Title NVARCHAR(100),
    Content NVARCHAR(MAX),
    ReviewDate DATETIME NOT NULL DEFAULT GETDATE(),
    CleanlinessRating DECIMAL(3,1) CHECK (CleanlinessRating BETWEEN 1 AND 5),
    ServiceRating DECIMAL(3,1) CHECK (ServiceRating BETWEEN 1 AND 5),
    LocationRating DECIMAL(3,1) CHECK (LocationRating BETWEEN 1 AND 5),
    ValueRating DECIMAL(3,1) CHECK (ValueRating BETWEEN 1 AND 5),
    IsVerified BIT NOT NULL DEFAULT 0,
    IsPublished BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID),
    FOREIGN KEY (UserID) REFERENCES [User](UserID),
    FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID)
);

-- 18. 員工表
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT,
    HotelID INT NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Position NVARCHAR(50) NOT NULL,
    Department NVARCHAR(50) NOT NULL,
    HireDate DATE NOT NULL,
    Phone NVARCHAR(20),
    Email NVARCHAR(100) NOT NULL,
    Address NVARCHAR(255),
    IsActive BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (UserID) REFERENCES [User](UserID),
    FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID),
    CONSTRAINT UQ_Staff_Email UNIQUE (Email)
);

-- 19. 維護記錄表
CREATE TABLE MaintenanceRecord (
    RecordID INT PRIMARY KEY IDENTITY(1,1),
    RoomID INT NOT NULL,
    ReportedByStaffID INT,
    ReportDate DATETIME NOT NULL DEFAULT GETDATE(),
    Issue NVARCHAR(255) NOT NULL,
    Priority NVARCHAR(20) NOT NULL DEFAULT 'Medium', -- Low, Medium, High, Urgent
    Status NVARCHAR(20) NOT NULL DEFAULT 'Reported', -- Reported, In Progress, Completed, Cancelled
    AssignedToStaffID INT,
    StartDate DATETIME,
    CompletionDate DATETIME,
    Notes NVARCHAR(MAX),
    FOREIGN KEY (RoomID) REFERENCES Room(RoomID),
    FOREIGN KEY (ReportedByStaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (AssignedToStaffID) REFERENCES Staff(StaffID)
);

-- 20. 清潔記錄表
CREATE TABLE CleaningRecord (
    RecordID INT PRIMARY KEY IDENTITY(1,1),
    RoomID INT NOT NULL,
    CleanedByStaffID INT NOT NULL,
    CleaningDate DATETIME NOT NULL DEFAULT GETDATE(),
    Status NVARCHAR(20) NOT NULL DEFAULT 'Completed', -- Scheduled, In Progress, Completed, Verified
    VerifiedByStaffID INT,
    VerificationDate DATETIME,
    Notes NVARCHAR(255),
    FOREIGN KEY (RoomID) REFERENCES Room(RoomID),
    FOREIGN KEY (CleanedByStaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (VerifiedByStaffID) REFERENCES Staff(StaffID)
); 