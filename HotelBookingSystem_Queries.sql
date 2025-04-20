-- 飯店訂房系統常用查詢
-- 使用SQL Server

USE HotelBookingSystem;
GO

-- 1. 查詢指定日期範圍內的可用房間
CREATE OR ALTER PROCEDURE GetAvailableRooms
    @HotelID INT,
    @CheckInDate DATE,
    @CheckOutDate DATE
AS
BEGIN
    SELECT 
        r.RoomID,
        r.RoomNumber,
        r.Floor,
        rt.Name AS RoomTypeName,
        rt.BasePrice,
        rt.MaxOccupancy,
        rt.BedConfiguration,
        rt.RoomSize
    FROM 
        Room r
    JOIN 
        RoomType rt ON r.RoomTypeID = rt.RoomTypeID
    WHERE 
        r.HotelID = @HotelID
        AND r.IsActive = 1
        AND r.Status = 'Available'
        AND r.RoomID NOT IN (
            -- 排除已被預訂的房間
            SELECT bd.RoomID
            FROM BookingDetail bd
            JOIN Booking b ON bd.BookingID = b.BookingID
            WHERE 
                b.BookingStatus IN ('Confirmed', 'Checked In')
                AND (
                    (@CheckInDate BETWEEN bd.DateFrom AND DATEADD(DAY, -1, bd.DateTo))
                    OR (@CheckOutDate BETWEEN DATEADD(DAY, 1, bd.DateFrom) AND bd.DateTo)
                    OR (bd.DateFrom BETWEEN @CheckInDate AND DATEADD(DAY, -1, @CheckOutDate))
                    OR (bd.DateTo BETWEEN DATEADD(DAY, 1, @CheckInDate) AND @CheckOutDate)
                )
        );
END;
GO

-- 2. 查詢指定時間範圍內的收入報表
CREATE OR ALTER PROCEDURE GetRevenueReport
    @StartDate DATE,
    @EndDate DATE,
    @HotelID INT = NULL
AS
BEGIN
    SELECT 
        h.HotelID,
        h.Name AS HotelName,
        SUM(p.Amount) AS TotalRevenue,
        COUNT(DISTINCT b.BookingID) AS BookingCount,
        SUM(DATEDIFF(DAY, b.CheckInDate, b.CheckOutDate) * bd.DailyRate) AS RoomRevenue,
        AVG(b.FinalAmount) AS AverageBookingValue
    FROM 
        Payment p
    JOIN 
        Booking b ON p.BookingID = b.BookingID
    JOIN 
        BookingDetail bd ON b.BookingID = bd.BookingID
    JOIN 
        Room r ON bd.RoomID = r.RoomID
    JOIN 
        Hotel h ON r.HotelID = h.HotelID
    WHERE 
        p.PaymentDate BETWEEN @StartDate AND @EndDate
        AND p.PaymentStatus = 'Completed'
        AND (@HotelID IS NULL OR h.HotelID = @HotelID)
    GROUP BY 
        h.HotelID, h.Name
    ORDER BY 
        TotalRevenue DESC;
END;
GO

-- 3. 查詢房型入住率
CREATE OR ALTER PROCEDURE GetOccupancyRateByRoomType
    @StartDate DATE,
    @EndDate DATE,
    @HotelID INT = NULL
