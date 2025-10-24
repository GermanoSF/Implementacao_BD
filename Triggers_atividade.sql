-- INSERTS, DELETES, UPDATES
----------------------------------------------------
-- 1
INSERT INTO Livro (isbn,titulo,ano,fk_editora,fk_categoria)
VALUES ('666','BESTA',1900,1,1),('777','BESTA',1900,1,1);

INSERT INTO Livro (isbn,titulo,ano,fk_editora,fk_categoria)
VALUES ('666','BESTA',1900,1,1);

----------------------------------------------------
-- 2
INSERT INTO Livro (isbn,titulo,fk_editora,fk_categoria)
VALUES ('666','BESTA',1,1);

----------------------------------------------------
-- 3
INSERT INTO LivroAutor (fk_autor,fk_livro)
VALUES (5,'666');

DELETE FROM Livro WHERE isbn = '666';

----------------------------------------------------
-- 6
UPDATE Livro
SET titulo = 'ABESTADO' 
WHERE isbn = '666';

----------------------------------------------------
-- 8
UPDATE Livro
SET isbn = '999'
WHERE isbn = '666';

DELETE FROM AUDITORIA WHERE id = 1;

----------------------------------------------------
-- 11
DELETE FROM Livro WHERE isbn ='666' OR isbn = '9788581742458';

----------------------------------------------------

--SELECTS
SELECT * FROM Livro;
SELECT * FROM LivroAutor;
SELECT * FROM Auditoria;
SELECT * FROM Autor;

----------------------------------------------------
-- ADICIONANDO TABELA AUDITORIA
CREATE TABLE Auditoria (

	id INT NOT NULL IDENTITY,
	fk_livro VARCHAR (50) NOT NULL,
	data_atualizacao DATE NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (fk_livro) REFERENCES Livro(isbn)

);


----------------------------------------------------
--------------------- TRIGGERS ---------------------
----------------------------------------------------

-- 1
CREATE OR ALTER TRIGGER trg_controle_titulos
ON Livro
AFTER INSERT
AS
BEGIN

	IF EXISTS (
        SELECT titulo
        FROM Livro
        GROUP BY titulo
        HAVING COUNT(*) > 1
    )
	BEGIN
		PRINT 'OPERACAO FALHOU';
		ROLLBACK TRANSACTION;
		RETURN;
	END;

	PRINT 'INSERCAO REALIZADA';

END;

----------------------------------------------------

-- 2
CREATE OR ALTER TRIGGER trg_atualiza_ano
ON Livro
INSTEAD OF INSERT
AS 
BEGIN
	-- EVITA RECURSAO
	IF TRIGGER_NESTLEVEL() > 1
        RETURN;

	INSERT INTO Livro (isbn,titulo,ano,fk_editora,fk_categoria)
	SELECT isbn,titulo,YEAR(GETDATE()),fk_editora,fk_categoria FROM inserted;

END;

----------------------------------------------------

-- 3
CREATE OR ALTER TRIGGER trg_remover_livro_autor
ON Livro
INSTEAD OF DELETE
AS 
BEGIN

	DELETE FROM LivroAutor WHERE fk_livro IN (SELECT isbn FROM deleted); 
	DELETE FROM Livro WHERE isbn IN (SELECT isbn FROM deleted);

END;

----------------------------------------------------

-- 6
CREATE OR ALTER TRIGGER trg_att_auditoria
ON LIVRO
AFTER UPDATE
AS
BEGIN

	INSERT INTO Auditoria (fk_livro, data_atualizacao) 
	SELECT isbn, GETDATE() FROM inserted;

END;

----------------------------------------------------

-- 8
CREATE OR ALTER TRIGGER trg_restringe_att_isbn
ON Livro
AFTER UPDATE
AS
BEGIN
	IF EXISTS(SELECT isbn FROM inserted)
	BEGIN
		PRINT 'VOCE NAO PODE ALTERAR O ISBN DE UM LIVRO';
		ROLLBACK TRANSACTION;
		RETURN;
	END;
END;

----------------------------------------------------

-- 11
CREATE OR ALTER TRIGGER trg_deleta_autor_livro
ON LivroAutor
AFTER DELETE
AS 
BEGIN

		DELETE FROM Autor WHERE id IN (SELECT A.id
									   FROM Autor AS A
		                               WHERE A.id IN (SELECT fk_autor FROM deleted) 
									   AND NOT EXISTS (SELECT 1 FROM LivroAutor AS LA WHERE LA.fk_autor = A.id)
		                              );
		IF (@@ROWCOUNT>0)
		BEGIN 
			PRINT 'AUTOR(ES) DELETADO(S) DO BANCO POR FALTA DE LIVRO';
		END;

END;



