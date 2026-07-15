//In C. ver 2.

//Ahora utilizaremos una estructura de SynthDef para definir el reproductor de sonido.
(
SynthDef.new(\inC,{
	arg freq = 220, amp = 0.5, atk = 0.1, rel = 0.8; //Creo 4 argumentos, frecuencia y amplitud para controlar el oscilador y ataque y releas para controlar el envolvente.
	var sig, env, envGen; //Llamo 3 variables, sig para el UGen del oscilador y envGen y env para la envolvente de amplitud.

	sig = SinOsc.ar(freq: freq, mul: amp); //Aplico ambos argumentos directamente en el oscilador.
	env = Env.perc(attackTime: atk, releaseTime: rel); //La variable env tiene la creación del objeto Env con el metodo .perc que me otorga dos argumentos para controlar el tiempo de la envolvente, uno de ataque y otro de liberación.

	envGen = EnvGen.kr(envelope: env, gate: 1, doneAction: 2); //EnvGen es el UGen que genera la envolvente utilizando de modelo la variable env. Le otorgamos un valor de 1 al gate para que se active al momento de su creación.

	sig = sig * envGen; //Aplicamos la envolvente al oscilador mediante una multiplicación.

	Out.ar(0, [sig, sig]); //Por ultimo llamamos un objeto Out para mandar la señal a la salida de audio. el primer argumento correspone a la salida a la que mandará el sonido y el segundo la señal que se va a distribuir en esa salida. Para mandar una señal "estereo" genero un arreglo con la señal que quiero mandar repetida. sig!2 es otra forma de escribir lo mismo.
}).add; //El metodo add guarda el SynthDef para ser utilizado mas adelante.
)

//Probemos el SynthDef.
Synth(\inC);

//Probemos modificar sus valores de inicialización
Synth(\inC,[\freq, 330, \amp, 0.8, \atk, 2, \rel, 1]);

//Con la certeza de que SynthDef funciona crearemos la rutina del primer modulo.

(
~modulo1 = Routine({ //Almacenamos la rutina en la variable ~modulo1.
	3.do({ //como sabemos que lo que está en el modulo se repite 3 veces podemos usar el metodo .do para "iterar" sobre un solo proceso.
		arg i; //podemos llevar un registro sobre en que repetición estamos situados.
		Synth(\inC,[\freq, 60.midicps, \amp, 1, \atk, 0.01, \rel, 0.09]); //Fijate que la suma del valor de atk y rel coinciden con el de wait.
		0.1.wait;
		Synth(\inC,[\freq, 64.midicps, \amp, 1, \atk, 0.1, \rel, 0.9]);
		1.wait;
	});
});
)
~modulo1.play; //Reproducimos el modulo.

//Y los patrones?
(
~modulo1Pat = Pbind(
	\instrument, \inC, //determinamos el instrumento con el que queremos generar el evento.
	 //llamamos a las "claves" previamente definidas en el SynthDef. /freq, /amp, /atk, /rel. Para determinar la secuencia utilizamos el objeto Pseq, el cual recibe un arreglo con la secuencia de valores y un argumento indicando el numero de veces que se repite.
	\freq, Pseq([60,64].midicps, 3), //Podemos colocar un metodo al final de un arreglo para que todo el arreglo sea afectado por este ie: [60,64].midicps.
	\amp, 1, //Como la amplitud en este caso no la estoy modificando podemos utilizar un numero estático.
	\atk, Pseq([0.01,0.1],3),
	\rel, Pseq([0.09, 0.9], 3),
	// /dur es una clave por defecto de los eventos que representa la duración entre eventos. en este caso sustituye el metodo .wait.
	\dur, Pseq([0.1,1],3),
);
)
//Finalizamos almacenando la reproducción del patron en otra variable.
~streamModulo1Pat = ~modulo1Pat.play;

//Hay muchas areas de oportunidad para automatizar procesos y relacionar información (atk, rel y wait?).
//Como se podrá crear una rutina que reproduzca de forma aleatoria algunos modulos?



