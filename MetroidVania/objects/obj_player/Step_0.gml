/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor

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

//Aplicando Gravidade
if (!chao){
	if (velv < max_velv * 2){
		velv += GRAVIDADE * massa * global.vel_mult;
	}
}

//Codigo de Movimentação
velh = (right - left) * max_velh * global.vel_mult;

//Iniciando Maquina de Estados
switch(estado){
	#region //parado
	case "parado": 
	{
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
		else if (jump || velv != 0){
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
		else if(dash){
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
		else if (jump || velv != 0){
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
		else if(dash){
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
		if (chao){
			estado = "parado";
			velh = 0;
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
			if(dano){
				instance_destroy(dano, false);
				dano = noone;
			}
			//Zerar buff
			ataque_buff = 0;
		}
		
		if(image_index > image_number-1){
			estado = "parado";
			velh = 0;
			combo = 0;
			posso = true;
			ataque_mult = 1;
			if(dano){
				instance_destroy(dano, false);
				dano = noone;
			}
		}
		
		//desviando
		if(dash){
			estado = "rolando";
			image_index = 0;
			combo = 0;
			if(dano){
				instance_destroy(dano, false);
				dano = noone;
			}
		}
		
		if (velv != 0){
			estado = "pulando";
			image_index = 0;
		}
		
		break;
	}
	#endregion
	
	#region //dash
	case "rolando":
	{
		if (sprite_index != spr_player_dash){
			image_index = 0;
		}
		sprite_index = spr_player_dash;
		
		//velocidade
		
		velh = image_xscale * dash_vel; 
		
		//Saindo do estado
		if(image_index >= image_number-1){
			estado = "parado";
		}
		//pulando
		if(velv != 0){
			estado = "pulando";
			image_index = 0;
		}
		
		break;
	}
	
	#endregion
	
	#region // dano
	case "dano":
	{
		if (sprite_index != spr_player_hit){
			image_index = 0;
			
			//tremendo a tela
			screenshake(3)
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
	
	case "morte":
	{
		velh = 0;
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
	}
	
	//Estado padrão
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
}

if (keyboard_check(vk_enter)) game_restart();