USE master
GO

-- Drop database if it exists and create new
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'HotelBookingSystemDB')
BEGIN
    ALTER DATABASE HotelBookingSystemDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE HotelBookingSystemDB;
END
GO
CREATE DATABASE HotelBookingSystemDB
GO

USE HotelBookingSystemDB
GO

-- 1. USER & ROLE
CREATE TABLE UserAccount (
    id VARCHAR(10) PRIMARY KEY,
    username NVARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255),
    fullname NVARCHAR(255),
    email VARCHAR(100) UNIQUE NOT NULL,
    login_type VARCHAR(20) CHECK (login_type IN ('Local', 'Google')) NOT NULL DEFAULT 'Local',
    avatar_url VARCHAR(255),
    role VARCHAR(20) CHECK (role IN ('Customer', 'Staff', 'Manager', 'Admin', 'HotelOwner')) NOT NULL,
    status VARCHAR(10) CHECK (status IN ('Active', 'Inactive', 'Banned')) DEFAULT 'Active',
    created_at DATETIME DEFAULT GETDATE(),
    phonenumber VARCHAR(20),
    branch_id INT NULL,
	last_login_at DATETIME NULL,
    is_deleted BIT DEFAULT 0
);

-- 2. HOTEL BRANCH (Removed UNIQUE constraint on manager_id)
CREATE TABLE HotelBranch (
    id INT PRIMARY KEY IDENTITY(1, 1),
    name NVARCHAR(255) NOT NULL,
    address NVARCHAR(MAX) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    image_url VARCHAR(255),
    owner_id VARCHAR(10) NOT NULL,
    manager_id VARCHAR(10), -- No UNIQUE constraint
    created_at DATETIME DEFAULT GETDATE(),
    is_deleted BIT DEFAULT 0
);

-- 3. ROOM TYPE, ROOM, AMENITY
CREATE TABLE RoomType (
    id INT PRIMARY KEY IDENTITY(1, 1),
    name VARCHAR(100),
    description NVARCHAR(MAX),
    base_price DECIMAL(18,2) NOT NULL,
    capacity_adult INT NOT NULL,
    capacity_child INT NOT NULL,
    branch_id INT NOT NULL,
    image_url VARCHAR(255),
    is_deleted BIT DEFAULT 0
);

CREATE TABLE Room (
    id INT PRIMARY KEY IDENTITY(1, 1),
    room_number VARCHAR(20) NOT NULL,
    branch_id INT NOT NULL,
    room_type_id INT NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Available', 'Booked', 'Occupied', 'Maintenance')) DEFAULT 'Available',
    image_url VARCHAR(255),
    is_deleted BIT DEFAULT 0,
    CONSTRAINT UQ_Room_Branch_RoomNumber UNIQUE (branch_id, room_number)
);

CREATE TABLE Amenity (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255),
    is_deleted BIT DEFAULT 0
);

CREATE TABLE RoomAmenity (
    room_id INT,
    amenity_id INT,
    PRIMARY KEY (room_id, amenity_id)
);

-- 4. SERVICE
CREATE TABLE Service (
    id INT PRIMARY KEY IDENTITY(1, 1),
    name VARCHAR(100),
    description NVARCHAR(MAX),
    price DECIMAL(18,2),
    branch_id INT NOT NULL,
    status VARCHAR(10) CHECK (status IN ('Active', 'Inactive')) DEFAULT 'Active',
    image_url VARCHAR(255),
    is_deleted BIT DEFAULT 0
);

-- 5. BOOKING, BOOKING DETAIL
CREATE TABLE Booking (
    id INT PRIMARY KEY IDENTITY(1, 1),
    user_id VARCHAR(10) NOT NULL,
    booking_time DATETIME DEFAULT GETDATE(),
    check_in DATETIME NOT NULL,
    check_out DATETIME NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Pending', 'Paid', 'CheckedIn', 'CheckedOut', 'Completed', 'Cancelled', 'NoShow', 'Locked', 'Deleted')) DEFAULT 'Pending',
    total_price DECIMAL(18,2) NOT NULL,
    refund_amount DECIMAL(18,2),
    payment_status VARCHAR(10) CHECK (payment_status IN ('Unpaid', 'Paid')) DEFAULT 'Unpaid',
    cancel_reason NVARCHAR(MAX),
    cancel_time DATETIME,
    promotion_id INT,
    branch_id INT NOT NULL,
    is_deleted BIT DEFAULT 0
);

