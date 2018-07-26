-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2018-07-26 21:57:15.415

Create database TRANSPORTE
-- tables
-- Table: Boleto
CREATE TABLE Boleto (
    cod_bolet int  NOT NULL,
    Fecha_bolet date  NOT NULL,
    Importe_total int  NOT NULL,
    Pasajero_codPas int  NOT NULL,
    Personal_Cod_pers int  NOT NULL,
    CONSTRAINT Boleto_pk PRIMARY KEY  (cod_bolet)
);

-- Table: Detalle_Ruta
CREATE TABLE Detalle_Ruta (
    codRuta int  NOT NULL,
    NomRUT varchar(50)  NOT NULL,
    Origen varchar(20)  NOT NULL,
    Destino varchar(20)  NOT NULL,
    Costo varchar(10)  NOT NULL,
    importe varchar(10)  NOT NULL,
    Pasajero_codPas int  NOT NULL,
    CONSTRAINT Detalle_Ruta_pk PRIMARY KEY  (codRuta)
);

-- Table: Empresa
CREATE TABLE Empresa (
    cod_Empre int  NOT NULL,
    Nombre_Emp varchar(50)  NOT NULL,
    RUC char(12)  NOT NULL,
    Dir_Emp varchar(50)  NOT NULL,
    CONSTRAINT Empresa_pk PRIMARY KEY  (cod_Empre)
);

-- Table: Pasajero
CREATE TABLE Pasajero (
    codPas int  NOT NULL,
    NomPas varchar(40)  NOT NULL,
    ApePas varchar(40)  NOT NULL,
    DNI char(8)  NOT NULL,
    telf char(9)  NOT NULL,
    direc varchar(50)  NOT NULL,
    Personal_Cod_pers int  NOT NULL,
    CONSTRAINT Pasajero_pk PRIMARY KEY  (codPas)
);

-- Table: Personal
CREATE TABLE Personal (
    Cod_pers int  NOT NULL,
    Nom_Pers varchar(50)  NOT NULL,
    Ape_Pers varchar(50)  NOT NULL,
    DNI varchar(8)  NOT NULL,
    Telef char(9)  NOT NULL,
    Direccio varchar(50)  NOT NULL,
    tipo varchar(20)  NOT NULL,
    Empresa_cod_Empre int  NOT NULL,
    CONSTRAINT Personal_pk PRIMARY KEY  (Cod_pers)
);

-- Table: Sucursales
CREATE TABLE Sucursales (
    Cod_sucur int  NOT NULL,
    nombre varchar(50)  NOT NULL,
    Direccion varchar(50)  NOT NULL,
    Telefono char(9)  NOT NULL,
    Empresa_cod_Empre int  NOT NULL,
    Ubigeo_cod_ubige int  NOT NULL,
    CONSTRAINT Sucursales_pk PRIMARY KEY  (Cod_sucur)
);

-- Table: Ubigeo
CREATE TABLE Ubigeo (
    cod_ubige int  NOT NULL,
    Departa varchar(50)  NOT NULL,
    Provincia varchar(50)  NOT NULL,
    distrito varchar(50)  NOT NULL,
    Detalle_Ruta_codRuta int  NOT NULL,
    CONSTRAINT Ubigeo_pk PRIMARY KEY  (cod_ubige)
);

-- foreign keys
-- Reference: Boleto_Pasajero (table: Boleto)
ALTER TABLE Boleto ADD CONSTRAINT Boleto_Pasajero
    FOREIGN KEY (Pasajero_codPas)
    REFERENCES Pasajero (codPas);

-- Reference: Boleto_Personal (table: Boleto)
ALTER TABLE Boleto ADD CONSTRAINT Boleto_Personal
    FOREIGN KEY (Personal_Cod_pers)
    REFERENCES Personal (Cod_pers);

-- Reference: Detalle_Ruta_Pasajero (table: Detalle_Ruta)
ALTER TABLE Detalle_Ruta ADD CONSTRAINT Detalle_Ruta_Pasajero
    FOREIGN KEY (Pasajero_codPas)
    REFERENCES Pasajero (codPas);

-- Reference: Pasajero_Personal (table: Pasajero)
ALTER TABLE Pasajero ADD CONSTRAINT Pasajero_Personal
    FOREIGN KEY (Personal_Cod_pers)
    REFERENCES Personal (Cod_pers);

-- Reference: Personal_Empresa (table: Personal)
ALTER TABLE Personal ADD CONSTRAINT Personal_Empresa
    FOREIGN KEY (Empresa_cod_Empre)
    REFERENCES Empresa (cod_Empre);

