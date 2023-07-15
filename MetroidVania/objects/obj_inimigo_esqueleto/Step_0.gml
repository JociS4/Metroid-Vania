/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor

var chao = place_meeting(x, y + 1, obj_block);
if (!chao){
	velv += GRAVIDADE * massa * global.vel_mult;
}

//if (mouse_check_button_pressed(mb_right)) estado = "ataque";


switch(estado){
	case "parado":
	{
		velh = 0;
		timer_estado++;
		if (sprite_index != spr_inimigo_esqueleto_idle){
			
			// iniciando o que for preciso para esse estado
			image_index = 0;
		}
		
		sprite_index = spr_inimigo_esqueleto_idle;
		
		if(position_meeting(mouse_x, mouse_y, self)){
			if (mouse_check_button_pressed(mb_right)){
				estado = "dano";
			}
		}
		// Indo para o estado de movimento
		if(timer_estado > 300){
			estado = choose("andando", "parado", "andando");
			timer_estado = 0;
		}
		scr_ataca_player_melee(obj_player, dist, xscale);
		
		break;
	}
	
	case "andando":
	{
		
		timer_estado++;
		if (sprite_index != spr_inimigo_esqueleto_walk){
			
			// iniciando o que for preciso para esse estado
			image_index = 0;
			velh = choose(1, -1) * global.vel_mult;
		}
		
		sprite_index = spr_inimigo_esqueleto_walk;
		
		//Condição de saida de estado
		if(timer_estado > 300){
			estado = choose("parado", "andando", "parado");
			timer_estado = 0;
		}
		scr_ataca_player_melee(obj_player, dist, xscale);
		break;
	}
	
	case "ataque":
	{
		velh = 0;
		if(sprite_index != spr_inimigo_esqueleto_attack){
			image_index = 0;
			posso = true;
			dano = noone;
		}
		sprite_index = spr_inimigo_esqueleto_attack;
		
		//Saindo do estado
		
		if (image_index > image_number-1){
			estado = "parado";
		}
		
		//criando dano para o player
		if(image_index >= 8 && dano == noone && image_index < 15 && posso){
			dano = instance_create_layer(x + sprite_width/2, y - sprite_height/3, layer, obj_dano);
			dano.dano = ataque;
			dano.pai = id;
			posso = false;
		}
		
		//destruindo o dano
		if(dano != noone && image_index >= 15){
			instance_destroy(dano);
			dano = noone;
		}
		break;
	}
	
	case "dano":
	{
		velh = 0;
		if (sprite_index != spr_inimigo_esqueleto_hit){
			
			// iniciando o que for preciso para esse estado
			image_index = 0;
			//vida_atual --;
		}
		
		sprite_index = spr_inimigo_esqueleto_hit;
		
		//condição para sair do estado
		if (vida_atual > 0){
			if (image_index > image_number-1){
				estado = "parado";
			}
		}
		else {
			if (image_index >=3){
				estado = "morte";
			}
		}

		
		break;
	}
	
	case "morte":
	{
		velh = 0;
		if (sprite_index != spr_inimigo_esqueleto_dead){
			
			// iniciando o que for preciso para esse estado
			image_index = 0;
		}
		
		sprite_index = spr_inimigo_esqueleto_dead;
		
		instance_destroy(dano);
		dano = noone;
		
		//destruindo apos a morte
		if (image_index > image_number-1){
			
			image_speed = 0;
			image_alpha -= .1;
			
			if(image_alpha < 0){
				instance_destroy();
			}
		}
		
		break;
	}
}