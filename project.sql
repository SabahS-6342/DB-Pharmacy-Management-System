USE PharmacyMS;

CREATE TABLE Insurance (
    InsuranceID    INT PRIMARY KEY IDENTITY(1,1), 
    CompanyName    VARCHAR(255) NOT NULL, 
    StartDate      DATE NOT NULL, 
    EndDate        DATE NOT NULL, 
    CoInsurance    INT NOT NULL
);

CREATE TABLE Employee (
    ID                INT PRIMARY KEY IDENTITY(1,1), 
    SSN               INT NOT NULL UNIQUE, 
    License           INT UNIQUE, 
    FirstName         VARCHAR(255) NOT NULL, 
    LastName          VARCHAR(255) NOT NULL, 
    StartDate         DATE NOT NULL, 
    EndDate           DATE, 
    Role              VARCHAR(255) NOT NULL, 
    Salary            DECIMAL(10, 2) NOT NULL, 
    PhoneNumber       VARCHAR(10) NOT NULL, 
    DateOfBirth       DATE NOT NULL
);

CREATE TABLE Customer (
    SSN              INT NOT NULL IDENTITY(1,1), 
    FirstName        VARCHAR(255) NOT NULL, 
    LastName         VARCHAR(255) NOT NULL, 
    Phone            VARCHAR(10) NOT NULL UNIQUE, 
    Gender           CHAR(1) NOT NULL, 
    Address          VARCHAR(1000) NOT NULL, 
    DateOfBirth      DATE NOT NULL, 
    InsuranceID      INT NOT NULL UNIQUE, 

    PRIMARY KEY (SSN),
    FOREIGN KEY (InsuranceID) REFERENCES Insurance(InsuranceID)
);

CREATE TABLE Prescription (
    PrescriptionID   INT NOT NULL IDENTITY(1,1), 
    SSN              INT NOT NULL, 
    DoctorID         INT NOT NULL, 
    PrescribedDate   DATE NOT NULL, 
    
    PRIMARY KEY (PrescriptionID),
    FOREIGN KEY (SSN) REFERENCES Customer(SSN)
);

CREATE TABLE Medicine (
    DrugName          VARCHAR(255) NOT NULL, 
    BatchNumber       INT NOT NULL, 
    MedicineType      VARCHAR(255) NOT NULL, 
    Manufacturer      VARCHAR(255) NOT NULL, 
    StockQuantity     INT NOT NULL, 
    ExpiryDate        DATE NOT NULL, 
    Price             DECIMAL(10, 2) NOT NULL, 

    PRIMARY KEY (DrugName, BatchNumber)
);

CREATE TABLE PrescribedDrugs (
    PrescriptionID       INT NOT NULL, 
    DrugName             VARCHAR(255) NOT NULL, 
    PrescribedQuantity   INT NOT NULL, 
    RefillLimit          INT NOT NULL, 
    
    PRIMARY KEY (PrescriptionID, DrugName),
    FOREIGN KEY (PrescriptionID) REFERENCES Prescription(PrescriptionID)
);

CREATE TABLE Orders (
    OrderID          INT NOT NULL IDENTITY(1,1), 
    PrescriptionID   INT NOT NULL, 
    EmployeeID       INT NOT NULL, 
    OrderDate        DATE NOT NULL, 

    PRIMARY KEY (OrderID),
    FOREIGN KEY (PrescriptionID) REFERENCES Prescription(PrescriptionID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(ID)
);

CREATE TABLE OrderedDrugs (
    OrderID            INT NOT NULL, 
    DrugName           VARCHAR(255) NOT NULL, 
    BatchNumber        INT NOT NULL, 
    OrderedQuantity    INT NOT NULL, 
    Price              DECIMAL(10, 2) NOT NULL, 

    PRIMARY KEY (OrderID, DrugName, BatchNumber),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (DrugName, BatchNumber) REFERENCES Medicine(DrugName, BatchNumber)
);

CREATE TABLE Bill (
    OrderID           INT NOT NULL, 
    CustomerSSN       INT NOT NULL, 
    TotalAmount       DECIMAL(10, 2) NOT NULL, 
    CustomerPayment   DECIMAL(10, 2) NOT NULL, 
    InsurancePayment  DECIMAL(10, 2) NOT NULL, 
    
    PRIMARY KEY (OrderID, CustomerSSN),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (CustomerSSN) REFERENCES Customer(SSN)
);

CREATE TABLE DisposedDrugs (
    DrugName       VARCHAR(255) NOT NULL, 
    BatchNumber    INT NOT NULL, 
    Quantity       INT NOT NULL, 
    Company        VARCHAR(255) NOT NULL, 

    PRIMARY KEY (DrugName, BatchNumber)
);

CREATE TABLE Notification (
    ID              INT NOT NULL IDENTITY(1,1), 
    Message         VARCHAR(255) NOT NULL, 
    Type            VARCHAR(255) NOT NULL, 

    PRIMARY KEY (ID)
);

CREATE TABLE Employee_Notification (
    EmployeeID        INT NOT NULL, 
    NotificationID    INT NOT NULL, 
    
    PRIMARY KEY (EmployeeID, NotificationID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(ID),
    FOREIGN KEY (NotificationID) REFERENCES Notification(ID)
);

CREATE TABLE Employee_DisposedDrugs (
    EmployeeID        INT NOT NULL, 
    DrugName          VARCHAR(255) NOT NULL, 
    BatchNumber       INT NOT NULL, 
    DisposalDate      DATE NOT NULL, 
    
    PRIMARY KEY (EmployeeID, DrugName, BatchNumber, DisposalDate),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(ID),
    FOREIGN KEY (DrugName, BatchNumber) REFERENCES DisposedDrugs(DrugName, BatchNumber)
);