-- Reference: Sucursales_Empresa (table: Sucursales)
ALTER TABLE Sucursales ADD CONSTRAINT Sucursales_Empresa
    FOREIGN KEY (Empresa_cod_Empre)
    REFERENCES Empresa (cod_Empre);

-- Reference: Sucursales_Ubigeo (table: Sucursales)
ALTER TABLE Sucursales ADD CONSTRAINT Sucursales_Ubigeo
    FOREIGN KEY (Ubigeo_cod_ubige)
    REFERENCES Ubigeo (cod_ubige);

-- Reference: Ubigeo_Detalle_Ruta (table: Ubigeo)
ALTER TABLE Ubigeo ADD CONSTRAINT Ubigeo_Detalle_Ruta
    FOREIGN KEY (Detalle_Ruta_codRuta)
    REFERENCES Detalle_Ruta (codRuta);

-- End of file.





/* Poner en uso la base de datos */
Use TRANSPORTE
GO



/*ESTORE PROCEDURE*/

/* Poner en uso la BD Librería */
USE TRANSPORTE
GO



/* Crear un SP que permita listar los registros de la tabla género */
CREATE PROCEDURE sp_lisPersonal
AS
    BEGIN
        SELECT * FROM Personal
    END
GO



/* Crear un SP que permita listar los registros de la tabla cliente */
CREATE PROCEDURE sp_ListPasajero
AS
    BEGIN
        SELECT * FROM Pasajero
    END
GO


/* Crear un SP que permita listar los clientes ordenados por la columna sexo de forma ascendente */
CREATE PROCEDURE sp_ListPersonalNombre
AS
    BEGIN
        SELECT * FROM Personal
        ORDER BY  Personal.Nom_Pers ASC
    END
GO


/*LISTAR*/
ALTER PROCEDURE sp_ListPersonalNombre
    @Tipo VARCHAR(1)
AS
    BEGIN
        SELECT *
        FROM Personal
        WHERE Personal.Nom_Pers = @Tipo
    END
GO

/* Ejecutar SP que muestre los PERSONAL del CHOFER */
EXEC sp_ListPersonalNombre @Tipo = C
GO

/* Modificar el SP de tal forma que se vea completo el nombre del CHOFER*/
ALTER PROCEDURE sp_ListPersonalNombre
    @Tipos VARCHAR(1)
AS
    BEGIN
        SELECT CONCAT( Personal.Ape_Pers, ', ', Personal.Nom_Pers) AS Personal,
        Personal.DNI AS dni,
        Tipo =
        CASE 
            WHEN Personal.tipo = 'c' THEN 'chofer'
            WHEN Personal.tipo = 'T' THEN 'Terramosa'
        END
        FROM Personal
        WHERE Personal.tipo = @Tipos
    END
GO


/*REGISTRART*/
/* Crer un SP que permita ingresar registros a la tabla PERSONAL */
CREATE PROCEDURE sp_AddPersonal
    @Codigo VARCHAR(4),
    @nombre VARCHAR(MAX)
AS
    BEGIN
        INSERT INTO Personal
            (Cod_pers, Nom_Pers)
        VALUES
            (@Codigo, @nombre)
    END
GO

/* Agregar el  tipo de personal */
EXEC sp_AddPersonal @Codigo = 5, @nombre = 'Chofer'
GO



/* Elaborar un SP que permita validar el código de personal antes de ingresar un registro */
ALTER PROCEDURE sp_AddPersonal
    @Codigo INT,
    @nombre VARCHAR(MAX)
AS
    BEGIN
        IF(SELECT Personal.Cod_pers FROM Personal WHERE Personal.Cod_pers = @Codigo) IS NOT NULL
            SELECT 'No puedo ingresar el registro porque el código ya existe' AS 'Resultado'
        ELSE
            INSERT INTO Personal
                (Cod_pers, Nom_Pers)
            VALUES
                (@Codigo, @nombre);
            SELECT * FROM Personal ORDER BY Cod_pers
    END
GO


/* Eliminar registro a través de un SP */
CREATE PROCEDURE SP_DelPersonal
    @Codigo VARCHAR(4)
AS
    BEGIN
        DELETE FROM Personal
        WHERE Personal.Cod_pers = @Codigo
    END
GO




/*LISTAR PASAJERO*/

CREATE PROCEDURE sp_ListPasajeroNombre
AS
    BEGIN
        SELECT * FROM Personal
        ORDER BY  Personal.Nom_Pers ASC
    END
GO



/*LISTAR PASAJERO*/
ALTER PROCEDURE sp_ListPasajeroNombre
    @sexo VARCHAR(1)
AS
    BEGIN
        SELECT *
        FROM Pasajero
        WHERE Pasajero.NomPas = @sexo
    END
GO

