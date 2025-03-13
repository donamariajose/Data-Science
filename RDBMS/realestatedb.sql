-- Creating Database
CREATE DATABASE RealEstateDB;
USE RealEstateDB;

-- Creating all the necessary tables in the RealEstateDB database
CREATE TABLE UserRole (
    RoleID INT AUTO_INCREMENT PRIMARY KEY,
    RoleName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE User (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    RoleID INT,
    FOREIGN KEY (RoleID) REFERENCES UserRole(RoleID)
);

CREATE TABLE Agent (
    AgentID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    CommissionRate DECIMAL(5,2) NOT NULL
);

CREATE TABLE PropertyType (
    PropertyTypeID INT AUTO_INCREMENT PRIMARY KEY,
    TypeName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Property (
    PropertyID INT AUTO_INCREMENT PRIMARY KEY,
    Address VARCHAR(255) NOT NULL,
    TypeID INT,
    Size DECIMAL(6,2) NOT NULL,
    Price DECIMAL(12,2) NOT NULL,
    Status VARCHAR(50) NOT NULL,
    ListedDate DATETIME NOT NULL,
    AgentID INT,
    FOREIGN KEY (AgentID) REFERENCES Agent(AgentID),
    FOREIGN KEY (TypeID) REFERENCES PropertyType(PropertyTypeID)
);

CREATE TABLE ClientType (
    ClientTypeID INT AUTO_INCREMENT PRIMARY KEY,
    TypeName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Client (
    ClientID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PreferredLocation VARCHAR(100),
    Budget DECIMAL(12,2) NOT NULL,
    ClientTypeID INT,
    FOREIGN KEY (ClientTypeID) REFERENCES ClientType(ClientTypeID)
);

CREATE TABLE TransactionType (
    TransactionTypeID INT AUTO_INCREMENT PRIMARY KEY,
    TypeName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Transaction (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    PropertyID INT,
    ClientID INT,
    AgentID INT,
    TransactionDate DATETIME NOT NULL,
    TransactionTypeID INT,
    TransactionAmount DECIMAL(12,2) NOT NULL,
    PaymentStatus VARCHAR(50) NOT NULL,
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID),
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID),
    FOREIGN KEY (AgentID) REFERENCES Agent(AgentID),
    FOREIGN KEY (TransactionTypeID) REFERENCES TransactionType(TransactionTypeID)
);

CREATE TABLE PaymentMethod (
    PaymentMethodID INT AUTO_INCREMENT PRIMARY KEY,
    MethodName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Payment (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    TransactionID INT,
    PaymentDate DATETIME NOT NULL,
    Amount DECIMAL(12,2) NOT NULL,
    PaymentMethodID INT,
    FOREIGN KEY (TransactionID) REFERENCES Transaction(TransactionID),
    FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethod(PaymentMethodID)
);

CREATE TABLE ClientPreferences (
    PreferenceID INT AUTO_INCREMENT PRIMARY KEY,
    ClientID INT,
    PropertyTypeID INT,
    PreferredSizeMin DECIMAL(6,2),
    PreferredSizeMax DECIMAL(6,2),
    PreferredPriceMin DECIMAL(12,2),
    PreferredPriceMax DECIMAL(12,2),
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID),
    FOREIGN KEY (PropertyTypeID) REFERENCES PropertyType(PropertyTypeID)
);

CREATE TABLE MaintenanceRequest (
    RequestID INT AUTO_INCREMENT PRIMARY KEY,
    PropertyID INT,
    ClientID INT,
    Description TEXT NOT NULL,
    Status VARCHAR(50) NOT NULL,
    RequestDate DATETIME NOT NULL,
    CompletionDate DATETIME,
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID),
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID)
);

CREATE TABLE ServiceProvider (
    ProviderID INT AUTO_INCREMENT PRIMARY KEY,
    CompanyName VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Specialization VARCHAR(100) NOT NULL
);

CREATE TABLE MaintenanceAssignment (
    AssignmentID INT AUTO_INCREMENT PRIMARY KEY,
    RequestID INT,
    ProviderID INT,
    AssignmentDate DATETIME NOT NULL,
    Status VARCHAR(50) NOT NULL,
    FOREIGN KEY (RequestID) REFERENCES MaintenanceRequest(RequestID),
    FOREIGN KEY (ProviderID) REFERENCES ServiceProvider(ProviderID)
);

CREATE TABLE AgentPerformance (
    PerformanceID INT AUTO_INCREMENT PRIMARY KEY,
    AgentID INT,
    Year YEAR NOT NULL,
    TotalTransactions INT NOT NULL,
    RevenueGenerated DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (AgentID) REFERENCES Agent(AgentID)
);

