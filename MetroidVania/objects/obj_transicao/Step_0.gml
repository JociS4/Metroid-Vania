/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor

//ja mudei de room
if (mudei){
	alpha -= .02;	
	
}
//ainda não mudei de tela
else {
	alpha += .02;
	obj_player.sprite_index = spr_player_parado1;
	obj_player.velh = 0;
	obj_player.estado = "parado";
}

//quando o alpha passar de 1, acontece a transicao de room
if(alpha >= 1){
	room_goto(destino);
	
	//posicao do player
	obj_player.x = destino_x;
	obj_player.y = destino_y;
}

//destruindo o obj_transicao depois de mudar de room
if(mudei && alpha <=0){
	instance_destroy();
}