/* Baza Autokomis */

--USE master;
--DROP DATABASE Autokomis;
--GO

--CREATE DATABASE Autokomis;
--GO

--USE Autokomis;
--GO

SET LANGUAGE polski;
GO

-------- DROP --------

DROP TABLE IF EXISTS Samochód_osobowy;
DROP TABLE IF EXISTS Samochód_ciê¿arowy;
DROP TABLE IF EXISTS Model_silnik;
DROP TABLE IF EXISTS Wyposa¿enie_samochód;
DROP TABLE IF EXISTS Dealer_samochód;
DROP TABLE IF EXISTS Sprzeda¿;
DROP TABLE IF EXISTS Samochód;
DROP TABLE IF EXISTS Typ_silnika;
DROP TABLE IF EXISTS Dodatkowe_wyposa¿enie;
DROP TABLE IF EXISTS Klient;
DROP TABLE IF EXISTS Dealer_model;
DROP TABLE IF EXISTS Dealer;
DROP TABLE IF EXISTS Model;
DROP TABLE IF EXISTS Marka;

-------- CREATE --------

CREATE TABLE Marka
(
    nazwa           VARCHAR(30) CONSTRAINT pk_marka_nazwa PRIMARY KEY,
    rok_za³o¿enia   INT,
    CONSTRAINT ck_marka_rok CHECK (rok_za³o¿enia > 1500 AND rok_za³o¿enia < 2500)
);

CREATE TABLE Model
(
    id          INT NOT NULL CONSTRAINT pk_model_id PRIMARY KEY,
    nazwa       VARCHAR(30),
    rok_wprowadzenia INT,
    CONSTRAINT ck_model_rok CHECK (rok_wprowadzenia > 1500 AND rok_wprowadzenia < 2500),
    nastêpnik   VARCHAR(30) UNIQUE CONSTRAINT fk_model_nastepnik REFERENCES Model(nastêpnik),
    marka       VARCHAR(30) CONSTRAINT fk_marka_nazwa REFERENCES Marka(nazwa)  
    
);

CREATE TABLE Samochód_osobowy
(
    model_id            INT NOT NULL CONSTRAINT pfk_osobowy_model_id REFERENCES Model(id) PRIMARY KEY,
    liczba_pasa¿erów    INT,
    pojemnoœæ_baga¿nika INT
);

CREATE TABLE Samochód_ciê¿arowy
(
    model_id  INT NOT NULL CONSTRAINT pfk_ciezarowy_model_id REFERENCES Model(id) PRIMARY KEY,
    ³adownoœæ INT   
);

CREATE TABLE Typ_silnika
(
    id              INT CONSTRAINT pk_typ_silnika PRIMARY KEY,
    rodzaj_paliwa   VARCHAR(30),
    opis_parametrów VARCHAR(100)
);

CREATE TABLE Model_silnik
(
    id_modelu   INT NOT NULL CONSTRAINT fk_model_silnik_id REFERENCES Model(id),
    id_silnika  INT CONSTRAINT fk_silnik_id REFERENCES Typ_silnika(id),
    CONSTRAINT pk_model_silnik PRIMARY KEY (id_modelu, id_silnika)
);

CREATE TABLE Samochód
(
    VIN VARCHAR(17) CONSTRAINT pk_samochod_vin PRIMARY KEY,
    przebieg INT,
    skrzynia_biegów VARCHAR(30),
    kraj_pochodzenia VARCHAR(30),
    rok_produkcji INT,
    CONSTRAINT ck_sam_rok CHECK (rok_produkcji > 1500 AND rok_produkcji < 2500),
    id_modelu INT UNIQUE CONSTRAINT fk_samochod_model_id REFERENCES Model(id),
    id_silnika INT UNIQUE CONSTRAINT fk_samochod_silnik_id REFERENCES Typ_silnika(id)
);

CREATE TABLE Dodatkowe_wyposa¿enie
(
    nazwa VARCHAR(30) CONSTRAINT pk_dod_wyp_nazwa PRIMARY KEY
);

CREATE TABLE Wyposa¿enie_samochód
(
    VIN_sam         VARCHAR(17) CONSTRAINT fk_wyp_sam_VIN REFERENCES Samochód(VIN),
    dod_wyp_nazwa   VARCHAR(30) CONSTRAINT fk_sam_wyp_dod_nazwa REFERENCES Dodatkowe_wyposa¿enie(nazwa),
    CONSTRAINT pk_wyp_sam PRIMARY KEY(VIN_sam, dod_wyp_nazwa)
);

CREATE TABLE Dealer
(
    nazwa   VARCHAR(30) CONSTRAINT pk_dealer_nazwa PRIMARY KEY,
    adres   VARCHAR(50)
);

CREATE TABLE Dealer_model
(
    nazwa_dealera    VARCHAR(30) CONSTRAINT fk_dealer_model_nazwa REFERENCES Dealer(nazwa),
    id_modelu       INT UNIQUE CONSTRAINT fk_delaer_model_id REFERENCES Model(id),
    CONSTRAINT pk_dealer_model PRIMARY KEY(nazwa_dealera, id_modelu)
);

