/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor

var chao = place_meeting(x, y + 1, obj_block);
if (!chao){
	velv += GRAVIDADE * massa * global.vel_mult;
}

//maquina de esatdo

switch(estado){
	
	case "parado":
	{
		if (sprite_index != spr_boss_minotauro_parado){
			
			sprite_index = spr_boss_minotauro_parado;
			image_index = 0;
		}
		
		//checando se o player está na tela
		if(instance_exists(obj_player)){
			var _dist = point_distance(x, y, obj_player.x, obj_player.y);
			//se o player estiver perto o boss ira atras dele
			if (_dist < 300){
				estado = "movendo";
			}
		}
		break;
	}
	
	case "movendo":
	{
		if (sprite_index != spr_boss_minotauro_movendo){
			
			sprite_index = spr_boss_minotauro_movendo;
			image_index = 0;

		}
		
		//perseguir o player
		if(instance_exists(obj_player)){
			var _dist = point_distance(x, y, obj_player.x, obj_player.y);
			var _dir = point_direction(x, y, obj_player.x, obj_player.y);
			
			if(_dist > 40){
			
				//definindo velocidade
				velh = lengthdir_x(max_velh, _dir);
			}
			else{
				//chegou perto ele para e ataca
				velh = 0;
				estado = "ataque";
				
				ataque = irandom(2);
			}
		}
		
		break;
	}
	
	case "ataque":
	{
		switch(ataque){
			//primeiro ataque
			case 0:
				atacando(spr_boss_minotauro_ataque1, 2, 6, sprite_width / 2, - sprite_height / 4, 2, 2, "provocando");
				break;
			
			//segundo ataque
			case 1:
				atacando(spr_boss_minotauro_ataque2, 2, 4, sprite_width / 3, - sprite_height / 4, 3, 1, "provocando");
				break;
			//terceiro ataque
			case 2:
				atacando(spr_boss_minotauro_ataque3, 4, 9, 0, - sprite_height / 4, 5, 1, "provocando");
				break;
		}
		
		break;
	}
	
	case "dano":
	{
		leva_dano(spr_boss_minotauro_dano, 2);
		break;
	}
	
	case "provocando":
	{
		tempo_provocar --;
		
		if (sprite_index != spr_boss_minotauro_provocacao){
			
			sprite_index = spr_boss_minotauro_provocacao;
			image_index = 0;
		}
		
		//condição de saida do estado
		if (tempo_provocar <= 0){
			tempo_provocar = provocar_delay;
			estado = "parado";
		}
		break;
	}
	
	case "morte":
	{
		morrendo(spr_boss_minotauro_morte);
		
		//adicionando um screenshake
		screenshake(6);
		break;
	}
}