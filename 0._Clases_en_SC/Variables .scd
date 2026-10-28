//SC.

/*/////////////////////////
//Variables y argumentos.//
*//////////////////////////

//Una variable es un contenedor que nos permite almacenar un instancia de un "OBJETO" y referirnos a el.

//3 tipos de variables.

///*Del interpretador*///

//Todas las letras del abcdário a excepción de la "s" pueden ser utilizadas como variable.
//estas no son perecederas y se pueden sobreescribir.
//Ejemplo:

x = 5;
x;

x = [0,1,2,3,4,5];
x.at(0);

x = 10.rand;
x; //A que es igual x?

///*Local*///

//Solo guardan información dentro de un "contexto()" y son perecederas.
//Se declaran con "var"
//Ejemplo:
(
var x;
x = [0,1,2,3,4].choose;
x = x * 10;
x.postln;
)

x; //"x" y "var x" son diferentes.

///*Global*///
~x = "Esto es una variable Global";

~x.scramble;
~x;