CREATE TABLE AgentRating (
    RatingID INT AUTO_INCREMENT PRIMARY KEY,
    AgentID INT,
    ClientID INT,
    Rating DECIMAL(3,2) NOT NULL,
    Comments TEXT,
    RatingDate DATETIME NOT NULL,
    FOREIGN KEY (AgentID) REFERENCES Agent(AgentID),
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID)
);

CREATE TABLE MonthlyReport (
    ReportID INT AUTO_INCREMENT PRIMARY KEY,
    Month INT NOT NULL,
    Year YEAR NOT NULL,
    TotalRevenue DECIMAL(12,2) NOT NULL,
    TotalTransactions INT NOT NULL,
    AgentID INT,
    FOREIGN KEY (AgentID) REFERENCES Agent(AgentID)
);

CREATE TABLE YearlyReport (
    ReportID INT AUTO_INCREMENT PRIMARY KEY,
    Year YEAR NOT NULL,
    TotalRevenue DECIMAL(12,2) NOT NULL,
    TotalTransactions INT NOT NULL,
    TopAgentID INT,
    FOREIGN KEY (TopAgentID) REFERENCES Agent(AgentID)
);

CREATE TABLE UserLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    Action TEXT NOT NULL,
    ActionDate DATETIME NOT NULL,
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

CREATE TABLE PropertyFeature (
    FeatureID INT AUTO_INCREMENT PRIMARY KEY,
    PropertyID INT,
    FeatureType VARCHAR(100) NOT NULL,
    FeatureValue VARCHAR(50) NOT NULL,
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID)
);

CREATE TABLE PropertyImages (
    ImageID INT AUTO_INCREMENT PRIMARY KEY,
    PropertyID INT,
    ImageURL VARCHAR(255) NOT NULL,
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID)
);

CREATE TABLE PageViews (
    PageViewID INT AUTO_INCREMENT PRIMARY KEY,
    PropertyID INT,
    ClientID INT,
    DateViewed DATETIME NOT NULL,
    Referrer VARCHAR(255),
    DeviceType VARCHAR(50),
    UserIP VARCHAR(50),
    SessionID VARCHAR(100),
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID),
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID)
);

CREATE TABLE UserSessions (
    SessionID VARCHAR(100) PRIMARY KEY,
    ClientID INT,
    StartTime DATETIME NOT NULL,
    EndTime DATETIME,
    DeviceType VARCHAR(50),
    BrowserType VARCHAR(50),
    OperatingSystem VARCHAR(50),
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID)
);

CREATE TABLE EventTracking (
    EventID INT AUTO_INCREMENT PRIMARY KEY,
    SessionID VARCHAR(100),
    EventCategory VARCHAR(100) NOT NULL,
    EventAction VARCHAR(100) NOT NULL,
    EventLabel VARCHAR(100),
    EventTime DATETIME NOT NULL,
    FOREIGN KEY (SessionID) REFERENCES UserSessions(SessionID)
);

CREATE TABLE ConversionTracking (
    ConversionID INT AUTO_INCREMENT PRIMARY KEY,
    SessionID VARCHAR(100),
    ConversionType VARCHAR(100) NOT NULL,
    ConversionValue DECIMAL(12,2),
    ConversionDate DATETIME NOT NULL,
    FOREIGN KEY (SessionID) REFERENCES UserSessions(SessionID)
);

CREATE TABLE TrafficSources (
    SourceID INT AUTO_INCREMENT PRIMARY KEY,
    SessionID VARCHAR(100),
    Source VARCHAR(100) NOT NULL,
    Medium VARCHAR(100),
    Campaign VARCHAR(100),
    LandingPage VARCHAR(255),
    FOREIGN KEY (SessionID) REFERENCES UserSessions(SessionID)
);

CREATE TABLE PropertySearchMetrics (
    SearchID INT AUTO_INCREMENT PRIMARY KEY,
    ClientID INT,
    SessionID VARCHAR(100),
    SearchQuery TEXT NOT NULL,
    SearchTime DATETIME NOT NULL,
    ResultsReturned INT NOT NULL,
    ClickedPropertyID INT,
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID),
    FOREIGN KEY (SessionID) REFERENCES UserSessions(SessionID)
);

CREATE TABLE ViewingAppointment (
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
    PropertyID INT,
    ClientID INT,
    AgentID INT,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID),
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID),
    FOREIGN KEY (AgentID) REFERENCES Agent(AgentID)
);

CREATE TABLE PropertyViewingHistory (
    HistoryID INT AUTO_INCREMENT PRIMARY KEY,
    PropertyID INT,
    ClientID INT,
    ViewingDate DATE NOT NULL,
    ViewingTime TIME NOT NULL,
    Feedback TEXT,
    Rating DECIMAL(3,2),
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID),
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID)
);