AS
BEGIN
    -- 計算日期範圍內的總天數
    DECLARE @TotalDays INT = DATEDIFF(DAY, @StartDate, @EndDate) + 1;
    
    SELECT 
        h.HotelID,
        h.Name AS HotelName,
        rt.RoomTypeID,
        rt.Name AS RoomTypeName,
        COUNT(DISTINCT r.RoomID) AS TotalRooms,
        SUM(
            CASE 
                WHEN bd.BookingDetailID IS NOT NULL THEN 
                    DATEDIFF(DAY, 
                        CASE 
                            WHEN bd.DateFrom < @StartDate THEN @StartDate 
                            ELSE bd.DateFrom 
                        END, 
                        CASE 
                            WHEN bd.DateTo > @EndDate THEN @EndDate 
                            ELSE bd.DateTo 
                        END
                    ) + 1
                ELSE 0
            END
        ) AS OccupiedDays,
        CAST(
            SUM(
                CASE 
                    WHEN bd.BookingDetailID IS NOT NULL THEN 
                        DATEDIFF(DAY, 
                            CASE 
                                WHEN bd.DateFrom < @StartDate THEN @StartDate 
                                ELSE bd.DateFrom 
                            END, 
                            CASE 
                                WHEN bd.DateTo > @EndDate THEN @EndDate 
                                ELSE bd.DateTo 
                            END
                        ) + 1
                    ELSE 0
                END
            ) * 100.0 / (COUNT(DISTINCT r.RoomID) * @TotalDays) AS DECIMAL(5, 2)
        ) AS OccupancyRate
    FROM 
        Hotel h
    JOIN 
        RoomType rt ON h.HotelID = rt.HotelID
    JOIN 
        Room r ON rt.RoomTypeID = r.RoomTypeID
    LEFT JOIN 
        BookingDetail bd ON r.RoomID = bd.RoomID 
        AND bd.DateFrom <= @EndDate 
        AND bd.DateTo >= @StartDate
    LEFT JOIN 
        Booking b ON bd.BookingID = b.BookingID 
        AND b.BookingStatus IN ('Confirmed', 'Checked In', 'Checked Out')
    WHERE 
        (@HotelID IS NULL OR h.HotelID = @HotelID)
        AND r.IsActive = 1
    GROUP BY 
        h.HotelID, h.Name, rt.RoomTypeID, rt.Name
    ORDER BY 
        h.Name, OccupancyRate DESC;
END;
GO

-- 4. 查詢客戶預訂統計
CREATE OR ALTER PROCEDURE GetCustomerBookingStats
AS
BEGIN
    SELECT 
        u.UserID,
        u.FirstName + ' ' + u.LastName AS CustomerName,
        u.Email,
        COUNT(b.BookingID) AS TotalBookings,
        SUM(b.FinalAmount) AS TotalSpent,
        MIN(b.BookingDate) AS FirstBookingDate,
        MAX(b.BookingDate) AS LastBookingDate,
        AVG(DATEDIFF(DAY, b.CheckInDate, b.CheckOutDate)) AS AvgStayDuration,
        AVG(r.Rating) AS AvgRating
    FROM 
        [User] u
    LEFT JOIN 
        Booking b ON u.UserID = b.UserID
    LEFT JOIN 
        Review r ON b.BookingID = r.BookingID
    WHERE 
        u.UserType = 'Customer'
    GROUP BY 
        u.UserID, u.FirstName, u.LastName, u.Email
    ORDER BY 
        TotalSpent DESC;
END;
GO

-- 5. 查詢預訂來源分析
CREATE OR ALTER PROCEDURE GetBookingSourceAnalysis
    @StartDate DATE,
    @EndDate DATE,
    @HotelID INT = NULL
AS
BEGIN
    SELECT 
        h.HotelID,
        h.Name AS HotelName,
        b.BookingSource,
        COUNT(b.BookingID) AS BookingCount,
        SUM(b.FinalAmount) AS TotalRevenue,
        CAST(COUNT(b.BookingID) * 100.0 / SUM(COUNT(b.BookingID)) OVER (PARTITION BY h.HotelID) AS DECIMAL(5, 2)) AS PercentageOfTotal
    FROM 
        Booking b
    JOIN 
        BookingDetail bd ON b.BookingID = bd.BookingID
    JOIN 
        Room r ON bd.RoomID = r.RoomID
    JOIN 
        Hotel h ON r.HotelID = h.HotelID
    WHERE 
        b.BookingDate BETWEEN @StartDate AND @EndDate
        AND (@HotelID IS NULL OR h.HotelID = @HotelID)
    GROUP BY 
        h.HotelID, h.Name, b.BookingSource
    ORDER BY 
        h.Name, BookingCount DESC;
END;
GO

-- 6. 查詢未來30天的入住預測
CREATE OR ALTER PROCEDURE GetUpcomingBookingsForecast
    @HotelID INT
