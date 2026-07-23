//Modulación.
//En terminos generales se refiere a controlar algun parametro de una señal con otra señal.

//El concepto es muy basto y las tecnicas que le inluyen tambien.
//Las mas conocidas son:
/*///////////////////////////////
//Modulación de anillo (RM)//////
//Modulación de amplitud (AM)////
//Modulación de frecuencia (FM)//
*////////////////////////////////

//En todo caso de modulación se consideran dos señales.
/*
1. Señal moduladora (mod): Quien se encarga de modificar.

2. Señal portadora (car): Quien será modificado.

**Se pueden generar arreglos muy complejos de señales modulando señales en serie -- y paralelo ||.
*/

//Revisemos antes algunos ejemplos de modulación con UGens de baja frecuencia. (LF).

//Tremolo
(
{
	var sig, mod; //Definimos dos variables, una para la señal portadora (sig) y otra para la moduladora (mod).
	mod = SinOsc.ar(10, 0, 1).range(0,1); // La señal moduladora es una onda sinoide.
	sig = Pulse.ar([110,111], mul: mod); //la señal portadora es una cuadrada.
	sig = sig * 0.1;
}.play;
);

//Vibrato
(
{
	var sig, mod;
	mod = SinOsc.ar(1,0,1).bipolar(0.5);
	sig = SinOsc.ar([220,221] * mod.midiratio);
	sig = sig * 0.1;
}.play
)


//Wah-Wah.
(
{
	var sig, mod;
	mod = SinOsc.ar(2, 0).range(0,3000);
	sig = Saw.ar([90,91]);
	sig = LPF.ar(sig, 200 + mod); //La modulación se aplica a la frecuencia de un filtro.
	sig = sig * 0.1;
}.play;
)

//El sonido del mar?
(
{
	var sig, mod;
	mod = SinOsc.ar(5.reciprocal,(3pi/2),1).range(0,1);
	sig = PinkNoise.ar(mod * 0.1);
	sig = sig!2;
}.play;
)

//¿Como se ve la Fase?
(
{
	4.collect{|i|SinOsc.ar(100, (90*i).degrad).range(0,1)};
}.plot
);

(
var x,y;
x = (90*3).degrad;
y = 3pi/2;
[x,y].postln;
)

//Cascada de modulación.
(
{
	var sig, mod1, mod2;
	mod2 = LFNoise0.kr(1).exprange(0.5,3); //mod2 modula la frecuencia de mod1.
	mod1 = SinOsc.kr(mod2, 3pi/2, 1).range(0,3000); //mod1 modula la frecuencia del LPF.
	sig = Saw.ar([110,111]);
	sig = LPF.ar(sig, 200 + mod1);
	sig = sig * 0.1;
}.play;
)

/*/////////////////////////
//Modulación de amplitud //
*//////////////////////////

//Se refiere a la modulación provocada cuando una señal moduladora (mod) afecta la amplitud de una señal portadora.

            [mod]
              |
[car : frec, amp]

//Una modulación de baja frecuencia < 20Hz provoca un efecto de "Tremolo".
//Cuando la frecuencia moduladora aumenta > 20Hz suceden modificaciones en el espectro armonico.

//AM : amplitud modulation
( //Del Tremolo al AM.
{
	var sig, mod;
	mod = SinOsc.ar(XLine.kr(1,220,10)).range(0,1);
	sig = SinOsc.ar(440) * mod;
	sig!2 * 0.3;
}.scope;
FreqScope.new;
)
//Los componentes armonicos adicionales se conocen como bandas laterales o "sidebands"

//RM : ring modulation
//Cuando el rango de modulación del modulador es de -1 a +1 es que se le llama Modulación de anillo o Ring Modulation.
(
{
	var sig, mod;
	mod = SinOsc.ar(XLine.kr(1,220,10)).range(-1,1);
	sig = SinOsc.ar(440) * mod;
	sig!2 * 0.3;
}.scope;
FreqScope.new;
)

//¿Cual es la diferencia?

//En el segundo caso, la frecuencia fundamental desaparece.

//¿Cual es la relación entre la frecuencia del modulador y la frecuencia del portador.?

//Una forma comun de trabajar con modulación es buscar expresar parametros en termino de otros.
/*
En el ejemplo siguiente la frecuencia del modulador es el resultado de multiplicar la frecuencia del portador (car) por un valor [1-20]. De esta manera ya no estamos pensando en 2 frecuencias, sino en una con un indice de cualidad.

*/
(
{
	var car, mod, freq, modFreq;

	modFreq = MouseX.kr(1,20).poll;
	freq = MouseY.kr(100,2000,1);
	mod = SinOsc.ar(freq * modFreq).range(0,1);
	car = SinOsc.ar(freq) * mod;
	car = car!2 * 0.1;
}.scope;
FreqScope.new;
)