-- Inserting values into each table
INSERT INTO UserRole (RoleName) VALUES 
('admin'), 
('agent'), 
('client');

INSERT INTO User (Username, Password, RoleID) 
VALUES 
('john_smith', 'hashed_password', 1),
('linda_carter', 'hashed_password', 2),
('daniel_lee', 'hashed_password', 2),
('emily_wilson', 'hashed_password', 3),
('michael_jones', 'hashed_password', 3),
('sarah_taylor', 'hashed_password', 2),
('kevin_martin', 'hashed_password', 3),
('lucas_brown', 'hashed_password', 2),
('amanda_davis', 'hashed_password', 3),
('chloe_evans', 'hashed_password', 3);

INSERT INTO Agent (FirstName, LastName, PhoneNumber, Email, CommissionRate) 
VALUES 
('Linda', 'Carter', '+12135550987', 'linda.carter@remax.com', 5.50),
('Daniel', 'Lee', '+12135559876', 'daniel.lee@cityrealty.com', 4.75),
('Sarah', 'Taylor', '+13105550765', 'sarah.taylor@homefinders.com', 6.00),
('Lucas', 'Brown', '+14155552345', 'lucas.brown@elitebrokers.com', 4.95),
('Rebecca', 'Moore', '+15155552345', 'rebecca.moore@bluehomes.com', 5.20),
('Chris', 'Johnson', '+16175552345', 'chris.johnson@sunnyrealty.com', 5.10),
('Jessica', 'Roberts', '+17185551234', 'jessica.roberts@cityestate.com', 4.85),
('Anthony', 'Miller', '+18195552345', 'anthony.miller@luxuryrealty.com', 5.30),
('Olivia', 'Scott', '+19175552345', 'olivia.scott@downtownrealty.com', 5.45),
('David', 'Harris', '+11234567890', 'david.harris@primebrokers.com', 4.60);

INSERT INTO PropertyType (TypeName) 
VALUES 
('Apartment'), 
('House'), 
('Condo'), 
('Townhouse'), 
('Villa'), 
('Penthouse'), 
('Duplex'), 
('Studio'), 
('Loft'), 
('Cottage');

INSERT INTO Property (Address, TypeID, Size, Price, Status, ListedDate, AgentID) 
VALUES 
('123 Main St, Brooklyn, NY', 1, 850.50, 850000.00, 'available', '2023-09-10 00:00:00', 1),
('45 Ocean Ave, Miami, FL', 3, 1200.00, 1200000.00, 'sold', '2023-08-12 00:00:00', 2),
('78 Sunset Blvd, Los Angeles, CA', 2, 1500.00, 2400000.00, 'available', '2023-10-01 00:00:00', 3),
('101 Lakeside Dr, Austin, TX', 4, 1000.00, 980000.00, 'available', '2023-09-15 00:00:00', 4),
('56 Beacon St, Boston, MA', 1, 900.00, 750000.00, 'rented', '2023-07-20 00:00:00', 5),
('67 West End Ave, New York, NY', 6, 2300.00, 4500000.00, 'available', '2023-10-05 00:00:00', 6),
('202 Hilltop Rd, San Francisco, CA', 5, 3200.00, 6800000.00, 'sold', '2023-08-05 00:00:00', 7),
('15 Bay St, Seattle, WA', 8, 1300.00, 1250000.00, 'available', '2023-09-20 00:00:00', 8),
('400 Elm St, Chicago, IL', 7, 1700.00, 1500000.00, 'available', '2023-09-25 00:00:00', 9),
('230 Maple Ln, Dallas, TX', 10, 950.00, 750000.00, 'rented', '2023-07-30 00:00:00', 10);

INSERT INTO ClientType (TypeName) VALUES 
('Buyer'), 
('Seller'), 
('Tenant'), 
('Landlord');

INSERT INTO Client (FirstName, LastName, PhoneNumber, Email, PreferredLocation, Budget, ClientTypeID) 
VALUES 
('Emily', 'Wilson', '+19175556789', 'emily.wilson@gmail.com', 'Brooklyn, NY', 1200000.00, 1),  -- Buyer
('Michael', 'Jones', '+19255550987', 'michael.jones@hotmail.com', 'Manhattan, NY', 2500000.00, 1), -- Buyer
('Kevin', 'Martin', '+18195550976', 'kevin.martin@gmail.com', 'Queens, NY', 800000.00, 2),  -- Seller
('Amanda', 'Davis', '+17175556765', 'amanda.davis@yahoo.com', 'Los Angeles, CA', 1600000.00, 1), -- Buyer
('Chloe', 'Evans', '+15155552345', 'chloe.evans@outlook.com', 'Chicago, IL', 950000.00, 3),  -- Tenant
('Sophia', 'Brooks', '+14155550976', 'sophia.brooks@gmail.com', 'Miami, FL', 1100000.00, 1), -- Buyer
('Jack', 'Moore', '+13155552345', 'jack.moore@ymail.com', 'San Francisco, CA', 3000000.00, 2), -- Seller
('Charlotte', 'Taylor', '+12155552345', 'charlotte.taylor@gmail.com', 'Austin, TX', 750000.00, 4), -- Landlord
('Benjamin', 'Thomas', '+11155552345', 'ben.thomas@hotmail.com', 'Seattle, WA', 1350000.00, 1), -- Buyer
('Ella', 'Brown', '+15155552346', 'ella.brown@live.com', 'Dallas, TX', 950000.00, 3); -- Tenant


