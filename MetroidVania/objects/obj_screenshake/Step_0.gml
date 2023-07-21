/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor

if(!dir_mode){
	
	//tremendo
	view_xport[0] = irandom_range(-shake, shake);
	view_yport[0] = irandom_range(-shake, shake);

	shake *= .9;

	//destruindo
	if(shake <= .2){
		instance_destroy();
	}
}
else{
	if(!voltar){
		//descobrir para onde mover
		var _x = lengthdir_x(shake, dir);
		var _y = lengthdir_y(shake, dir);

		view_xport[0] = _x;
		view_yport[0] = _y;
		
		voltar = true;
	}
	else {
		view_xport[0] = lerp(view_xport[0], 0, .5);
		view_yport[0] = lerp(view_yport[0], 0, .5);
		
		var _xport = abs(view_xport[0]);
		var _yport = abs(view_yport[0]);
		
		if (_xport <= 1 && _yport <=1){
			instance_destroy();
		}
	}
	
}
