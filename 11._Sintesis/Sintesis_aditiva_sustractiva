
/*//////////
//Sintesis//
*///////////

/*
Consiste en la practica creativa de combinar e interconectar generadores de onda
tipicamente osciladores y generadores de ruido con el proposito de construir / componer timbres y texturas.
*/
/*//////////////////
//Sintesis aditiva./
*///////////////////

/*
Consiste en el acto de SUMAR dos o mas señales produciendo una nueva onda diferente a las originales.
Se suman los valores de sampleo de cada onda de la siguiente manera.
*/

//Suma de señales.
(
{
	var x, y, z;
	x = SinOsc.ar(2);
	y = SinOsc.ar(10) * 0.33;
	z = x + y; //SUMA
	[x,y,z]
}.plot(1)
.plotColor_([Color.red, Color.blue, Color.green])
.plotMode_(\plines)
.axisLabelX_([\SinOscX, \SinOscY, \SinOscZ])
.superpose_(true)
)
//s.

/*
La onda Sinoide funcióna como un buen bloque de construcción por la simplicidad de la onda ademas de que sabemos por el teorema de Fourier que todas las ondas periódicas se pueden expresar como la suma de ondas simples.
*/
"https://www.jezzamon.com/fourier/".openOS;

//Ejemplos de sintesis.

//Onda de diente de sierra.
//Suma de todos los armonicos con una apmlitud de 1/n.
(
{
	var sig;
	sig = 10.collect({
		arg i;
		var freq = 1;
		SinOsc.ar(freq * (i+1), mul: 1/(i+1));
	});
	sig ++ sig.sum;
}.plot(1)
.plotMode_(\plines)
.superpose_(true);
)

{Saw.ar(10)}.plot(1);
{LFSaw.ar(1)}.plot(1);

//Onda Cuadrada.
(
{
	var sig;
	sig = 10.collect({
		arg i;
		var freq = 1;
		SinOsc.ar(freq * (i+1), mul: 1/(i+1));
	});
	sig ++ sig.sum;
}.plot(1)
.plotMode_(\plines)
.superpose_(true);
)


10.collect

Mix.Fill

Mix

Klang
DynKlang

Splay

//Sintesis sustractiva

WhiteNoise

PinkNoise

Filtros