INSERT INTO TransactionType (TypeName) 
VALUES 
('sale'), 
('rent');

INSERT INTO Transaction (PropertyID, ClientID, AgentID, TransactionDate, TransactionTypeID, TransactionAmount, PaymentStatus) 
VALUES 
(2, 6, 2, '2023-09-18 00:00:00', 1, 1200000.00, 'completed'),
(5, 1, 5, '2023-08-30 00:00:00', 2, 750000.00, 'completed'),
(3, 4, 3, '2023-10-10 00:00:00', 1, 2400000.00, 'pending'),
(7, 9, 7, '2023-09-02 00:00:00', 1, 6800000.00, 'completed'),
(10, 2, 10, '2023-08-15 00:00:00', 2, 750000.00, 'completed');

INSERT INTO PaymentMethod (MethodName) 
VALUES 
('cash'), 
('card'), 
('bank transfer');

INSERT INTO Payment (TransactionID, PaymentDate, Amount, PaymentMethodID) 
VALUES 
(1, '2023-09-18 00:00:00', 1200000.00, 3),
(2, '2023-08-30 00:00:00', 750000.00, 1),
(3, '2023-10-11 00:00:00', 2400000.00, 2),
(4, '2023-09-03 00:00:00', 6800000.00, 3),
(5, '2023-08-16 00:00:00', 750000.00, 1);

INSERT INTO ClientPreferences (ClientID, PropertyTypeID, PreferredSizeMin, PreferredSizeMax, PreferredPriceMin, PreferredPriceMax) 
VALUES 
(1, 1, 800.00, 1000.00, 700000.00, 900000.00),
(2, 2, 1200.00, 1600.00, 1500000.00, 2500000.00),
(3, 3, 900.00, 1200.00, 500000.00, 1000000.00),
(4, 4, 1400.00, 2000.00, 1000000.00, 2000000.00),
(5, 5, 1000.00, 2000.00, 800000.00, 1200000.00),
(6, 6, 1500.00, 2500.00, 2000000.00, 4000000.00),
(7, 7, 1000.00, 1500.00, 800000.00, 2000000.00),
(8, 8,  500.00, 800.00, 300000.00, 800000.00),
(9, 9, 1500.00, 2200.00, 1000000.00, 3000000.00),
(10, 10, 800.00, 1200.00, 600000.00, 1000000.00);

INSERT INTO MaintenanceRequest (PropertyID, ClientID, Description, Status, RequestDate, CompletionDate) 
VALUES 
(5, 1, 'Plumbing issue in bathroom.', 'completed', '2023-09-01 00:00:00', '2023-09-05 00:00:00'),
(6, 2, 'Broken window in the living room.', 'ongoing', '2023-10-10 00:00:00', NULL),
(7, 3, 'Electrical issue in kitchen.', 'completed', '2023-08-15 00:00:00', '2023-08-18 00:00:00'),
(8, 4, 'HVAC system malfunctioning.', 'pending', '2023-10-11 00:00:00', NULL),
(9, 5, 'Leaky roof in the bedroom.', 'completed', '2023-09-12 00:00:00', '2023-09-18 00:00:00');

INSERT INTO ServiceProvider (CompanyName, PhoneNumber, Email, Specialization) 
VALUES 
('RapidFix Plumbing', '+12155553210', 'support@rapidfixplumbing.com', 'Plumbing'),
('BrightSpark Electricians', '+14155553215', 'info@brightspark.com', 'Electrical'),
('HVAC Masters', '+13155553214', 'contact@hvacmasters.com', 'HVAC'),
('RoofGuard Services', '+15155553213', 'info@roofguard.com', 'Roofing'),
('GlassCare Experts', '+16155553212', 'help@glasscare.com', 'Window Repairs');

INSERT INTO MaintenanceAssignment (RequestID, ProviderID, AssignmentDate, Status) 
VALUES 
(1, 1, '2023-09-01 00:00:00', 'completed'),
(2, 5, '2023-10-11 00:00:00', 'in progress'),
(3, 2, '2023-08-16 00:00:00', 'completed'),
(4, 3, '2023-10-12 00:00:00', 'assigned'),
(5, 4, '2023-09-13 00:00:00', 'completed');