/* Ejecutar SP que muestre los PASAJEROS */
EXEC sp_ListPasajeroNombre @sexo = F
GO

/* Modificar el SP de tal forma que se vea completo el nombre del PASAJERO*/
ALTER PROCEDURE sp_ListPasajeroNombre
    @Tipos VARCHAR(1)
AS
    BEGIN
        SELECT CONCAT( Pasajero.ApePas, ', ', Pasajero.NomPas) AS Pasajero,
        Pasajero.DNI AS dni,
        Tipo =
        CASE 
            WHEN Pasajero.Estado = 'm' THEN 'mayor'
            WHEN Pasajero.Estado = 'n' THEN 'niño'
        END
        FROM Pasajero
        WHERE Pasajero.Estado = @Tipos
    END
GO


/*REGISTRART*/
/* Crer un SP que permita ingresar registros a la tabla PERSONAL */
CREATE PROCEDURE sp_AddPasajero
    @Codigo VARCHAR(4),
    @nombre VARCHAR(MAX)
AS
    BEGIN
        INSERT INTO Pasajero
            (codPas, NomPas)
        VALUES
            (@Codigo, @nombre)
    END
GO




/* Elaborar un SP que permita validar el código de personal antes de ingresar un registro */
ALTER PROCEDURE sp_AddPasajero
    @Codigo INT,
    @nombre VARCHAR(MAX)
AS
    BEGIN
        IF(SELECT Pasajero.codPas FROM Pasajero WHERE Pasajero.codPas = @Codigo) IS NOT NULL
            SELECT 'No puedo ingresar el registro porque el código ya existe' AS 'Resultado'
        ELSE
            INSERT INTO Pasajero
                (codPas, NomPas)
            VALUES
                (@Codigo, @nombre);
            SELECT * FROM Pasajero ORDER BY codPas
    END
GO


/* Eliminar registro a través de un SP */
CREATE PROCEDURE SP_DelPasajero
    @Codigo VARCHAR(4)
AS
    BEGIN
        DELETE FROM Pasajero
        WHERE Pasajero.codPas = @Codigo
    END
GO







/*listar sucursal*/

CREATE PROCEDURE sp_ListSucursal
AS
    BEGIN
        SELECT * FROM Sucursales
        ORDER BY  Sucursales.nombre ASC
    END
GO



/*LISTAR PASAJERO*/
ALTER PROCEDURE sp_ListSucursal
    @nobre VARCHAR(1)
AS
    BEGIN
        SELECT *
        FROM Sucursales
        WHERE Sucursales.nombre = @nobre
    END
GO

/* Ejecutar SP que muestre los PASAJEROS */
EXEC sp_ListSucursal @nobre = I
GO

/* Modificar el SP de tal forma que se vea completo el nombre del PASAJERO*/
ALTER PROCEDURE sp_ListSucursal
    @Tipos VARCHAR(1)
AS
    BEGIN
        SELECT CONCAT( Sucursales.nombre, ', ', Sucursales.Direccion) AS Sucursales,
        Sucursales.nombre AS sucursal,
        Tipo =
        CASE 
            WHEN Sucursales.Direccion = 'I' THEN 'ICA'
            WHEN Sucursales.Direccion = 'L' THEN 'LIMA'
        END
        FROM Sucursales
        WHERE Sucursales.Direccion = @Tipos
    END
GO


/*REGISTRART*/
/* Crer un SP que permita ingresar registros a la tabla PERSONAL */
CREATE PROCEDURE sp_AddSucursal
    @Codigo VARCHAR(4),
    @nombre VARCHAR(MAX)
AS
    BEGIN
        INSERT INTO Sucursales
            (Cod_sucur, Direccion)
        VALUES
            (@Codigo, @nombre)
    END
GO




/* Elaborar un SP que permita validar el código de personal antes de ingresar un registro */
ALTER PROCEDURE sp_AddSucursal
    @Codigo INT,
    @nombre VARCHAR(MAX)
AS
    BEGIN
        IF(SELECT Sucursales.Cod_sucur FROM Sucursales WHERE Sucursales.Cod_sucur = @Codigo) IS NOT NULL
            SELECT 'No puedo ingresar el registro porque el código ya existe' AS 'Resultado'
        ELSE
            INSERT INTO Sucursales
                (Cod_sucur, Direccion)
            VALUES
                (@Codigo, @nombre);
            SELECT * FROM Sucursales ORDER BY Cod_sucur
    END
GO


/* Eliminar registro a través de un SP */
CREATE PROCEDURE SP_DelSucrusal
    @Codigo VARCHAR(4)
AS
    BEGIN
        DELETE FROM Sucursales
        WHERE Sucursales.Cod_sucur = @Codigo
    END
GO






