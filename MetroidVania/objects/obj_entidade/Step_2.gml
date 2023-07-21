/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor

//passando o mid_vlh para o velh equanto não chega no limite
if(abs(velh) <= max_velh ){
	velh += mid_velh;
}
else{
	velh = 0;
}


//Sistema de Colisão e Movimentação
var _velh = sign(velh);
var _velv = sign(velv);

//Horizontal
repeat(abs(velh)){
	if(place_meeting(x + _velh, y, obj_block)){
		velh = 0;
		break;
	}
	x += _velh;
}

//Vertical
repeat(abs(velv)){
	if(place_meeting (x, y + _velv, obj_block)){
		velv = 0;
		break;
	}
	y += _velv;
}