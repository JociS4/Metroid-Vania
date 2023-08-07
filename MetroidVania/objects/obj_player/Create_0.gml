/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor

randomize();

//Criando camera
var can = instance_create_layer(x, y, layer,obj_camera);
can.alvo = id;


// Inherit the parent event
event_inherited();




som_ataque = [snd_ataque1_player, snd_ataque2_player, snd_ataque3_player];
som_dano = snd_dano_player;
som_morte = snd_morte_player;

vida_max = 5;
vida_atual = vida_max;

max_velh = 4;
max_velv = 7;
dash_vel = 8;

mostra_estado = false;

combo = 0;
dano = noone;

ataque = 1;
posso = true;

ataque_mult = 1;
ataque_buff = room_speed;

ataque_baixo = false;

invencivel = false;
invencivel_time = room_speed * 2;
tempo_invencivel = invencivel_time;

dash_aereo_timer = 0;
dash_aereo = true;

dash_delay = room_speed * 2;
dash_timer = 0;




//controle de power ups
//Power ups [pular deslizando, dash aereo, ataque aereo para baixo]
global.power_ups = [false, false, false];

//metodo para iniciar o ataque
///@method inicia_ataque(chao)
inicia_ataque = function(chao){
	if(chao){
		estado = "ataque";
		velh = 0;
		image_index = 0;
	}
	// não estou no chão
	else{
		if(keyboard_check(ord("S"))  && global.power_ups[2]){
			estado = "ataque aereo baixo";
			velh = 0;
			image_index = 0;
		}
		else{
			estado = "ataque aereo";
			image_index = 0;
		}
	}

}

finaliza_ataque = function(){
	posso = true;
	if(dano){
		instance_destroy(dano, false);
		dano = noone;
	}
}



//Aplicando Gravidade
aplicando_gravidade = function(){
	var chao = place_meeting(x, y + 1, obj_block);
	if (!chao){
		if (velv < max_velv * 2){
			velv += GRAVIDADE * massa * global.vel_mult;
		}
	}
}