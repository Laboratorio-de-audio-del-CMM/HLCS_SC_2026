//Ejercicio inC.
/*
A continuación proponemos un modelo con el cual resolver el ejercicio de inC del compositor Terry Riley.
*/

//1. Primero debemos definir un generador de sondido con la posibilidad de cambiar su altura.

(
~f = { //Guardamos la función en una variable global "~f"
	arg freq = 440; //definimos un argumento llamado freq con un valor predeterminado "440".
	SinOsc.ar(freq); //Llamamos un UGen capaz de producir sonido, SinOsc en este caso. Puedes usar otros.
}

);
//Recuerda evaluar la función anterior con el comando |cmd + ENTER| para evaluar el bloque completo.

//Resolvamos el modulo 1. de la partitura, la cual se encuentra en el repositorio.
~c = ~f.play(args: [freq: 220]);
~c.set(\freq,330);
~c.release(1);
~c.free

//1.
(
~r = Routine({ //Para secuenciar una serie de eventos utilizamos el objeto "Routine"
	~c = ~f.play(args: [freq: 60.midicps]); //Asignamos a una nueva variable "~c" la ejecución de la función "~f". incluimos lo siguiente: ".(args: [freq: 60.midicps])" para cambiar el valor de inicialización de la función. | El valor de la frecuencia lo indico en numero midi pero lo convierto a Hz mediante el metodo .midicps.
	0.1.wait; //Las rutinas utilizan el metodo .wait para retrazar la ejecución de comandos.
	~c.set(\freq, 64.midicps); //Utilizamos sobre la variable "~c" el metodo ".set" para modificar un valor de la función en ejecución. Indentificamos el argumento llamandolo con una diagonal antes del texto "\freq"
	1.wait; //Volvemos a emplear el metodo .wait
	~c.free; //el metodo .free "libera" la ejecución del sintetizador, deteniendo el sonido.
	//Podemos utilizar el metodo .release(1) para detener el sonido de forma gradual, tomando en cuenta que esto toma tiempo!

	//Ya que realizamos un evento del modulo 1. solo hay que copiar y pegar la secuencia anterior otras 2 veces.
	~c = ~f.play(args: [freq: 60.midicps]);
	0.1.wait;
	~c.set(\freq, 64.midicps);
	1.wait;
	~c.free;

	~c = ~f.play(args: [freq: 60.midicps]);
	0.1.wait;
	~c.set(\freq, 64.midicps);
	1.wait;
	~c.free;
});
)

//Al evaluar el bloque anterior solo habremos creado la rutina, ahora hay que ejecutarla.

~r.play; //Evaluando el siguiente codigo.

//Prueba realizar alguno de los otros 53. modulos.