-- Categoria do Salario
SELECT
	Pnome,
	Unome,
	Salario,
	CASE
		WHEN Salario < 20000 THEN 'Baixo'
		WHEN Salario BETWEEN 20000 AND 40000 THEN 'Medio'
		WHEN Salario > 40000 THEN 'Alto'
		ELSE 'Sem Registro'
	END AS 'Categoria'
FROM FUNCIONARIO;

-- Verificar se o funcionario foi contratado nos ultimos 6 meses
SELECT 
	Pnome,
	Unome,
	Data_Admissao,
	CASE
		WHEN DATEDIFF(DAY,Data_Admissao,GETDATE()) <= 180 THEN 'Contratado ha menos de 6 meses'
		WHEN DATEDIFF(DAY,Data_Admissao,GETDATE()) > 180 THEN 'Contratado ha mais de 6 meses'
		ELSE 'Sem registro'
	END AS 'Contratado'
FROM FUNCIONARIO;

-- Mudar salario de um tal de 'Carlos'
UPDATE FUNCIONARIO 
SET Salario = 30000
WHERE Pnome = 'Carlos';

SELECT * 
FROM FUNCIONARIO 
WHERE Pnome = 'Carlos';

-- Transaction
BEGIN TRANSACTION
	
	UPDATE FUNCIONARIO
	SET Salario = 25000
	WHERE Pnome = 'Carlos'

	SELECT * FROM FUNCIONARIO WHERE Pnome = 'Carlos'

ROLLBACK TRANSACTION;

SELECT * FROM FUNCIONARIO WHERE Pnome = 'Carlos'

-- Transaction 2.0
BEGIN TRANSACTION
	
	DECLARE @registroAfetado INT;

	UPDATE FUNCIONARIO
	SET Salario = 25000
	WHERE Pnome = 'Carlos'
	SET @registroAfetado = @@ROWCOUNT;

	if @registroAfetado > 1
	BEGIN
		ROLLBACK TRANSACTION;
		PRINT 'Alteracao nao foi bem sucedida';
	END;
	ELSE
	BEGIN 
		COMMIT TRANSACTION;
		PRINT 'Alteracao bem sucedida';
	END;

-- Aumento de 10% pro pessoal do Departamento Pesquisa
UPDATE F
SET Salario = Salario * 1.1
FROM FUNCIONARIO AS F
JOIN DEPARTAMENTO AS D ON D.Dnumero = F.Dnr
WHERE D.Dnome = 'Pesquisa';

SELECT * 
FROM FUNCIONARIO AS F
JOIN DEPARTAMENTO AS D ON D.Dnumero = F.Dnr
WHERE D.Dnome = 'Pesquisa';

-- SAVE POINT
BEGIN TRANSACTION

	INSERT INTO DEPARTAMENTO (Dnome, Dnumero) VALUES ('Marketing',88);

	SAVE TRANSACTION pt1;

	INSERT INTO DEPARTAMENTO (Dnome, Dnumero) VALUES ('Marketing2',98);

	ROLLBACK TRANSACTION pt1;
	COMMIT TRANSACTION;

SELECT * FROM DEPARTAMENTO;

-- Foi visto tambem em aula TRY e CATCH com TRANSACTION
