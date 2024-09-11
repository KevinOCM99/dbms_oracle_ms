CREATE OR REPLACE FUNCTION hex_to_decimal(hex_value IN VARCHAR2) RETURN NUMBER IS
    decimal_value NUMBER;
BEGIN
    -- Convert hex string to decimal using TO_NUMBER with format 'XXXXXX'
    decimal_value := TO_NUMBER(LTRIM (hex_value, '0x'), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    RETURN decimal_value;
EXCEPTION
    WHEN OTHERS THEN
        -- Handle any conversion errors
        RAISE_APPLICATION_ERROR(-20001, 'Invalid hexadecimal input: ' || hex_value);
END;
/

SELECT hex_to_decimal('&1') AS decimal_value FROM dual;
