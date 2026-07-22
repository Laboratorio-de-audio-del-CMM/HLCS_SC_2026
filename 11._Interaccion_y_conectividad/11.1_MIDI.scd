/*
COMUNICACIÓN MIDI EN SC

MIDI (Musical Instrument Digital Interface o Interfaz Digital de Instrumentos Musicales, en español) es un protocolo que permite la comunicación entre instrumentos musicales electrónicos, computadoras y otros dispositivos relacionados.

Fue publicado en 1983 y desde entonces tuvo muy rápida aceptación en el mundo musical y de audio digital. Actualmente MIDI es ya un estándar de comunicación para recibir y mandar datos sencillos en general. Se encuentra disponible en prácticamente cualquier DAW o lenguaje de programación de audio moderno.

Un mensaje midi se compone de información en código binario. Cada digito binario es llamado bit. 8 bits conforman un byte. Un mensaje MIDI se compone de 8 bytes.
*/


//Estructura de un mensaje MIDI:
(

var ventana, img;

img = Image.open(thisProcess.nowExecutingPath.dirname +/+ "media" +/+ "midi_bytes.jpg");

ventana = Window("Estructura de un mensaje MIDI", img.bounds + [500,500,0,0]);

UserView(ventana,ventana.view.bounds).drawFunc_({img.drawInRect(img.bounds)});

ventana.front;
);

/*
El primer byte es llamado byte de estatus y comienza con un bit con valor de 1 para comunicar esto.

Los segundos dos bytes son llamados bytes de datos y comienzan con un bit en valor de 0 para comunicarlo.

Si un bit de cada byte ya está ocupado, nos quedan 7 bits disponibles para representar valores. Si cada bit tiene dos posibles valores tenemos en total 128 combinaciones posibles para cada byte.
*/

2*2*2*2*2*2*2;
//o
2.pow(7);

//El byte de status se divide en dos: los primeros tres bits disponibles después del 1 especifican la acción

2*2*2 //Número de acciones disponibles

//Las acciones disponibles son:
(

var ventana, img;

img = Image.open(thisProcess.nowExecutingPath.dirname +/+ "media" +/+ "acciones_MIDI.png");

ventana = Window("Mensajes MIDI disponibles", img.bounds + [200,200,0,0]);

UserView(ventana,ventana.view.bounds).drawFunc_({img.drawInRect(img.bounds)});

ventana.front;
);

//Los segundos cuatro bits representan el canal al cual mandar los datos

2.pow(4); //Número de canales disponibles para envío de información

//En resumen: en MIDI tenemos diferentes tipos de mensajes, que pueden comunicarse en 128 valores a través de 16 canales.

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


\noteOn
\noteOff
\control
\touch
\polytouch
\bend
\program
\sysex
\mtcQF
\smpte
\songPosition,
\songSelect,
\tuneRequest,
\midiClock,
\sysrt,
\tick,
\start,
\continue,
\stop,
\activeSense
\reset



/*
Si queremos que SC realice acciones en respuesta a un mensaje MIDI entrante, utilizamos definiciones MIDI.

Las definiciones MIDI registran funciones a realizarse cuando se registra un mensaje MIDI entrante y se crean con la clase MIDIdef.

MIDIdef responde a los mensajes MIDI más comunes por medio de los métodos .noteOn, .noteOff, .cc, .polytouch y .bend. La lista completa de métodos se puede consultar en la ayuda de esta clase.
*/

//Para el siguiente ejemplo usemos los métodos .new y .cc, que poseen argumentos distintos

MIDIdef.new( //Método .new
	key: \ctrlNew,
	func: {{Saw.ar(Array.fill(2,{rrand(220,250)}),0.3) * Env.perc.kr(2)}.play},
	ccNum: 0,
	chan: 1,
	argTemplate: {arg val; val == 127}
);

MIDIdef.new( //Método .new
	key: \ctrlNew,
	func: {{Saw.ar(Array.fill(2,{rrand(220,250)}),0.3) * Env.perc.kr(2)}.play},
	ccNum: 0,
	chan: 1,
	argTemplate: {arg val; val == 127}
);

MIDIdef.cc( //Método .cc
	key: \ctrlCC,
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

.set
Spec
ControlSpec


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

MIDIdef.noteOff(\notesOff, {|val, num| ~phonkP[num].set(\gate,0); ~phonkP[num] = nil});




