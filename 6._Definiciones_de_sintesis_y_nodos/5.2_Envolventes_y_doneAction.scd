/*
Envolventes

Hasta ahora hemos creado sonidos que mantienen su duración indefinidamente y sólo se detienen de manera manual, pero ¿qué pasa si queremos un sonido corto que se detenga automáticamente después de 0.3 segundos?

La respuesta es utilizar una envolvente.

Una envolvente es una señal de forma y duración personalizable. Usualmente se constituye de varios segmentos conectados de inicio a fin. Su uso más común es automatizar valores de amplitud, pero puede servirnos para automatizar casi cualquier parámetro.

A la hora de controlar amplitud, una envolvente comunmente:
1. Inicia en 0
2. Sube de manera más o menos gradual a algun valor
3. Se mantiene en dicho valor por un momento
4. Regresa a 0
*/

Env.linen(1,3,1).plot;

/*
El primer segmento de esta envolvente es por convención llamado ataque (attack). El segundo se conoce como sostenimiento (sustain). El tercero se conoce como relajación (release).

Existen muchas variaciones más o menos estandarizadas de envolventes de amplitud. Siendo ADSR (attack, decay, sustain y release) la más común. Esta envolvente agrega un segmento de decaimiento (decay) entre el ataque y el sostenimiento.
*/

Env.new([0,1,0.65,0.65,0],[0.2,0.1,0.8,0.1]).plot;

//Es importante señalar que ASR y ADSR son solo convenciones de envolventes de amplitud que asemejan comportamiento de sonidos no sintéticos. Sin embargo, en el mundo electrónico, una envolvente es una señal automatizada y personalizable que puede ser usada para controlar cualquier aspecto de un algoritmo de señal.

//Envolventes de amplitud asociadas a un piano y un violín:
(
var ventana, img;
ventana = Window("Envolventes de violín y piano", Rect(200, 300, 1367.25, 420.75));
img = Image.open(thisProcess.nowExecutingPath.dirname +/+ "/media/env_piano_violin.png");

UserView(ventana,ventana.view.bounds).drawFunc_({img.drawInRect(Rect(0, 0, 1367.25, 420.75)) });

ventana.front;
);

//Envolvente aleatoria
(
var num = rrand(4, 15);
Env.new(
    Array.fill(num, { rrand(100, 800) }).postln,
    Array.fill(num - 1, { rrand(0.3, 8) }),
	Array.fill(num - 1, { rrand(-10, 10) })
).plot;
)

/*
Pero entonces, ¿Cómo incorporamos envolventes a nuestras definciones de síntesis?

Existen diferentes clases que nos permiten incorporar envolventes para controlar parámetros de generadores de unidades. Estas clases, también entran en la clasificación de generadores de unidades. Algunas de ellas son: */

Line
//Genera una señal que transiciona de manera lineal de un valor a otro
{Line.kr(start: 0, end: 1, dur: 1)}.plot(1);
{Line.kr(0,1,1)}.plot(1); //Síntaxis alternativa
{Line.kr()}.plot(1); //Síntaxis alternativa

XLine
//Genera una señal que transiciona de manera exponencial de un valor a otro.
{XLine.kr(start: 0.01, end: 10,dur: 3)}.plot(3);

//Exponencial: Dicho del crecimiento de una cantidad: De un ritmo que aumenta proporcionalmente al valor de esa cantidad.

//NOTA: Las clases que tratan con valores exponenciales deben especificar sus valores con el mísmo sígno (+ o -) y ninguno de los dos deberá ser 0. De no tomar en cuenta estas indicaciones, obtendremos un error.
{XLine.kr(start: 0,end: 3, dur: 1)}.plot(1);
{XLine.kr(start: -1,end: 3, dur: 1)}.plot(1);
{XLine.kr(start: 0.000000000001,end: 3, dur: 1)}.plot(1);

EnvGen
//Reproductor de envolventes personalizadas. Transiciona entre distintos puntos especificados por el usuario, con curvas y tiempos de transición personalizables.

//Probemos Line y XLine como envolventes de amplitud para el siguiente sintetizador:

(
SynthDef.new(
	\envRecta,
	{
		var sig, env;
		sig = Pulse.ar(440,0.4); //Generador de unidades
		env = Line.kr(start: 0,end: 0.7,dur: 5); //Line como envolvente de amplitud
		//env = XLine.kr(start: 0.01,end: 0.7,dur: 5); //XLine como envolvente de amplitud
		sig = sig * env; //Aplicación de envolvente
		Out.ar(0,sig)
		}
).play;
Stethoscope.new(numChannels: 1);
)

/*
Y ¿por qué al llegar a su último punto, la envolvente permanece ahí indefinidamente? Este es un parámetro que puede modificarse con el argumento doneAction.

El argumento doneAction define qué se hará con el nodo en el servidor una vez que un generador de unidades finito finalice su reproducción.

Las acciones disponibles y su tabla de equivalencia a números pueden consultarse en la ayuda de la clase Done.

SuperCollider usa por defecto el valor "0"  para doneAction, lo que significa que no implementa ninguna acción cuando un generador de unidades termina de reproducirse. Esto puede provocar que el nodo siga existiendo en el servidor aún sin estar sonando.
*/

