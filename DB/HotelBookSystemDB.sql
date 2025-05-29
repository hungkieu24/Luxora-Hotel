CREATE DATABASE HotelBookSystemDB
GO

USE HotelBookSystemDB
GO

CREATE TABLE [UserAccount] (
  [id] varchar(10) PRIMARY KEY,
  [username] nvarchar(100) UNIQUE NOT NULL,
  [password] varchar(255) NOT NULL,
  [email] varchar(100) UNIQUE NOT NULL,
  [avatar_url] varchar(255),
  [role] varchar(20) NOT NULL,
  [status] varchar(10),
  [created_at] datetime,
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
  [status] varchar(20),
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
  [status] varchar(10)
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
  [status] varchar(20)
)
GO

CREATE TABLE [Booking] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [user_id] varchar(10),
  [booking_time] datetime,
  [check_in] datetime,
  [check_out] datetime,
  [status] varchar(20),
  [total_price] decimal(18,2),
  [deposit] decimal(18,2),
  [payment_status] varchar(10),
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
  [status] varchar(10),
  [image_url] varchar(255)
)
GO

CREATE TABLE [BookingService] (
  [booking_id] int,
  [service_id] int,
  [quantity] int,
  [paid_status] varchar(10),
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
  [created_at] datetime,
  [status] varchar(10),
  [admin_action] varchar(10)
)
GO

CREATE TABLE [VNPayPayment] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [booking_id] int,
  [amount] decimal(18,2),
  [status] varchar(10),
  [paid_at] datetime
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
  [created_at] datetime
)
GO

CREATE TABLE [LoyaltyPoint] (
  [user_id] varchar(10) PRIMARY KEY,
  [points] int,
  [level] varchar(10),
  [last_updated] datetime,
  [expired_at] datetime
)
GO

CREATE TABLE [PointTransaction] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [user_id] varchar(10),
  [change_type] varchar(20),
  [points_changed] int,
  [reason] nvarchar(max),
  [created_at] datetime
)
GO

CREATE TABLE [PointRedeemVoucher] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [user_id] varchar(10),
  [voucher_id] int,
  [points_used] int,
  [redeemed_at] datetime
)
GO

CREATE TABLE [ChatAIHistory] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [user_id] varchar(10),
  [message] nvarchar(max),
  [created_at] datetime,
  [violation] varchar(10)
)
GO

CREATE TABLE [Invoice] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [booking_id] int,
  [total_amount] decimal(18,2),
  [issued_at] datetime,
  [pdf_url] varchar(255),
  [image_url] varchar(255)
)
GO

CREATE TABLE [MemberTierHistory] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [user_id] varchar(10),
  [old_level] varchar(10),
  [new_level] varchar(10),
  [changed_at] datetime,
  [reason] nvarchar(max)
)
GO

CREATE TABLE [Permission] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [role] varchar(20),
  [resource] varchar(100),
  [action] varchar(10),
  [allowed] bit
)
GO

CREATE TABLE [Notification] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [user_id] varchar(10),
  [title] varchar(255),
  [message] nvarchar(max),
  [type] varchar(20),
  [status] varchar(10),
  [created_at] datetime,
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

