/*
COMUNICACIÓN MIDI EN SC

El protocolo de comunicación MIDI (Musical Instrument Digital Interface o Interfaz Digital de Instrumentos Musicales en español) fue publicado en 1983 y fué rápidamente adoptado por el mundo musical y de audio digital. Actualmente es un estándar de la comunicación para recibir y mandar datos en general y se encuentra disponible en prácticamente cualquier DAW o lenguaje de programación de audio moderno.

Debido a su diseño, un mensaje de este tipo puede representar valores del 0 al 127 (128 valores). Por lo tanto hay 128 notas MIDI disponibles, 128 valores de velocidad (intensidad), 128 instrumentos, etc. 

MIDI es un protocolo efectivo para el audio en tiempo real debido a su relativamente baja resolución.
*/

//Para mapear MIDI en SC primero tenemos que establecer conexión con el subsistema MIDI de nuestra computadora. Para esto usaremos la clase MIDIClient y el método .init , lo cual nos dará además una lista de los dispositivos MIDI conectados a nuestra computadora. 
MIDIClient.init;

/*
Para conectar un dispositivo primero debemos decidir qué queremos hacer con él.

Si lo que queremos es recibir mensajes MIDI usamos la clase MIDIIn. 

Si lo que queremos es mandar mensajes MIDI usamos la clase MIDIOut

Veamos ambas posibilidades:

1) Recibir mensajes MIDI
Para conectar todos los dispositivos usaremos el método .connectAll.
*/
MIDIIn.connectAll;

//Para conectar selectivamente un dispositivo, usaremos su índice dentro del arreglo de MIDIClient.sources
MIDIClient.sources;

MIDIClient.sources.at(0);
MIDIClient.sources.at(1);
MIDIClient.sources[2];

MIDIIn.connect(device: MIDIClient.sources[2].postln);

//Una vez conectado algun dispositivo podemos comprobar y monitorear si estamos recibiendo mensajes MIDI:
MIDIFunc.trace(true); //Activa la impresión de los datos MIDI recibidos en la ventana de posteo.
MIDIFunc.trace(false);//Desactiva la impresión de los datos MIDI recibidos en la ventana de posteo.

//Para desconectar todos los dispositivos o alguno en específico utilizamos la misma sintaxis que usamos para conectarlos, unicamente sustituyendo los métodos .connectAll y .connect por .disconnectAll y .disconnect
MIDIIn.disconnectAll;
MIDIIn.disconnect(device: MIDIClient.sources[2].postln);

/* 
Si queremos que SC realice acciones en respuesta a un mensaje MIDI entrante, utilizaremos definiciones MIDI.

Las definiciones MIDI registran funciones a realizarse cuando se registra un mensaje MIDI entrante y se crean con la clase MIDIdef, la cuál responde entre otros, a los métodos .noteOn, .noteOff, .cc

Debemos identificar el tipo de mensaje MIDI que queremos usar (para esto puede ser buena idea usar MIDIFunc.trace(true)). Para este ejemplo utilizaramos mensajes del tipo Control Change (CC).
*/

MIDIdef.cc( //Método .cc
	key: \controlador,
	func: {{Saw.ar(Array.fill(2,{rrand(220,250)}),0.3) * Env.perc.kr(2)}.play},
	ccNum: 0,
	chan: 1, 
	argTemplate: {arg val; val == 127}
);

//El siguiente sintetizador posee varios parámetros modulables, para el ejemplo escogeremos la frecuencia base (expresada en números MIDI) y la frecuencia moduladora(expresada en HZ):

(
SynthDef(\phonk, {
	arg midiNote = 60, amp = 0.4, modFreq = 5, gate = 1;
	var env, sig, sig1, sig2, sig3, offsets, mod, rev;

	env = Env.asr().kr(2,gate);

	offsets = [ -0.4, 0, 0.4];

	mod  = SinOsc.ar(modFreq).range(0,1);

	sig1 = offsets.collect{ |off|
		Saw.ar((midiNote - 5).midicps + off, mod )};

	sig2 = offsets.collect{ |off|
		Saw.ar((midiNote - 12).midicps + off, mod)};

	sig3 = Saw.ar(midiNote.midicps, mod);

	sig = (sig1 + sig2 + sig3) * env * amp;

	rev = FreeVerb.ar(sig,0.5);

	Out.ar(0,rev!2);

}).add
)

~phonkP = Synth(\phonk); //Prender el sintetizador
~phonkP.set(\gate,0);//Apagar el sintetizador


