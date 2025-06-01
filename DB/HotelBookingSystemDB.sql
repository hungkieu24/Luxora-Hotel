CREATE DATABASE HotelBookingSystemDB
GO

USE HotelBookingSystemDB
GO
CREATE TABLE [UserAccount] (
  [id] varchar(10) PRIMARY KEY,
  [username] nvarchar(100) UNIQUE NOT NULL,
  [password] varchar(255) NOT NULL,
  [email] varchar(100) UNIQUE NOT NULL,
  [avatar_url] varchar(255),
  [role] VARCHAR(20) CHECK ([role] IN ('Customer', 'Staff', 'Manager', 'Admin', 'HotelOwner')) NOT NULL,
  [status] VARCHAR(10) CHECK ([status] IN ('Active', 'Inactive', 'Banned')) DEFAULT 'Active',
  [created_at] datetime DEFAULT GETDATE(),
  [phonenumber] varchar(20)
)
GO

CREATE TABLE [HotelBranch] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [name] nvarchar(255) NOT NULL,
  [address] nvarchar(max) NOT NULL,
  [phone] varchar(20),
  [email] varchar(100),
  [image_url] varchar(255),
  [owner_id] varchar(10),
  [manager_id] varchar(10)
)
GO

CREATE TABLE [RoomType] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [name] varchar(100),
  [description] nvarchar(max),
  [base_price] decimal(18,2),
  [capacity] int,
  [image_url] varchar(255)
)
GO

CREATE TABLE [Room] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [room_number] varchar(20) NOT NULL,
  [branch_id] int,
  [room_type_id] int,
  [status] VARCHAR(20) CHECK ([status] IN ('Available', 'Booked', 'Maintenance', 'Locked')) DEFAULT 'Available',
  [image_url] varchar(255)
)
GO

CREATE TABLE [Voucher] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [code] varchar(50) UNIQUE NOT NULL,
  [description] nvarchar(max),
  [discount_percent] int,
  [discount_amount] decimal(18,2),
  [valid_from] datetime,
  [valid_to] datetime,
  [status] VARCHAR(10) CHECK ([status] IN ('Active', 'Inactive', 'Expired')) DEFAULT 'Active'
)
GO

CREATE TABLE [SeasonalPromotion] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [name] nvarchar(100),
  [description] nvarchar(max),
  [discount_percent] decimal(5,2),
  [discount_amount] decimal(18,2),
  [start_date] datetime NOT NULL,
  [end_date] datetime NOT NULL,
  [status] VARCHAR(10) CHECK ([status] IN ('Active', 'Inactive', 'Expired')) DEFAULT 'Active'
)
GO

CREATE TABLE [Booking] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [user_id] varchar(10),
  [booking_time] datetime DEFAULT GETDATE(),
  [check_in] datetime,
  [check_out] datetime,
  [status] VARCHAR(20) CHECK ([status] IN ('Pending', 'Confirmed', 'Cancelled', 'CheckedIn', 'CheckedOut', 'Locked')) DEFAULT 'Pending',
  [total_price] decimal(18,2),
  [deposit] decimal(18,2),
  [payment_status] VARCHAR(10) CHECK ([payment_status] IN ('Unpaid', 'Paid', 'Partial')),
  [cancel_reason] nvarchar(max),
  [cancel_time] datetime,
  [promotion_id] int
)
GO

CREATE TABLE [BookingVoucher] (
  [booking_id] int,
  [voucher_id] int,
  PRIMARY KEY ([booking_id], [voucher_id])
)
GO

CREATE TABLE [BookingRoom] (
  [booking_id] int,
  [room_id] int,
  PRIMARY KEY ([booking_id], [room_id])
)
GO

CREATE TABLE [Service] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [name] varchar(100),
  [description] nvarchar(max),
  [price] decimal(18,2),
  [branch_id] int,
  [status] VARCHAR(10) CHECK ([status] IN ('Active', 'Inactive')) DEFAULT 'Active',
  [image_url] varchar(255)
)
GO

CREATE TABLE [BookingService] (
  [booking_id] int,
  [service_id] int,
  [quantity] int,
  [paid_status] VARCHAR(10) CHECK ([paid_status] IN ('Unpaid', 'Paid')) DEFAULT 'Unpaid',
  PRIMARY KEY ([booking_id], [service_id])
)
GO

CREATE TABLE [Feedback] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [user_id] varchar(10),
  [booking_id] int,
  [rating] int,
  [comment] nvarchar(max),
  [image_url] nvarchar(max),
  [created_at] datetime DEFAULT GETDATE(),
  [status] VARCHAR(10) CHECK ([status] IN ('Visible', 'Hidden', 'Blocked')) DEFAULT 'Visible',
  [admin_action] VARCHAR(10) CHECK ([admin_action] IN ('None', 'Warned', 'Deleted', 'Banned')) DEFAULT 'None'
)
GO

CREATE TABLE [VNPayPayment] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [booking_id] int,
  [amount] decimal(18,2),
  [status] VARCHAR(10) CHECK ([status] IN ('Pending', 'Completed', 'Failed', 'Refunded')) DEFAULT 'Pending',
  [paid_at] datetime DEFAULT GETDATE()
)
GO

