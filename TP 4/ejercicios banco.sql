DELIMITER $$
CREATE PROCEDURE VerCuentas()
BEGIN
    SELECT numero_cuenta, saldo
    FROM cuentas;
END$$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE CuentasConSaldoMayorQue(IN limite DECIMAL(10,2))
BEGIN
    SELECT numero_cuenta, saldo
    FROM cuentas
    WHERE saldo > limite;
END$$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE TotalMovimientosDelMes(IN p_cuenta INT, OUT p_total DECIMAL(10,2))
BEGIN
    SELECT IFNULL(SUM(
        CASE
            WHEN tipo = 'CREDITO' THEN importe
            WHEN tipo = 'DEBITO' THEN -importe
            ELSE 0
        END
    ), 0.00)
    INTO p_total
    FROM movimientos
    WHERE numero_cuenta = p_cuenta
      AND MONTH(fecha) = MONTH(CURDATE())
      AND YEAR(fecha) = YEAR(CURDATE());
END$$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE Depositar(IN p_cuenta INT, IN p_monto DECIMAL(10,2))
BEGIN
  
    IF p_monto > 0 THEN
        INSERT INTO movimientos (numero_cuenta, fecha, tipo, importe)
        VALUES (p_cuenta, CURDATE(), 'CREDITO', p_monto);
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El monto a depositar debe ser positivo.';
    END IF;
END$$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE Extraer(IN p_cuenta INT, IN p_monto DECIMAL(10,2))
BEGIN
    DECLARE v_saldo_actual DECIMAL(10,2);

   
    SELECT saldo INTO v_saldo_actual
    FROM cuentas
    WHERE numero_cuenta = p_cuenta;

   
    IF p_monto > 0 AND v_saldo_actual >= p_monto THEN
        INSERT INTO movimientos (numero_cuenta, fecha, tipo, importe)
        VALUES (p_cuenta, CURDATE(), 'DEBITO', p_monto);
    ELSEIF p_monto <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El monto a extraer debe ser positivo.';
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Fondos insuficientes para la extracción.';
    END IF;
END$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER tr_actualizar_saldo
AFTER INSERT ON movimientos
FOR EACH ROW
BEGIN
    DECLARE v_monto_a_actualizar DECIMAL(10,2);
    IF NEW.tipo = 'CREDITO' THEN
        SET v_monto_a_actualizar = NEW.importe;
    ELSEIF NEW.tipo = 'DEBITO' THEN
        SET v_monto_a_actualizar = -NEW.importe;
    END IF;
    UPDATE cuentas
    SET saldo = saldo + v_monto_a_actualizar
    WHERE numero_cuenta = NEW.numero_cuenta;
END$$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER tr_actualizar_saldo_y_historial
AFTER INSERT ON movimientos
FOR EACH ROW
BEGIN
    DECLARE v_saldo_anterior DECIMAL(10,2);
    DECLARE v_saldo_actual DECIMAL(10,2);
    DECLARE v_monto_a_actualizar DECIMAL(10,2);

    /* 1. Obtenemos el saldo ANTES de la operación */
    SELECT saldo INTO v_saldo_anterior
    FROM cuentas
    WHERE numero_cuenta = NEW.numero_cuenta;

    /* 2. Calculamos el monto y el nuevo saldo */
    IF NEW.tipo = 'CREDITO' THEN
        SET v_monto_a_actualizar = NEW.importe;
    ELSEIF NEW.tipo = 'DEBITO' THEN
        SET v_monto_a_actualizar = -NEW.importe;
    END IF;
    
    SET v_saldo_actual = v_saldo_anterior + v_monto_a_actualizar;

    /* 3. Actualizamos el saldo en la tabla cuentas */
    UPDATE cuentas
    SET saldo = v_saldo_actual
    WHERE numero_cuenta = NEW.numero_cuenta;

    /* 4. Registramos en el historial  */
    INSERT INTO historial_movimientos 
        (numero_cuenta, numero_movimiento, saldo_anterior, saldo_actual)
    VALUES 
        (NEW.numero_cuenta, NEW.numero_movimiento, v_saldo_anterior, v_saldo_actual);
END$$
DELIMITER ;