AS
BEGIN
    DECLARE @Today DATE = CAST(GETDATE() AS DATE);
    DECLARE @EndDate DATE = DATEADD(DAY, 30, @Today);
    
    SELECT 
        h.HotelID,
        h.Name AS HotelName,
        CAST(b.CheckInDate AS DATE) AS Date,
        COUNT(DISTINCT b.BookingID) AS ArrivingBookings,
        SUM(CASE WHEN bd.GuestFirstName IS NOT NULL THEN 1 ELSE 0 END) AS ArrivingGuests,
        COUNT(DISTINCT CASE WHEN b.CheckOutDate = CAST(b.CheckInDate AS DATE) THEN b.BookingID END) AS DepartingBookings
    FROM 
        Hotel h
    JOIN 
        Room r ON h.HotelID = r.HotelID
    JOIN 
        BookingDetail bd ON r.RoomID = bd.RoomID
    JOIN 
        Booking b ON bd.BookingID = b.BookingID
    WHERE 
        h.HotelID = @HotelID
        AND b.BookingStatus = 'Confirmed'
        AND b.CheckInDate BETWEEN @Today AND @EndDate
    GROUP BY 
        h.HotelID, h.Name, CAST(b.CheckInDate AS DATE)
    ORDER BY 
        Date;
END;
GO

-- 7. 查詢房型收入貢獻度
CREATE OR ALTER PROCEDURE GetRoomTypeRevenueContribution
    @StartDate DATE,
    @EndDate DATE,
    @HotelID INT
AS
BEGIN
    SELECT 
        rt.RoomTypeID,
        rt.Name AS RoomTypeName,
        COUNT(DISTINCT r.RoomID) AS RoomCount,
        COUNT(DISTINCT b.BookingID) AS BookingCount,
        SUM(b.FinalAmount) AS TotalRevenue,
        CAST(SUM(b.FinalAmount) * 100.0 / SUM(SUM(b.FinalAmount)) OVER () AS DECIMAL(5, 2)) AS RevenuePercentage,
        CAST(SUM(b.FinalAmount) / COUNT(DISTINCT r.RoomID) AS DECIMAL(10, 2)) AS RevenuePerRoom
    FROM 
        RoomType rt
    JOIN 
        Room r ON rt.RoomTypeID = r.RoomTypeID
    JOIN 
        BookingDetail bd ON r.RoomID = bd.RoomID
    JOIN 
        Booking b ON bd.BookingID = b.BookingID
    WHERE 
        r.HotelID = @HotelID
        AND b.BookingDate BETWEEN @StartDate AND @EndDate
        AND b.BookingStatus NOT IN ('Cancelled', 'No-Show')
    GROUP BY 
        rt.RoomTypeID, rt.Name
    ORDER BY 
        TotalRevenue DESC;
END;
GO

-- 8. 查詢評價統計分析
CREATE OR ALTER PROCEDURE GetReviewAnalysis
    @HotelID INT
AS
BEGIN
    SELECT 
        h.HotelID,
        h.Name AS HotelName,
        COUNT(r.ReviewID) AS TotalReviews,
        CAST(AVG(r.Rating) AS DECIMAL(3, 1)) AS AvgRating,
        CAST(AVG(r.CleanlinessRating) AS DECIMAL(3, 1)) AS AvgCleanlinessRating,
        CAST(AVG(r.ServiceRating) AS DECIMAL(3, 1)) AS AvgServiceRating,
        CAST(AVG(r.LocationRating) AS DECIMAL(3, 1)) AS AvgLocationRating,
        CAST(AVG(r.ValueRating) AS DECIMAL(3, 1)) AS AvgValueRating,
        COUNT(CASE WHEN r.Rating >= 4 THEN 1 END) AS PositiveReviews,
        COUNT(CASE WHEN r.Rating < 3 THEN 1 END) AS NegativeReviews,
        CAST(COUNT(CASE WHEN r.Rating >= 4 THEN 1 END) * 100.0 / COUNT(r.ReviewID) AS DECIMAL(5, 2)) AS PositivePercentage
    FROM 
        Hotel h
    LEFT JOIN 
        Review r ON h.HotelID = r.HotelID
    WHERE 
        h.HotelID = @HotelID
        AND r.IsPublished = 1
    GROUP BY 
        h.HotelID, h.Name;
