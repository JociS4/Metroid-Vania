/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor

//checando se o obj_transicao existe
if (instance_exists(obj_transicao)){
	exit;
}

//controlando a ivencibilidade
if(invencivel && tempo_invencivel > 0){
	tempo_invencivel --;
	image_alpha = max(sin(get_timer()/1000), 0.2);
	
}
else{
	invencivel = false;
	image_alpha = 1;
}


//Iniciando Variaveis
var right, left, jump, attack, dash;
var chao = place_meeting(x, y + 1, obj_block);

right = keyboard_check(ord("D"));
left = keyboard_check(ord("A"));
jump = keyboard_check_pressed(ord("K"));
attack = keyboard_check_pressed(ord("J"));
dash = keyboard_check_pressed(ord("L"));


//Intervalo para fazer combo
if (ataque_buff > 0){
	ataque_buff -= 10;
}

//diminuindo o dash_timer
if (dash_timer > 0){
	dash_timer--;
}

//Codigo de Movimentação
velh = (right - left) * max_velh * global.vel_mult;

//Iniciando Maquina de Estados
switch(estado){
	#region //parado
	case "parado": 
	{
		//checando se estou no chão
		if(chao){
			dash_aereo = true;
		}
		
		//parando mid_velh
		mid_velh = 0;
		
		//comportamento do estado
	
		if (sprite_index != spr_player_parado1){
			image_index = 0;
		}
		sprite_index = spr_player_parado1;
		
		//condição troca de estado

		//movendo
		if(velh != 0){
			estado = "movendo";
		}
		//pulando
		else if (jump || !chao){
			estado = "pulando";
			velv = (-max_velv * jump);
			image_index = 0;
		}
		//atacando
		else if(attack){
			inicia_ataque(chao);
		}
		//desviando
		else if(dash && dash_timer <= 0){
			estado = "rolando";
			image_index = 0;
		}
		
		break;
	}
	#endregion
	
	#region //movendo
	case "movendo":
	{

		//comportamento do estado de movimento
		if (sprite_index != spr_player_run){
			image_index = 0;
		}
		sprite_index = spr_player_run;
		
		//condição troca de estado
		//parado
		if(abs(velh) < .1){
			estado = "parado";
			velh = 0;
		}
		//pulando
		else if (jump || !chao){
			estado = "pulando";
			velv = (-max_velv * jump);
			image_index = 0;
		}
		//atacando
		else if(attack){
			estado = "ataque";
			velh = 0;
			image_index = 0;
		}
		//desviando
		else if(dash && dash_timer <= 0){
			estado = "rolando";
			image_index = 0;
		}
		
		break;
	}
	#endregion
	
	#region //pulando
	case "pulando":
	{
		
		//caindo
		if(velv > 0){
			sprite_index = spr_player_fall;
		}
		else {
			sprite_index = spr_player_jump;
			// Garantindo que a animação não se repita
			if(image_index >= image_number-1){
				image_index = image_number-1;
			}
		}
		
		//condição troca de estado
		if(attack){
			inicia_ataque(chao);
		}
		
		if (chao){
			estado = "parado";
			velh = 0;
		}
		
		//trocando de sprite se Eu toquei na parede
		var wall = place_meeting(x + sign(velh), y, obj_block);
		
		//So vou conseguir fazer isso se Estiver com o power up
		if(wall && global.power_ups[0]){
			
			//fazendo pular se estiver deslizando
			if(jump){
				
				//indo para cima
				velv = -max_velv;
				//indo para a direita
				mid_velh = (max_velh * 2) * sign(velh) * -1;
				
			}
			
			//tocando de sprite
			sprite_index = spr_player_wall;
			
			//alterando o velv quando cai
			if (velv > 1){
				velv = 1;
			}
			else {
				aplicando_gravidade();
			}
		}
		
		else {
			aplicando_gravidade();
			
			//diminuindo valor do mid_velh
			mid_velh = lerp(mid_velh, 0, 0.01);
		}
		
		//indo para o dash aereo
		//So vou conseguir fazer isso se Estiver com o power up
		if(dash && dash_aereo == true && global.power_ups[1]){
			estado = "dash aereo";
		}
		
		break;
	}
	#endregion
	
	#region //ataque
	case "ataque":
	{
		velh = 0;
		
		if(combo == 0){
			sprite_index = spr_player_ataque1;
		}
		else if (combo == 1){
			sprite_index = spr_player_ataque2;
		}
		else if (combo == 2){
			sprite_index = spr_player_ataque3;
		}
		
		//criando objeto de dano
		if (image_index >=2 && dano == noone && posso){
			dano = instance_create_layer(x + sprite_width/2, y - sprite_height/2, layer, obj_dano);
			dano.dano = ataque * ataque_mult;
			dano.pai = id;
			posso = false;
			audio_play_sound(som_ataque[0],5,false);
		}
		
		//Configurando buff
		if(attack && combo < 2){
			ataque_buff = room_speed;
		}
		
		if (ataque_buff && combo < 2 && image_index >= image_number-1){
			combo ++;
			image_index = 0;
			posso = true;
			ataque_mult += .8;
			
			finaliza_ataque();
			
			//Zerar buff
			ataque_buff = 0;
		}
		
		if(image_index > image_number-1){
			estado = "parado";
			velh = 0;
			combo = 0;
			posso = true;
			ataque_mult = 1;
			finaliza_ataque();
		}
		
		//desviando
		if(dash && dash_delay <= 0){
			estado = "rolando";
			image_index = 0;
			combo = 0;
			
			finaliza_ataque();
		}
		
		if (velv != 0){
			estado = "pulando";
			image_index = 0;
		}
		
		break;
	}
	#endregion
	
	#region //ataque aereo
	case "ataque aereo":
	{
		aplicando_gravidade();
		//checando a troca de sprite
		if(sprite_index != spr_player_ataque_ar1){
			sprite_index = spr_player_ataque_ar1;
			image_index = 0;
		}
		
		//criando objeto de dano
		if (image_index >= 1 && dano == noone && posso){
			dano = instance_create_layer(x + sprite_width/2 + velh * 2, y - sprite_height/2, layer, obj_dano);
			dano.dano = ataque;
			dano.pai = id;
			posso = false;
			audio_play_sound(som_ataque[2],5,false);
		}
		
		
		
		//saindo do estado
		if (image_index >= image_number -1){
			estado = "pulando";
			finaliza_ataque();
		}
		if(chao){
			estado = "parado";
			posso = true;
			
			finaliza_ataque();
		}
		break;
	}
	#endregion
	
	#region //ataque aereo baixo
	case "ataque aereo baixo":
	{
		aplicando_gravidade();
		velv += .5;
		velh = 0;
		if(!ataque_baixo){
			sprite_index = spr_player_ataque_ar_baixo_ready;
			image_index = 0;
			ataque_baixo = true;
			audio_play_sound(som_ataque[1],5,false);
			
		}
		
		//indo para o loop
		if(sprite_index == spr_player_ataque_ar_baixo_ready){
			//checar se passou bastante tempo da animação
			if (image_index > .07){
				sprite_index = spr_player_ataque_ar_baixo_loop;
				image_index = 0;
			}
		}
		
		//encerrando a animação
		if(chao){
			if(sprite_index != spr_player_ataque_ar_baixo_end){
				sprite_index  = spr_player_ataque_ar_baixo_end;
				image_index = 0;
				
				//criando screenshake direcional
				screenshake(8,true,270);
				
			}
			else{
				if(image_index >= image_number - .2){
					estado = "parado";
					ataque_baixo = false;
					finaliza_ataque();
				}
			}
		}
		
		//criando objeto de dano
		if (sprite_index == spr_player_ataque_ar_baixo_ready && dano == noone && posso){
			dano = instance_create_layer(x + sprite_width/2 + velh * 2, y - sprite_height/2, layer, obj_dano);
			dano.dano = ataque;
			dano.pai = id;
			dano.morrer = false;
			posso = false;
		}
		
		break;
	}
	#endregion
	
	#region //dash
	case "rolando":
	{
		if (sprite_index != spr_player_dash){
			sprite_index = spr_player_dash;
			image_index = 0;
		}
		
		//velocidade
		
		mid_velh = image_xscale * dash_vel; 
		velh = 0;
		
		//Saindo do estado
		if(image_index >= image_number-1 || !chao){
			estado = "parado";
			mid_velh = 0;
			
			//resetando o dash_timer
			dash_timer = dash_delay;
		}
		break;
	}
	
	#endregion
	
	#region //dash aereo
	case "dash aereo":
	{
		//sem sequencias de dashs seguidos
		dash_aereo = false;
		
		if (sprite_index != spr_player_dash_ar){
			image_index = 0;
			sprite_index = spr_player_dash_ar;
			
			//dando valor para o dash aereo
			dash_aereo_timer = room_speed / 4;
		}
		//diminuindo o timer
		dash_aereo_timer --;
		
		if(dash_aereo_timer <= 0){
			estado = "parado";
		}
		
		//velocidade horizontal
		velh = 0;
		
		//indo para a direção certa
		mid_velh = dash_vel * image_xscale;
		
		//velocidade vertical 
		velv = 0;
		
		break;
	}
	
	#endregion
	
	#region //dano
	case "dano":
	{
		audio_play_sound(som_dano,1,false);
		if (sprite_index != spr_player_hit){
			image_index = 0;
			
			//tremendo a tela
			screenshake(3)
			
			//ficando ivencivel
			invencivel = true;
			tempo_invencivel = invencivel_time;
		}
		sprite_index = spr_player_hit;
		
		//ficando parado ao levar dano
		velh = 0;
		
		if(vida_atual > 0){
			//saindo do estado
			if(image_index >= image_number-1){
				estado = "parado";
			}
		}
		else if(vida_atual < 1 ){
			if(image_index >= image_number-1){
				estado = "morte";
			}
		}	
		break;
	}
	#endregion
	
	#region //morrendo
	case "morte":
	{
		velh = 0;
		image_alpha = 1;
		//checando se o controlador existe
		if(instance_exists(obj_game_controller)){
			with(obj_game_controller){
				game_over = true;
			}
		}
		
		if (sprite_index != spr_player_dead){
			image_index = 0;
			
		}
		sprite_index = spr_player_dead;
		
		//ficando parado no final da animação
		if(image_index >= image_number -1){
			image_index = image_number -1;

		}
		
		if (keyboard_check_released(vk_enter)){
			game_restart();
		}
	}
	#endregion
	
	#region//Estado padrão
	default:
	{
		if(vida_atual < 1 ){
			if(image_index >= image_number-1){
				estado = "morte";
			}
		}	
		else{
			estado = "parado";
		}
	}
	#endregion
}
if (keyboard_check_released(vk_escape)){
	if(window_get_fullscreen() == false){
	    window_set_fullscreen(true);
	}
	else {
		window_set_fullscreen(false);
	}
}