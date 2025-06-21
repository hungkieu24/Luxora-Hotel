CREATE TABLE BenefitRank (
    id INT PRIMARY KEY IDENTITY(1,1),
    level VARCHAR(10) CHECK (level IN ('Member', 'Silver', 'Gold', 'VIP')) UNIQUE NOT NULL,
    point_rate DECIMAL(5,2) NOT NULL,
    discount_percent DECIMAL(5,2),    
    benefit NVARCHAR(MAX),            
    is_deleted BIT DEFAULT 0
);

-- Thêm d? li?u m?u cho các rank
INSERT INTO BenefitRank (level, point_rate, discount_percent, benefit, is_deleted) VALUES
('Member', 1.00, 0, N'Basic benefits, standard bonus points accumulation.', 0),
('Silver', 1.20, 3, N'Free water, higher reward points, priority check-in.', 0),
('Gold', 1.30, 5, N'Use VIP lounge, free room upgrade depending on room availability, service incentives.', 0),
('VIP', 1.50, 10, N'Top deals, free services, big discounts, dedicated customer care.', 0);