CREATE TABLE [VNPayTransaction] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [payment_id] int,
  [vnp_TxnRef] varchar(100),
  [vnp_TransactionNo] varchar(100),
  [vnp_ResponseCode] varchar(10),
  [vnp_Amount] decimal(18,2),
  [vnp_BankCode] varchar(50),
  [vnp_CardType] varchar(50),
  [vnp_SecureHash] varchar(255),
  [is_refund] bit,
  [created_at] datetime DEFAULT GETDATE()
)
GO

CREATE TABLE [LoyaltyPoint] (
  [user_id] varchar(10) PRIMARY KEY,
  [points] int,
  [level] VARCHAR(10) CHECK ([level] IN ('Member', 'Silver', 'Gold', 'VIP')) DEFAULT 'Member',
  [last_updated] datetime DEFAULT GETDATE(),
  [expired_at] datetime
)
GO

CREATE TABLE [PointTransaction] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [user_id] varchar(10),
  [change_type] VARCHAR(20) CHECK ([change_type] IN ('Earn', 'Redeem', 'Adjustment')),
  [points_changed] int,
  [reason] nvarchar(max),
  [created_at] datetime DEFAULT GETDATE()
)
GO

CREATE TABLE [PointRedeemVoucher] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [user_id] varchar(10),
  [voucher_id] int,
  [points_used] int,
  [redeemed_at] datetime DEFAULT GETDATE()
)
GO

CREATE TABLE [ChatAIHistory] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [user_id] varchar(10),
  [message] nvarchar(max),
  [created_at] datetime DEFAULT GETDATE(),
  [violation] varchar(10)
)
GO

CREATE TABLE [Invoice] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [booking_id] int,
  [total_amount] decimal(18,2),
  [issued_at] datetime DEFAULT GETDATE(),
  [pdf_url] varchar(255),
  [image_url] varchar(255)
)
GO

CREATE TABLE [MemberTierHistory] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [user_id] varchar(10),
  [old_level] VARCHAR(10) CHECK ([old_level] IN ('Member', 'Silver', 'Gold', 'VIP')),
  [new_level] VARCHAR(10) CHECK ([new_level] IN ('Member', 'Silver', 'Gold', 'VIP')),
  [changed_at] datetime DEFAULT GETDATE(),
  [reason] nvarchar(max)
)
GO

CREATE TABLE [Permission] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [role] VARCHAR(20) CHECK ([role] IN ('Customer', 'Staff', 'Manager', 'Admin', 'HotelOwner')) NOT NULL,
  [resource] varchar(100),
  [action] VARCHAR(10) CHECK ([action] IN ('Create', 'Read', 'Update', 'Delete')) NOT NULL,
  [allowed] bit
)
GO

CREATE TABLE [Notification] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [user_id] varchar(10),
  [title] varchar(255),
  [message] nvarchar(max),
  [type] VARCHAR(20) CHECK ([type] IN (
        'System', 'Promotion', 'Booking', 'Payment',
        'Feedback', 'Chat', 'LoyaltyPoint', 'TierUpgrade'
    )) DEFAULT 'System',
  [status] VARCHAR(10) CHECK ([status] IN ('Unread', 'Read')) DEFAULT 'Unread',
  [created_at] datetime DEFAULT GETDATE(),
  [read_at] datetime,
  [related_booking_id] int,
  [related_point_transaction_id] int,
  [related_member_tier_history_id] int
)
GO

CREATE TABLE [CartRoomType] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [user_id] varchar(10) NOT NULL,
  [room_type_id] int NOT NULL,
  [quantity] int NOT NULL DEFAULT (1),
  [added_at] datetime DEFAULT (getdate())
)
GO

ALTER TABLE [HotelBranch] ADD CONSTRAINT FK_HotelBranch_Owner FOREIGN KEY ([owner_id]) REFERENCES [UserAccount] ([id])
GO

ALTER TABLE [HotelBranch] ADD CONSTRAINT FK_HotelBranch_Manager FOREIGN KEY ([manager_id]) REFERENCES [UserAccount] ([id])
GO

ALTER TABLE [Room] ADD CONSTRAINT FK_Room_Branch FOREIGN KEY ([branch_id]) REFERENCES [HotelBranch] ([id])
GO

ALTER TABLE [Room] ADD CONSTRAINT FK_Room_RoomType FOREIGN KEY ([room_type_id]) REFERENCES [RoomType] ([id])
GO

ALTER TABLE [Booking] ADD CONSTRAINT FK_Booking_User FOREIGN KEY ([user_id]) REFERENCES [UserAccount] ([id])
GO

ALTER TABLE [Booking] ADD CONSTRAINT FK_Booking_Promotion FOREIGN KEY ([promotion_id]) REFERENCES [SeasonalPromotion] ([id])
GO

ALTER TABLE [BookingVoucher] ADD CONSTRAINT FK_BookingVoucher_Booking FOREIGN KEY ([booking_id]) REFERENCES [Booking] ([id])
GO

ALTER TABLE [BookingVoucher] ADD CONSTRAINT FK_BookingVoucher_Voucher FOREIGN KEY ([voucher_id]) REFERENCES [Voucher] ([id])
GO