INSERT INTO AgentPerformance (AgentID, Year, TotalTransactions, RevenueGenerated) 
VALUES 
(1, 2023, 12, 3200000.00),
(2, 2023, 15, 5400000.00),
(3, 2023, 9, 2900000.00),
(4, 2023, 7, 1800000.00),
(5, 2023, 10, 2600000.00),
(6, 2023, 11, 3500000.00),
(7, 2023, 6, 1500000.00),
(8, 2023, 13, 4700000.00),
(9, 2023, 8, 2200000.00),
(10, 2023, 9, 2600000.00);

INSERT INTO AgentRating (AgentID, ClientID, Rating, Comments, RatingDate) 
VALUES 
(1, 2, 4.80, 'Very professional and helpful.', '2023-09-20 00:00:00'),
(2, 3, 4.50, 'Great communication, helped with everything.', '2023-09-22 00:00:00'),
(3, 1, 4.90, 'Excellent service, highly recommended.', '2023-09-25 00:00:00'),
(4, 4, 4.60, 'Smooth transaction and very responsive.', '2023-10-10 00:00:00'),
(5, 5, 4.70, 'Efficient and friendly agent.', '2023-10-12 00:00:00'),
(6, 6, 4.55, 'Good support but slow response time.', '2023-08-30 00:00:00'),
(7, 7, 4.85, 'Top notch service, very satisfied.', '2023-09-15 00:00:00'),
(8, 8, 4.75, 'Knowledge able and professional agent.', '2023-09-10 00:00:00'),
(9, 9, 4.80, 'Good experience, would recommend.', '2023-09-05 00:00:00'),
(10, 10, 4.65, 'Handled everything smoothly.', '2023-10-01 00:00:00');

INSERT INTO MonthlyReport (Month, Year, TotalRevenue, TotalTransactions, AgentID) 
VALUES 
(9, 2023, 4500000.00, 15, 2),
(8, 2023, 3200000.00, 10, 1),
(7, 2023, 3000000.00, 8, 4),
(10, 2023, 4700000.00, 13, 8),
(6, 2023, 2900000.00, 9, 3);

INSERT INTO YearlyReport (Year, TotalRevenue, TotalTransactions, TopAgentID) 
VALUES 
(2023, 18000000.00, 65, 2);

INSERT INTO UserLog (UserID, Action, ActionDate) 
VALUES 
(1, 'Logged in and created a new agent account.', '2023-09-10 12:15:30'),
(2, 'Logged in and updated property details.', '2023-09-11 09:20:15'),
(3, 'Logged in and added a new property listing.', '2023-09-12 11:25:00'),
(4, 'Logged in and scheduled a viewing appointment.', '2023-09-13 15:40:10'),
(5, 'Logged in and requested maintenance for property.', '2023-09-14 10:50:05');

INSERT INTO PropertyFeature (PropertyID, FeatureType, FeatureValue) 
VALUES 
(1, 'Bedrooms', '3'),
(2, 'Bathrooms', '2'),
(3, 'Parking', '2 car garage'),
(4, 'Garden', 'Yes'),
(5, 'Balcony', 'Yes'),
(6, 'Swimming Pool', 'No'),
(7, 'Furnished', 'Yes'),
(8, 'Security', '24-hour security'),
(9, 'Air Conditioning', 'Central'),
(10, 'Heating', 'Yes');

INSERT INTO PropertyImages (PropertyID, ImageURL) 
VALUES 
(1, 'https://realestate.com/property1/main.jpg'),
(2, 'https://realestate.com/property2/main.jpg'),
(3, 'https://realestate.com/property3/main.jpg'),
(4, 'https://realestate.com/property4/main.jpg'),
(5, 'https://realestate.com/property5/main.jpg'),
(6, 'https://realestate.com/property6/main.jpg'),
(7, 'https://realestate.com/property7/main.jpg'),
(8, 'https://realestate.com/property8/main.jpg'),
(9, 'https://realestate.com/property9/main.jpg'),
(10, 'https://realestate.com/property10/main.jpg');

