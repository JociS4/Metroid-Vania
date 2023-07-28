/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor

var chao = place_meeting(x, y + 1, obj_block);
if (!chao){
	velv += GRAVIDADE * massa * global.vel_mult;
}

switch(estado){
	case "parado":
	{
		mid_velh = 0;
		timer_estado++;
		if (sprite_index != spr_slime_parado){
			
			// iniciando o que for preciso para esse estado
			image_index = 0;
		}
		
		sprite_index = spr_slime_parado;
		
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
		if (sprite_index != spr_slime_movendo){
			
			// iniciando o que for preciso para esse estado
			image_index = 0;
			mid_velh = choose(.8, -.8) * global.vel_mult;
		}
		
		sprite_index = spr_slime_movendo;
		
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
		atacando(spr_slime_ataque, 2, 4, sprite_width/2, -sprite_height/4, 1.5, 1);
		break;
	}
	
	case "dano":
	{
		
		leva_dano(spr_slime_dano, 3);
		break;
	}
	
	case "morte":
	{
		morrendo(spr_slime_morto);
		break;
	}
}