ALTER TABLE [BookingRoom] ADD CONSTRAINT FK_BookingRoom_Booking FOREIGN KEY ([booking_id]) REFERENCES [Booking] ([id])
GO

ALTER TABLE [BookingRoom] ADD CONSTRAINT FK_BookingRoom_Room FOREIGN KEY ([room_id]) REFERENCES [Room] ([id])
GO

ALTER TABLE [Service] ADD CONSTRAINT FK_Service_Branch FOREIGN KEY ([branch_id]) REFERENCES [HotelBranch] ([id])
GO

ALTER TABLE [BookingService] ADD CONSTRAINT FK_BookingService_Booking FOREIGN KEY ([booking_id]) REFERENCES [Booking] ([id])
GO

ALTER TABLE [BookingService] ADD CONSTRAINT FK_BookingService_Service FOREIGN KEY ([service_id]) REFERENCES [Service] ([id])
GO

ALTER TABLE [Feedback] ADD CONSTRAINT FK_Feedback_User FOREIGN KEY ([user_id]) REFERENCES [UserAccount] ([id])
GO

ALTER TABLE [Feedback] ADD CONSTRAINT FK_Feedback_Booking FOREIGN KEY ([booking_id]) REFERENCES [Booking] ([id])
GO

ALTER TABLE [VNPayPayment] ADD CONSTRAINT FK_VNPayPayment_Booking FOREIGN KEY ([booking_id]) REFERENCES [Booking] ([id])
GO

ALTER TABLE [VNPayTransaction] ADD CONSTRAINT FK_VNPayTransaction_Payment FOREIGN KEY ([payment_id]) REFERENCES [VNPayPayment] ([id])
GO

ALTER TABLE [LoyaltyPoint] ADD CONSTRAINT FK_LoyaltyPoint_User FOREIGN KEY ([user_id]) REFERENCES [UserAccount] ([id])
GO

ALTER TABLE [PointTransaction] ADD CONSTRAINT FK_PointTransaction_User FOREIGN KEY ([user_id]) REFERENCES [UserAccount] ([id])
GO

ALTER TABLE [PointRedeemVoucher] ADD CONSTRAINT FK_PointRedeemVoucher_User FOREIGN KEY ([user_id]) REFERENCES [UserAccount] ([id])
GO

ALTER TABLE [PointRedeemVoucher] ADD CONSTRAINT FK_PointRedeemVoucher_Voucher FOREIGN KEY ([voucher_id]) REFERENCES [Voucher] ([id])
GO

ALTER TABLE [ChatAIHistory] ADD CONSTRAINT FK_ChatAIHistory_User FOREIGN KEY ([user_id]) REFERENCES [UserAccount] ([id])
GO

ALTER TABLE [Invoice] ADD CONSTRAINT FK_Invoice_Booking FOREIGN KEY ([booking_id]) REFERENCES [Booking] ([id])
GO

ALTER TABLE [MemberTierHistory] ADD CONSTRAINT FK_MemberTierHistory_User FOREIGN KEY ([user_id]) REFERENCES [UserAccount] ([id])
GO

ALTER TABLE [Notification] ADD CONSTRAINT FK_Notification_User FOREIGN KEY ([user_id]) REFERENCES [UserAccount] ([id])
GO

ALTER TABLE [Notification] ADD CONSTRAINT FK_Notification_Booking FOREIGN KEY ([related_booking_id]) REFERENCES [Booking] ([id])
GO

ALTER TABLE [Notification] ADD CONSTRAINT FK_Notification_PointTransaction FOREIGN KEY ([related_point_transaction_id]) REFERENCES [PointTransaction] ([id])
GO

ALTER TABLE [Notification] ADD CONSTRAINT FK_Notification_MemberTierHistory FOREIGN KEY ([related_member_tier_history_id]) REFERENCES [MemberTierHistory] ([id])
GO

ALTER TABLE [CartRoomType] ADD CONSTRAINT FK_CartRoomType_User FOREIGN KEY ([user_id]) REFERENCES [UserAccount] ([id])
GO

ALTER TABLE [CartRoomType] ADD CONSTRAINT FK_CartRoomType_RoomType FOREIGN KEY ([room_type_id]) REFERENCES [RoomType] ([id])
GO


-- Insert data into UserAccount
INSERT INTO [UserAccount] ([id], [username], [password], [email], [avatar_url], [role], [status], [phonenumber]) VALUES
('U001', 'john_doe', 'hashed_pass1', 'john.doe@example.com', 'http://example.com/avatar1.jpg', 'Customer', 'Active', '0901234567'),
('U002', 'jane_smith', 'hashed_pass2', 'jane.smith@example.com', 'http://example.com/avatar2.jpg', 'Customer', 'Active', '0901234568'),
('U003', 'hotel_owner1', 'hashed_pass3', 'owner1@example.com', NULL, 'HotelOwner', 'Active', '0901234569'),
('U004', 'manager1', 'hashed_pass4', 'manager1@example.com', NULL, 'Manager', 'Active', '0901234570'),
('U005', 'staff1', 'hashed_pass5', 'staff1@example.com', NULL, 'Staff', 'Active', '0901234571'),
('U006', 'admin1', 'hashed_pass6', 'admin1@example.com', NULL, 'Admin', 'Active', '0901234572'),
('U007', 'customer3', 'hashed_pass7', 'customer3@example.com', NULL, 'Customer', 'Inactive', '0901234573'),
('U008', 'customer4', 'hashed_pass8', 'customer4@example.com', NULL, 'Customer', 'Banned', '0901234574'),
('U009', 'staff2', 'hashed_pass9', 'staff2@example.com', NULL, 'Staff', 'Active', '0901234575'),
('U010', 'manager2', 'hashed_pass10', 'manager2@example.com', NULL, 'Manager', 'Active', '0901234576');

