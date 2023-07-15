function scr_ataca_player_melee(){
	
	///@arg player
	///@arg dist
	///@arg xscale
	
	var outro = argument0;
	var dist = argument1;
	var xscale = argument2;
	
	//checando se o player entrou na linha de ataque
	var player = collision_line(x, y - sprite_height/2, x + (dist * xscale), y - sprite_height/2, outro, 0, 1);

	// se o player estiver na linha ele é atacado
	if(player){
		estado = "ataque";
	}
}