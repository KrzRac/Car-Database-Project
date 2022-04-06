USE Autokomis

--DROP PROCEDURE IF EXISTS dodaj_samochod
--DROP PROCEDURE IF EXISTS dodaj_sprzeda�

CREATE OR ALTER PROCEDURE dodaj_samochod
    @dealer_nazwa VARCHAR(30),
    @samoch�d_VIN VARCHAR(17)
AS
BEGIN
    DECLARE @blad VARCHAR(MAX)

    SELECT @blad = blad FROM (
        SELECT 'Nie mo�na wstawi� warto�ci ' + @samoch�d_VIN + ', bo nie ma jej w tabeli Samochod' AS [blad]
        WHERE NOT EXISTS (SELECT 1
                          FROM   Samoch�d
                          WHERE  VIN = @samoch�d_VIN)

        UNION

        SELECT 'Nie mo�na wstawi� warto��i ' + @dealer_nazwa + ', bo nie ma jej w tabeli Dealer'
        WHERE NOT EXISTS (SELECT 1
                          FROM Dealer
                          WHERE nazwa = @dealer_nazwa)
    
        UNION 

        SELECT 'Nie mo�na wstawi� warto�ci ' + @dealer_nazwa + ', ' + @samoch�d_VIN + ', bo znajduj� si� ju� w tabeli Dealer_samoch�d'
        WHERE EXISTS (SELECT 1
                      FROM Dealer_samoch�d
                      WHERE sam_VIN = @samoch�d_VIN AND nazwa_dealera = @dealer_nazwa)

) AS [x]

    IF @blad IS NULL
        INSERT INTO Dealer_samoch�d (nazwa_dealera, sam_VIN) VALUES
        (@dealer_nazwa, @samoch�d_VIN)
    ELSE
        RAISERROR(@blad, 11, 1)

END
GO

-------------------------------

CREATE OR ALTER PROCEDURE dodaj_sprzeda�
    @cena INT,
    @data DATETIME,
    @klient_id INT,
    @dealer_nazwa VARCHAR(30),
    @samoch�d_VIN VARCHAR(17)
AS
BEGIN
    DECLARE @blad VARCHAR(MAX)

    SELECT @blad = blad FROM (
        SELECT  'Nie mo�na wstawi� warto��i ' + CAST(@klient_id AS VARCHAR(10)) + ', bo nie ma jej w tabeli Klient' AS [blad]
        WHERE NOT EXISTS (SELECT 1
                          FROM Klient
                          WHERE id = @klient_id)
        
        UNION

        SELECT 'Nie mo�na wstawi� warto��i ' + @dealer_nazwa + ', bo nie ma jej w tabeli Dealer'
        WHERE NOT EXISTS (SELECT 1
                          FROM Dealer
                          WHERE nazwa = @dealer_nazwa)

        UNION

        SELECT 'Nie mo�na wstawi� warto��i ' + @samoch�d_VIN + ', bo nie ma jej w tabeli Samoch�d'
        WHERE NOT EXISTS (SELECT 1
                          FROM Samoch�d
                          WHERE VIN = @samoch�d_VIN)

        UNION

        SELECT 'Podane warto�ci znajduj� si� juz w tabeli Sprzeda�'
        WHERE EXISTS (SELECT 1
                      FROM Sprzeda�
                      WHERE dat = @data
                            AND klient_id = @klient_id
                            AND nazwa_dealer = @dealer_nazwa
                            AND sam_VIN = @samoch�d_VIN)
    
    ) AS [y]


    IF @blad IS NULL
        BEGIN
            INSERT INTO Sprzeda�(dat, klient_id, nazwa_dealer, sam_VIN, cena) VALUES
            (@data, @klient_id, @dealer_nazwa, @samoch�d_VIN, @cena)
            DELETE FROM Dealer_samoch�d WHERE nazwa_dealera = 'Papis' AND sam_VIN = 'Q356bmFcPdln840A3'
        END
    ELSE
        RAISERROR(@blad, 11, 1)

END 
GO



-------------------------------------

CREATE OR ALTER PROCEDURE dod_sam_ogr
    @VIN VARCHAR(17),
    @przebieg INT,
    @skrzynia_bieg�w VARCHAR(30),
    @kraj_pochodznia VARCHAR(30),
    @rok_produkcji INT,
    @id_modelu INT,
    @id_silnika INT