-- Insert data into HotelBranch
INSERT INTO [HotelBranch] ([name], [address], [phone], [email], [image_url], [owner_id], [manager_id]) VALUES
('Sunrise Hotel Hanoi', '123 Tran Phu, Hanoi', '0241234567', 'hanoi@sunrise.com', 'http://example.com/hotel1.jpg', 'U003', 'U004'),
('Sunrise Hotel HCMC', '456 Le Loi, HCMC', '0281234567', 'hcmc@sunrise.com', 'http://example.com/hotel2.jpg', 'U003', 'U010'),
('Ocean View Da Nang', '789 Vo Nguyen Giap, Da Nang', '02361234567', 'danang@oceanview.com', 'http://example.com/hotel3.jpg', 'U003', NULL),
('Paradise Resort Phu Quoc', '101 Bai Dai, Phu Quoc', '02971234567', 'phuquoc@paradise.com', NULL, 'U003', NULL),
('Moonlight Hotel Hue', '202 Nguyen Hue, Hue', '02341234567', 'hue@moonlight.com', NULL, 'U003', 'U004'),
('Golden Sand Nha Trang', '303 Ly Tu Trong, Nha Trang', '02581234567', 'nhatrang@goldensand.com', NULL, 'U003', NULL),
('Silver Star Vung Tau', '404 Tran Hung Dao, Vung Tau', '02541234567', 'vungtau@silverstar.com', NULL, 'U003', NULL),
('Green Hill Sapa', '505 Dien Bien Phu, Sapa', '02141234567', 'sapa@greenhill.com', NULL, 'U003', NULL),
('Royal Hotel Can Tho', '606 Nguyen Van Cu, Can Tho', '02921234567', 'cantho@royal.com', NULL, 'U003', NULL),
('Starlight Hotel Dalat', '707 Le Hong Phong, Dalat', '02631234567', 'dalat@starlight.com', NULL, 'U003', NULL);

-- Insert data into RoomType
INSERT INTO [RoomType] ([name], [description], [base_price], [capacity], [image_url]) VALUES
('Standard', 'Basic room with single bed', 500000.00, 2, 'http://example.com/roomtype1.jpg'),
('Deluxe', 'Spacious room with city view', 1000000.00, 3, 'http://example.com/roomtype2.jpg'),
('Suite', 'Luxury suite with balcony', 2000000.00, 4, 'http://example.com/roomtype3.jpg'),
('Family', 'Room for family with 2 beds', 1500000.00, 5, 'http://example.com/roomtype4.jpg'),
('Single', 'Cozy room for one person', 400000.00, 1, 'http://example.com/roomtype5.jpg'),
('Twin', 'Room with two single beds', 800000.00, 2, 'http://example.com/roomtype6.jpg'),
('Executive', 'Premium room with workspace', 1800000.00, 3, 'http://example.com/roomtype7.jpg'),
('Presidential', 'Top-tier suite with full amenities', 5000000.00, 6, 'http://example.com/roomtype8.jpg'),
('Economy', 'Budget room with basic amenities', 300000.00, 2, 'http://example.com/roomtype9.jpg'),
('Superior', 'Enhanced room with extra space', 1200000.00, 3, 'http://example.com/roomtype10.jpg');

-- Insert data into Room
INSERT INTO [Room] ([room_number], [branch_id], [room_type_id], [status], [image_url]) VALUES
('101', 1, 1, 'Available', 'http://example.com/room101.jpg'),
('102', 1, 2, 'Booked', 'http://example.com/room102.jpg'),
('201', 2, 3, 'Available', 'http://example.com/room201.jpg'),
('202', 2, 4, 'Maintenance', 'http://example.com/room202.jpg'),
('301', 3, 5, 'Available', 'http://example.com/room301.jpg'),
('302', 3, 6, 'Locked', 'http://example.com/room302.jpg'),
('401', 4, 7, 'Available', 'http://example.com/room401.jpg'),
('402', 4, 8, 'Booked', 'http://example.com/room402.jpg'),
('501', 5, 9, 'Available', 'http://example.com/room501.jpg'),
('502', 5, 10, 'Available', 'http://example.com/room502.jpg');

