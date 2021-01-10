select * from habitante
select * from apartamento
select * from apartamento_servicios
select * from enfermedad
select * from habitante_enfermedad
------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
                                                                      CONSULTAS 1
--------------------------------------------------------------------------------------------------------------------------------------
1.- Listar cedula, nombre, apellido y sexo de las personas de sexo femenino

select id,nombre, apellido, sexo from habitante where sexo like 'f'

2- Listar los datos de los menores de 30 años

select * from habitante where fecha_nacimiento > '1990-01-01' order by fecha_nacimiento 

3.- Listar las personas que no tienen teléfono o correo electrónico.

select apellido, nombre, correo, celular from habitante where celular is null  or correo is null 

4.- Listar nombre, apellido, teléfono y correo de los jefes de familia

select nombre,apellido,celular,correo, es_jefe_familia from habitante where es_jefe_familia is true

5.- Listar sólo los datos de las personas que tengan correo de gmail.

select * from habitante where correo like '%gmail.com'

6.- Listar sólo los datos de las personas con teléfonos que no sean movilnet.

select * from habitante where celular iLIKE'%0414%' or celular iLIKE '%0412%'

7.- Listar sólo las personas que tengas teléfono y correo.

select * from habitante where celular is not null and correo is not null 

8.- Listar los datos de las personas nacidas antes del año 1976.

select * from habitante where fecha_nacimiento < '1976/01/01'

9.- Listar los datos de las personas del piso 3 ordenados por apellido y nombre.

Select * from habitante where apartamento between 301 and 304 order by (apellido, nombre) 
-------------------------------
Select x.*, a.* From habitante as x inner join apartamento as a on x.apartamento = a.numero where
a.piso = 3 order by x.apellido, x.nombre;

10.- Listar sólo nombre, apellido y sexo de los habitantes que no son jefes de familia.

select nombre,apellido,sexo, es_jefe_familia from habitante where es_jefe_familia is null

11.- Crear una consulta para agregar un nuevo registro en la tabla enfermedad.

insert into enfermedad (codigo,nombre,descripcion) values (8,'covid','dificultad_respirar');

------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
                                                    CONSULTAS 2
--------------------------------------------------------------------------------------------------------------------------------------
1.- Mostrar cantidad total de personas con enfermedades.
select count (*) as cantidad_enfermos from habitante_enfermedad 

2.- Mostrar datos de las personas nacidas entre 1970 y 1980
select * from habitante where fecha_nacimiento between '1970-01-01' and '1980-12-31' order by fecha_nacimiento;

3.- Listar datos de los jefes de familia donde el grado de instrucción esté comprendido por los valore (1, 2, o 3)
select * from habitante where es_jefe_familia is true and grado_instruccion <=3

4.- Listar la cantidad de personas que tienen celulares movilnet agrupados por sexo.
select sexo, count (celular)as personas_movilnet from habitante where celular similar to '0416%' or celular similar to '0426%' group by sexo

5.- Seleccionar nombre, apellido, apartamento, y la edad (con el alias edad), ordenados por apartamento.
select nombre, apellido, apartamento, date_part('year', age (fecha_nacimiento))::int as edad from habitante order by apartamento

6.- Seleccionar la edad promedio de los habitantes por apartamento (apartamento, promedio de edad)
select apartamento, avg(date_part('year', age (fecha_nacimiento)))::int as promedio_edad from habitante group by apartamento order by apartamento 

7.- Seleccionar los datos del habitantes con apartamentos no comprendidos en los valores (104, 204, 304, 404)
SELECT * FROM habitante WHERE apartamento NOT IN ('104', '204', '304', '404') order by apartamento 

8.- Seleccionar el monto total pagado por apartamento por concepto de servicios listados desde el que paga mas hasta el que paga menos.
select apartamento, sum (precio)as monto_total from apartamento_servicios group by apartamento order by monto_total desc

---------------------------------------------------------------------------------------------------------
-------------------------------------  CONSULTAS 3   ----------------------------------------------------
select * from habitante
select * from apartamento
select * from apartamento_servicios
select * from enfermedad
select * from habitante_enfermedad