CREATE TABLE BookingVoucher (
    booking_id INT,
    voucher_id INT,
    PRIMARY KEY (booking_id, voucher_id),
    used_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE BookingRoom (
    booking_id INT,
    room_id INT,
    price DECIMAL(18,2) NOT NULL,
    PRIMARY KEY (booking_id, room_id)
);

CREATE TABLE BookingService (
    booking_id INT,
    service_id INT,
    quantity INT,
    paid_status VARCHAR(10) CHECK (paid_status IN ('Unpaid', 'Paid')) DEFAULT 'Unpaid',
    PRIMARY KEY (booking_id, service_id)
);

-- 6. VOUCHER, PROMOTION
CREATE TABLE Voucher (
    id INT PRIMARY KEY IDENTITY(1, 1),
    code VARCHAR(50) UNIQUE NOT NULL,
    description NVARCHAR(MAX),
    discount_percent INT,
    discount_amount DECIMAL(18,2),
    min_price DECIMAL(18,2),
    total_quantity INT,
    used_quantity INT DEFAULT 0,
    branch_id INT NOT NULL,
    valid_from DATETIME,
    valid_to DATETIME,
    status VARCHAR(10) CHECK (status IN ('Active', 'Inactive', 'Expired')) DEFAULT 'Active',
    is_deleted BIT DEFAULT 0
);

CREATE TABLE SeasonalPromotion (
    id INT PRIMARY KEY IDENTITY(1, 1),
    name NVARCHAR(100),
    description NVARCHAR(MAX),
    discount_percent DECIMAL(5,2),
    discount_amount DECIMAL(18,2),
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    branch_id INT NOT NULL,
    room_type_id INT NOT NULL,
    status VARCHAR(10) CHECK (status IN ('Active', 'Inactive', 'Expired')) DEFAULT 'Active',
    is_deleted BIT DEFAULT 0
);

-- 7. FEEDBACK
CREATE TABLE Feedback (
    id INT PRIMARY KEY IDENTITY(1, 1),
    user_id VARCHAR(10) NOT NULL,
    booking_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(MAX),
    image_url NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    status VARCHAR(10) CHECK (status IN ('Visible', 'Hidden', 'Blocked')) DEFAULT 'Visible',
    admin_action VARCHAR(10) CHECK (admin_action IN ('None', 'Warned', 'Banned')) DEFAULT 'None',
    is_deleted BIT DEFAULT 0
);

-- 8. PAYMENT, INVOICE, EXPENSE
CREATE TABLE VNPayPayment (
    id INT PRIMARY KEY IDENTITY(1, 1),
    booking_id INT NOT NULL,
    amount DECIMAL(18,2),
    status VARCHAR(10) CHECK (status IN ('Pending', 'Completed', 'Failed', 'Refunded')) DEFAULT 'Pending',
    paid_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE VNPayTransaction (
    id INT PRIMARY KEY IDENTITY(1, 1),
    payment_id INT NOT NULL,
    vnp_TxnRef VARCHAR(100),
    vnp_TransactionNo VARCHAR(100),
    vnp_ResponseCode VARCHAR(10),
    vnp_Amount DECIMAL(18,2),
    vnp_BankCode VARCHAR(50),
    vnp_CardType VARCHAR(50),
    vnp_SecureHash VARCHAR(255),
    is_refunded BIT,
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE Invoice (
    id INT PRIMARY KEY IDENTITY(1, 1),
    booking_id INT NOT NULL,
    total_amount DECIMAL(18,2),
    issued_at DATETIME DEFAULT GETDATE(),
    pdf_url VARCHAR(255),
    image_url VARCHAR(255)
);

CREATE TABLE Expense (
    id INT PRIMARY KEY IDENTITY(1,1),
    branch_id INT NOT NULL,
    expense_type VARCHAR(50),
    amount DECIMAL(18,2) NOT NULL,
    description NVARCHAR(MAX),
    expense_date DATETIME DEFAULT GETDATE(),
    created_by VARCHAR(10)
);

-- 9. LOYALTY POINT & REDEEM
CREATE TABLE LoyaltyPoint (
    user_id VARCHAR(10) PRIMARY KEY,
    points INT,
    level VARCHAR(10) CHECK (level IN ('Member', 'Silver', 'Gold', 'VIP')) DEFAULT 'Member',
    last_updated DATETIME DEFAULT GETDATE(),
    expired_at DATETIME
);

CREATE TABLE PointTransaction (
    id INT PRIMARY KEY IDENTITY(1, 1),
    user_id VARCHAR(10),
    change_type VARCHAR(20) CHECK (change_type IN ('Earn', 'Redeem', 'Adjustment')),
    points_changed INT,
    reason NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE PointRedeemVoucher (
    id INT PRIMARY KEY IDENTITY(1, 1),
    user_id VARCHAR(10),
    voucher_id INT,
    points_used INT,
    redeemed_at DATETIME DEFAULT GETDATE(),
    expired_at DATETIME
);

-- 10. AI HISTORY, MEMBER TIER HISTORY, BACKUP HISTORY
CREATE TABLE ChatAIHistory (
    id INT PRIMARY KEY IDENTITY(1, 1),
    user_id VARCHAR(10),
    message NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    violation VARCHAR(10)
);

CREATE TABLE MemberTierHistory (
    id INT PRIMARY KEY IDENTITY(1, 1),
    user_id VARCHAR(10),
    old_level VARCHAR(10) CHECK (old_level IN ('Member', 'Silver', 'Gold', 'VIP')),
    new_level VARCHAR(10) CHECK (new_level IN ('Member', 'Silver', 'Gold', 'VIP')),
    changed_at DATETIME DEFAULT GETDATE(),
    reason NVARCHAR(MAX)
);

CREATE TABLE BackupHistory (
    id INT PRIMARY KEY IDENTITY(1,1),
    backup_time DATETIME DEFAULT GETDATE(),
    backup_type VARCHAR(20) CHECK (backup_type IN ('FULL', 'PARTIAL')),
    backup_path NVARCHAR(500) NOT NULL,
    file_size_mb FLOAT,
    is_deleted BIT DEFAULT 0
);

-- 11. PERMISSION, NOTIFICATION, CART
CREATE TABLE Permission (
    id INT PRIMARY KEY IDENTITY(1, 1),
    role VARCHAR(20) CHECK (role IN ('Customer', 'Staff', 'Manager', 'Admin', 'HotelOwner')) NOT NULL,
    resource VARCHAR(100) NOT NULL,
    action VARCHAR(10) CHECK (action IN ('Create', 'Read', 'Update', 'Delete')) NOT NULL,
    allowed BIT
);

CREATE TABLE Notification (
    id INT PRIMARY KEY IDENTITY(1, 1),
    user_id VARCHAR(10),
    title VARCHAR(255),
    message NVARCHAR(MAX),
    type VARCHAR(20) CHECK (type IN (
        'System', 'Promotion', 'Booking', 'Payment',
        'Feedback', 'Chat', 'LoyaltyPoint', 'TierUpgrade'
    )) DEFAULT 'System',
    status VARCHAR(10) CHECK (status IN ('Unread', 'Read')) DEFAULT 'Unread',
    created_at DATETIME DEFAULT GETDATE(),
    read_at DATETIME,
    related_booking_id INT,
    related_point_transaction_id INT,
    related_member_tier_history_id INT
);

CREATE TABLE CartRoomType (
    id INT PRIMARY KEY IDENTITY(1, 1),
    user_id VARCHAR(10) NOT NULL,
    room_type_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT (1),
    added_at DATETIME DEFAULT (GETDATE()),
    CONSTRAINT UQ_CartRoomType_User_RoomType UNIQUE(user_id, room_type_id)
);

-- 12. FOREIGN KEYS
ALTER TABLE UserAccount ADD CONSTRAINT FK_UserAccount_Branch FOREIGN KEY (branch_id) REFERENCES HotelBranch (id);
ALTER TABLE HotelBranch ADD CONSTRAINT FK_HotelBranch_Owner FOREIGN KEY (owner_id) REFERENCES UserAccount (id);
ALTER TABLE HotelBranch ADD CONSTRAINT FK_HotelBranch_Manager FOREIGN KEY (manager_id) REFERENCES UserAccount (id);
ALTER TABLE RoomType ADD CONSTRAINT FK_RoomType_Branch FOREIGN KEY (branch_id) REFERENCES HotelBranch (id);
ALTER TABLE Room ADD CONSTRAINT FK_Room_Branch FOREIGN KEY (branch_id) REFERENCES HotelBranch (id);
ALTER TABLE Room ADD CONSTRAINT FK_Room_RoomType FOREIGN KEY (room_type_id) REFERENCES RoomType (id);
ALTER TABLE RoomAmenity ADD CONSTRAINT FK_RoomAmenity_Room FOREIGN KEY (room_id) REFERENCES Room (id);
ALTER TABLE RoomAmenity ADD CONSTRAINT FK_RoomAmenity_Amenity FOREIGN KEY (amenity_id) REFERENCES Amenity (id);
ALTER TABLE Booking ADD CONSTRAINT FK_Booking_User FOREIGN KEY (user_id) REFERENCES UserAccount (id);
ALTER TABLE Booking ADD CONSTRAINT FK_Booking_Promotion FOREIGN KEY (promotion_id) REFERENCES SeasonalPromotion (id);
ALTER TABLE Booking ADD CONSTRAINT FK_Booking_Branch FOREIGN KEY (branch_id) REFERENCES HotelBranch (id);
ALTER TABLE BookingVoucher ADD CONSTRAINT FK_BookingVoucher_Booking FOREIGN KEY (booking_id) REFERENCES Booking (id);
ALTER TABLE BookingVoucher ADD CONSTRAINT FK_BookingVoucher_Voucher FOREIGN KEY (voucher_id) REFERENCES Voucher (id);
ALTER TABLE BookingRoom ADD CONSTRAINT FK_BookingRoom_Booking FOREIGN KEY (booking_id) REFERENCES Booking (id);
ALTER TABLE BookingRoom ADD CONSTRAINT FK_BookingRoom_Room FOREIGN KEY (room_id) REFERENCES Room (id);
ALTER TABLE Service ADD CONSTRAINT FK_Service_Branch FOREIGN KEY (branch_id) REFERENCES HotelBranch (id);
ALTER TABLE BookingService ADD CONSTRAINT FK_BookingService_Booking FOREIGN KEY (booking_id) REFERENCES Booking (id);
ALTER TABLE BookingService ADD CONSTRAINT FK_BookingService_Service FOREIGN KEY (service_id) REFERENCES Service (id);
ALTER TABLE Feedback ADD CONSTRAINT FK_Feedback_User FOREIGN KEY (user_id) REFERENCES UserAccount (id);
ALTER TABLE Feedback ADD CONSTRAINT FK_Feedback_Booking FOREIGN KEY (booking_id) REFERENCES Booking (id);
ALTER TABLE VNPayPayment ADD CONSTRAINT FK_VNPayPayment_Booking FOREIGN KEY (booking_id) REFERENCES Booking (id);
ALTER TABLE VNPayTransaction ADD CONSTRAINT FK_VNPayTransaction_Payment FOREIGN KEY (payment_id) REFERENCES VNPayPayment (id);
ALTER TABLE Invoice ADD CONSTRAINT FK_Invoice_Booking FOREIGN KEY (booking_id) REFERENCES Booking (id);
ALTER TABLE Expense ADD CONSTRAINT FK_Expense_Branch FOREIGN KEY (branch_id) REFERENCES HotelBranch (id);
ALTER TABLE LoyaltyPoint ADD CONSTRAINT FK_LoyaltyPoint_User FOREIGN KEY (user_id) REFERENCES UserAccount (id);
ALTER TABLE PointTransaction ADD CONSTRAINT FK_PointTransaction_User FOREIGN KEY (user_id) REFERENCES UserAccount (id);
ALTER TABLE PointRedeemVoucher ADD CONSTRAINT FK_PointRedeemVoucher_User FOREIGN KEY (user_id) REFERENCES UserAccount (id);
ALTER TABLE PointRedeemVoucher ADD CONSTRAINT FK_PointRedeemVoucher_Voucher FOREIGN KEY (voucher_id) REFERENCES Voucher (id);
ALTER TABLE ChatAIHistory ADD CONSTRAINT FK_ChatAIHistory_User FOREIGN KEY (user_id) REFERENCES UserAccount (id);
ALTER TABLE MemberTierHistory ADD CONSTRAINT FK_MemberTierHistory_User FOREIGN KEY (user_id) REFERENCES UserAccount (id);
ALTER TABLE Notification ADD CONSTRAINT FK_Notification_User FOREIGN KEY (user_id) REFERENCES UserAccount (id);
ALTER TABLE Notification ADD CONSTRAINT FK_Notification_Booking FOREIGN KEY (related_booking_id) REFERENCES Booking (id);
ALTER TABLE Notification ADD CONSTRAINT FK_Notification_PointTransaction FOREIGN KEY (related_point_transaction_id) REFERENCES PointTransaction (id);
ALTER TABLE Notification ADD CONSTRAINT FK_Notification_MemberTierHistory FOREIGN KEY (related_member_tier_history_id) REFERENCES MemberTierHistory (id);
ALTER TABLE CartRoomType ADD CONSTRAINT FK_CartRoomType_User FOREIGN KEY (user_id) REFERENCES UserAccount (id);
ALTER TABLE CartRoomType ADD CONSTRAINT FK_CartRoomType_RoomType FOREIGN KEY (room_type_id) REFERENCES RoomType (id);
ALTER TABLE Voucher ADD CONSTRAINT FK_Voucher_Branch FOREIGN KEY (branch_id) REFERENCES HotelBranch (id);
ALTER TABLE SeasonalPromotion ADD CONSTRAINT FK_SeasonalPromotion_Branch FOREIGN KEY (branch_id) REFERENCES HotelBranch (id);
ALTER TABLE SeasonalPromotion ADD CONSTRAINT FK_SeasonalPromotion_RoomType FOREIGN KEY (room_type_id) REFERENCES RoomType (id);
GO

-- Insert data in correct order to avoid foreign key violations

-- 1. UserAccount (with branch_id = NULL initially)
INSERT INTO UserAccount (
    id, username, password, fullname, email, login_type,
    avatar_url, role, status, created_at, phonenumber, branch_id, is_deleted, last_login_at
) VALUES
-- Active users with recent login times
('U001', 'john_doe', 'hashed_password1', N'John Doe', 'john.doe@email.com', 'Local', 
 'https://example.com/avatar1.jpg', 'Customer', 'Active', GETDATE(), '1234567890', NULL, 0, DATEADD(HOUR, -2, GETDATE())), -- Logged in 2 hours ago
('U002', 'jane_smith', 'hashed_password2', N'Jane Smith', 'jane.smith@email.com', 'Google', 
 'https://example.com/avatar2.jpg', 'Staff', 'Active', GETDATE(), '0987654321', NULL, 0, DATEADD(DAY, -1, GETDATE())), -- Logged in 1 day ago
('U003', 'mike_manager', 'hashed_password3', N'Mike Johnson', 'mike.johnson@email.com', 'Local', 
 'https://example.com/avatar3.jpg', 'Manager', 'Active', GETDATE(), '5551234567', NULL, 0, DATEADD(HOUR, -5, GETDATE())), -- Logged in 5 hours ago
('U004', 'anna_owner', 'hashed_password4', N'Anna Brown', 'anna.brown@email.com', 'Local', 
 'https://example.com/avatar4.jpg', 'HotelOwner', 'Active', GETDATE(), '5559876543', NULL, 0, DATEADD(DAY, -2, GETDATE())), -- Logged in 2 days ago
('U005', 'admin_user', 'hashed_password5', N'Admin User', 'admin@email.com', 'Local', 
 'https://example.com/avatar5.jpg', 'Admin', 'Active', GETDATE(), '5551112222', NULL, 0, DATEADD(HOUR, -1, GETDATE())), -- Logged in 1 hour ago
-- Inactive user, no recent login
('U006', 'truongminhquan', 'pass123', N'Trương Minh Quân', 'quan.truong@example.com', 
 'Local', NULL, 'Customer', 'Inactive', GETDATE(), '0901000001', NULL, 0, NULL),
-- Banned user, no recent login
('U007', 'nguyenthuytrang', 'pass456', N'Nguyễn Thùy Trang', 'trang.nguyen@example.com', 
 'Local', NULL, 'Customer', 'Banned', GETDATE(), '0902000002', NULL, 0, NULL),
-- Soft-deleted user, no recent login (status changed to 'Active' to satisfy CHECK constraint)
('U008', 'phamducthinh', 'pass789', N'Phạm Đức Thịnh', 'thinh.pham@example.com', 
 'Local', NULL, 'Customer', 'Active', GETDATE(), '0903000003', NULL, 1, NULL);
GO
-- 2. HotelBranch
INSERT INTO HotelBranch (name, address, phone, email, image_url, owner_id, manager_id, created_at, is_deleted) VALUES
(N'Sunshine Hotel Hanoi', N'123 Tran Phu, Hanoi', '0241234567', 'hanoi@sunshinehotel.com', 'https://example.com/hotel1.jpg', 'U004', 'U003', GETDATE(), 0),
(N'Sunshine Hotel Da Nang', N'456 Vo Nguyen Giap, Da Nang', '0236123456', 'danang@sunshinehotel.com', 'https://example.com/hotel2.jpg', 'U004', NULL, GETDATE(), 0),
(N'Sunshine Hotel HCMC', N'789 Le Loi, HCMC', '0281234567', 'hcmc@sunshinehotel.com', 'https://example.com/hotel3.jpg', 'U004', NULL, GETDATE(), 0),
(N'Sunshine Hotel Nha Trang', N'101 Tran Hung Dao, Nha Trang', '0258123456', 'nhatrang@sunshinehotel.com', 'https://example.com/hotel4.jpg', 'U004', NULL, GETDATE(), 0),
(N'Sunshine Hotel Phu Quoc', N'202 Duong Dong, Phu Quoc', '0297123456', 'phuquoc@sunshinehotel.com', 'https://example.com/hotel5.jpg', 'U004', NULL, GETDATE(), 0);

-- Update UserAccount to set branch_id
UPDATE UserAccount SET branch_id = 1 WHERE id IN ('U002', 'U004');

-- 3. RoomType
INSERT INTO RoomType (name, description, base_price, capacity_adult, capacity_child, branch_id, image_url, is_deleted) VALUES
('Standard Room', N'Cozy room with city view', 500000.00, 2, 1, 1, 'https://example.com/room1.jpg', 0),
('Deluxe Room', N'Spacious room with sea view', 800000.00, 3, 2, 1, 'https://example.com/room2.jpg', 0),
('Suite Room', N'Luxury suite with balcony', 1500000.00, 4, 2, 2, 'https://example.com/room3.jpg', 0),
('Family Room', N'Large room for families', 1200000.00, 4, 3, 3, 'https://example.com/room4.jpg', 0),
('Single Room', N'Compact room for solo travelers', 400000.00, 1, 0, 4, 'https://example.com/room5.jpg', 0);

-- 4. Room
INSERT INTO Room (room_number, branch_id, room_type_id, status, image_url, is_deleted) VALUES
('101', 1, 1, 'Available', 'https://example.com/room101.jpg', 0),
('102', 1, 1, 'Booked', 'https://example.com/room102.jpg', 0),
('201', 1, 2, 'Available', 'https://example.com/room201.jpg', 0),
('301', 2, 3, 'Occupied', 'https://example.com/room301.jpg', 0),
('401', 3, 4, 'Maintenance', 'https://example.com/room401.jpg', 0);

-- 5. Amenity
INSERT INTO Amenity (name, description, is_deleted) VALUES
(N'Wi-Fi', N'High-speed internet access', 0),
(N'Mini Bar', N'Assorted drinks and snacks', 0),
(N'Air Conditioning', N'Climate control system', 0),
(N'TV', N'Flat-screen television', 0),
(N'Safe Box', N'In-room safe for valuables', 0);

-- 6. RoomAmenity
INSERT INTO RoomAmenity (room_id, amenity_id) VALUES
(1, 1),
(1, 3),
(2, 1),
(3, 2),
(4, 4);

-- 7. Service
INSERT INTO Service (name, description, price, branch_id, status, image_url, is_deleted) VALUES
('Breakfast Buffet', N'Variety of local and international dishes', 150000.00, 1, 'Active', 'https://example.com/service1.jpg', 0),
('Spa Treatment', N'Relaxing massage session', 500000.00, 1, 'Active', 'https://example.com/service2.jpg', 0),
('Airport Transfer', N'Private car to/from airport', 300000.00, 2, 'Active', 'https://example.com/service3.jpg', 0),
('Laundry Service', N'Dry cleaning and ironing', 100000.00, 3, 'Active', 'https://example.com/service4.jpg', 0),
('Room Service', N'24/7 in-room dining', 200000.00, 4, 'Active', 'https://example.com/service5.jpg', 0);

-- 8. Voucher
INSERT INTO Voucher (code, description, discount_percent, discount_amount, min_price, total_quantity, used_quantity, branch_id, valid_from, valid_to, status, is_deleted) VALUES
('SUMMER25', N'Summer discount 25%', 25, NULL, 500000.00, 100, 10, 1, '2025-06-01', '2025-08-31', 'Active', 0),
('WELCOME10', N'Welcome discount 10%', 10, NULL, 300000.00, 50, 5, 2, '2025-06-01', '2025-12-31', 'Active', 0),
('VIP50', N'VIP discount 50k', NULL, 50000.00, 1000000.00, 20, 2, 3, '2025-07-01', '2025-09-30', 'Active', 0),
('FESTIVE20', N'Festive season 20%', 20, NULL, 600000.00, 30, 3, 4, '2025-12-01', '2026-01-15', 'Active', 0),
('LOYALTY15', N'Loyalty discount 15%', 15, NULL, 400000.00, 40, 4, 5, '2025-06-15', '2025-11-30', 'Active', 0);

-- 9. SeasonalPromotion
INSERT INTO SeasonalPromotion (name, description, discount_percent, discount_amount, start_date, end_date, branch_id, room_type_id, status, is_deleted) VALUES
(N'Summer Sale', N'20% off for summer bookings', 20.00, NULL, '2025-06-01', '2025-08-31', 1, 1, 'Active', 0),
(N'Winter Promo', N'100k off for winter', NULL, 100000.00, '2025-12-01', '2026-02-28', 2, 3, 'Active', 0),
(N'Spring Deal', N'15% off for spring', 15.00, NULL, '2025-03-01', '2025-05-31', 3, 4, 'Active', 0),
(N'Autumn Offer', N'10% off for autumn', 10.00, NULL, '2025-09-01', '2025-11-30', 4, 5, 'Active', 0),
(N'New Year Promo', N'50k off for New Year', NULL, 50000.00, '2025-12-15', '2026-01-15', 5, 2, 'Active', 0);

-- 10. Booking
INSERT INTO Booking (user_id, booking_time, check_in, check_out, status, total_price, refund_amount, payment_status, cancel_reason, cancel_time, promotion_id, branch_id, is_deleted) VALUES
('U001', GETDATE(), '2025-06-22 14:00:00', '2025-06-24 12:00:00', 'Pending', 1000000.00, NULL, 'Unpaid', NULL, NULL, NULL, 1, 0),
('U001', GETDATE(), '2025-06-25 14:00:00', '2025-06-27 12:00:00', 'Paid', 1600000.00, NULL, 'Paid', NULL, NULL, NULL, 1, 0),
('U002', GETDATE(), '2025-07-01 14:00:00', '2025-07-03 12:00:00', 'Cancelled', 800000.00, 400000.00, 'Paid', N'Customer request', GETDATE(), NULL, 2, 0),
('U001', GETDATE(), '2025-07-05 14:00:00', '2025-07-07 12:00:00', 'CheckedIn', 1200000.00, NULL, 'Paid', NULL, NULL, NULL, 3, 0),
('U005', GETDATE(), '2025-07-10 14:00:00', '2025-07-12 12:00:00', 'Pending', 400000.00, NULL, 'Unpaid', NULL, NULL, NULL, 4, 0);

-- 11. BookingRoom
INSERT INTO BookingRoom (booking_id, room_id, price) VALUES
(1, 1, 500000.00),
(2, 2, 500000.00),
(3, 3, 800000.00),
(4, 4, 1500000.00),
(5, 5, 400000.00);

-- 12. BookingService
INSERT INTO BookingService (booking_id, service_id, quantity, paid_status) VALUES
(1, 1, 2, 'Paid'),
(2, 2, 1, 'Unpaid'),
(3, 3, 1, 'Paid'),
(4, 4, 2, 'Paid'),
(5, 5, 1, 'Unpaid');

-- 13. BookingVoucher
INSERT INTO BookingVoucher (booking_id, voucher_id, used_at) VALUES
(1, 1, GETDATE()),
(2, 2, GETDATE()),
(3, 3, GETDATE()),
(4, 4, GETDATE()),
(5, 5, GETDATE());

-- 14. Feedback
INSERT INTO Feedback (user_id, booking_id, rating, comment, image_url, created_at, status, admin_action, is_deleted) VALUES
('U001', 1, 4, N'Great stay, friendly staff!', 'https://example.com/feedback1.jpg', GETDATE(), 'Visible', 'None', 0),
('U001', 2, 5, N'Amazing experience!', 'https://example.com/feedback2.jpg', GETDATE(), 'Visible', 'None', 0),
('U002', 3, 3, N'Room was clean but small.', 'https://example.com/feedback3.jpg', GETDATE(), 'Visible', 'None', 0),
('U001', 4, 4, N'Good service, will return.', 'https://example.com/feedback4.jpg', GETDATE(), 'Visible', 'None', 0),
('U005', 5, 2, N'Expected better amenities.', 'https://example.com/feedback5.jpg', GETDATE(), 'Visible', 'Warned', 0);

-- 15. VNPayPayment
INSERT INTO VNPayPayment (booking_id, amount, status, paid_at) VALUES
(1, 1000000.00, 'Pending', GETDATE()),
(2, 1600000.00, 'Completed', GETDATE()),
(3, 800000.00, 'Refunded', GETDATE()),
(4, 1200000.00, 'Completed', GETDATE()),
(5, 400000.00, 'Pending', GETDATE());

-- 16. VNPayTransaction
INSERT INTO VNPayTransaction (payment_id, vnp_TxnRef, vnp_TransactionNo, vnp_ResponseCode, vnp_Amount, vnp_BankCode, vnp_CardType, vnp_SecureHash, is_refunded, created_at) VALUES
(1, 'TXN001', '123456', '00', 1000000.00, 'NCB', 'VISA', 'hash1', 0, GETDATE()),
(2, 'TXN002', '123457', '00', 1600000.00, 'VCB', 'MASTER', 'hash2', 0, GETDATE()),
(3, 'TXN003', '123458', '24', 800000.00, 'TPB', 'VISA', 'hash3', 1, GETDATE()),
(4, 'TXN004', '123459', '00', 1200000.00, 'MBB', 'MASTER', 'hash4', 0, GETDATE()),
(5, 'TXN005', '123460', '00', 400000.00, 'ACB', 'VISA', 'hash5', 0, GETDATE());

-- 17. Invoice
INSERT INTO Invoice (booking_id, total_amount, issued_at, pdf_url, image_url) VALUES
(1, 1000000.00, GETDATE(), 'https://example.com/invoice1.pdf', 'https://example.com/invoice1.jpg'),
(2, 1600000.00, GETDATE(), 'https://example.com/invoice2.pdf', 'https://example.com/invoice2.jpg'),
(3, 800000.00, GETDATE(), 'https://example.com/invoice3.pdf', 'https://example.com/invoice3.jpg'),
(4, 1200000.00, GETDATE(), 'https://example.com/invoice4.pdf', 'https://example.com/invoice4.jpg'),
(5, 400000.00, GETDATE(), 'https://example.com/invoice5.pdf', 'https://example.com/invoice5.jpg');

-- 18. Expense
INSERT INTO Expense (branch_id, expense_type, amount, description, expense_date, created_by) VALUES
(1, 'Utilities', 5000000.00, N'Electricity bill for June', GETDATE(), 'U003'),
(1, 'Maintenance', 2000000.00, N'Room repair costs', GETDATE(), 'U003'),
(2, 'Supplies', 3000000.00, N'Cleaning supplies', GETDATE(), 'U004'),
(3, 'Marketing', 4000000.00, N'Online advertising', GETDATE(), 'U004'),
(4, 'Staff Salary', 10000000.00, N'Monthly payroll', GETDATE(), 'U004');

-- 19. LoyaltyPoint
INSERT INTO LoyaltyPoint (user_id, points, level, last_updated, expired_at) VALUES
('U001', 500, 'Silver', GETDATE(), '2026-06-21'),
('U002', 200, 'Member', GETDATE(), '2026-06-21'),
('U003', 1000, 'Gold', GETDATE(), '2026-06-21'),
('U004', 1500, 'VIP', GETDATE(), '2026-06-21'),
('U005', 100, 'Member', GETDATE(), '2026-06-21');

-- 20. PointTransaction
INSERT INTO PointTransaction (user_id, change_type, points_changed, reason, created_at) VALUES
('U001', 'Earn', 100, N'Booking completed', GETDATE()),
('U001', 'Redeem', -50, N'Voucher redemption', GETDATE()),
('U002', 'Earn', 200, N'First booking bonus', GETDATE()),
('U003', 'Adjustment', 300, N'Admin adjustment', GETDATE()),
('U004', 'Earn', 500, N'VIP booking bonus', GETDATE());

-- 21. PointRedeemVoucher
INSERT INTO PointRedeemVoucher (user_id, voucher_id, points_used, redeemed_at, expired_at) VALUES
('U001', 1, 50, GETDATE(), '2025-12-31'),
('U001', 2, 30, GETDATE(), '2025-12-31'),
('U002', 3, 20, GETDATE(), '2025-12-31'),
('U003', 4, 40, GETDATE(), '2025-12-31'),
('U004', 5, 25, GETDATE(), '2025-12-31');

-- 22. ChatAIHistory
INSERT INTO ChatAIHistory (user_id, message, created_at, violation) VALUES
('U001', N'Can you recommend a room?', GETDATE(), NULL),
('U001', N'What are the hotel amenities?', GETDATE(), NULL),
('U002', N'How to cancel a booking?', GETDATE(), NULL),
('U003', N'Check room availability', GETDATE(), NULL),
('U005', N'Why is my booking locked?', GETDATE(), 'Warned');

-- 23. MemberTierHistory
INSERT INTO MemberTierHistory (user_id, old_level, new_level, changed_at, reason) VALUES
('U001', 'Member', 'Silver', GETDATE(), N'Reached 500 points'),
('U002', 'Member', 'Member', GETDATE(), N'Initial registration'),
('U003', 'Silver', 'Gold', GETDATE(), N'Reached 1000 points'),
('U004', 'Gold', 'VIP', GETDATE(), N'Reached 1500 points'),
('U005', 'Member', 'Member', GETDATE(), N'Initial registration');

-- 24. BackupHistory
INSERT INTO BackupHistory (backup_time, backup_type, backup_path, file_size_mb, is_deleted) VALUES
(GETDATE(), 'FULL', 'D:\Backup\full_20250621.bak', 500.5, 0),
(GETDATE(), 'PARTIAL', 'D:\Backup\partial_20250621.bak', 200.3, 0),
(GETDATE(), 'FULL', 'D:\Backup\full_20250620.bak', 480.7, 0),
(GETDATE(), 'PARTIAL', 'D:\Backup\partial_20250620.bak', 190.2, 0),
(GETDATE(), 'FULL', 'D:\Backup\full_20250619.bak', 510.0, 0);

-- 25. Permission
INSERT INTO Permission (role, resource, action, allowed) VALUES
('Admin', 'UserAccount', 'Create', 1),
('Manager', 'Booking', 'Update', 1),
('Staff', 'Room', 'Read', 1),
('Customer', 'Booking', 'Create', 1),
('HotelOwner', 'HotelBranch', 'Update', 1);

-- 26. Notification
INSERT INTO Notification (user_id, title, message, type, status, created_at, read_at, related_booking_id, related_point_transaction_id, related_member_tier_history_id) VALUES
('U001', 'Booking Confirmed', N'Your booking #1 is confirmed.', 'Booking', 'Unread', GETDATE(), NULL, 1, NULL, NULL),
('U001', 'Points Earned', N'You earned 100 points!', 'LoyaltyPoint', 'Read', GETDATE(), GETDATE(), NULL, 1, NULL),
('U002', 'Tier Upgrade', N'Congratulations! You are now Silver.', 'TierUpgrade', 'Unread', GETDATE(), NULL, NULL, NULL, 1),
('U003', 'Payment Success', N'Payment for booking #4 completed.', 'Payment', 'Read', GETDATE(), GETDATE(), 4, NULL, NULL),
('U005', 'Booking Cancelled', N'Your booking #3 was cancelled.', 'Booking', 'Unread', GETDATE(), NULL, 3, NULL, NULL);

-- 27. CartRoomType
INSERT INTO CartRoomType (user_id, room_type_id, quantity, added_at) VALUES
('U001', 1, 2, GETDATE()),
('U001', 2, 1, GETDATE()),
('U002', 3, 1, GETDATE()),
('U003', 4, 2, GETDATE()),
('U005', 5, 1, GETDATE());
GO