-- Insert data into Voucher
INSERT INTO [Voucher] ([code], [description], [discount_percent], [discount_amount], [valid_from], [valid_to], [status]) VALUES
('SUMMER25', 'Summer discount 25%', 25, NULL, '2025-06-01', '2025-08-31', 'Active'),
('WINTER10', 'Winter discount 10%', 10, NULL, '2025-12-01', '2026-02-28', 'Active'),
('NEWUSER50', 'New user 50k off', NULL, 50000.00, '2025-01-01', '2025-12-31', 'Active'),
('VIP20', 'VIP discount 20%', 20, NULL, '2025-01-01', '2025-12-31', 'Active'),
('FLASH100', 'Flash sale 100k off', NULL, 100000.00, '2025-05-30', '2025-06-15', 'Active'),
('LOYALTY15', 'Loyalty discount 15%', 15, NULL, '2025-01-01', '2025-12-31', 'Active'),
('GROUP30', 'Group booking 30% off', 30, NULL, '2025-07-01', '2025-09-30', 'Active'),
('EARLYBIRD', 'Early bird 75k off', NULL, 75000.00, '2025-04-01', '2025-06-30', 'Active'),
('FESTIVAL10', 'Festival discount 10%', 10, NULL, '2025-12-20', '2026-01-10', 'Active'),
('WEEKEND20', 'Weekend discount 20%', 20, NULL, '2025-01-01', '2025-12-31', 'Active');

-- Insert data into SeasonalPromotion
INSERT INTO [SeasonalPromotion] ([name], [description], [discount_percent], [discount_amount], [start_date], [end_date], [status]) VALUES
('Summer Sale', 'Summer promotion 20% off', 20.00, NULL, '2025-06-01', '2025-08-31', 'Active'),
('Winter Fest', 'Winter holiday discount', 15.00, NULL, '2025-12-01', '2026-02-28', 'Active'),
('Tet Holiday', 'Tet discount 100k', NULL, 100000.00, '2025-02-01', '2025-02-15', 'Inactive'),
('Spring Break', 'Spring discount 25%', 25.00, NULL, '2025-03-01', '2025-04-30', 'Active'),
('Mid-Autumn', 'Mid-Autumn festival 50k off', NULL, 50000.00, '2025-09-01', '2025-09-30', 'Active'),
('Black Friday', 'Black Friday 30% off', 30.00, NULL, '2025-11-28', '2025-11-30', 'Active'),
('New Year', 'New Year discount 15%', 15.00, NULL, '2025-12-25', '2026-01-05', 'Active'),
('Golden Week', 'Golden Week 20% off', 20.00, NULL, '2025-04-29', '2025-05-05', 'Active'),
('Christmas', 'Christmas 75k off', NULL, 75000.00, '2025-12-20', '2025-12-25', 'Active'),
('Lunar New Year', 'Lunar New Year 10% off', 10.00, NULL, '2025-02-01', '2025-02-10', 'Active');

-- Insert data into Booking
INSERT INTO [Booking] ([user_id], [booking_time], [check_in], [check_out], [status], [total_price], [deposit], [payment_status], [cancel_reason], [cancel_time], [promotion_id]) VALUES
('U001', '2025-05-30 10:00:00', '2025-06-01', '2025-06-03', 'Confirmed', 1000000.00, 200000.00, 'Paid', NULL, NULL, 1),
('U002', '2025-05-30 11:00:00', '2025-06-05', '2025-06-07', 'Pending', 1500000.00, 300000.00, 'Unpaid', NULL, NULL, 2),
('U001', '2025-05-29 09:00:00', '2025-06-10', '2025-06-12', 'Cancelled', 2000000.00, 400000.00, 'Unpaid', 'Changed plans', '2025-05-29 15:00:00', NULL),
('U002', '2025-05-28 14:00:00', '2025-07-01', '2025-07-05', 'Confirmed', 3000000.00, 600000.00, 'Partial', NULL, NULL, 4),
('U007', '2025-05-27 16:00:00', '2025-06-15', '2025-06-17', 'CheckedIn', 800000.00, 160000.00, 'Paid', NULL, NULL, NULL),
('U001', '2025-05-26 12:00:00', '2025-06-20', '2025-06-22', 'CheckedOut', 1200000.00, 240000.00, 'Paid', NULL, NULL, 5),
('U002', '2025-05-25 08:00:00', '2025-06-25', '2025-06-27', 'Pending', 1800000.00, 360000.00, 'Unpaid', NULL, NULL, NULL),
('U007', '2025-05-24 10:00:00', '2025-07-10', '2025-07-12', 'Confirmed', 2500000.00, 500000.00, 'Paid', NULL, NULL, 6),
('U001', '2025-05-23 11:00:00', '2025-07-15', '2025-07-17', 'Locked', 900000.00, 180000.00, 'Unpaid', NULL, NULL, NULL),
('U002', '2025-05-22 13:00:00', '2025-07-20', '2025-07-22', 'Confirmed', 1100000.00, 220000.00, 'Paid', NULL, NULL, 7);

-- Insert data into BookingVoucher
INSERT INTO [BookingVoucher] ([booking_id], [voucher_id]) VALUES
(1, 1),
(2, 2),
(4, 3),
(5, 4),
(6, 5),
(7, 6),
(8, 7),
(10, 8),
(1, 9),
(2, 10);

-- Insert data into BookingRoom
INSERT INTO [BookingRoom] ([booking_id], [room_id]) VALUES
(1, 1),
(2, 2),
(4, 3),
(5, 4),
(6, 5),
(7, 6),
(8, 7),
(10, 8),
(1, 9),
(2, 10);