/*Escogeremos un rango de valores para mapear a su equivalente a 0 a 127. En este caso utilizaremos los números MIDI del 36 al 95  (5 ocatvas) para la fecuencia base y 0 a 20 la frecuencia modulatoria

0 a 127 = 36 a 95 para fecuencia base
0 a 127 = 0 a 20 para la frecuencia modulatoria

Posteriormente crearemos un bus de control que conendrá los parámetros arrojados por nuestro mapeo MIDI.
Opcionalmente también se puede asignar un valor por default
*/

~note = Bus.control(s,1); //Creación del bus
~note.set(60); //Valor por defecto

~freqMod = Bus.control(s,1);
~freqMod.set(5);


//Procedemos a moificar el sintetizador para aceptar buses de control con la classe In.kr

(
SynthDef(\phonk, {
	arg amp = 0.4, gate = 1;
	var env, sig, sig1, sig2, sig3, offsets, mod, rev, midiNote, modFreq;

	midiNote = In.kr(~note);
	modFreq = In.kr(~freqMod);

	env = Env.asr().kr(2,gate);

	offsets = [ -0.4, 0, 0.4];

	mod  = SinOsc.ar(modFreq).range(0,1);

	sig1 = offsets.collect{ |off|
		Saw.ar((midiNote - 5).midicps + off, mod )};

	sig2 = offsets.collect{ |off|
		Saw.ar((midiNote - 12).midicps + off, mod)};

	sig3 = Saw.ar(midiNote.midicps, mod);

	sig = (sig1 + sig2 + sig3) * env * amp;

	rev = FreeVerb.ar(sig,0.5);

	Out.ar(0,rev!2);

}).add
)

~phonkP = Synth(\phonk); //Prender el sintetizador
~phonkP.set(\gate,0);//Apagar el sintetizador

//Para finalizar, agregaremos un objeto MIDIdef para mapear nuestros valores y reflejarlos en el bus de control.

/*El método  .cc responde a mensajes de control MIDI, (más adelante veremos cómo repsonder a mensajes noteOn y note Off)

Los argumentos de MIDIdef.cc son
1.Nombre
2.Función que responderá a los valores entrantes
3.Número de Control Change que leerá
4.Canal que se leera
5.srcID: Entreada MIDI que se leera
6.Función opcional que indica si los valores cumplen cierta condición para que la función principal se ejecute.

Los príncipales y más útiles son 1,2,3 y 4. Los demás pueden omitirse en este ejercicio.
*/

MIDIdef.cc(\note, { },ccNum: 93, chan: 0);

MIDIdef.cc(\note, { |val| ("Nota MIDI ").post; ~note.value_(val.linlin(0,127,36,95).asInteger.postln)},ccNum: 93, chan: 0);

MIDIdef.cc(\freqMod, { |val| ("Frecuencia de modulación ").post; ~freqMod.value_(val.linlin(0,127,0,20).asInteger.postln)},ccNum: 18, chan: 0);


//////////////////////////////MAPEO DE NOTAS MIDI /////////////////////
//Para mapear las notas de un controlador a notas MIDI, usaremos un sintetizador adaptado y la clase MIDIdef.noteOn y MIDIdef.noteOff

(
SynthDef(\phonk, {
	arg amp = 0.4, gate = 1, midiNote = 60;
	var env, sig, sig1, sig2, sig3, offsets, mod, rev, modFreq;

	modFreq = In.kr(~freqMod);

	env = Env.asr().kr(2,gate);

	offsets = [ -0.4, 0, 0.4];

	mod  = SinOsc.ar(modFreq).range(0,1);

	sig1 = offsets.collect{ |off|
		Saw.ar((midiNote - 5).midicps + off, mod )};

	sig2 = offsets.collect{ |off|
		Saw.ar((midiNote - 12).midicps + off, mod)};

	sig3 = Saw.ar(midiNote.midicps, mod);

	sig = (sig1 + sig2 + sig3) * env * amp;

	rev = FreeVerb.ar(sig,0.5);

	Out.ar(0,rev!2);

}).add
)

~phonkP = Array.newClear(128);

MIDIdef.noteOn(\notesOn, {|val, num| ~phonkP[num] = Synth(\phonk,[\midiNote, num, \amp, val.linlin(0,127,0.1,0.8)])});

MIDIdef.noteOff(\notesOff, {|val, num| ~phonkP[num].set(\gate,0)});