-- FOREIGN KEYS
ALTER TABLE [HotelBranch] ADD FOREIGN KEY ([owner_id]) REFERENCES [UserAccount] ([id])
ALTER TABLE [HotelBranch] ADD FOREIGN KEY ([manager_id]) REFERENCES [UserAccount] ([id])
ALTER TABLE [Room] ADD FOREIGN KEY ([branch_id]) REFERENCES [HotelBranch] ([id])
ALTER TABLE [Room] ADD FOREIGN KEY ([room_type_id]) REFERENCES [RoomType] ([id])
ALTER TABLE [Booking] ADD FOREIGN KEY ([user_id]) REFERENCES [UserAccount] ([id])
ALTER TABLE [Booking] ADD FOREIGN KEY ([promotion_id]) REFERENCES [SeasonalPromotion] ([id])
ALTER TABLE [BookingVoucher] ADD FOREIGN KEY ([booking_id]) REFERENCES [Booking] ([id])
ALTER TABLE [BookingVoucher] ADD FOREIGN KEY ([voucher_id]) REFERENCES [Voucher] ([id])
ALTER TABLE [BookingRoom] ADD FOREIGN KEY ([booking_id]) REFERENCES [Booking] ([id])
ALTER TABLE [BookingRoom] ADD FOREIGN KEY ([room_id]) REFERENCES [Room] ([id])
ALTER TABLE [Service] ADD FOREIGN KEY ([branch_id]) REFERENCES [HotelBranch] ([id])
ALTER TABLE [BookingService] ADD FOREIGN KEY ([booking_id]) REFERENCES [Booking] ([id])
ALTER TABLE [BookingService] ADD FOREIGN KEY ([service_id]) REFERENCES [Service] ([id])
ALTER TABLE [Feedback] ADD FOREIGN KEY ([user_id]) REFERENCES [UserAccount] ([id])
ALTER TABLE [Feedback] ADD FOREIGN KEY ([booking_id]) REFERENCES [Booking] ([id])
ALTER TABLE [VNPayPayment] ADD FOREIGN KEY ([booking_id]) REFERENCES [Booking] ([id])
ALTER TABLE [VNPayTransaction] ADD FOREIGN KEY ([payment_id]) REFERENCES [VNPayPayment] ([id])
ALTER TABLE [LoyaltyPoint] ADD FOREIGN KEY ([user_id]) REFERENCES [UserAccount] ([id])
ALTER TABLE [PointTransaction] ADD FOREIGN KEY ([user_id]) REFERENCES [UserAccount] ([id])
ALTER TABLE [PointRedeemVoucher] ADD FOREIGN KEY ([user_id]) REFERENCES [UserAccount] ([id])
ALTER TABLE [PointRedeemVoucher] ADD FOREIGN KEY ([voucher_id]) REFERENCES [Voucher] ([id])
ALTER TABLE [ChatAIHistory] ADD FOREIGN KEY ([user_id]) REFERENCES [UserAccount] ([id])
ALTER TABLE [Invoice] ADD FOREIGN KEY ([booking_id]) REFERENCES [Booking] ([id])
ALTER TABLE [MemberTierHistory] ADD FOREIGN KEY ([user_id]) REFERENCES [UserAccount] ([id])
ALTER TABLE [Notification] ADD FOREIGN KEY ([user_id]) REFERENCES [UserAccount] ([id])
ALTER TABLE [Notification] ADD FOREIGN KEY ([related_booking_id]) REFERENCES [Booking] ([id])
ALTER TABLE [Notification] ADD FOREIGN KEY ([related_point_transaction_id]) REFERENCES [PointTransaction] ([id])
ALTER TABLE [Notification] ADD FOREIGN KEY ([related_member_tier_history_id]) REFERENCES [MemberTierHistory] ([id])
ALTER TABLE [CartRoomType] ADD FOREIGN KEY ([user_id]) REFERENCES [UserAccount] ([id])
ALTER TABLE [CartRoomType] ADD FOREIGN KEY ([room_type_id]) REFERENCES [RoomType] ([id])
GO

-- 1. UserAccount
INSERT INTO [UserAccount] ([id], [username], [password], [email], [avatar_url], [role], [status], [created_at], [phonenumber]) VALUES
('U001', 'admin1', 'hashed_password1', 'admin1@hotel.com', 'avatar1.jpg', 'Admin', 'Active', '2025-01-01 10:00:00', '0901234567'),
('U002', 'manager1', 'hashed_password2', 'manager1@hotel.com', 'avatar2.jpg', 'Manager', 'Active', '2025-01-02 10:00:00', '0901234568'),
('U003', 'owner1', 'hashed_password3', 'owner1@hotel.com', 'avatar3.jpg', 'Owner', 'Active', '2025-01-03 10:00:00', '0901234569'),
('U004', 'customer1', 'hashed_password4', 'customer1@gmail.com', 'avatar4.jpg', 'Customer', 'Active', '2025-01-04 10:00:00', '0901234570'),
('U005', 'customer2', 'hashed_password5', 'customer2@gmail.com', 'avatar5.jpg', 'Customer', 'Active', '2025-01-05 10:00:00', '0901234571'),
('U006', 'customer3', 'hashed_password6', 'customer3@gmail.com', 'avatar6.jpg', 'Customer', 'Active', '2025-01-06 10:00:00', '0901234572'),
('U007', 'manager2', 'hashed_password7', 'manager2@hotel.com', 'avatar7.jpg', 'Manager', 'Active', '2025-01-07 10:00:00', '0901234573'),
('U008', 'owner2', 'hashed_password8', 'owner2@hotel.com', 'avatar8.jpg', 'Owner', 'Active', '2025-01-08 10:00:00', '0901234574'),
('U009', 'customer4', 'hashed_password9', 'customer4@gmail.com', 'avatar9.jpg', 'Customer', 'Active', '2025-01-09 10:00:00', '0901234575'),
('U010', 'customer5', 'hashed_password10', 'customer5@gmail.com', 'avatar10.jpg', 'Customer', 'Active', '2025-01-10 10:00:00', '0901234576');