-- Insert data into Service
INSERT INTO [Service] ([name], [description], [price], [branch_id], [status], [image_url]) VALUES
('Breakfast', 'Buffet breakfast', 150000.00, 1, 'Active', 'http://example.com/service1.jpg'),
('Spa', 'Relaxing spa session', 500000.00, 1, 'Active', 'http://example.com/service2.jpg'),
('Airport Transfer', 'Pick-up and drop-off', 300000.00, 2, 'Active', 'http://example.com/service3.jpg'),
('Laundry', 'Laundry service', 100000.00, 2, 'Active', 'http://example.com/service4.jpg'),
('Room Service', 'In-room dining', 200000.00, 3, 'Active', 'http://example.com/service5.jpg'),
('Gym Access', 'Access to fitness center', 80000.00, 3, 'Active', 'http://example.com/service6.jpg'),
('Tour Guide', 'City tour with guide', 600000.00, 4, 'Active', 'http://example.com/service7.jpg'),
('Bike Rental', 'Bicycle rental for a day', 120000.00, 4, 'Active', 'http://example.com/service8.jpg'),
('Massage', 'Full body massage', 400000.00, 5, 'Active', 'http://example.com/service9.jpg'),
('Parking', 'Secure parking', 50000.00, 5, 'Active', 'http://example.com/service10.jpg');

-- Insert data into BookingService
INSERT INTO [BookingService] ([booking_id], [service_id], [quantity], [paid_status]) VALUES
(1, 1, 2, 'Paid'),
(2, 2, 1, 'Unpaid'),
(4, 3, 1, 'Paid'),
(5, 4, 3, 'Paid'),
(6, 5, 2, 'Unpaid'),
(7, 6, 1, 'Paid'),
(8, 7, 1, 'Unpaid'),
(10, 8, 2, 'Paid'),
(1, 9, 1, 'Paid'),
(2, 10, 1, 'Unpaid');

-- Insert data into Feedback
INSERT INTO [Feedback] ([user_id], [booking_id], [rating], [comment], [image_url], [status], [admin_action]) VALUES
('U001', 1, 5, 'Great experience!', 'http://example.com/feedback1.jpg', 'Visible', 'None'),
('U002', 2, 4, 'Nice room but slow service', NULL, 'Visible', 'None'),
('U001', 3, 2, 'Cancelled due to personal reasons', NULL, 'Hidden', 'None'),
('U002', 4, 5, 'Amazing stay!', 'http://example.com/feedback4.jpg', 'Visible', 'None'),
('U007', 5, 3, 'Average experience', NULL, 'Visible', 'None'),
('U001', 6, 4, 'Good service', NULL, 'Visible', 'None'),
('U002', 7, 3, 'Room needs maintenance', NULL, 'Visible', 'Warned'),
('U007', 8, 5, 'Perfect vacation', 'http://example.com/feedback8.jpg', 'Visible', 'None'),
('U001', 10, 4, 'Nice view', NULL, 'Visible', 'None'),
('U002', 10, 3, 'Could be better', NULL, 'Blocked', 'Deleted');

-- Insert data into VNPayPayment
INSERT INTO [VNPayPayment] ([booking_id], [amount], [status], [paid_at]) VALUES
(1, 1000000.00, 'Completed', '2025-05-30 10:30:00'),
(2, 1500000.00, 'Pending', '2025-05-30 11:30:00'),
(4, 3000000.00, 'Completed', '2025-05-28 14:30:00'),
(5, 800000.00, 'Completed', '2025-05-27 16:30:00'),
(6, 1200000.00, 'Completed', '2025-05-26 12:30:00'),
(7, 1800000.00, 'Pending', '2025-05-25 08:30:00'),
(8, 2500000.00, 'Completed', '2025-05-24 10:30:00'),
(10, 1100000.00, 'Completed', '2025-05-22 13:30:00'),
(1, 200000.00, 'Refunded', '2025-05-29 15:30:00'),
(2, 300000.00, 'Failed', '2025-05-30 11:45:00');

-- Insert data into VNPayTransaction
INSERT INTO [VNPayTransaction] ([payment_id], [vnp_TxnRef], [vnp_TransactionNo], [vnp_ResponseCode], [vnp_Amount], [vnp_BankCode], [vnp_CardType], [vnp_SecureHash], [is_refund], [created_at]) VALUES
(1, 'TXN001', '123456', '00', 1000000.00, 'NCB', 'VISA', 'hash1', 0, '2025-05-30 10:30:00'),
(2, 'TXN002', '123457', '24', 1500000.00, 'VCB', 'MASTERCARD', 'hash2', 0, '2025-05-30 11:30:00'),
(3, 'TXN003', '123458', '00', 3000000.00, 'TPB', 'VISA', 'hash3', 0, '2025-05-28 14:30:00'),
(4, 'TXN004', '123459', '00', 800000.00, 'MBB', 'VISA', 'hash4', 0, '2025-05-27 16:30:00'),
(5, 'TXN005', '123460', '00', 1200000.00, 'ACB', 'MASTERCARD', 'hash5', 0, '2025-05-26 12:30:00'),
(6, 'TXN006', '123461', '24', 1800000.00, 'VTB', 'VISA', 'hash6', 0, '2025-05-25 08:30:00'),
(7, 'TXN007', '123462', '00', 2500000.00, 'NCB', 'VISA', 'hash7', 0, '2025-05-24 10:30:00'),
(8, 'TXN008', '123463', '00', 1100000.00, 'VCB', 'MASTERCARD', 'hash8', 0, '2025-05-22 13:30:00'),
(9, 'TXN009', '123464', '00', 200000.00, 'TPB', 'VISA', 'hash9', 1, '2025-05-29 15:30:00'),
(10, 'TXN010', '123465', '99', 300000.00, 'MBB', 'VISA', 'hash10', 0, '2025-05-30 11:45:00');

