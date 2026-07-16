
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
//Suma de todos los armonicos con una amplitud de 1/n.
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

//Versiones UGen
{Saw.ar(10)}.plot(1);
{LFSaw.ar(1)}.plot(1);

//Onda Cuadrada.
//Suma todos los armonicos inpares con una amplitud de 1/n inpar.

(
{
	var sig;
	sig = 100.collect({
		arg i;
		var freq = 1;
		i = (i*2) + 1;
		SinOsc.ar(freq * i, mul: 1/i);
	});
	sig ++ sig.sum;
}.plot(1)
.plotMode_(\plines)
.superpose_(true);
)

//Versiones UGen
{Pulse.ar(10)}.plot(1);
{LFPulse.ar(10)}.plot(1);

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

//Ejemplos con sonido y el metodo .do

(
{
	var sig = 0; //Sig tiene que ser igual a 0 al inicio para poder sumarse a sí mismo.
	var freq = Array.geom(5,100,2); //Creamos un arreglo con el metodo .geom

	freq.do({ //Tomamos el arreglo e iteramos sobre los valores de este.
		arg it, in; //El primer argumento es el elemento y el segundo el indice.
		sig = sig + SinOsc.ar(it, mul: (in+1).reciprocal) * -3.dbamp; //Dado que la variable sig fue definida fuera de la iteración, podemos conservar la suma de cadaa iteración.
	});

	sig = sig!2;
}.scope;
)

//Ejemplos con sonido y el metodo .collect

/*//////////
//.collect//
*///////////
//similar a .do pero en lugar de entregar como resultado a si mismo, entrega un arreglo que resulta de la función.
~x = 10.collect({arg i; i.postln});
~x;

//Sobre arreglos igual contempla dos argumentos.
~x = [100,200,300,400,500].collect({arg it, in; [it,in].postln});
~x;

(
{
	var sig;  //ahora sig va a resultar en un arreglo.
	var freq = Array.rand(10,60,72).midicps;
	sig = freq.collect({
		arg it, in;
		SinOsc.ar(it, mul: (in+1).reciprocal * -12.dbamp);
	});
	sig.postln;
	sig = sig.sum; //el metodo .sum sobre un arreglo suma todos los valores contenidos. [1,1,1,1,1].sum;
	sig = sig!2;
}.scope
);

//Mix.fill
(
{
	var sig;
	var freq = Array.rand(10,0,12); //creamos un arreglo de frecuencias en MIDI.0-12.

	sig = Mix.fill(10, {
		arg i; //al igual que Array.fill, mix tiene un argumento i.
		var f = freq[i] + ((i + 3) * 12); //tomamos el valor i del arreglo.
		SinOsc.ar(f.midicps) * 10.reciprocal * -6.dbamp;
	});
	sig.postln;
	sig!2;
}.scope;
);

//Expansión Multicanal.

(
{
	var sig;
	var freq = Array.rand(10,0,12);
	Mix.fill(10,{
		arg i;
		var f = freq[i] + ((i + 3) * 12);
		SinOsc.ar(
			{f.midicps * Rand(0.9,1.1)}!2 //Utilizamos una función para expresar que el contenido dentro se va a ejecutar 2 veces.
		) * 10.reciprocal * -6.dbamp;
	});
}.scope;
)

//Algunos UGens para sintesis aditiva.

//Blip.
(
{
	var sig, mod;
	mod = SinOsc.kr(0.1, {Rand(0,pi)}!2).range(1,200);
	sig = Blip.ar(freq: 220, numharm: mod);
}.scope;
)

//Klang
//Ref
Ref
//Previene expansión multicanal.
(
{
	var sig, ref;
	ref = Ref.new([
		[1,2,3,4,5]*100,
		[1,2,3,4,5].normalizeSum,
		{Rand(0,2pi)}!5
	]);
	sig = Klang.ar(specificationsArrayRef: ref, freqscale: 1.0.rand);
	sig!2 * -6.dbamp;
}.scope
)

//DynKlang
DynKlang

`[].class;

(
{
	var ref;
	var iter = 5;
	ref = `[
		Array.rand(iter, 100, 200),
		Array.rand(iter, -12.dbamp,-3.dbamp) * iter.reciprocal,
		Array.interpolation(iter,0,2pi);
	];

	DynKlang.ar(ref, SinOsc.kr({rrand(0.4,0.5)}!2, {rrand(0,pi)}!2).range(0.5,16));
}.scope;
)

//Splay
Splay
(
{
	var sig, freq;
	//freq = Array.fill(12, {arg i; (i + 0.25.rand + 72).midicps});
	freq = Scale.choose(7).degrees + 60 + 0.25.rand;
	freq = freq.midicps;
	sig = freq.collect({
		arg it, in;
		SinOsc.ar(it) * SinOsc.kr(freq: {rrand(0.1,0.3)}, phase: (in/11 * 2pi).postln).range(0,1);
	});
	sig = Splay.ar(sig, spread: 1) * -3.dbamp;
}.scope;
)

//Sintesis sustractiva

WhiteNoise

PinkNoise

Filtros



