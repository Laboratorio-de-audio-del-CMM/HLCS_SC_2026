/*
ALEATORIEDAD

Los valores aleatorios pueden ser de mucha utilidad a la hora de crear sonido. 

En SC existen diferentes maneras de crear valores aleatorios. Algunos de los más comunes son:

1. El método rrand
Devuelve un valor aleatorio dentro de un rango especificado. Cada valor en el rango tiene las mismas probabilidades de ser seleccionado.
*/

rrand(2,100); //Si los valores que especifican el rango son enteros, el resultado también lo será. 

rrand(2,100.0);//Si cualquiera de los valores tiene decimales, el resultado también los tendrá.

/*
2. El método .exprand
Similar a rrand (arroja un valor aleatorio dentro de un rango especificado) pero hay más probabilidades de que salga un valor bajo.

Este método siempre arroja números con valores decimales. Los dos valores tienen que ser del mismo signo (+ o -) y ninguno puede ser 0.
*/

exprand(0.0001,1000);
exprand(0,1000); //Error
exprand(-1000,1000); //Error

/* 
3. El método .choose
También podemos especificar un arreglo de valores y usar el método .choose, que eligirá un valor aleatorio de entre aquellos que conforman nuestro arreglo.
*/

[5,10,15,20,25,30,35,40,45,50,55].choose;

/*
4. El método .wchoose 
.wchoose hará algo similar a .choose, sin embargo, en él podemos especificar a manera de arreglo, las probabilidades de selección de cada elemento. 
*/

[\rojo, \amarillo, \azul, \rosa].wchoose([0.3,0.1,0.5,0.1]); //La suma de todas las probabilidades debe dar como resultado 1

[\rojo, \amarillo, \azul, \rosa].wchoose([140,200,540,300].normalizeSum); //Alternativamente podemos usar valores aproximados y  el método .normalizeSum

//El método .normalizeSum realiza la operación [array]/[array].sum, de forma que la suma de todos los elementos del arreglo sea 1.
[140,200,540,300] / [140,200,540,300].sum

//Una consideración final: al generar areglos de valores aleatorios, debe cuidarse la sintaxis a utilizarse. 

rrand(0.8,10)!10 //Esto generará un array con 10 elementos de un único número aleatorio 

{rrand(0.8,10)}!10 //Esto generará un array con 10 elementos aleatorios