-- Insert data into LoyaltyPoint
INSERT INTO [LoyaltyPoint] ([user_id], [points], [level], [last_updated], [expired_at]) VALUES
('U001', 500, 'Silver', '2025-05-30', '2026-05-30'),
('U002', 200, 'Member', '2025-05-30', '2026-05-30'),
('U007', 1000, 'Gold', '2025-05-30', '2026-05-30'),
('U008', 0, 'Member', '2025-05-30', NULL),
('U009', 300, 'Member', '2025-05-30', '2026-05-30'),
('U010', 600, 'Silver', '2025-05-30', '2026-05-30'),
('U003', 0, 'Member', '2025-05-30', NULL),
('U004', 100, 'Member', '2025-05-30', '2026-05-30'),
('U005', 200, 'Member', '2025-05-30', '2026-05-30'),
('U006', 400, 'Silver', '2025-05-30', '2026-05-30');

-- Insert data into PointTransaction
INSERT INTO [PointTransaction] ([user_id], [change_type], [points_changed], [reason], [created_at]) VALUES
('U001', 'Earn', 100, 'Booking completed', '2025-05-30 10:00:00'),
('U002', 'Earn', 50, 'Booking completed', '2025-05-30 11:00:00'),
('U007', 'Earn', 200, 'Booking completed', '2025-05-27 16:00:00'),
('U001', 'Redeem', -50, 'Redeemed voucher', '2025-05-29 09:00:00'),
('U002', 'Earn', 30, 'Promotion bonus', '2025-05-28 14:00:00'),
('U007', 'Earn', 150, 'Booking completed', '2025-05-24 10:00:00'),
('U009', 'Earn', 80, 'Booking completed', '2025-05-30 12:00:00'),
('U010', 'Earn', 120, 'Booking completed', '2025-05-30 13:00:00'),
('U005', 'Earn', 70, 'Promotion bonus', '2025-05-30 14:00:00'),
('U006', 'Redeem', -100, 'Redeemed voucher', '2025-05-30 15:00:00');

-- Insert data into PointRedeemVoucher
INSERT INTO [PointRedeemVoucher] ([user_id], [voucher_id], [points_used], [redeemed_at]) VALUES
('U001', 1, 50, '2025-05-30 10:00:00'),
('U002', 2, 30, '2025-05-30 11:00:00'),
('U007', 3, 100, '2025-05-27 16:00:00'),
('U001', 4, 80, '2025-05-29 09:00:00'),
('U002', 5, 60, '2025-05-28 14:00:00'),
('U007', 6, 120, '2025-05-24 10:00:00'),
('U009', 7, 70, '2025-05-30 12:00:00'),
('U010', 8, 90, '2025-05-30 13:00:00'),
('U005', 9, 40, '2025-05-30 14:00:00'),
('U006', 10, 100, '2025-05-30 15:00:00');

-- Insert data into ChatAIHistory
INSERT INTO [ChatAIHistory] ([user_id], [message], [created_at], [violation]) VALUES
('U001', 'What are the best hotels in Hanoi?', '2025-05-30 10:00:00', NULL),
('U002', 'How to book a room?', '2025-05-30 11:00:00', NULL),
('U007', 'Check my booking status', '2025-05-27 16:00:00', NULL),
('U001', 'Cancel my booking', '2025-05-29 09:00:00', NULL),
('U002', 'What is the price of Deluxe room?', '2025-05-28 14:00:00', NULL),
('U007', 'Any promotions available?', '2025-05-24 10:00:00', NULL),
('U009', 'How to use voucher?', '2025-05-30 12:00:00', NULL),
('U010', 'What services are available?', '2025-05-30 13:00:00', NULL),
('U005', 'Book a spa session', '2025-05-30 14:00:00', NULL),
('U006', 'Inappropriate message', '2025-05-30 15:00:00', 'Blocked');

-- Insert data into Invoice
INSERT INTO [Invoice] ([booking_id], [total_amount], [issued_at], [pdf_url], [image_url]) VALUES
(1, 1000000.00, '2025-05-30 10:30:00', 'http://example.com/invoice1.pdf', NULL),
(2, 1500000.00, '2025-05-30 11:30:00', 'http://example.com/invoice2.pdf', NULL),
(4, 3000000.00, '2025-05-28 14:30:00', 'http://example.com/invoice3.pdf', NULL),
(5, 800000.00, '2025-05-27 16:30:00', 'http://example.com/invoice4.pdf', NULL),
(6, 1200000.00, '2025-05-26 12:30:00', 'http://example.com/invoice5.pdf', NULL),
(7, 1800000.00, '2025-05-25 08:30:00', 'http://example.com/invoice6.pdf', NULL),
(8, 2500000.00, '2025-05-24 10:30:00', 'http://example.com/invoice7.pdf', NULL),
(10, 1100000.00, '2025-05-22 13:30:00', 'http://example.com/invoice8.pdf', NULL),
(1, 200000.00, '2025-05-29 15:30:00', 'http://example.com/invoice9.pdf', NULL),
(2, 300000.00, '2025-05-30 11:45:00', 'http://example.com/invoice10.pdf', NULL);

