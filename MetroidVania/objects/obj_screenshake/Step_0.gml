/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor

//tremendo
view_xport[0] = irandom_range(-shake, shake);
view_yport[0] = irandom_range(-shake, shake);

shake *= .9;

//destruindo
if(shake <= .2){
	instance_destroy();
}