-- 2. HotelBranch
INSERT INTO [HotelBranch] ([name], [address], [phone], [email], [image_url], [owner_id], [manager_id]) VALUES
('Hanoi Branch', '123 Tran Hung Dao, Hanoi', '0241234567', 'hanoi@hotel.com', 'hanoi.jpg', 'U003', 'U002'),
('HCMC Branch', '456 Nguyen Hue, HCMC', '0281234567', 'hcmc@hotel.com', 'hcmc.jpg', 'U008', 'U007'),
('Da Nang Branch', '789 Vo Nguyen Giap, Da Nang', '02361234567', 'danang@hotel.com', 'danang.jpg', 'U003', 'U002'),
('Hue Branch', '101 Le Loi, Hue', '02341234567', 'hue@hotel.com', 'hue.jpg', 'U008', 'U007'),
('Nha Trang Branch', '202 Tran Phu, Nha Trang', '02581234567', 'nhatrang@hotel.com', 'nhatrang.jpg', 'U003', 'U002'),
('Vung Tau Branch', '303 Ba Trieu, Vung Tau', '02541234567', 'vungtau@hotel.com', 'vungtau.jpg', 'U008', 'U007'),
('Phu Quoc Branch', '404 Duong Dong, Phu Quoc', '02971234567', 'phuquoc@hotel.com', 'phuquoc.jpg', 'U003', 'U002'),
('Sa Pa Branch', '505 Cau May, Sa Pa', '02141234567', 'sapa@hotel.com', 'sapa.jpg', 'U008', 'U007'),
('Can Tho Branch', '606 Ninh Kieu, Can Tho', '02921234567', 'cantho@hotel.com', 'cantho.jpg', 'U003', 'U002'),
('Hai Phong Branch', '707 Le Hong Phong, Hai Phong', '02251234567', 'haiphong@hotel.com', 'haiphong.jpg', 'U008', 'U007');

-- 3. RoomType
INSERT INTO [RoomType] ([name], [description], [base_price], [capacity], [image_url]) VALUES
('Standard Room', 'Basic room with essential amenities', 500000.00, 2, 'standard.jpg'),
('Deluxe Room', 'Spacious room with city view', 800000.00, 3, 'deluxe.jpg'),
('Suite Room', 'Luxury room with full amenities', 1500000.00, 4, 'suite.jpg'),
('Family Room', 'Large room for family stays', 1200000.00, 5, 'family.jpg'),
('Single Room', 'Cozy room for solo travelers', 400000.00, 1, 'single.jpg'),
('Twin Room', 'Room with two single beds', 600000.00, 2, 'twin.jpg'),
('Executive Suite', 'Premium suite with balcony', 2000000.00, 4, 'executive.jpg'),
('Ocean View Room', 'Room with sea view', 1000000.00, 3, 'oceanview.jpg'),
('Penthouse', 'Top-floor luxury room', 3000000.00, 6, 'penthouse.jpg'),
('Budget Room', 'Affordable room with basic amenities', 350000.00, 2, 'budget.jpg');

-- 4. Room
INSERT INTO [Room] ([room_number], [branch_id], [room_type_id], [status], [image_url]) VALUES
('101', 1, 1, 'Available', 'room101.jpg'),
('102', 1, 2, 'Available', 'room102.jpg'),
('201', 2, 3, 'Occupied', 'room201.jpg'),
('202', 2, 4, 'Available', 'room202.jpg'),
('301', 3, 5, 'Available', 'room301.jpg'),
('302', 3, 6, 'Maintenance', 'room302.jpg'),
('401', 4, 7, 'Available', 'room401.jpg'),
('402', 4, 8, 'Occupied', 'room402.jpg'),
('501', 5, 9, 'Available', 'room501.jpg'),
('502', 5, 10, 'Available', 'room502.jpg');