(
SynthDef.new(
	\envRecta,
	{
		var sig, env;
		sig = Pulse.ar(133,0.4);
		env = Line.kr(start: 1, end: 0, dur: 5, doneAction: 0); //Envolvente con doneAction 0
		sig = sig * env;
		Out.ar(0,sig);
		}
).play;
Stethoscope.new(numChannels: 1);
NodeTreeView().start;
)

//En la práctica, el doneAction más común para envolventes es el "2", que libera el nodo correspondiente cuando una envolvente ha llegado a su último punto. Esto nos ayuda a no acumular procesos "fantasma" en nuestro servidor.

//Prueba cambiar el doneAction de la definición de arriba por 2.

/*
Line y XLine son útiles para realizar automatizaciones simples, sin embargo, el verdadero potencial de las envolventes se encuentra en las clases EnvGen y Env.

Como dijimos, EnvGen es un reproductor de envolventes personalizadas.

La envolvente en custión se genera con la clase Env.

Para generar una envolvente personalizada usamos la clase Env y el método .new

Los argumentos relevantes que tendremos a nuestra disposición serán:

1. levels: Un arreglo especificando la sucesión de puntos.

2. times: Un arreglo especificando la duración de la transiciones entre puntos.

3. curve: Un Symbol o un arreglo especificando la forma de los segmentos de la envolvente 

*/

Env.new([0.1,1,0.5],[2,4],[\sin,1]).plot;

//Para reproducir nuestra envolvente usamos la clase EnvGen. Exploremos sus argumentos más relevantes:

EnvGen.kr(envelope:, gate:, doneAction:);

EnvGen.kr(
	envelope: Env.new([0.1,1,0.5],[2,4],[\sin,1]), 
	gate: 1, 
	doneAction: 2
	);

//Un gate es una señal de control que mantiene activa una envolvente mientras su valor es positivo y activa su fase de liberación cuando pasa a 0.

//Ahora incorporemos esta envolvente a una definición de síntesis que reproduciremos inmediatamente.=
(
SynthDef.new(
	\envGenSynth,
	{
		var sig, env;
		sig = Pulse.ar(133,0.4);
		env = EnvGen.kr(
			envelope: Env.new(
				levels:[0.1,1,0],
				times:[2,4],
				curve: \sin),
			gate: 1, 
			doneAction: 2);
		sig = sig * env;
		Out.ar(0,sig);
		}
).play;
Stethoscope.new(numChannels: 1);
NodeTreeView().start;
)

//Env también recibe algunos métodos que generan envolventes de amplitud estandarizadas. Estos métodos establecen 0 como su punto de partida y de llegada. Algunos de ellos son:

//Perc
Env.perc(0.5,0.2,1,curve: \sin).test.plot;
//Triangle
Env.triangle.test.plot;
//ASR
Env.linen(0.3,1,1,0.8,\sin).test.plot;


//También posee métodos para envolventes de sostenimiento indefinido. Este tipo de envolventes permanece indefinidamente en el segmento de sostenimiento y necesita un gate = 0 para iniciar su proceso de decaimiento. Las más comunes son:

//ASR
Env.asr().plot;

//ADSR
Env.adsr().plot;

//Implementemos algunas de estas envolventes con una definición de síntesis:
(
SynthDef.new(
	\envSynth,
	{
		arg gate = 1, frec = 200, amp = 0.8;
		var sig, env;
		sig = Saw.ar(frec,amp);
		env = EnvGen.kr(
			envelope: Env.adsr(
				attackTime: 0.1,
				decayTime: 0.05,
				sustainLevel: 0.8,
				releaseTime:1,
				curve: \lin
				),
			gate: gate, 
			doneAction: 2);
		sig = sig * env;
		Out.ar(0,sig);
		}
).add;
)

(
~gateSynthP = Synth(\envSynth, [\frec, 100, \amp, 0.3]);
Stethoscope.new(numChannels: 1);
NodeTreeView().start;
)

~gateSynthP.set(\gate,0);
//Esta última línea de código es quizás la forma más eficiente de detener sonidos sostenidos con el mayor control posible, sin embargo y como vimos, requiere de una construcción detallada de definiciones de síntesis con parámetros específicos. 

//Envolvente de frecuencia:
(
SynthDef.new(
	\envSynth,
	{
		var num, sig, env;
		num = rrand(5,10);
		env = EnvGen.kr(
			envelope: Env.new(
				Array.fill(num, { rrand(100, 800) }).postln,
				Array.fill(num - 1, { rrand(0.3, 2) }),
				Array.fill(num - 1, { rrand(-10, 10) })),
			gate: 1, 
			doneAction: 2);
		sig = Saw.ar(env,0.4);
		Out.ar(0,sig);
		}
).play;
FreqScope.new(server: s,scopeColor: Color.green);
)