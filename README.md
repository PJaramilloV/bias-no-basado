# Resumen de tablas

Se tiene resumen breve de que es cada observacion de cada tabla y que atributos discernibles se pueden encontrar en cada tabla

## 1. casearrest

Cada observación consta de un cargo de arresto en forma succinta y sin detalles sobre el cargo. 
Muestra:
- Nombre de infractor/criminal
- Numero serial de caso
- id de arresto
- fecha del arresto
- grado de cargo por etiqueta
- ????????
- id del infractor/criminal

## 2. charge

Cada observación consta de un cargo criminal/infracción en detalle, la diferencia entre esta y la tabla "casearrest" es que en esta los cargos no se agrupan.

Ejemplo: hay una persona con varios cargos del mismo tipo y por ello se hizo un arresto, cargos del mismo grado se pueden agrupar para efectos de "casearrest" con un cierto limite de cargos por arresto

Muestra:
- Numero serial de caso
- Fecha de ofensa
- Nombre de infractor/criminal
- Numero de cargo impuesto sobre infractor/criminal
- grado de cargo por etiqueta
- descripcion de cargo
- fecha de registro de cargo
- tipo de registro
- agencia que realizo el registro
- dias desde analisis COMPAS
- id del infractor/criminal
- estatuto legal infringido

## 3. compas

Cada observación consta de una evaluación de un cierto tipo de metrica de COMPAS
Muestra:
- Nombre del infractor/criminal
- id del infractor/criminal en COMPAS
- id de caso COMPAS
- id de analisis COMPAS
- estado de custodia del infractor/criminal
- estado civil del infractor/criminal
- fecha de analisis COMPAS
- nivel de supervision merecido segun COMPAS
- metrica COMPAS
- puntaje en metrica
- decil al que se agrupa la metrica
- id del infractor/criminal


## 4. jailhistory

Cada observación consta del periodo de carcel visto por una persona por el crimen por el cual se realizo el analisis COMPAS (si no me equivoco).

Notar que dada la naturaleza de la base de datos TODOS los registros tienen fecha de salida, puesto que la idea del dataset es ver si la gente re-ofende criminalmente. Para ello tienen que volver a estar en libertad a lo menos 1 vez
Muestra:
- nombre del infractor/criminal
- fecha de nacimiento
- fecha de ingreso a la carcel
- fecha de salida de la carcel
- id del infractor/criminal

## 5. people

Cada observación consta de un resumen por persona sobre su historial de COMPAS.
Muestra:
- nombre del infractor/criminal
- sexo
- raza
- fecha de nacimiento
- edad
- rango de edad
- cantidad de felonias/misdemeanors/infracciones juveniles
- fecha de analisis COMPAS
- decil de riesgo de recidivismo segun COMPAS
- numero de crimienes previos al analisis COMPAS
- resta: fecha de ingreso a carcel por crimen COMPAS - fecha de analisis COMPAS
- fecha de ingreso/salida de la carcel
- numero serial de caso COMPAS
- fecha de arresto
- fecha de ofensa
- grado de cargo por el cual se realizo el analisis COMPAS
- descripcion del cargo por el cual se realizo el analisi COMPAS
- booleano: re-ofendio criminalmente? (-1 significa que no fue puesto a carcel/prision)
- numero de casos de re-ofensa
- numero serial de caso re-ofensor
- grado de caso re-ofensor
- resta: fecha de nuevo arresto - fecha de ofensa re-ofensora 
- fecha de ofensa re-ofensora
- descripcion cargo re-ofensor
- fecha de reingreso/posterior-salida a carcel
- booleano: fue el crimen-reofensor violento?
- numero serial de caso re-ofensor violento
- grado de caso re-ofensor violento
- descripcion de caso re-ofensor violento

## 6. prison history 

Cada observación consta del periodo de prision visto por una persona por el crimen por el cual se realizo el analisis COMPAS (si no me equivoco).

Notar que dada la naturaleza de la base de datos TODOS los registros tienen fecha de salida, puesto que la idea del dataset es ver si la gente re-ofende criminalmente. Para ello tienen que volver a estar en libertad a lo menos 1 vez
Muestra:
- nombre del infractor/criminal
- fecha de nacimiento
- fecha de ingreso a la prision
- fecha de salida de la prision
- id del infractor/criminal