-- Insert data into MemberTierHistory
INSERT INTO [MemberTierHistory] ([user_id], [old_level], [new_level], [changed_at], [reason]) VALUES
('U001', 'Member', 'Silver', '2025-05-30 10:00:00', 'Reached 500 points'),
('U002', 'Member', 'Member', '2025-05-30 11:00:00', 'Initial signup'),
('U007', 'Silver', 'Gold', '2025-05-27 16:00:00', 'Reached 1000 points'),
('U001', 'Silver', 'Silver', '2025-05-29 09:00:00', 'Point redemption'),
('U002', 'Member', 'Member', '2025-05-28 14:00:00', 'Earned points'),
('U007', 'Gold', 'Gold', '2025-05-24 10:00:00', 'Earned points'),
('U009', 'Member', 'Member', '2025-05-30 12:00:00', 'Initial signup'),
('U010', 'Member', 'Silver', '2025-05-30 13:00:00', 'Reached 600 points'),
('U005', 'Member', 'Member', '2025-05-30 14:00:00', 'Earned points'),
('U006', 'Member', 'Silver', '2025-05-30 15:00:00', 'Reached 400 points');

-- Insert data into Permission
INSERT INTO [Permission] ([role], [resource], [action], [allowed]) VALUES
('Customer', 'Booking', 'Create', 1),
('Customer', 'Booking', 'Read', 1),
('Staff', 'Booking', 'Update', 1),
('Manager', 'Room', 'Update', 1),
('Admin', 'UserAccount', 'Delete', 1),
('HotelOwner', 'HotelBranch', 'Create', 1),
('Customer', 'Feedback', 'Create', 1),
('Staff', 'Service', 'Read', 1),
('Manager', 'Voucher', 'Create', 1),
('Admin', 'Permission', 'Update', 1);

-- Insert data into Notification
INSERT INTO [Notification] ([user_id], [title], [message], [type], [status], [created_at], [read_at], [related_booking_id], [related_point_transaction_id], [related_member_tier_history_id]) VALUES
('U001', 'Booking Confirmed', 'Your booking is confirmed!', 'Booking', 'Read', '2025-05-30 10:00:00', '2025-05-30 10:05:00', 1, NULL, NULL),
('U002', 'New Promotion', 'Summer Sale 20% off', 'Promotion', 'Unread', '2025-05-30 11:00:00', NULL, NULL, NULL, NULL),
('U007', 'Points Earned', 'You earned 200 points', 'LoyaltyPoint', 'Read', '2025-05-27 16:00:00', '2025-05-27 16:05:00', NULL, 3, NULL),
('U001', 'Tier Upgrade', 'Upgraded to Silver', 'TierUpgrade', 'Unread', '2025-05-30 10:00:00', NULL, NULL, NULL, 1),
('U002', 'Booking Pending', 'Your booking is pending payment', 'Booking', 'Unread', '2025-05-30 11:00:00', NULL, 2, NULL, NULL),
('U007', 'Feedback Received', 'Thank you for your feedback', 'Feedback', 'Read', '2025-05-24 10:00:00', '2025-05-24 10:05:00', 5, NULL, NULL),
('U009', 'New Service', 'Spa service available', 'System', 'Unread', '2025-05-30 12:00:00', NULL, NULL, NULL, NULL),
('U010', 'Points Earned', 'You earned 120 points', 'LoyaltyPoint', 'Read', '2025-05-30 13:00:00', '2025-05-30 13:05:00', NULL, 8, NULL),
('U005', 'Booking Confirmed', 'Your booking is confirmed!', 'Booking', 'Unread', '2025-05-30 14:00:00', NULL, 8, NULL, NULL),
('U006', 'Tier Upgrade', 'Upgraded to Silver', 'TierUpgrade', 'Unread', '2025-05-30 15:00:00', NULL, NULL, NULL, 10);

-- Insert data into CartRoomType
INSERT INTO [CartRoomType] ([user_id], [room_type_id], [quantity], [added_at]) VALUES
('U001', 1, 2, '2025-05-30 10:00:00'),
('U002', 2, 1, '2025-05-30 11:00:00'),
('U007', 3, 1, '2025-05-27 16:00:00'),
('U001', 4, 3, '2025-05-29 09:00:00'),
('U002', 5, 2, '2025-05-28 14:00:00'),
('U007', 6, 1, '2025-05-24 10:00:00'),
('U009', 7, 1, '2025-05-30 12:00:00'),
('U010', 8, 2, '2025-05-30 13:00:00'),
('U005', 9, 1, '2025-05-30 14:00:00'),
('U006', 10, 1, '2025-05-30 15:00:00');