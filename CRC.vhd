----------------------------------------------------------------------------------
-- Module Name:    CRC - COMPORTAMIENTO 
-- Project Name: Diseño Circuito Generador CRC

-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity CRC is
	GENERIC(M: INTEGER:=8;
		N: INTEGER:=4);
		
	PORT(MENSAJE: IN STD_LOGIC_VECTOR(M-1 DOWNTO 0);		--MENSAJE DE M BITS
	     POLGEN: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);			--POLINOMIO GENERADOR N BITS
	     BITSCOMP: OUT STD_LOGIC_VECTOR(N-2 DOWNTO 0);		--N-1 BITS DE COMPROBACIÓN
	     MENSBITSCOMP: OUT STD_LOGIC_VECTOR(M+N-2 DOWNTO 0));	--M BITS MENSAJE DE ENTRADA + N-1 BITS DE COMPROBACIÓN
end CRC;

architecture COMPORTAMIENTO of CRC is

begin
	PROCESS(MENSAJE, POLGEN)
		VARIABLE VAR1: STD_LOGIC_VECTOR(M+N-2 DOWNTO 0); 	--Variable donde se almacena el mensaje entero
		VARIABLE VAR2: STD_LOGIC_VECTOR(N-1 DOWNTO 0); 		--Variables de n bits
		VARIABLE VAR3: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		VARIABLE VAR4: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		
	BEGIN
		VAR1(M+N-2 DOWNTO N-1):=MENSAJE(M-1 DOWNTO 0);	--Se copia el mensaje en los bits mas significativos
		
		FOR j IN N-2 DOWNTO 0 LOOP	--Agrega los 0 necesarios dependiendo de la longitud del polinomio
			VAR1(j):='0';
			END LOOP;
			
		VAR2:=POLGEN;	--Se copia el polinomio generador
		
		VAR3:=VAR1(M+N-2 DOWNTO M-1);		--Almacenamos los bits iniciales para iniciar la comprobacion
							--(Para este caso los 4 mas significativos ya que los primeros 3 deplazamientos no puede haber un 1 en el 
							-- bit del mensaje que se compara con el bit mas significativo del polinomio)

		--Se repite el proceso por la cantidad de bits del mensaje ya que los n bits ya fueron desplazados
		FOR i IN M-1 DOWNTO 0 LOOP
			IF(VAR3(N-1)='1') THEN		--Analiza si el bit mas significativo del mensaje es 1
				VAR3:=VAR3 XOR VAR2;	--Si es asi realiza la operacion XOR										
			ELSE				--Sino continua el ciclo sin cambios
				NULL;	
			END IF;
		
		VAR4:=VAR3;
		
		VAR3(N-1 DOWNTO 1):=VAR4(N-2 DOWNTO 0);	--Se deplaza el mensaje
																	--LAS POSICIONES (2 DOWNTO 0) DE VAR4 
			IF(i=0) THEN	--En caso de que llegue al fin de ciclo
				VAR3(0):='0';	--Se agrega un 0 para rellenar la variable, pero no sera utilizado
				
				ELSE		--Sino se agrega el siguiente bit
					VAR3(0):=VAR1(i-1);
				
			END IF;
			
		END LOOP;
		--Asignamos las salidas
		BITSCOMP<=VAR3(N-1 DOWNTO 1);			--Solamente los n-1 bits mas altos de la variable 3 se usan, ya que la posicion 0 es la que rellenamos con un 0
		MENSBITSCOMP(M+N-2 DOWNTO N-1)<=MENSAJE;	--Copiamos el mensaje														--AL MENSAJE QUE SE DESEA ENVIAR
		MENSBITSCOMP(N-2 DOWNTO 0)<=VAR3(N-1 DOWNTO 1);	--y en las ultimas posiciones el CRC
																			
	END PROCESS;
														
end COMPORTAMIENTO;

