-- =====================================================
--           TV SHOWS DATABASE PROJECT
-- =====================================================

-- =====================================================
-- CREATE DATABASE
-- =====================================================

CREATE DATABASE IF NOT EXISTS TV_Shows_Database;
USE TV_Shows_Database;

-- =====================================================
-- DROP TABLES (FOR RE-RUNNING PROJECT)
-- =====================================================

DROP TABLE IF EXISTS Acts_In;
DROP TABLE IF EXISTS Available_On;
DROP TABLE IF EXISTS TV_SHOW;
DROP TABLE IF EXISTS Actor;
DROP TABLE IF EXISTS Platform;
DROP TABLE IF EXISTS Genre;
DROP TABLE IF EXISTS Rating_Category;

-- =====================================================
-- CREATE TABLE: Genre
-- =====================================================

CREATE TABLE Genre (
    GenreID INT AUTO_INCREMENT PRIMARY KEY,
    GenreName VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT
);

-- =====================================================
-- CREATE TABLE: Rating_Category
-- =====================================================

CREATE TABLE Rating_Category (
    RatingID INT AUTO_INCREMENT PRIMARY KEY,
    RatingValue VARCHAR(20) NOT NULL UNIQUE,
    Description TEXT
);

-- =====================================================
-- CREATE TABLE: Platform
-- =====================================================

CREATE TABLE Platform (
    PlatformID INT AUTO_INCREMENT PRIMARY KEY,
    PlatformName VARCHAR(100) NOT NULL,
    Type VARCHAR(50)
);

-- =====================================================
-- CREATE TABLE: Actor
-- =====================================================

CREATE TABLE Actor (
    ActorID INT AUTO_INCREMENT PRIMARY KEY,
    ActorName VARCHAR(100) NOT NULL,
    Gender ENUM('Male', 'Female'),
    BirthDate DATE
);

-- =====================================================
-- CREATE TABLE: TV_SHOW
-- =====================================================