CREATE TABLE Dealer_samochód
(
    nazwa_dealera   VARCHAR(30) CONSTRAINT fk_dealer_samochod_nazwa REFERENCES Dealer(nazwa),
    sam_VIN         VARCHAR(17) CONSTRAINT fk_dealer_samochod_VIN REFERENCES Samochód(VIN),
    CONSTRAINT pk_dealer_samochod PRIMARY KEY(nazwa_dealera, sam_VIN)
);

CREATE TABLE Klient
(
    id          INT PRIMARY KEY,
    imiê        VARCHAR(15),
    nazwisko    VARCHAR(15),
    num_tel     INT,
    CONSTRAINT ck_klient_num_tel CHECK (num_tel > 1 AND num_tel < 999999999)
);

CREATE TABLE Sprzeda¿
(
    dat             DATETIME,
    klient_id       INT CONSTRAINT fk_sp_klient_id REFERENCES Klient(id),
    nazwa_dealer    VARCHAR(30) CONSTRAINT fk_sp_nazwa_dealer REFERENCES Dealer(nazwa),
    sam_VIN         VARCHAR(17) CONSTRAINT fk_sp_sam_VIN REFERENCES Samochód(VIN),
    cena            INT,
    CONSTRAINT pk_sprzedaz PRIMARY KEY(dat, klient_id, nazwa_dealer, sam_VIN)
);

GO

------------ INSERT ------------

INSERT INTO Marka VALUES
('Audi',    '1909'),
('BMW',     '1916'),
('Jeep',    '1941'),
('Ford',    '1903');

INSERT INTO Model VALUES
('1', 'A3',                     '1996', 'A3 II',                    'Audi'),
('2', 'seria 5 Gran Turismo',   '2017', 'seria 6 Gran Turismo',     'BMW'),
('3', 'Grand Cherokee III',     '2004', 'Grand Cherokee IV',        'Jeep'),
('4', 'Mustang Shelby GT350',   '1965', 'Mustang Shleby GTX500',    'Ford');

INSERT INTO Samochód_osobowy VALUES
('1', '4', '700'),
('2', '5', '1500');


INSERT INTO Samochód_ciê¿arowy VALUES
('3', '7000'),
('4', '500');


INSERT INTO Typ_silnika VALUES
('1', 'Diesel',     '1.4 TFSI turbo'),
('2', 'Diesel',     '4-cylindrowy BMW B47'),
('3', 'benzyna',    'V6 3.7l 210 KM'),
('4', 'benzyna',    '4,7-litrowy silnik V8 typu Windsor');

INSERT INTO Model_silnik VALUES
('1', '1'),
('2', '2'),
('3', '3'),
('4', '4');

INSERT INTO Samochód VALUES
('1234567890qwertyu', '100000', '5-biegowa manualna',     'Niemcy',   '2000', '1', '1'),
('zXcVbNmAsDfGhJkLq', '50000',  '8-biegowa automatyczna', 'Niemcy',   '2018', '2', '2'),
('asdfghjkl12345678', '87000',  '6-biegowa automatyczna', 'USA',      '2012', '3', '3'),
('QWERTYUIOPLMNBVCX', '150000', '4-biegowa manualna',     'USA',      '1969', '4', '4');

INSERT INTO Dodatkowe_wyposa¿enie VALUES
('Ambition'),
('Luxury Line'),
('Overland'),
('Limited');

INSERT INTO Wyposa¿enie_samochód VALUES
('1234567890qwertyu', 'Ambition'),
('zXcVbNmAsDfGhJkLq', 'Luxury Line'),
('asdfghjkl12345678', 'Overland'),
('QWERTYUIOPLMNBVCX', 'Limited');

INSERT INTO Dealer VALUES
('Auto Watin',      'Obornicka 4'),
('Voyager Club',    'Œwietego Micha³a 20'),
('AMC MARI-CAR',    'Metalowa 1'),
('Bemo Motors',     'Op³oki 19');

INSERT INTO Dealer_model VALUES
('Auto Watin',      '1'),
('Voyager Club',    '2'),
('AMC MARI-CAR',    '3'),
('Bemo Motors',     '4');

INSERT INTO Dealer_samochód VALUES
('Auto Watin',      '1234567890qwertyu'),
('Voyager Club',    'zXcVbNmAsDfGhJkLq'),
('AMC MARI-CAR',    'asdfghjkl12345678'),
('Bemo Motors',     'QWERTYUIOPLMNBVCX');

INSERT INTO Klient VALUES
('1', 'Andrzej',    'Kowalski',     '997110001'),
('2', 'Igor',       'Nowak',        '123456789'),
('3', 'Stefan',     'Polañski',     '987654321'),
('4', 'Mi³osz',     'Lewandowski',  '456372916');

INSERT INTO Sprzeda¿ VALUES
('25-05-2019', '1', 'Auto Watin',   '1234567890qwertyu', '15000'),
('15-04-2019', '2', 'Voyager Club', 'zXcVbNmAsDfGhJkLq', '2000000'),
('13-02-2019', '3', 'AMC MARI-CAR', 'asdfghjkl12345678', '300000'),
('04-01-2019', '4', 'Bemo Motors',  'QWERTYUIOPLMNBVCX', '50000');