-- 5. Voucher
INSERT INTO [Voucher] ([code], [description], [discount_percent], [discount_amount], [valid_from], [valid_to], [status]) VALUES
('WELCOME10', '10% off for new users', 10, NULL, '2025-01-01', '2025-12-31', 'Active'),
('SUMMER20', '20% off summer bookings', 20, NULL, '2025-06-01', '2025-08-31', 'Active'),
('FLASHSALE', 'Flash sale discount', NULL, 200000.00, '2025-05-01', '2025-05-31', 'Active'),
('LOYALTY50', '50% off for loyal customers', 50, NULL, '2025-01-01', '2025-12-31', 'Active'),
('WEEKEND15', '15% off weekend stays', 15, NULL, '2025-01-01', '2025-12-31', 'Active'),
('FAMILY30', '30% off family rooms', 30, NULL, '2025-07-01', '2025-09-30', 'Active'),
('FIRSTBOOK', 'First booking discount', NULL, 150000.00, '2025-01-01', '2025-12-31', 'Active'),
('VIP20', '20% off for VIP members', 20, NULL, '2025-01-01', '2025-12-31', 'Active'),
('HOLIDAY25', '25% off holiday season', 25, NULL, '2025-12-01', '2025-12-31', 'Active'),
('GROUP10', '10% off group bookings', 10, NULL, '2025-01-01', '2025-12-31', 'Active');

-- 6. SeasonalPromotion
INSERT INTO [SeasonalPromotion] ([name], [description], [discount_percent], [discount_amount], [start_date], [end_date], [status]) VALUES
('Summer Sale', 'Discount for summer bookings', 15.00, NULL, '2025-06-01', '2025-08-31', 'Active'),
('Winter Promo', 'Winter season discount', 20.00, NULL, '2025-12-01', '2025-12-31', 'Active'),
('Spring Deal', 'Spring season offer', NULL, 100000.00, '2025-03-01', '2025-05-31', 'Active'),
('Autumn Getaway', 'Autumn discount', 10.00, NULL, '2025-09-01', '2025-11-30', 'Active'),
('New Year Promo', 'New Year celebration', NULL, 200000.00, '2025-12-25', '2026-01-05', 'Active'),
('Mid-Autumn', 'Mid-Autumn festival discount', 25.00, NULL, '2025-09-10', '2025-09-20', 'Active'),
('Lunar New Year', 'Lunar New Year offer', 30.00, NULL, '2025-01-25', '2025-02-05', 'Active'),
('Black Friday', 'Black Friday sale', NULL, 300000.00, '2025-11-25', '2025-11-30', 'Active'),
('Christmas Deal', 'Christmas season discount', 20.00, NULL, '2025-12-20', '2025-12-25', 'Active'),
('Early Bird', 'Early booking discount', 10.00, NULL, '2025-01-01', '2025-12-31', 'Active');

-- 7. Booking
INSERT INTO [Booking] ([user_id], [booking_time], [check_in], [check_out], [status], [total_price], [deposit], [payment_status], [cancel_reason], [cancel_time], [promotion_id]) VALUES
('U004', '2025-05-01 10:00:00', '2025-06-01', '2025-06-03', 'Confirmed', 1000000.00, 200000.00, 'Paid', NULL, NULL, 1),
('U005', '2025-05-02 10:00:00', '2025-06-05', '2025-06-07', 'Confirmed', 1500000.00, 300000.00, 'Paid', NULL, NULL, 2),
('U006', '2025-05-03 10:00:00', '2025-06-10', '2025-06-12', 'Cancelled', 800000.00, 100000.00, 'Refunded', 'Personal reason', '2025-05-04 10:00:00', NULL),
('U009', '2025-05-04 10:00:00', '2025-06-15', '2025-06-17', 'Confirmed', 2000000.00, 400000.00, 'Paid', NULL, NULL, 3),
('U010', '2025-05-05 10:00:00', '2025-06-20', '2025-06-22', 'Confirmed', 1200000.00, 240000.00, 'Pending', NULL, NULL, 4),
('U004', '2025-05-06 10:00:00', '2025-07-01', '2025-07-03', 'Confirmed', 1800000.00, 360000.00, 'Paid', NULL, NULL, 5),
('U005', '2025-05-07 10:00:00', '2025-07-05', '2025-07-07', 'Confirmed', 900000.00, 180000.00, 'Paid', NULL, NULL, 6),
('U006', '2025-05-08 10:00:00', '2025-07-10', '2025-07-12', 'Confirmed', 1600000.00, 320000.00, 'Paid', NULL, NULL, 7),
('U009', '2025-05-09 10:00:00', '2025-07-15', '2025-07-17', 'Confirmed', 2500000.00, 500000.00, 'Paid', NULL, NULL, 8),
('U010', '2025-05-10 10:00:00', '2025-07-20', '2025-07-22', 'Confirmed', 1400000.00, 280000.00, 'Paid', NULL, NULL, 9);