/*//////////////////////////
//Modulación de frecuencia//
*///////////////////////////

//La FM es el producto de modular la frecuencia de una señal mediante otra señal.

          [mod : modFreq, modAmp]
            |
[car : freq + , amp]

//Ejemplo.
(
{
	var carFreq, modFreq, car, mod;

	carFreq = 220; //Frecuencia del portador.
	modFreq = XLine.kr(1, 2000, 10); //Frecuencia del modulador

	mod = SinOsc.ar(modFreq).range(110,880); //En este caso el rango de la modulación no es entre 0 y 1 sino entre dos valores en el rango de frecuencia.
	car = SinOsc.ar(carFreq + mod); //Aplicamos el modulador al portador.
	car = car!2 * 0.1;
}.play;
FreqScope.new;
)

//
(
{
	var car, carFreq;
	var mod, modFreq, modAmp;

	carFreq = 220; //frecuencia portadora estática.

	modFreq = MouseX.kr(80,2000,1); //frecuencia moduladora.
	modAmp = MouseY.kr(1, carFreq * 4, 1); //rango de modulación.
	[modFreq,modAmp].poll; //reporta valores del mouse.

	mod = SinOsc.ar(modFreq,mul: modAmp); //modulador

	car = SinOsc.ar(carFreq + mod); //portador.
	car = car!2 * 0.1;
}.play;

FreqScope.new;
)

// Indice de modulación.  (mi)
(
{
	arg cf, mf, mi;
	var car, mod;

	cf = 220;
	// mf = 440;
	mf = MouseY.kr(0, 10) * cf; //Expresamos la frecuencia de modulación en terminos de la frecuencia del portador.

	mi = MouseX.kr(0,10) * mf; //expresamos el indice de modulación en terminos de la ffrecuencia de modulación.

	mod = SinOsc.ar(mf) * mi;
	car = SinOsc.ar(cf + mod);
}.play;
FreqScope.new;
)

//El ejemplo anterior se trata de un "Operador". El bloque fundacional de lo que se conoce como FM compuesta.
//Existen varios diseños, aquí van algunos ejemplos.

/*
1. Aditivo de portadores con moduladores independientes.
2. Aditivo de portadores con un solo modulador.
3. Un portador con moduladores en paralelo.
4. Un portador con moduladores en serie.
5. Portador automodulante.
*/

//1.Aditivo de portadores con moduladores independientes.


(

~grp = Group.new;
~fxGrp = Group.after(~grp);
~fxBus = Bus.audio(s,2);
~tempo = TempoClock.new;

SynthDef(\fm, {
	arg fc1, fc2, fm1, fm2, mi1, mi2, amp, atk, rel, bus;
	var car1, car2, mod1, mod2, env, sig;

	env = EnvGen.ar(Env.perc(atk,rel),doneAction: 2);
	fm1 = fc1 * fm1;
	fm2 = fc2 * fm2;
	mi1 = fm1 * mi1;
	mi2 = fm2 * mi2;

	mod1 = SinOsc.ar(fm1) * mi1;
	mod2 = SinOsc.ar(fm2) * mi2;

	car1 = SinOsc.ar(fc1 + mod1);
	car2 = SinOsc.ar(fc2 + mod2);

	sig = car1 + car2;
	sig = sig * amp * env;
	Out.ar(0,sig!2);
	Out.ar(bus, sig!2);
}).add;

SynthDef(\fx,{
	arg in;
	var sig;
	sig = In.ar(in,2);
	sig = GVerb.ar(sig);
	sig = sig * 0.33;
	Out.ar(0,sig);
}).add;

~fxNode = Synth(
	\fx,
	args:[\in, ~fxBus ],
	target: ~fxGrp
);

~p = Pbind(
	\instrument, \fm,
	\group, ~grp,
	\dur, Plprand(0.01,0.5).round(1/16),
	\fc1, Pseq([60,62,64,67,69].midicps,inf),
	\fc2, Pshuf([60,62,64,67,69].midicps,inf) * Prand([1,0.5,2],inf),
	\fm1, Prand([2,3,5,7,11],inf),
	\fm2, Prand([2,3,5,7,11],inf) * Pwhite(0.9,1.1),
	\mi1, Pwhite(1,10),
	\mi2, Pwhite(1,10),
	\amp, Pxrand([0,-3,-6,-12].dbamp,inf),
	\atk, 0.01,
	\rel, Pkey(\dur),
	\bus, ~fxBus
);
~q = ~p.play(~tempo);
)
~tempo.tempo = 45/60;
~q.stop;


