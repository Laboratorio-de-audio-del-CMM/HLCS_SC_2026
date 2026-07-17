/*
BUSES, SALIDAS Y ENTRADAS

Aplicar modulaciones, efectos, filtros y otros tipos de procesamientos a una señal de audio puede enriquecer y afianzar su sonido.

Si queremos efectos muy específicos para cierto sonido, quizá sea bueno integrar estos efectos en la defeinición de síntesis de dicho sonido. Sin embargo, si queremos un mismo efecto para varios sonidos, es más eficiente crear una definición de síntesis propia para el efecto.

Si ambos procesos están separados, necesitamos una forma para conectarlos. Esta es la función de un bus.

En audio digital un bus es una ubicación donde señales de auido o de control pueden ser escritas y/o leídas por procesos separados. Es una especie de "cable virtual" con el que podemos conectar procesos separados.

Los buses se inician automáticamente al iniciar el servidor.
*/

s.options.numAudioBusChannels
s.options.numControlBusChannels

//Los buses se identifican por un índice en el servidor. Los primeros buses se reservan automáticamente para nuestras salidas y nuestras entradas, respectivamente. Los buses restantes podemos usarlos para hacer conexiones internas.

(
{
	var sig, env;
	sig = Saw.ar(rrand(300,600),mul: 0.6);
	env = EnvGen.kr(Env.perc,doneAction: 2);
	sig = sig * env;
	Out.ar(1, sig)
}.play;
)

(
{
	var in, sig;
	in = In.ar(66,1);
	sig = CombC.ar(in,decaytime: 5);
	Out.ar(1, sig)
}.play;
)

/*
Sin embargo, trabajar con ídices puede ser difícil de recordar y en algunos casos, modificar nuestras conexiones de maneras inesperadas.

A fin de hacer las cosas más fáciles. Podemos gestionar nuestros buses con la clase Bus. Bus asigna buses automáticamente a los índices más bajos que no se encuentran ocupados, automatizando la asignación de buses y garantizando la compatibilidad con otros sistemas. Al ser una clase, posee la ventaja adicional de poder relacionarla a una variable, así, en lugar de índices abstractos y confusos, obtenemos buses con nombres relevantes.

Para implementar este sistema, la clase Bus requiere de un método .audio o .control dependiendo de la señal que querramos asociar a ese bus. Como argumentos solo posee el servidor, y el número de canales (cada canal ocupará un índice separado).

*/

~delBus = Bus.audio(s,1);
~delBus2 = Bus.audio(s,2);

~delBus.index;
~delBus2.index;

s.newBusAllocators; // resetea la asignación de buses

//Para interconectar señales provenientes de procesos distintos utilizando buses, utilizamos las clases In y Out.

~delBus = Bus.audio(s,1);

(
{
	var sig, env;
	sig = Saw.ar(exprand(40,80).midicps.postln,mul: 0.6);
	env = EnvGen.kr(Env.perc,doneAction: 2);
	sig = sig * env;
	Out.ar(~delBus, sig) //Out posee como argumentos el bus de salida y la señal de entrada.
}.play;
)

(
{
	var in, sig;
	in = In.ar(~delBus,1); //In posee como argumentos, el bus de entrada y el número de canales a leer.
	sig = CombC.ar(in,decaytime: 5);
	Out.ar(1, sig)
}.play;
)

/*
Si tenemos una fuente sonora (micrófono, instrumento, etc.) conectada a nuestra computadora, también es posible leer esta señal por medio de buses. Para esto utilizaremos la clase SoundIn y el método .ar

SoundIn requiere que especifiquemos el núemero de bus de entrada. Este número no guarda relación con el índice general de buses sino con el número de entradas que tengamos disponibles y hayamos habilitado. 0 es nuestra primera entrada, 1 la segunda, y así sucesivamente.
*/

~fxBus = Bus.audio(s,1);

(
{
	var sig, env;
	sig = SoundIn.ar(0,0.7);
	Out.ar(~fxBus, sig);
}.play;
)

(
{
	var in, sig;
	in = In.ar(~fxBus = Bus.audio(s,1);
,1); //In posee como argumentos, el bus de entrada y el número de canales a leer.
	sig = CombC.ar(in,decaytime: 5);
	Out.ar(1, sig)
}.play;
)

(
{
	var sig, freq;
	sig = In.ar(~fxBus,1)!2;
	freq = LFNoise0.kr([8, 7]).exprange(50, 2000);
	sig = sig * SinOsc.ar(freq);
	Out.ar(0, sig);
}.play;
)