-- 8. BookingVoucher
INSERT INTO [BookingVoucher] ([booking_id], [voucher_id]) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- 9. BookingRoom
INSERT INTO [BookingRoom] ([booking_id], [room_id]) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- 10. Service
INSERT INTO [Service] ([name], [description], [price], [branch_id], [status], [image_url]) VALUES
('Breakfast', 'Buffet breakfast', 150000.00, 1, 'Active', 'breakfast.jpg'),
('Spa', 'Relaxing spa session', 500000.00, 1, 'Active', 'spa.jpg'),
('Airport Transfer', 'Airport pickup and drop-off', 300000.00, 2, 'Active', 'transfer.jpg'),
('Laundry', 'Laundry service', 100000.00, 2, 'Active', 'laundry.jpg'),
('Room Service', 'In-room dining', 200000.00, 3, 'Active', 'roomservice.jpg'),
('Gym Access', 'Access to fitness center', 150000.00, 3, 'Active', 'gym.jpg'),
('Tour Guide', 'City tour with guide', 400000.00, 4, 'Active', 'tour.jpg'),
('Bike Rental', 'Bicycle rental service', 80000.00, 4, 'Active', 'bike.jpg'),
('Swimming Pool', 'Access to pool', 100000.00, 5, 'Active', 'pool.jpg'),
('Massage', 'Full body massage', 600000.00, 5, 'Active', 'massage.jpg');

-- 11. BookingService
INSERT INTO [BookingService] ([booking_id], [service_id], [quantity], [paid_status]) VALUES
(1, 1, 2, 'Paid'),
(2, 2, 1, 'Paid'),
(3, 3, 1, 'Refunded'),
(4, 4, 2, 'Paid'),
(5, 5, 1, 'Pending'),
(6, 6, 1, 'Paid'),
(7, 7, 1, 'Paid'),
(8, 8, 2, 'Paid'),
(9, 9, 1, 'Paid'),
(10, 10, 1, 'Paid');

-- 12. Feedback
INSERT INTO [Feedback] ([user_id], [booking_id], [rating], [comment], [image_url], [created_at], [status], [admin_action]) VALUES
('U004', 1, 5, 'Great stay!', 'feedback1.jpg', '2025-06-04 10:00:00', 'Approved', 'None'),
('U005', 2, 4, 'Good service, but room was small', 'feedback2.jpg', '2025-06-08 10:00:00', 'Approved', 'Noted'),
('U006', 3, 3, 'Cancelled due to personal reasons', NULL, '2025-06-13 10:00:00', 'Approved', 'None'),
('U009', 4, 5, 'Excellent experience!', 'feedback4.jpg', '2025-06-18 10:00:00', 'Approved', 'None'),
('U010', 5, 4, 'Nice hotel, good staff', 'feedback5.jpg', '2025-06-23 10:00:00', 'Pending', 'None'),
('U004', 6, 5, 'Loved the amenities', 'feedback6.jpg', '2025-07-04 10:00:00', 'Approved', 'None'),
('U005', 7, 4, 'Good but noisy at night', 'feedback7.jpg', '2025-07-08 10:00:00', 'Approved', 'Investigate'),
('U006', 8, 5, 'Perfect stay!', 'feedback8.jpg', '2025-07-13 10:00:00', 'Approved', 'None'),
('U009', 9, 4, 'Great view, slow check-in', 'feedback9.jpg', '2025-07-18 10:00:00', 'Approved', 'Noted'),
('U010', 10, 5, 'Will come back!', 'feedback10.jpg', '2025-07-23 10:00:00', 'Approved', 'None');