INSERT INTO PageViews (PropertyID, ClientID, DateViewed, Referrer, DeviceType, UserIP, SessionID) 
VALUES 
(1, 1, '2023-10-01 10:15:00', 'google.com', 'desktop', '192.168.1.1', 'session001'),
(2, 2, '2023-10-01 11:20:00', 'facebook.com', 'mobile', '192.168.1.2', 'session002'),
(3, 3, '2023-10-01 12:25:00', 'instagram.com', 'tablet', '192.168.1.3', 'session003'),
(4, 4, '2023-10-02 14:30:00', 'twitter.com', 'desktop', '192.168.1.4', 'session004'),
(5, 5, '2023-10-02 15:35:00', 'yahoo.com', 'mobile', '192.168.1.5', 'session005'),
(6, 6, '2023-10-02 16:40:00', 'linkedin.com', 'tablet', '192.168.1.6', 'session006'),
(7, 7, '2023-10-03 09:45:00', 'referral.com', 'desktop', '192.168.1.7', 'session007'),
(8, 8, '2023-10-03 10:50:00', 'direct', 'mobile', '192.168. 1.8', 'session008'),
(9, 9, '2023-10-04 11:55:00', 'google.com', 'tablet', '192.168.1.9', 'session009'),
(10, 10, '2023-10-05 12:00:00', 'bing.com', 'desktop', '192.168.1.10', 'session010');

INSERT INTO UserSessions (SessionID, ClientID, StartTime, EndTime, DeviceType, BrowserType, OperatingSystem) 
VALUES 
('session001', 1, '2023-10-01 10:00:00', '2023-10-01 10:30:00', 'desktop', 'Chrome', 'Windows'),
('session002', 2, '2023-10-01 11:15:00', '2023-10-01 11:50:00', 'mobile', 'Safari', 'iOS'),
('session003', 3, '2023-10-01 12:20:00', '2023-10-01 12:45:00', 'tablet', 'Firefox', 'Android'),
('session004', 4, '2023-10-02 14:25:00', '2023-10-02 15:00:00', 'desktop', 'Edge', 'Windows'),
('session005', 5, '2023-10-02 15:30:00', '2023-10-02 16:10:00', 'mobile', 'Chrome', 'Android'),
('session006', 6, '2023-10-02 16:35:00', '2023-10-02 17:05:00', 'tablet', 'Safari', 'iOS'),
('session007', 7, '2023-10-03 09:40:00', '2023-10-03 10:00:00', 'desktop', 'Firefox', 'Windows'),
('session008', 8, '2023-10-03 10:45:00', '2023-10-03 11:10:00', 'mobile', 'Chrome', 'iOS'),
('session009', 9, '2023-10-04 11:50:00', '2023-10-04 12:15:00', 'tablet', 'Edge', 'Android'),
('session010', 10, '2023-10-05 12:00:00', '2023-10-05 12:30:00', 'desktop', 'Chrome', 'Windows');

INSERT INTO EventTracking (SessionID, EventCategory, EventAction, EventLabel, EventTime) 
VALUES 
('session001', 'Property View', 'View Details', 'View 123 Main St', '2023-10-01 10:10:00'),
('session002', 'Property View', 'View Details', 'View 45 Ocean Ave', '2023-10-01 11:25:00'),
('session003', 'Property View', 'View Details', 'View 78 Sunset Blvd', '2023-10-01 12:30:00'),
('session004', 'Appointment Booking', 'Book Viewing', 'Book 101 Lakeside Dr', '2023-10-02 14:40:00'),
('session005', 'Property Inquiry', 'Send Inquiry', 'Inquiry about 56 Beacon St', '2023-10-02 15:45:00'),
('session006', 'Property View', 'View Details', 'View 67 West End Ave', '2023-10-02 16:50:00'),
('session007', 'Property View', 'View Details', 'View 202 Hilltop Rd', '2023-10-03 09:55:00'),
('session008', 'Appointment Booking', 'Book Viewing', 'Book 15 Bay St', '2023-10-03 10:55:00'),
('session009', 'Property Inquiry', 'Send Inquiry', 'Inquiry about 400 Elm St', '2023-10-04 12:10:00'),
('session010', 'Property View', 'View Details', 'View 230 Maple Ln', '2023-10-05 12:05:00');

INSERT INTO ConversionTracking (SessionID, ConversionType, ConversionValue, ConversionDate) 
VALUES 
('session001', 'Appointment Booked', 0, '2023-10-02 14:45:00'),
('session002', 'Inquiry Sent', 0, '2023-10-01 11:30:00'),
('session003', 'Appointment Booked', 0, '2023-10-01 12:35:00'),
('session004', 'Inquiry Sent ', 0, '2023-10-02 15:50:00'),
('session005', 'Property Viewed', 850000.00, '2023-10-02 16:55:00'),
('session006', 'Appointment Booked', 0, '2023-10-02 17:10:00'),
('session007', 'Inquiry Sent', 0, '2023-10-03 10:05:00'),
('session008', 'Appointment Booked', 0, '2023-10-03 11:05:00'),
('session009', 'Inquiry Sent', 0, '2023-10-04 12:15:00'),
('session010', 'Property Viewed', 750000.00, '2023-10-05 12:10:00');