1.- Listar nombre, apellido, edad, teléfono, grado de instrucción de los hombres con edades comprendidas entre 25 y 34 años

select nombre,apellido,(date_part('year', age (fecha_nacimiento)))::int as edad, celular, grado_instruccion,sexo
from habitante where (date_part('year', age (fecha_nacimiento)))::int  between 25 and 34 and sexo='m'

2.- Listar nombre, apellido, cantidad de servicios y monto de los habitantes que cuentan con al menos 5 servicios

SELECT n.nombre,n.apellido,count(c.servicio)as cantidad_servicios,sum(precio) as monto FROM apartamento_servicios c,habitante n where c.apartamento= 
n.apartamento GROUP BY n.nombre,apellido HAVING COUNT(*) = 5;

3.- Listar cédula, nombre, apellido, celular, enfermedad, condición y tratamiento de los habitantes que estén recibiendo tratamiento, ordenados 
por número de cédula

SELECT n.id as cedula, n.nombre,n.apellido,n.celular,c.nombre as enfermedad,nc.condicion,nc.tratamiento FROM enfermedad c,habitante_enfermedad nc,habitante n where 
c.codigo = nc.enfermedad and nc.habitante = n.id and recibe_tratamiento= true order by n.id;

4.- Listar los nombres, apellidos, edad, correo y enfermedad de los mayores 30 años  que presenten alguna enfermedad

SELECT n.nombre, n.apellido, ((current_date - n.fecha_nacimiento)/365) as edad, n.correo, c.nombre AS enfermedad FROM habitante n, habitante_enfermedad nc, 
enfermedad c  WHERE n.id = nc.habitante AND nc.enfermedad = c.codigo  AND ((current_date - fecha_nacimiento)/365) > 30 ORDER BY edad asc;

SELECT n.nombre, n.apellido, (date_part('year', age (fecha_nacimiento)))::int as edad, n.correo, c.nombre AS enfermedad FROM habitante n, habitante_enfermedad nc, 
enfermedad c  WHERE n.id = nc.habitante AND nc.enfermedad = c.codigo  AND (date_part('year', age (fecha_nacimiento)))::int > 30 ORDER BY nombre;

5.- Listar apartamento, cédula, nombre, apellido, día y mes de cumpleaños (día/mes) de la persona más joven del edificio. (SubConsulta recomendada)

SELECT n.apartamento, n.id as cedula, n.nombre, n.apellido, (extract(day from n.fecha_nacimiento) || '/' || extract(month from n.fecha_nacimiento)) AS dia_mes,
n.correo FROM habitante n WHERE (date_part('year', age (fecha_nacimiento)))::int = (SELECT MIN((date_part('year', age (fecha_nacimiento)))::int) as edad FROM habitante n);

6.- Mostrar cuanto paga cada piso por cada servicio

SELECT apartamento_servicios.servicio,  SUM (precio*piso) AS total FROM apartamento_servicios, apartamento WHERE 
	apartamento.numero = apartamento_servicios.apartamento  GROUP BY apartamento_servicios.servicio ORDER BY apartamento_servicios.servicio;

7.-Listar apartamento, cédula, nombre, apellido, mensualidad de los jefes de familia agrupados por apartamento

SELECT n.apartamento, n.id AS cedula, n.nombre, n.apellido, SUM(a_s.precio) as mensualidad FROM habitante n  INNER JOIN apartamento_servicios a_s ON 
	n.apartamento = a_s.apartamento WHERE n.es_jefe_familia = 'true' GROUP BY n.apartamento, n.id, n.nombre, n.apellido;

8.- Listar nombre, apellido, correo, apartamento, gasto mensual de los habitantes con un gasto mensual por debajo del promedio de todos los apartamentos. 
(SubConsulta recomendada)

SELECT n.nombre, n.apellido, n.correo, n.apartamento, d_b.precio FROM habitante n INNER JOIN apartamento_servicios d_b ON n.apartamento = d_b.apartamento 
WHERE d_b.precio < (SELECT AVG(precio)FROM apartamento_servicios);



