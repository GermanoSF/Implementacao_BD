--PROCEDURES

CREATE PROCEDURE usp_meunome(@nome VARCHAR(45) = 'Germano')
AS
BEGIN
	PRINT @nome;
END;
--------------------------------------------------------------------
CREATE PROCEDURE usp_nomesedeps
AS 
BEGIN
	SELECT F.Pnome + ' ' + F.Unome AS 'Nome Funcionario', D.Dnome AS 'Nome Departamento'
	FROM FUNCIONARIO AS F
	INNER JOIN DEPARTAMENTO AS D ON F.Dnr = D.Dnumero
END;
--------------------------------------------------------------------
CREATE PROCEDURE usp_funcionario
WITH ENCRYPTION
AS 
BEGIN
		SELECT *
		FROM FUNCIONARIO;
END;
--------------------------------------------------------------------
CREATE PROCEDURE usp_atualizarsalario(@cpf CHAR(11),@novoSalario DECIMAL(10,2))
AS 
BEGIN	
	UPDATE FUNCIONARIO
	SET Salario = @novoSalario
	WHERE Cpf = @cpf;
	IF @@ROWCOUNT = 0    PRINT 'Ninguem com o cpf: ' + @cpf;
END;
--------------------------------------------------------------------
CREATE PROCEDURE usp_inserirFuncionario
		@pNome VARCHAR(15),  
		@uNome VARCHAR(15),
		@cpf CHAR(11)
AS
BEGIN
	if EXISTS (SELECT 1 FROM FUNCIONARIO WHERE Pnome = @pNome AND Unome = @uNome) PRINT 'ERRO: USUARIO COM NOME E SOBRENOME JA EXISTE!';
	ELSE INSERT INTO FUNCIONARIO (Pnome,Unome,Cpf) VALUES (@pNome,@uNome,@cpf);
END;
--------------------------------------------------------------------
CREATE PROCEDURE usp_InserirDepartamento
		@dNome VARCHAR(15),
		@dNumero INT,
		@local VARCHAR(15)
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM DEPARTAMENTO WHERE Dnome = @dNome) 
	BEGIN
		INSERT INTO DEPARTAMENTO (Dnome,Dnumero) VALUES (@dNome,@dNumero);
		INSERT INTO LOCALIZACAO_DEP (Dnumero,Dlocal) VALUES (@dNumero,@local);
		RETURN;
	END
	INSERT INTO LOCALIZACAO_DEP (Dnumero,Dlocal) VALUES (@dNumero,@local);
END;
--------------------------------------------------------------------
CREATE PROCEDURE usp_FuncionariosPorDep
		@departamento INT = NULL
AS 
BEGIN
	IF (@departamento IS NULL) SELECT * FROM FUNCIONARIO;
	ELSE SELECT * FROM FUNCIONARIO AS F 
		 FULL JOIN DEPARTAMENTO AS D 
		 ON F.Dnr = D.Dnumero
		 WHERE D.Dnumero = @departamento;
END;
--------------------------------------------------------------------
CREATE PROCEDURE usp_dobro(@valor AS INT OUTPUT)
AS 
BEGIN
	SELECT @valor*2;
END;