INSERT INTO TrafficSources (SessionID, Source, Medium, Campaign, LandingPage) 
VALUES 
('session001', 'Google', 'Organic', 'Fall Campaign', '/property/123-main-st'),
('session002', 'Facebook', 'Social', 'New Listing', '/property/45-ocean-ave'),
('session003', 'Instagram', 'Social', 'Luxury Homes', '/property/78-sunset-blvd'),
('session004', 'Twitter', 'Social', 'Open House', '/property/101-lakeside-dr'),
('session005', 'Yahoo', 'Referral', 'Apartment Listings', '/property/56-beacon-st'),
('session006', 'LinkedIn', 'Professional', 'Networking', '/property/67-west-end-ave'),
('session007', 'Referral', 'Referral', 'Special Offers', '/property/202-hilltop-rd'),
('session008', 'Direct', 'Direct', 'Fall Specials', '/property/15-bay-st'),
('session009', 'Google', 'Organic', 'Seattle Market', '/property/400-elm-st'),
('session010', 'Bing', 'Organic', 'Luxury Listings', '/property/230-maple-ln');

INSERT INTO PropertySearchMetrics (ClientID, SessionID, SearchQuery, SearchTime, ResultsReturned, ClickedPropertyID) 
VALUES 
(1, 'session001', 'Brooklyn Apartment', '2023-10-01 10:05:00', 5, 1),
(2, 'session002', 'Miami Condo', '2023-10-01 11:10:00', 3, 2),
(3, 'session003', 'Los Angeles House', '2023-10-01 12:15:00', 4, 3),
(4, 'session004', 'Austin Townhouse', '2023-10-02 14:20:00', 6, 4),
(5, 'session005', 'New York Loft', '2023-10-02 15:25:00', 2, 5),
(6, 'session006', 'San Francisco Flat', '2023-10-02 16:30:00', 7, 6),
(7, 'session007', 'Seattle Bungalow', '2023-10-03 09:35:00', 5, 7),
(8, 'session008', 'Chicago Studio', '2023-10-03 10:40:00', 4, 8),
(9, 'session009', 'Houston Apartment', '2023-10-04 11:45:00', 3, 9),
(10, 'session010', 'Philadelphia Rowhouse', '2023-10-05 12:05:00', 6, 10);

INSERT INTO ViewingAppointment (PropertyID, ClientID, AgentID, AppointmentDate, AppointmentTime) 
VALUES 
(1, 1, 1, '2023-10-06', '10:00:00'),
(2, 2, 2, '2023-10-06', '11:00:00'),
(3, 3, 3, '2023-10-06', '12:00:00'),
(4, 4, 4, '2023-10-07', '14:00:00'),
(5, 5, 5, '2023-10-07', '15:00:00'),
(6, 6, 6, '2023-10-07', '16:00:00'),
(7, 7, 7, '2023-10-08', '09:00:00'),
(8, 8, 8, '2023-10-08', '10:00:00'),
(9, 9, 9, '2023-10-09', '11:00:00'),
(10, 10, 10, '2023-10-09', '12:00:00');

INSERT INTO PropertyViewingHistory (ClientID, PropertyID, ViewingDate, ViewingTime, Feedback, Rating) 
VALUES 
(1, 1, '2023-10-06', '10:00:00', 'Loved the open layout.', 5),
(2, 2, '2023-10-06', '11:00:00', 'Great location, but too small.', 3),
(3, 3, '2023-10-06', '12:00:00', 'Beautiful kitchen!', 4),
(4, 4, '2023-10-07', '14:00:00', 'Very spacious.', 5),
(5, 5, '2023-10-07', '15:00:00', 'Nice garden.', 4),
(6, 6, '2023-10-07', '16:00:00', 'Did not like the area.', 2),
(7, 7, '2023-10-08', '09:00:00', 'Perfect for my family.', 5),
(8, 8, '2023-10-08', '10:00:00', 'Too far from public transport.', 3),
(9, 9, '2023-10-09', '11:00:00', 'Good value for the price.', 4),
(10, 10, '2023-10-09', '12:00:00', 'Charming house.', 5);


-- Query to retrieve all properties
SELECT * FROM Property;

-- Query to retrieve properties that are available
SELECT * FROM Property WHERE Status = 'available';

-- Query to get all transactions
SELECT * FROM Transaction;

-- Query to find transactions handled by a specific agent
SELECT * FROM Transaction WHERE AgentID = 5;

-- Query to find all clients
SELECT * FROM Client;

-- Query to find all transactions for a specific client
SELECT * FROM Transaction WHERE ClientID = 9;

-- Query to update the price of a property
UPDATE Property
SET Price = 900000.00
WHERE PropertyID = 1;

-- Query to retrieve all agents
SELECT * FROM Agent;

-- Query to add a new agent
INSERT INTO Agent (FirstName, LastName, PhoneNumber, Email, CommissionRate) 
VALUES ('John', 'Doe', '+12135559888', 'john.doe@example.com', 5.00);

