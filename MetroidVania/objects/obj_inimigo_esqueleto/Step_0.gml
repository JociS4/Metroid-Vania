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
		mid_velh = 0;
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
			mid_velh = choose(.9, -.9) * global.vel_mult;
		}
		
		sprite_index = spr_inimigo_esqueleto_walk;
		
		//mudando a direção após colidir na parede
		if(place_meeting(x + mid_velh, y, obj_block)){
			//ivertendo mid_velh
			mid_velh *= -1;
		}
		
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
		atacando(spr_inimigo_esqueleto_attack, 8, 15, sprite_width/2, -sprite_height/3,  1.5, 1);
		break;
	}
	
	case "dano":
	{
		leva_dano(spr_inimigo_esqueleto_hit, 3);
		break;
	}
	
	case "morte":
	{
		morrendo(spr_inimigo_esqueleto_dead);
		break;
	}
}

