/*
1.3 Acciones básicas

Ahora que conocemos lo qué es SuperCollider y repasamos los elementos de su IDE, aprenderemos algunas acciones básicas que nos serán de ayuda a lo largo de nuestro proceso de aprendizaje de esta plataforma.

Evalua la linea de código de la acción básica sobre la que te gustaría saber más:
*/

//Evaluar código:
"1.3.1_Evaluar_codigo.scd".openOS;

(PathName.new(thisProcess.nowExecutingPath).parentPath+/+"1.3.1_Evaluar_codigo.scd").openOS;

//Hacer comentarios
"1.3.2_Hacer_comentarios.scd".openOS;

(PathName.new(thisProcess.nowExecutingPath).parentPath+/+"1.3.2_Hacer_comentarios.scd").openOS;

//Navegar la ayuda

"1.3.3_Navegar_la_ayuda.scd".openOS;

(PathName.new(thisProcess.nowExecutingPath).parentPath+/+"1.3.3_Navegar_la_ayuda.scd").openOS;

//Siguiente tutorial

"1.3.1_Evaluar_codigo.scd".openOS;

(PathName.new(thisProcess.nowExecutingPath).parentPath+/+"1.3.1_Evaluar_codigo.scd").openOS;

//Tutorial anterior:
"1.2.1_Conociendo_el_scIDE.scd".openOS;

(PathName.new(thisProcess.nowExecutingPath).parentPath+/+"1.2.1_Conociendo_el_scIDE.scd").openOS;







/*
1.3.3 Navegar la ayuda

SuperCollider es un inmenso territorio en el que nos perderíamos sin un mapa. Ese mapa es la ayuda, tan importante en SuperCollider que tiene su propio panel.


*/
HelpBrowser.instance