-- 13. VNPayPayment
INSERT INTO [VNPayPayment] ([booking_id], [amount], [status], [paid_at]) VALUES
(1, 1000000.00, 'Success', '2025-05-01 10:30:00'),
(2, 1500000.00, 'Success', '2025-05-02 10:30:00'),
(3, 800000.00, 'Refunded', '2025-05-03 10:30:00'),
(4, 2000000.00, 'Success', '2025-05-04 10:30:00'),
(5, 1200000.00, 'Pending', '2025-05-05 10:30:00'),
(6, 1800000.00, 'Success', '2025-05-06 10:30:00'),
(7, 900000.00, 'Success', '2025-05-07 10:30:00'),
(8, 1600000.00, 'Success', '2025-05-08 10:30:00'),
(9, 2500000.00, 'Success', '2025-05-09 10:30:00'),
(10, 1400000.00, 'Success', '2025-05-10 10:30:00');

-- 14. VNPayTransaction
INSERT INTO [VNPayTransaction] ([payment_id], [vnp_TxnRef], [vnp_TransactionNo], [vnp_ResponseCode], [vnp_Amount], [vnp_BankCode], [vnp_CardType], [vnp_SecureHash], [is_refund], [created_at]) VALUES
(1, 'TXN001', '123456', '00', 1000000.00, 'NCB', 'VISA', 'hash1', 0, '2025-05-01 10:30:00'),
(2, 'TXN002', '123457', '00', 1500000.00, 'VCB', 'MASTER', 'hash2', 0, '2025-05-02 10:30:00'),
(3, 'TXN003', '123458', '00', 800000.00, 'TPB', 'VISA', 'hash3', 1, '2025-05-03 10:30:00'),
(4, 'TXN004', '123459', '00', 2000000.00, 'MBB', 'MASTER', 'hash4', 0, '2025-05-04 10:30:00'),
(5, 'TXN005', '123460', '24', 1200000.00, 'VCB', 'VISA', 'hash5', 0, '2025-05-05 10:30:00'),
(6, 'TXN006', '123461', '00', 1800000.00, 'NCB', 'MASTER', 'hash6', 0, '2025-05-06 10:30:00'),
(7, 'TXN007', '123462', '00', 900000.00, 'TPB', 'VISA', 'hash7', 0, '2025-05-07 10:30:00'),
(8, 'TXN008', '123463', '00', 1600000.00, 'MBB', 'MASTER', 'hash8', 0, '2025-05-08 10:30:00'),
(9, 'TXN009', '123464', '00', 2500000.00, 'VCB', 'VISA', 'hash9', 0, '2025-05-09 10:30:00'),
(10, 'TXN010', '123465', '00', 1400000.00, 'NCB', 'MASTER', 'hash10', 0, '2025-05-10 10:30:00');

-- 15. LoyaltyPoint
INSERT INTO [LoyaltyPoint] ([user_id], [points], [level], [last_updated], [expired_at]) VALUES
('U004', 500, 'Silver', '2025-05-01 10:00:00', '2026-05-01'),
('U005', 300, 'Bronze', '2025-05-02 10:00:00', '2026-05-02'),
('U006', 200, 'Bronze', '2025-05-03 10:00:00', '2026-05-03'),
('U009', 700, 'Gold', '2025-05-04 10:00:00', '2026-05-04'),
('U010', 400, 'Silver', '2025-05-05 10:00:00', '2026-05-05'),
('U004', 600, 'Silver', '2025-05-06 10:00:00', '2026-05-06'),
('U005', 350, 'Bronze', '2025-05-07 10:00:00', '2026-05-07'),
('U006', 250, 'Bronze', '2025-05-08 10:00:00', '2026-05-08'),
('U009', 800, 'Gold', '2025-05-09 10:00:00', '2026-05-09'),
('U010', 450, 'Silver', '2025-05-10 10:00:00', '2026-05-10');