CREATE TABLE TV_SHOW (
    ShowID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    ReleaseYear YEAR NOT NULL,
    IMDB_Rating DECIMAL(3,1) CHECK (IMDB_Rating BETWEEN 0 AND 10),
    Netflix BOOLEAN DEFAULT TRUE,
    Description TEXT,
    No_of_Seasons INT CHECK (No_of_Seasons > 0),

    GenreID INT,
    RatingID INT,

    FOREIGN KEY (GenreID)
        REFERENCES Genre(GenreID)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    FOREIGN KEY (RatingID)
        REFERENCES Rating_Category(RatingID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- =====================================================
-- CREATE TABLE: Available_On
-- MANY-TO-MANY RELATIONSHIP
-- =====================================================

CREATE TABLE Available_On (
    ShowID INT,
    PlatformID INT,

    PRIMARY KEY (ShowID, PlatformID),

    FOREIGN KEY (ShowID)
        REFERENCES TV_SHOW(ShowID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (PlatformID)
        REFERENCES Platform(PlatformID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =====================================================
-- CREATE TABLE: Acts_In
-- MANY-TO-MANY RELATIONSHIP
-- =====================================================

CREATE TABLE Acts_In (
    ShowID INT,
    ActorID INT,
    RoleName VARCHAR(100),

    PRIMARY KEY (ShowID, ActorID),

    FOREIGN KEY (ShowID)
        REFERENCES TV_SHOW(ShowID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (ActorID)
        REFERENCES Actor(ActorID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =====================================================
-- INSERT DATA INTO Genre
-- =====================================================

INSERT INTO Genre (GenreName, Description)
VALUES
('Drama', 'Emotionally driven TV shows'),
('Comedy', 'Funny and entertaining shows'),
('Action', 'Adventure and action-based content'),
('Thriller', 'Suspense and mystery shows');

-- =====================================================
-- INSERT DATA INTO Rating_Category
-- =====================================================

INSERT INTO Rating_Category (RatingValue, Description)
VALUES
('18+', 'Adults only'),
('16+', 'Suitable for teenagers'),
('7+', 'Kids and family content');

-- =====================================================
-- INSERT DATA INTO Platform
-- =====================================================

INSERT INTO Platform (PlatformName, Type)
VALUES
('Netflix', 'Streaming'),
('Amazon Prime', 'Streaming'),
('Disney+', 'Streaming');

-- =====================================================
-- INSERT DATA INTO Actor
-- =====================================================

INSERT INTO Actor (ActorName, Gender, BirthDate)
VALUES
('Millie Bobby Brown', 'Female', '2004-02-19'),
('Alvaro Morte', 'Male', '1975-02-23'),
('Pedro Alonso', 'Male', '1971-06-21'),
('Jenna Ortega', 'Female', '2002-09-27');

-- =====================================================
-- INSERT DATA INTO TV_SHOW
-- =====================================================

INSERT INTO TV_SHOW
(Title, ReleaseYear, IMDB_Rating, Netflix,
 Description, No_of_Seasons, GenreID, RatingID)

VALUES

('Stranger Things', 2019, 8.9, TRUE,
 'Sci-fi mystery series', 4, 1, 2),

('Money Heist', 2020, 8.5, TRUE,
 'Crime thriller series', 5, 4, 1),

('Wednesday', 2022, 8.2, TRUE,
 'Mystery comedy horror show', 1, 2, 2);

-- =====================================================
-- INSERT DATA INTO Available_On
-- =====================================================

INSERT INTO Available_On
VALUES
(1, 1),
(2, 1),
(2, 2),
(3, 1),
(3, 3);

-- =====================================================
-- INSERT DATA INTO Acts_In
-- =====================================================

INSERT INTO Acts_In
VALUES
(1, 1, 'Eleven'),
(2, 2, 'Professor'),
(2, 3, 'Berlin'),
(3, 4, 'Wednesday Addams');

-- =====================================================
-- VIEW ALL TABLES
-- =====================================================

SELECT * FROM Genre;
SELECT * FROM Rating_Category;
SELECT * FROM Platform;
SELECT * FROM Actor;
SELECT * FROM TV_SHOW;
SELECT * FROM Available_On;
SELECT * FROM Acts_In;

-- =====================================================
-- ADVANCED QUERIES
-- =====================================================

-- 1. Find all TV shows with rating above 8

SELECT Title, IMDB_Rating
FROM TV_SHOW
WHERE IMDB_Rating > 8;

-- =====================================================

-- 2. Count total TV shows

SELECT COUNT(*) AS Total_Shows
FROM TV_SHOW;

-- =====================================================

-- 3. Find shows with genre names

SELECT
    TV_SHOW.Title,
    Genre.GenreName
FROM TV_SHOW
JOIN Genre
ON TV_SHOW.GenreID = Genre.GenreID;

-- =====================================================

-- 4. Find actors and their roles

SELECT
    TV_SHOW.Title,
    Actor.ActorName,
    Acts_In.RoleName
FROM Acts_In
JOIN TV_SHOW
ON Acts_In.ShowID = TV_SHOW.ShowID
JOIN Actor
ON Acts_In.ActorID = Actor.ActorID;

-- =====================================================

-- 5. Find platforms where shows are available

SELECT
    TV_SHOW.Title,
    Platform.PlatformName
FROM Available_On
JOIN TV_SHOW
ON Available_On.ShowID = TV_SHOW.ShowID
JOIN Platform
ON Available_On.PlatformID = Platform.PlatformID;

-- =====================================================

-- 6. Find shows released after 2018

SELECT
    Title,
    ReleaseYear
FROM TV_SHOW
WHERE ReleaseYear > 2018;

-- =====================================================

-- 7. Sort shows by highest IMDB rating

SELECT
    Title,
    IMDB_Rating
FROM TV_SHOW
ORDER BY IMDB_Rating DESC;

-- =====================================================

-- 8. Count shows by genre

SELECT
    Genre.GenreName,
    COUNT(TV_SHOW.ShowID) AS TotalShows
FROM TV_SHOW
JOIN Genre
ON TV_SHOW.GenreID = Genre.GenreID
GROUP BY Genre.GenreName;

-- =====================================================

-- 9. Count shows on each platform

SELECT
    Platform.PlatformName,
    COUNT(Available_On.ShowID) AS TotalShows
FROM Available_On
JOIN Platform
ON Available_On.PlatformID = Platform.PlatformID
GROUP BY Platform.PlatformName;

-- =====================================================

-- 10. Find actors born after 1980

SELECT
    ActorName,
    BirthDate
FROM Actor
WHERE BirthDate > '1980-01-01';

-- =====================================================
-- END OF PROJECT
-- =====================================================