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