-- 16. PointTransaction
INSERT INTO [PointTransaction] ([user_id], [change_type], [points_changed], [reason], [created_at]) VALUES
('U004', 'Earn', 100, 'Booking completed', '2025-05-01 10:00:00'),
('U005', 'Earn', 50, 'Booking completed', '2025-05-02 10:00:00'),
('U006', 'Deduct', -50, 'Voucher redemption', '2025-05-03 10:00:00'),
('U009', 'Earn', 200, 'Booking completed', '2025-05-04 10:00:00'),
('U010', 'Earn', 100, 'Booking completed', '2025-05-05 10:00:00'),
('U004', 'Earn', 150, 'Booking completed', '2025-05-06 10:00:00'),
('U005', 'Earn', 75, 'Booking completed', '2025-05-07 10:00:00'),
('U006', 'Earn', 50, 'Feedback submitted', '2025-05-08 10:00:00'),
('U009', 'Earn', 250, 'Booking completed', '2025-05-09 10:00:00'),
('U010', 'Deduct', -100, 'Voucher redemption', '2025-05-10 10:00:00');

-- 17. PointRedeemVoucher
INSERT INTO [PointRedeemVoucher] ([user_id], [voucher_id], [points_used], [redeemed_at]) VALUES
('U004', 1, 50, '2025-05-01 10:00:00'),
('U005', 2, 100, '2025-05-02 10:00:00'),
('U006', 3, 50, '2025-05-03 10:00:00'),
('U009', 4, 150, '2025-05-04 10:00:00'),
('U010', 5, 100, '2025-05-05 10:00:00'),
('U004', 6, 75, '2025-05-06 10:00:00'),
('U005', 7, 50, '2025-05-07 10:00:00'),
('U006', 8, 100, '2025-05-08 10:00:00'),
('U009', 9, 200, '2025-05-09 10:00:00'),
('U010', 10, 150, '2025-05-10 10:00:00');

-- 18. ChatAIHistory
INSERT INTO [ChatAIHistory] ([user_id], [message], [created_at], [violation]) VALUES
('U004', 'What are the best rooms in Hanoi?', '2025-05-01 10:00:00', 'None'),
('U005', 'Can you help with booking?', '2025-05-02 10:00:00', 'None'),
('U006', 'Check room availability', '2025-05-03 10:00:00', 'None'),
('U009', 'What are the promotions?', '2025-05-04 10:00:00', 'None'),
('U010', 'How to cancel a booking?', '2025-05-05 10:00:00', 'None'),
('U004', 'What services are available?', '2025-05-06 10:00:00', 'None'),
('U005', 'Can you recommend a hotel?', '2025-05-07 10:00:00', 'None'),
('U006', 'What is the refund policy?', '2025-05-08 10:00:00', 'None'),
('U009', 'How to earn loyalty points?', '2025-05-09 10:00:00', 'None'),
('U010', 'What is the spa service?', '2025-05-10 10:00:00', 'None');

-- 19. Invoice
INSERT INTO [Invoice] ([booking_id], [total_amount], [issued_at], [pdf_url], [image_url]) VALUES
(1, 1000000.00, '2025-05-01 10:30:00', 'invoice1.pdf', 'invoice1.jpg'),
(2, 1500000.00, '2025-05-02 10:30:00', 'invoice2.pdf', 'invoice2.jpg'),
(3, 800000.00, '2025-05-03 10:30:00', 'invoice3.pdf', 'invoice3.jpg'),
(4, 2000000.00, '2025-05-04 10:30:00', 'invoice4.pdf', 'invoice4.jpg'),
(5, 1200000.00, '2025-05-05 10:30:00', 'invoice5.pdf', 'invoice5.jpg'),
(6, 1800000.00, '2025-05-06 10:30:00', 'invoice6.pdf', 'invoice6.jpg'),
(7, 900000.00, '2025-05-07 10:30:00', 'invoice7.pdf', 'invoice7.jpg'),
(8, 1600000.00, '2025-05-08 10:30:00', 'invoice8.pdf', 'invoice8.jpg'),
(9, 2500000.00, '2025-05-09 10:30:00', 'invoice9.pdf', 'invoice9.jpg'),
(10, 1400000.00, '2025-05-10 10:30:00', 'invoice10.pdf', 'invoice10.jpg');