AS
BEGIN
    DECLARE @blad VARCHAR(MAX)

    SELECT @blad = blad FROM (
        SELECT 'Ten samochodu jest ju� w tabeli Samoch�d!' AS [blad]
        WHERE EXISTS (SELECT 1
                      FROM Samoch�d
                      WHERE VIN = @VIN)

        UNION

        SELECT 'Tego modelu nie ma w tabeli Model!' 
        WHERE NOT EXISTS (SELECT 1
                          FROM Model
                          WHERE id = @id_modelu)

        UNION

        SELECT 'Tego silnika nie ma w tabeli Typ_silnika!'
        WHERE NOT EXISTS (SELECT 1
                          FROM Typ_silnika
                          WHERE id = @id_silnika)

        UNION 

        SELECT 'Dany silnik nie wyst�puje w tym modelu!'
        WHERE @id_modelu NOT IN (SELECT id_modelu
                                 FROM Model_silnik
                                 WHERE id_silnika = @id_silnika)
        
    ) AS [z]

    IF @blad IS NULL
        INSERT INTO Samoch�d(VIN, przebieg, skrzynia_bieg�w, kraj_pochodzenia, rok_produkcji, id_modelu, id_silnika) VALUES
        (@VIN, @przebieg, @skrzynia_bieg�w, @kraj_pochodznia, @rok_produkcji, @id_modelu, @id_silnika)
    ELSE
        RAISERROR(@blad, 11, 1)


END 
GO



-----------------------------

CREATE OR ALTER TRIGGER sam_osob_check
ON Samoch�d_osobowy
INSTEAD OF INSERT
AS  

    DECLARE @model_id INT
    DECLARE @liczba_osob INT
    DECLARE @pojemnosc INT
    DECLARE cursor_2 CURSOR FAST_FORWARD FOR
    SELECT model_id, liczba_pasa�er�w, pojemno��_baga�nika FROM inserted

    OPEN cursor_2
    FETCH NEXT FROM cursor_2 into @model_id, @liczba_osob, @pojemnosc

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT @model_id
        IF @model_id IN (SELECT id FROM Model) 
            IF @model_id NOT IN (SELECT model_id FROM Samoch�d_ci�arowy)
                IF @model_id NOT IN (SELECT model_id FROM Samoch�d_osobowy)         
                    INSERT INTO Samoch�d_osobowy (model_id, liczba_pasa�er�w, pojemno��_baga�nika) VALUES (@model_id, @liczba_osob, @pojemnosc)
                ELSE
                    PRINT 'Ten model znajduje si� ju� w tabeli Samoch�d_osobowy!'
            ELSE
                PRINT 'Ten model znajduje si� ju� w tabeli Samoch�d_ci�arowy!'
        ELSE
            PRINT 'Ten model nie znajduje si� w tabeli Modele!'
        FETCH NEXT FROM cursor_2 into @model_id, @liczba_osob, @pojemnosc
    END
    CLOSE cursor_2
    DEALLOCATE cursor_2
GO

   

--CREATE OR ALTER TRIGGER sam_ciez_check
--ON Samoch�d_ci�arowy
--INSTEAD OF INSERT
--AS
--    DECLARE @model_id INT
--    SELECT @model_id = model_id FROM inserted
    
--    IF @model_id IN (SELECT id FROM Model) 
--        IF @model_id NOT IN (SELECT model_id FROM Samoch�d_ci�arowy)
--            IF @model_id NOT IN (SELECT model_id FROM Samoch�d_osobowy)         
--                INSERT INTO Samoch�d_ci�arowy SELECT * FROM inserted
--            ELSE
--                PRINT 'Ten model znajduje si� ju� w tabeli Samoch�d_osobowy!'
--        ELSE
--            PRINT 'Ten model znajduje si� ju� w tabeli Samoch�d_ci�arowy!'
--    ELSE
--        PRINT 'Ten model nie znajduje si� w tabeli Modele!'
--GO



-------------------------

CREATE OR ALTER VIEW modele (marka, nazwa, rok_wprowadzenia)
AS
(
    SELECT marka, nazwa, rok_wprowadzenia
    FROM Model
    WHERE rok_wprowadzenia > 2000
);
GO


CREATE OR ALTER FUNCTION sprzeda�e
(
    @cena INT
)
    RETURNS TABLE 
AS
    RETURN SELECT dat AS [data], nazwa_dealer, sam_VIN, cena
            FROM Sprzeda�
            WHERE cena > @cena;
GO
