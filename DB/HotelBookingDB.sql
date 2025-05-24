USE master
GO

-- Xóa database nếu đã tồn tại và tạo mới
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'HotelBookingDB')
BEGIN
    ALTER DATABASE HotelBookingDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE HotelBookingDB;
END
GO

CREATE DATABASE HotelBookingDB
GO

USE HotelBookingDB
GO
CREATE TABLE UserAccount (
    id VARCHAR(10) PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    avatar_url VARCHAR(255),
    role VARCHAR(20) CHECK (role IN ('Customer', 'Receptionist', 'Manager', 'Admin', 'HotelOwner')) NOT NULL,
    status VARCHAR(10) CHECK (status IN ('Active', 'Inactive', 'Banned')) DEFAULT 'Active',
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE HotelBranch (
    id INT PRIMARY KEY IDENTITY,
    name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    image_url VARCHAR(255),
    owner_id VARCHAR(10),
    manager_id VARCHAR(10),
    FOREIGN KEY (owner_id) REFERENCES UserAccount(id),
    FOREIGN KEY (manager_id) REFERENCES UserAccount(id)
);

CREATE TABLE RoomType (
    id INT PRIMARY KEY IDENTITY,
    name VARCHAR(100),
    description TEXT,
    base_price DECIMAL(18, 2),
    capacity INT,
    image_url VARCHAR(255)
);

CREATE TABLE Room (
    id INT PRIMARY KEY IDENTITY,
    room_number VARCHAR(20) NOT NULL,
    branch_id INT,
    room_type_id INT,
    status VARCHAR(20) CHECK (status IN ('Available', 'Booked', 'Maintenance', 'Locked')) DEFAULT 'Available',
    image_url VARCHAR(255),
    FOREIGN KEY (branch_id) REFERENCES HotelBranch(id),
    FOREIGN KEY (room_type_id) REFERENCES RoomType(id)
);
CREATE TABLE Voucher (
    id INT PRIMARY KEY IDENTITY,
    code VARCHAR(50) UNIQUE,
    description TEXT,
    discount_percent INT,
    valid_from DATETIME,
    valid_to DATETIME,
    status VARCHAR(10) CHECK (status IN ('Active', 'Inactive', 'Expired')) DEFAULT 'Active'
);

CREATE TABLE Booking (
    id INT PRIMARY KEY IDENTITY,
    user_id VARCHAR(10),
    booking_time DATETIME DEFAULT GETDATE(),
    check_in DATETIME,
    check_out DATETIME,
    status VARCHAR(20) CHECK (status IN ('Pending', 'Confirmed', 'Cancelled', 'CheckedIn', 'CheckedOut', 'Locked')) DEFAULT 'Pending',
    total_price DECIMAL(18, 2),
    deposit DECIMAL(18, 2),
    payment_status VARCHAR(10) CHECK (payment_status IN ('Unpaid', 'Paid', 'Partial')),
    cancel_reason TEXT,
    cancel_time DATETIME,
    promotion_id INT,
    FOREIGN KEY (user_id) REFERENCES UserAccount(id),
    FOREIGN KEY (promotion_id) REFERENCES Voucher(id)
);

CREATE TABLE BookingRoom (
    booking_id INT,
    room_id INT,
    PRIMARY KEY (booking_id, room_id),
    FOREIGN KEY (booking_id) REFERENCES Booking(id),
    FOREIGN KEY (room_id) REFERENCES Room(id)
);

CREATE TABLE Service (
    id INT PRIMARY KEY IDENTITY,
    name VARCHAR(100),
    description TEXT,
    price DECIMAL(18, 2),
    branch_id INT,
    status VARCHAR(10) CHECK (status IN ('Active', 'Inactive')) DEFAULT 'Active',
    image_url VARCHAR(255),
    FOREIGN KEY (branch_id) REFERENCES HotelBranch(id)
);

CREATE TABLE BookingService (
    booking_id INT,
    service_id INT,
    quantity INT DEFAULT 1,
    paid_status VARCHAR(10) CHECK (paid_status IN ('Unpaid', 'Paid')) DEFAULT 'Unpaid',
    PRIMARY KEY (booking_id, service_id),
    FOREIGN KEY (booking_id) REFERENCES Booking(id),
    FOREIGN KEY (service_id) REFERENCES Service(id)
);

CREATE TABLE Feedback (
    id INT PRIMARY KEY IDENTITY,
    user_id VARCHAR(10),
    booking_id INT,
    rating INT,
    comment TEXT,
    image_url TEXT,
    created_at DATETIME DEFAULT GETDATE(),
    status VARCHAR(10) CHECK (status IN ('Visible', 'Hidden', 'Blocked')) DEFAULT 'Visible',
    admin_action VARCHAR(10) CHECK (admin_action IN ('None', 'Warned', 'Deleted', 'Banned')) DEFAULT 'None',
    FOREIGN KEY (user_id) REFERENCES UserAccount(id),
    FOREIGN KEY (booking_id) REFERENCES Booking(id)
);

CREATE TABLE Payment (
    id INT PRIMARY KEY IDENTITY,
    booking_id INT,
    method VARCHAR(20) CHECK (method IN ('VNPay', 'CreditCard', 'Cash')),
    amount DECIMAL(18, 2),
    status VARCHAR(10) CHECK (status IN ('Pending', 'Completed', 'Failed', 'Refunded')) DEFAULT 'Pending',
    paid_at DATETIME,
    FOREIGN KEY (booking_id) REFERENCES Booking(id)
);

CREATE TABLE LoyaltyPoint (
    user_id VARCHAR(10) PRIMARY KEY,
    points INT DEFAULT 0,
    level VARCHAR(10) CHECK (level IN ('Member', 'Silver', 'Gold', 'VIP')) DEFAULT 'Member',
    last_updated DATETIME DEFAULT GETDATE(),
    expired_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES UserAccount(id)
);

CREATE TABLE PointTransaction (
    id INT PRIMARY KEY IDENTITY,
    user_id VARCHAR(10),
    change_type VARCHAR(20) CHECK (change_type IN ('Earn', 'Redeem', 'Adjustment')),
    points_changed INT,
    reason TEXT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES UserAccount(id)
);



CREATE TABLE BookingVoucher (
    booking_id INT,
    voucher_id INT,
    PRIMARY KEY (booking_id, voucher_id),
    FOREIGN KEY (booking_id) REFERENCES Booking(id),
    FOREIGN KEY (voucher_id) REFERENCES Voucher(id)
);

CREATE TABLE ChatAIHistory (
    id INT PRIMARY KEY IDENTITY,
    user_id VARCHAR(10),
    message TEXT,
    created_at DATETIME DEFAULT GETDATE(),
    violation VARCHAR(10) CHECK (violation IN ('None', 'Abuse', 'InfoLeak')) DEFAULT 'None',
    FOREIGN KEY (user_id) REFERENCES UserAccount(id)
);

CREATE TABLE Invoice (
    id INT PRIMARY KEY IDENTITY,
    booking_id INT,
    total_amount DECIMAL(18, 2),
    issued_at DATETIME,
    pdf_url VARCHAR(255),
    image_url VARCHAR(255),
    FOREIGN KEY (booking_id) REFERENCES Booking(id)
);

CREATE TABLE MemberTierHistory (
    id INT PRIMARY KEY IDENTITY,
    user_id VARCHAR(10),
    old_level VARCHAR(10) CHECK (old_level IN ('Member', 'Silver', 'Gold', 'VIP')),
    new_level VARCHAR(10) CHECK (new_level IN ('Member', 'Silver', 'Gold', 'VIP')),
    changed_at DATETIME DEFAULT GETDATE(),
    reason TEXT,
    FOREIGN KEY (user_id) REFERENCES UserAccount(id)
);

CREATE TABLE Permission (
    id INT PRIMARY KEY IDENTITY,
    role VARCHAR(20) CHECK (role IN ('Customer', 'Receptionist', 'Manager', 'Admin', 'HotelOwner')) NOT NULL,
    resource VARCHAR(100) NOT NULL,
    action VARCHAR(10) CHECK (action IN ('Create', 'Read', 'Update', 'Delete')) NOT NULL,
    allowed BIT DEFAULT 1
);

CREATE TABLE Notification (
    id INT PRIMARY KEY IDENTITY,
    user_id VARCHAR(10),
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(20) CHECK (type IN (
        'System', 'Promotion', 'Booking', 'Payment',
        'Feedback', 'Chat', 'LoyaltyPoint', 'TierUpgrade'
    )) DEFAULT 'System',
    status VARCHAR(10) CHECK (status IN ('Unread', 'Read')) DEFAULT 'Unread',
    created_at DATETIME DEFAULT GETDATE(),
    read_at DATETIME,
    related_booking_id INT,
    related_point_transaction_id INT,
    related_member_tier_history_id INT,
    FOREIGN KEY (user_id) REFERENCES UserAccount(id),
    FOREIGN KEY (related_booking_id) REFERENCES Booking(id),
    FOREIGN KEY (related_point_transaction_id) REFERENCES PointTransaction(id),
    FOREIGN KEY (related_member_tier_history_id) REFERENCES MemberTierHistory(id)
);
-- Insert Data
INSERT INTO UserAccount (id, username, password, email, avatar_url, role, status, created_at) VALUES
('U001', 'nguyenvanA', 'hashed_pass1', 'nguyen.vanA@gmail.com', 'https://example.com/avatars/nguyenA.jpg', 'Customer', 'Active', '2025-01-01 10:00:00'),
('U002', 'tranthiB', 'hashed_pass2', 'tran.thiB@gmail.com', NULL, 'Customer', 'Active', '2025-02-01 12:00:00'),
('U003', 'leminhC', 'hashed_pass3', 'le.minhC@hotel.com', 'https://example.com/avatars/leminhC.jpg', 'Receptionist', 'Active', '2025-03-01 09:00:00'),
('U004', 'phamquangD', 'hashed_pass4', 'pham.quangD@hotel.com', NULL, 'Manager', 'Active', '2025-04-01 08:00:00'),
('U005', 'hoangthanhE', 'hashed_pass5', 'hoang.thanhE@hotel.com', 'https://example.com/avatars/hoangE.jpg', 'HotelOwner', 'Active', '2025-05-01 07:00:00');

INSERT INTO HotelBranch (name, address, phone, email, image_url, owner_id, manager_id) VALUES
('Sunset Hotel Hanoi', '123 Tran Hung Dao, Hanoi', '0901234567', 'hanoi@sunset.com', 'https://example.com/hotels/hanoi.jpg', 'U005', 'U004'),
('Sunset Hotel Da Nang', '456 Vo Nguyen Giap, Da Nang', '0902345678', 'danang@sunset.com', 'https://example.com/hotels/danang.jpg', 'U005', 'U004'),
('Sunset Hotel HCMC', '789 Le Loi, Ho Chi Minh City', '0903456789', 'hcmc@sunset.com', 'https://example.com/hotels/hcmc.jpg', 'U005', 'U004'),
('Sunset Hotel Hue', '101 Nguyen Hue, Hue', '0904567890', 'hue@sunset.com', 'https://example.com/hotels/hue.jpg', 'U005', 'U004'),
('Sunset Hotel Nha Trang', '222 Tran Phu, Nha Trang', '0905678901', 'nhatrang@sunset.com', 'https://example.com/hotels/nhatrang.jpg', 'U005', 'U004');

INSERT INTO RoomType (name, description, base_price, capacity, image_url) VALUES
('Standard', 'Cozy room with basic amenities', 500000.00, 2, 'https://example.com/rooms/standard.jpg'),
('Deluxe', 'Spacious room with city view', 800000.00, 3, 'https://example.com/rooms/deluxe.jpg'),
('Suite', 'Luxury suite with premium amenities', 1500000.00, 4, 'https://example.com/rooms/suite.jpg'),
('Family', 'Large room for families', 1200000.00, 5, 'https://example.com/rooms/family.jpg'),
('Executive', 'Room with business facilities', 1000000.00, 3, 'https://example.com/rooms/executive.jpg');

INSERT INTO Room (room_number, branch_id, room_type_id, status, image_url) VALUES
('101', 1, 1, 'Available', 'https://example.com/rooms/101.jpg'),
('202', 2, 2, 'Booked', 'https://example.com/rooms/202.jpg'),
('303', 3, 3, 'Available', 'https://example.com/rooms/303.jpg'),
('404', 4, 4, 'Maintenance', 'https://example.com/rooms/404.jpg'),
('505', 5, 5, 'Available', 'https://example.com/rooms/505.jpg');

INSERT INTO Voucher (code, description, discount_percent, valid_from, valid_to, status) VALUES
('SUMMER25', 'Summer discount 25%', 25, '2025-06-01 00:00:00', '2025-08-31 23:59:59', 'Active'),
('NEWUSER10', 'New user discount 10%', 10, '2025-01-01 00:00:00', '2025-12-31 23:59:59', 'Active'),
('VIP20', 'VIP discount 20%', 20, '2025-05-01 00:00:00', '2025-07-31 23:59:59', 'Active'),
('WINTER15', 'Winter discount 15%', 15, '2024-12-01 00:00:00', '2025-02-28 23:59:59', 'Expired'),
('FESTIVE30', 'Festive season discount 30%', 30, '2025-12-01 00:00:00', '2026-01-15 23:59:59', 'Inactive');

INSERT INTO Booking (user_id, booking_time, check_in, check_out, status, total_price, deposit, payment_status, cancel_reason, cancel_time, promotion_id) VALUES
('U001', '2025-05-01 14:00:00', '2025-06-01 14:00:00', '2025-06-03 12:00:00', 'Confirmed', 1500000.00, 500000.00, 'Paid', NULL, NULL, 1),
('U002', '2025-05-02 15:00:00', '2025-06-05 14:00:00', '2025-06-07 12:00:00', 'Pending', 1600000.00, 0.00, 'Unpaid', NULL, NULL, 2),
('U001', '2025-05-03 16:00:00', '2025-06-10 14:00:00', '2025-06-12 12:00:00', 'Cancelled', 3000000.00, 0.00, 'Unpaid', 'Change of plans', '2025-05-04 10:00:00', NULL),
('U002', '2025-05-04 17:00:00', '2025-06-15 14:00:00', '2025-06-20 12:00:00', 'CheckedIn', 6000000.00, 2000000.00, 'Partial', NULL, NULL, 3),
('U001', '2025-05-05 18:00:00', '2025-06-20 14:00:00', '2025-06-22 12:00:00', 'CheckedOut', 2000000.00, 1000000.00, 'Paid', NULL, NULL, 1);

INSERT INTO BookingRoom (booking_id, room_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 5),
(5, 1);

INSERT INTO Service (name, description, price, branch_id, status, image_url) VALUES
('Breakfast Buffet', 'Daily breakfast buffet', 150000.00, 1, 'Active', 'https://example.com/services/breakfast.jpg'),
('Spa Treatment', 'Relaxing spa session', 500000.00, 2, 'Active', 'https://example.com/services/spa.jpg'),
('Airport Transfer', 'Private airport transfer', 300000.00, 3, 'Active', 'https://example.com/services/transfer.jpg'),
('Laundry Service', 'Express laundry service', 100000.00, 4, 'Active', 'https://example.com/services/laundry.jpg'),
('Room Service', '24/7 room service', 200000.00, 5, 'Inactive', 'https://example.com/services/room_service.jpg');

INSERT INTO BookingService (booking_id, service_id, quantity, paid_status) VALUES
(1, 1, 2, 'Paid'),
(2, 2, 1, 'Unpaid'),
(3, 3, 1, 'Unpaid'),
(4, 4, 3, 'Paid'),
(5, 1, 1, 'Paid');

INSERT INTO Feedback (user_id, booking_id, rating, comment, image_url, created_at, status, admin_action) VALUES
('U001', 1, 5, 'Great stay, very comfortable!', 'https://example.com/feedback/1.jpg', '2025-06-04 10:00:00', 'Visible', 'None'),
('U002', 2, 3, 'Room was clean but service was slow.', NULL, '2025-06-08 12:00:00', 'Visible', 'None'),
('U001', 3, 2, 'Cancelled due to personal reasons.', NULL, '2025-06-13 14:00:00', 'Hidden', 'None'),
('U002', 4, 4, 'Amazing view from the room!', 'https://example.com/feedback/4.jpg', '2025-06-21 16:00:00', 'Visible', 'None'),
('U001', 5, 5, 'Perfect experience, will return!', NULL, '2025-06-23 18:00:00', 'Visible', 'None');

INSERT INTO Payment (booking_id, method, amount, status, paid_at) VALUES
(1, 'VNPay', 1500000.00, 'Completed', '2025-05-01 14:30:00'),
(2, 'CreditCard', 1600000.00, 'Pending', NULL),
(3, 'Cash', 0.00, 'Failed', NULL),
(4, 'VNPay', 2000000.00, 'Completed', '2025-05-04 17:30:00'),
(5, 'CreditCard', 2000000.00, 'Completed', '2025-05-05 18:30:00');

INSERT INTO LoyaltyPoint (user_id, points, level, last_updated, expired_at) VALUES
('U001', 500, 'Silver', '2025-05-20 10:00:00', '2026-05-20 23:59:59'),
('U002', 200, 'Member', '2025-05-15 12:00:00', '2026-05-15 23:59:59'),
('U003', 0, 'Member', '2025-05-01 09:00:00', NULL),
('U004', 0, 'Member', '2025-05-01 08:00:00', NULL),
('U005', 100, 'Member', '2025-05-01 07:00:00', '2026-05-01 23:59:59');

INSERT INTO PointTransaction (user_id, change_type, points_changed, reason, created_at) VALUES
('U001', 'Earn', 200, 'Booking completed', '2025-06-03 12:00:00'),
('U002', 'Earn', 100, 'Booking confirmed', '2025-06-07 14:00:00'),
('U001', 'Redeem', -50, 'Redeemed for discount', '2025-06-10 16:00:00'),
('U002', 'Earn', 100, 'Feedback submitted', '2025-06-21 18:00:00'),
('U001', 'Earn', 350, 'Booking completed', '2025-06-22 20:00:00');

INSERT INTO BookingVoucher (booking_id, voucher_id) VALUES
(1, 1),
(2, 2),
(4, 3),
(5, 1),
(1, 3);

INSERT INTO ChatAIHistory (user_id, message, created_at, violation) VALUES
('U001', 'Can you recommend a room in Hanoi?', '2025-05-01 10:00:00', 'None'),
('U002', 'What are the available services?', '2025-05-02 11:00:00', 'None'),
('U001', 'How to cancel my booking?', '2025-05-03 12:00:00', 'None'),
('U002', 'Please provide spa details.', '2025-05-04 13:00:00', 'None'),
('U001', 'What is the best room type?', '2025-05-05 14:00:00', 'None');

INSERT INTO Invoice (booking_id, total_amount, issued_at, pdf_url, image_url) VALUES
(1, 1500000.00, '2025-06-03 12:00:00', 'https://example.com/invoices/1.pdf', NULL),
(2, 1600000.00, '2025-06-07 14:00:00', 'https://example.com/invoices/2.pdf', NULL),
(3, 0.00, '2025-06-13 14:00:00', 'https://example.com/invoices/3.pdf', NULL),
(4, 6000000.00, '2025-06-20 16:00:00', 'https://example.com/invoices/4.pdf', NULL),
(5, 2000000.00, '2025-06-22 18:00:00', 'https://example.com/invoices/5.pdf', NULL);

INSERT INTO MemberTierHistory (user_id, old_level, new_level, changed_at, reason) VALUES
('U001', 'Member', 'Silver', '2025-05-20 10:00:00', 'Reached 500 points'),
('U002', 'Member', 'Member', '2025-05-15 12:00:00', 'Initial tier assignment'),
('U001', 'Silver', 'Silver', '2025-06-03 12:00:00', 'Points earned'),
('U002', 'Member', 'Member', '2025-06-07 14:00:00', 'Points earned'),
('U001', 'Silver', 'Silver', '2025-06-22 18:00:00', 'Points redeemed');

INSERT INTO Permission (role, resource, action, allowed) VALUES
('Customer', 'Booking', 'Create', 1),
('Receptionist', 'Booking', 'Update', 1),
('Manager', 'Room', 'Update', 1),
('Admin', 'UserAccount', 'Delete', 1),
('HotelOwner', 'HotelBranch', 'Create', 1);

INSERT INTO Notification (user_id, title, message, type, status, created_at, read_at, related_booking_id, related_point_transaction_id, related_member_tier_history_id) VALUES
('U001', 'Booking Confirmed', 'Your booking #1 has been confirmed.', 'Booking', 'Read', '2025-05-01 14:30:00', '2025-05-01 15:00:00', 1, NULL, NULL),
('U002', 'New Voucher Available', 'Use NEWUSER10 for 10% off!', 'Promotion', 'Unread', '2025-05-02 10:00:00', NULL, NULL, NULL, NULL),
('U001', 'Points Earned', 'You earned 200 points for booking #1.', 'LoyaltyPoint', 'Read', '2025-06-03 12:00:00', '2025-06-03 13:00:00', 1, 1, NULL),
('U002', 'Booking Pending', 'Your booking #2 is pending payment.', 'Booking', 'Unread', '2025-06-07 14:00:00', NULL, 2, NULL, NULL),
('U001', 'Tier Upgrade', 'Congratulations! You are now Silver tier.', 'TierUpgrade', 'Read', '2025-05-20 10:00:00', '2025-05-20 11:00:00', NULL, NULL, 1);