-- 20. MemberTierHistory
INSERT INTO [MemberTierHistory] ([user_id], [old_level], [new_level], [changed_at], [reason]) VALUES
('U004', 'Bronze', 'Silver', '2025-05-01 10:00:00', 'Reached 500 points'),
('U005', NULL, 'Bronze', '2025-05-02 10:00:00', 'New member'),
('U006', NULL, 'Bronze', '2025-05-03 10:00:00', 'New member'),
('U009', 'Silver', 'Gold', '2025-05-04 10:00:00', 'Reached 700 points'),
('U010', 'Bronze', 'Silver', '2025-05-05 10:00:00', 'Reached 400 points'),
('U004', 'Silver', 'Silver', '2025-05-06 10:00:00', 'Points updated'),
('U005', 'Bronze', 'Bronze', '2025-05-07 10:00:00', 'Points updated'),
('U006', 'Bronze', 'Bronze', '2025-05-08 10:00:00', 'Points updated'),
('U009', 'Gold', 'Gold', '2025-05-09 10:00:00', 'Points updated'),
('U010', 'Silver', 'Silver', '2025-05-10 10:00:00', 'Points updated');

-- 21. Permission
INSERT INTO [Permission] ([role], [resource], [action], [allowed]) VALUES
('Admin', 'UserAccount', 'Manage', 1),
('Manager', 'HotelBranch', 'Update', 1),
('Owner', 'HotelBranch', 'Create', 1),
('Customer', 'Booking', 'Create', 1),
('Customer', 'Feedback', 'Create', 1),
('Admin', 'Voucher', 'Manage', 1),
('Manager', 'Service', 'Update', 1),
('Customer', 'Booking', 'Cancel', 1),
('Admin', 'Feedback', 'Approve', 1),
('Customer', 'LoyaltyPoint', 'View', 1);

-- 22. Notification
INSERT INTO [Notification] ([user_id], [title], [message], [type], [status], [created_at], [read_at], [related_booking_id], [related_point_transaction_id], [related_member_tier_history_id]) VALUES
('U004', 'Booking Confirmed', 'Your booking is confirmed!', 'Booking', 'Unread', '2025-05-01 10:00:00', NULL, 1, NULL, NULL),
('U005', 'Points Earned', 'You earned 50 points!', 'Points', 'Unread', '2025-05-02 10:00:00', NULL, NULL, 2, NULL),
('U006', 'Booking Cancelled', 'Your booking was cancelled.', 'Booking', 'Read', '2025-05-03 10:00:00', '2025-05-03 11:00:00', 3, NULL, NULL),
('U009', 'Tier Upgraded', 'Congratulations! You are now Gold!', 'Membership', 'Unread', '2025-05-04 10:00:00', NULL, NULL, NULL, 4),
('U010', 'Booking Confirmed', 'Your booking is confirmed!', 'Booking', 'Unread', '2025-05-05 10:00:00', NULL, 5, NULL, NULL),
('U004', 'Points Earned', 'You earned 150 points!', 'Points', 'Unread', '2025-05-06 10:00:00', NULL, NULL, 6, NULL),
('U005', 'Booking Confirmed', 'Your booking is confirmed!', 'Booking', 'Unread', '2025-05-07 10:00:00', NULL, 7, NULL, NULL),
('U006', 'Points Earned', 'You earned 50 points!', 'Points', 'Unread', '2025-05-08 10:00:00', NULL, NULL, 8, NULL),
('U009', 'Booking Confirmed', 'Your booking is confirmed!', 'Booking', 'Unread', '2025-05-09 10:00:00', NULL, 9, NULL, NULL),
('U010', 'Tier Upgraded', 'Congratulations! You are now Silver!', 'Membership', 'Unread', '2025-05-10 10:00:00', NULL, NULL, NULL, 10);

-- 23. CartRoomType
INSERT INTO [CartRoomType] ([user_id], [room_type_id], [quantity], [added_at]) VALUES
('U004', 1, 1, '2025-05-01 09:00:00'),
('U005', 2, 2, '2025-05-02 09:00:00'),
('U006', 3, 1, '2025-05-03 09:00:00'),
('U009', 4, 1, '2025-05-04 09:00:00'),
('U010', 5, 2, '2025-05-05 09:00:00'),
('U004', 6, 1, '2025-05-06 09:00:00'),
('U005', 7, 1, '2025-05-07 09:00:00'),
('U006', 8, 2, '2025-05-08 09:00:00'),
('U009', 9, 1, '2025-05-09 09:00:00'),
('U010', 10, 1, '2025-05-10 09:00:00');

