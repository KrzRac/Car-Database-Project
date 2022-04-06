USE Autokomis
SET NOCOUNT OFF

-------- dodaj_samochod --------

DELETE FROM Dealer_samochód
WHERE nazwa_dealera = 'Karlik'
      AND sam_VIN = 'ASDFGHJKLzxcvbnm4'

SELECT * FROM Dealer_samochód

----- POPRAWNE WYWO£ANIE ------

BEGIN TRY

    EXECUTE dodaj_samochod
            Karlik,
            ASDFGHJKLzxcvbnm4;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS 'KOMUNIKAT'
END CATCH


------ NIEPOPRAWNE WYWO£ANIE ------

--nazwa dealera nie znajduje siê w tabeli dealer
BEGIN TRY

    EXECUTE dodaj_samochod
            ABCD,
            12345678901234098;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS 'KOMUNIKAT'
END CATCH

--nazwa dealera i VIN samochodu znajduj¹ siê ju¿ w tabeli Dealer_samochód
BEGIN TRY

    EXECUTE dodaj_samochod
            Karlik,
            ASDFGHJKLzxcvbnm4;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS 'KOMUNIKAT'
END CATCH



------------- dodaj_sprzeda¿ -----------------

DELETE FROM Sprzeda¿
WHERE cena = '15000'
      AND dat = '20180603'
      AND klient_id = 5
      AND nazwa_dealer = 'Papis'
      AND sam_VIN = 'Q356bmFcPdln840A3'

INSERT INTO Dealer_samochód VALUES
('Papis', 'Q356bmFcPdln840A3');

SELECT * FROM Sprzeda¿
SELECT * FROM Dealer_samochód

---- POPRAWNE WYWO£ANIE ----

BEGIN TRY

    EXECUTE dodaj_sprzeda¿
            15000,
            '20180603',
            5,
            Papis,
            Q356bmFcPdln840A3

END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS 'KOMUNIKAT'
END CATCH


---- NIEPOPRAWNE WYWO£ANIE -----


BEGIN TRY

    EXECUTE dodaj_sprzeda¿
            15000,
            '20190201',
            5,
            Papis,
            gfk3459403nbmAtJb

END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS 'KOMUNIKAT'
END CATCH


--- poni¿sze wartoœci znajduj¹ siê ju¿ w tabeli sprzeda¿

BEGIN TRY

    EXECUTE dodaj_sprzeda¿
            15000,
            '20180603',
            5,
            Papis,
            Q356bmFcPdln840A3

END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS 'KOMUNIKAT'
END CATCH




----------------- dod_sam_ogr ---------------------

DELETE FROM Samochód
WHERE VIN = '1fb5NA8Kn560Perg4' AND przebieg = 195678 AND skrzynia_biegów =  '5-biegowa automatyczna' AND kraj_pochodzenia = 'Polska' AND rok_produkcji = 2011 AND id_modelu = 3 AND id_silnika = 3

SELECT * FROM Samochód

--- POPRAWNE WYWO£ANIE

BEGIN TRY

    EXECUTE dod_sam_ogr
            '1fb5NA8Kn560Perg4',
            195678,
            '5-biegowa automatyczna',
            'Polska',
            2011,
            3,
            3
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS 'KOMUNIKAT'
END CATCH


---- NIEPOPRAWNE WYWO£ANIE 

BEGIN TRY 

    EXECUTE dod_sam_ogr
            '417285jkahnv93013',
            543534534,
            '5-biegowa manualna',
            'USA',
            1999,
            1,
            2
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS 'KOMUNIKAT'
END CATCH
         
         


-------------- sam_osob_check ---------------------------]

DELETE FROM Samochód_osobowy WHERE model_id = 1
DELETE FROM Samochód_osobowy WHERE model_id = 3
DELETE FROM Samochód_osobowy WHERE model_id = 5
DELETE FROM Samochód_ciê¿arowy WHERE model_id = 6

SELECT * FROM Samochód_osobowy

INSERT INTO Samochód_osobowy VALUES 
('5', '2', '500'),
('100', '3', '1000'),
('1', '4', '700');

INSERT INTO Samochód_osobowy VALUES 
('3', '2', '500');

INSERT INTO Samochód_osobowy VALUES 
('100', '2', '500');



---------------

SELECT * FROM modele

SELECT * FROM sprzeda¿e('30000')