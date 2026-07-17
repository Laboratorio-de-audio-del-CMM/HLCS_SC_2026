/*
ORDEN DE EJECUCIÓN

Las señales tienen un flujo lineal: salen de un punto A y llegan a un punto B. La forma en la que posicionemos elementos en un flujo de señal tendrá una influencia directa en la forma en que se procesa la señal.

En SC, el flujo de señal se visualiza en el Árbol de nodos y ocurre de arriba hacia abajo. Por defecto, el proceso más reciente se posicionará por encima de los procesos previos.
*/

~fxBus = Bus.audio(s,1);

//Definición de síntesis de nuestra señal
(
SynthDef(
	\sig,
	{
		var sig;
		sig = Pulse.ar(200,mul: 0.5);
		Out.ar(~fxBus, sig);
	}
).add;
)

//Definición de síntesis de nuestro efecto
(
SynthDef(
	\fx,
	{
		var sig, freq;
		sig = In.ar(~fxBus,1)!2;
		freq = LFNoise0.kr([8, 7]).exprange(50, 2000);
		sig = sig * SinOsc.ar(freq);
		Out.ar(0, sig);
	}
).add;
)

s.plotTreeView;
Synth(\sig); //Creación del nodo de señal
Synth(\fx); //Creación del nodo de efecto

/*
Una de las formas más eficientes de adiministrar correctamente el flujo de señal es la creación de grupos.

Un grupo es un tipo de objeto que nos ayuda a organizar el flujo de señal de nuestros nodos en el servidor. Funcionan como contenedores de nodos o de otros grupos. El inicializar el servidor, un grupo por defecto llamado "default group". SC mandará todos los nodos a ese grupo por defecto.

Para crear un grupo nuevo utilizamos la clase Group y el método .new, que posee los siguientes argumentos:

1) target: un grupo o nodo de referencia que se encuentre previamente en el servidor.

2) addAction: Un symbol con la acción a realizarse. Los symbols compatibles y sus acciones derivadas pueden consultarse en la ayuda de Group

Creemos dos grupos, uno para la señal y otro para los efectos.
*/

~sigGroup = Group(target: s, addAction: \addReplace); //Remplazar el grupo por defecto por el grupo sig
~fxGroup = Group(target: ~sigGroup, addAction: \addAfter); //Remplazar el grupo por defecto por el grupo sig

//Finalmente, se puede administrar la posición de cada nodo individual con relación a los grupos o nodos previamente creados en el servidor.

//Creación del nodo de señal
(
Synth(
	defName: \sig,
	target:~sigGroup,
	addAction: \addToHead);
)

{Pulse.ar(2000,0.7)}.play(target: ~sigGroup, outbus: ~fxBus);

//Creación del nodo de efecto
(
Synth(
	defName: \fx,
	target: ~fxGroup,
	addAction: \addToHead
);
)