END;
GO

-- 9. 查詢促銷活動成效分析
CREATE OR ALTER PROCEDURE GetPromotionEffectiveness
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        p.PromotionID,
        p.Name AS PromotionName,
        COUNT(b.BookingID) AS BookingCount,
        SUM(b.DiscountAmount) AS TotalDiscountAmount,
        SUM(b.FinalAmount) AS TotalRevenue,
        CAST(AVG(b.DiscountAmount) AS DECIMAL(10, 2)) AS AvgDiscountAmount,
        CAST(SUM(b.DiscountAmount) * 100.0 / SUM(b.FinalAmount + b.DiscountAmount) AS DECIMAL(5, 2)) AS DiscountPercentage,
        CAST(SUM(b.FinalAmount) / SUM(b.DiscountAmount) AS DECIMAL(10, 2)) AS ROI
    FROM 
        Promotion p
    JOIN 
        Booking b ON p.PromotionID = b.PromotionID
    WHERE 
        b.BookingDate BETWEEN @StartDate AND @EndDate
        AND b.BookingStatus NOT IN ('Cancelled', 'No-Show')
    GROUP BY 
        p.PromotionID, p.Name
    ORDER BY 
        BookingCount DESC;
END;
GO

-- 10. 查詢房間維護和清潔統計
CREATE OR ALTER PROCEDURE GetRoomMaintenanceAndCleaningStats
    @HotelID INT
AS
BEGIN
    SELECT 
        r.RoomID,
        r.RoomNumber,
        rt.Name AS RoomTypeName,
        r.Status,
        -- 維護記錄統計
        COUNT(DISTINCT mr.RecordID) AS TotalMaintenanceRecords,
        MAX(mr.CompletionDate) AS LastMaintenanceDate,
        SUM(CASE WHEN mr.Status = 'In Progress' THEN 1 ELSE 0 END) AS PendingMaintenanceIssues,
        -- 清潔記錄統計
        COUNT(DISTINCT cr.RecordID) AS TotalCleaningRecords,
        MAX(cr.CleaningDate) AS LastCleaningDate,
        DATEDIFF(DAY, MAX(cr.CleaningDate), GETDATE()) AS DaysSinceLastCleaning
    FROM 
        Room r
    JOIN 
        RoomType rt ON r.RoomTypeID = rt.RoomTypeID
    LEFT JOIN 
        MaintenanceRecord mr ON r.RoomID = mr.RoomID
    LEFT JOIN 
        CleaningRecord cr ON r.RoomID = cr.RoomID
    WHERE 
        r.HotelID = @HotelID
        AND r.IsActive = 1
    GROUP BY 
        r.RoomID, r.RoomNumber, rt.Name, r.Status
    ORDER BY 
        PendingMaintenanceIssues DESC, DaysSinceLastCleaning DESC;
END;
GO

-- 範例查詢調用
-- EXEC GetAvailableRooms @HotelID = 1, @CheckInDate = '2023-07-01', @CheckOutDate = '2023-07-05';
-- EXEC GetRevenueReport @StartDate = '2023-01-01', @EndDate = '2023-06-30', @HotelID = NULL;
-- EXEC GetOccupancyRateByRoomType @StartDate = '2023-05-01', @EndDate = '2023-05-31', @HotelID = 1;
-- EXEC GetCustomerBookingStats;
-- EXEC GetBookingSourceAnalysis @StartDate = '2023-01-01', @EndDate = '2023-06-30', @HotelID = NULL;
-- EXEC GetUpcomingBookingsForecast @HotelID = 1;
-- EXEC GetRoomTypeRevenueContribution @StartDate = '2023-01-01', @EndDate = '2023-06-30', @HotelID = 1;
-- EXEC GetReviewAnalysis @HotelID = 1;
-- EXEC GetPromotionEffectiveness @StartDate = '2023-01-01', @EndDate = '2023-06-30';
-- EXEC GetRoomMaintenanceAndCleaningStats @HotelID = 1; 