-- Query to update an agent's commission rate
UPDATE Agent
SET CommissionRate = 6.00
WHERE AgentID = 1;

-- Query to update a client's budget
UPDATE Client
SET Budget = 2000000.00
WHERE ClientID = 1;

-- Query to retrieve all transactions along with client and agent details
SELECT 
    t.TransactionID,
    t.TransactionDate,
    t.TransactionAmount,
    c.FirstName AS ClientFirstName,
    c.LastName AS ClientLastName,
    a.FirstName AS AgentFirstName,
    a.LastName AS AgentLastName
FROM 
    Transaction t
INNER JOIN 
    Client c ON t.ClientID = c.ClientID
INNER JOIN 
    Agent a ON t.AgentID = a.AgentID;
    
 -- Query to generate a report of total transactions in September 2023
SELECT COUNT(*) AS TotalTransactions
FROM Transaction
WHERE MONTH(TransactionDate) = 9 AND YEAR(TransactionDate) = 2023; 

-- Query to generate a quarterly report of total revenue
SELECT SUM(TransactionAmount) AS TotalRevenue
FROM Transaction
WHERE QUARTER(TransactionDate) = 3 AND YEAR(TransactionDate) = 2023;

-- Query to generate a yearly report of total transactions for 2023
SELECT COUNT(*) AS TotalTransactions
FROM Transaction
WHERE YEAR(TransactionDate) = 2023;

-- Query to retrieve properties along with their respective agent names
SELECT 
    p.PropertyID,
    p.Address,
    a.FirstName AS AgentFirstName,
    a.LastName AS AgentLastName
FROM 
    Property p
INNER JOIN 
    Agent a ON p.AgentID = a.AgentID;
    
-- Query to retrieve all clients and their transactions (including clients without transactions)    
SELECT 
    c.ClientID,
    c.FirstName,
    c.LastName,
    t.TransactionID,
    t.TransactionAmount
FROM 
    Client c
LEFT JOIN 
    Transaction t ON c.ClientID = t.ClientID;
    
-- Query to retrieve all transactions and their corresponding properties (including transactions without properties)
SELECT 
    t.TransactionID,
    t.TransactionAmount,
    p.Address
FROM 
    Transaction t
RIGHT JOIN 
    Property p ON t.PropertyID = p.PropertyID;
    
-- Query to generate a report of all possible combinations of properties and agents
SELECT 
    p.PropertyID,
    p.Address,
    a.FirstName AS AgentFirstName,
    a.LastName AS AgentLastName
FROM 
    Property p
CROSS JOIN 
    Agent a;
    
-- Query to find clients who have made transactions above their budget
SELECT 
    c.FirstName,
    c.LastName,
    t.TransactionAmount,
    c.Budget
FROM 
    Client c
INNER JOIN 
    Transaction t ON c.ClientID = t.ClientID
WHERE 
    t.TransactionAmount > c.Budget;

-- Query to Find Clients Who Have Spent More Than the Average Transaction Amount    
SELECT 
    c.ClientID,
    c.FirstName,
    c.LastName,
    COALESCE(SUM(t.TransactionAmount), 0) AS TotalSpent
FROM 
    Client c
LEFT JOIN 
    Transaction t ON c.ClientID = t.ClientID
GROUP BY 
    c.ClientID, c.FirstName, c.LastName
HAVING 
    TotalSpent > (SELECT AVG(TransactionAmount) FROM Transaction);
    
-- Query to List Properties Sold by Agents with Above-Average Commission    
SELECT 
    p.PropertyID,
    p.Address,
    a.FirstName AS AgentFirstName,
    a.LastName AS AgentLastName
FROM 
    Property p
JOIN 
    Transaction t ON p.PropertyID = t.PropertyID
JOIN 
    Agent a ON t.AgentID = a.AgentID
WHERE 
    a.CommissionRate > (SELECT AVG(CommissionRate) FROM Agent);
    
-- Trigger to automatically update the property status when a transaction is completed
DELIMITER //
CREATE TRIGGER UpdatePropertyStatusAfterTransaction
AFTER INSERT ON Transaction
FOR EACH ROW
BEGIN
    UPDATE Property
    SET Status = 'sold'
    WHERE PropertyID = NEW.PropertyID;
END;
//
DELIMITER ;

-- Trigger to log changes to the property price
DELIMITER //
CREATE TRIGGER LogPriceChange
AFTER UPDATE ON Property
FOR EACH ROW
BEGIN
    INSERT INTO PriceChangeLog (PropertyID, OldPrice, NewPrice, ChangeDate)
    VALUES (OLD.PropertyID, OLD.Price, NEW.Price, NOW());
END;
//
DELIMITER ;