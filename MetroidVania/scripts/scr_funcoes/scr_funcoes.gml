// Os recursos de script mudaram para a v2.3.0; veja
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para obter mais informações
function scr_funcoes(){
	
	
}

global.dificuldade = 1;

//enumerator para definir ações possiveis
enum menu_acoes{
	roda_metodo,
	carrega_menu,
	ajustes_menu
}

enum menu_lista{
	principal,
	opcoes,
	tela,
	dificuldade
}


//screenshake
///@function  screenshake(valor_da_tremida)
///@arg forca_da_tremida
///@arg [dir_mode]
///@arg [direcao]
function screenshake(_treme, _dir_mode, _direcao){
		
	var shake = instance_create_layer(0, 0, "instances", obj_screenshake);
	shake.shake = _treme;
	shake.dir_mode = _dir_mode;
	shake.dir = _direcao;
}

//Define align
///@function define_align(vertical, horizontal)
function define_align(_ver, _hor){
	
	draw_set_valign(_ver);
	draw_set_halign(_hor);

}

//pegar o valor da da curva de animação
///@function valor_ca (curva_animacao, animar, [canal])
function valor_ca(_anim, _animar = false, _chan = 0){
	// posição da animação
	static _pos = 0, _val = 0;
	
	//aumentando o valor do pos
	//definindo a duração da aniação do pos
	_pos += delta_time/1000000;
	
	if(_animar){
		_pos = 0;
	}
	
	//pegando valor do canal
	var _canal = animcurve_get_channel(_anim, _chan);
	_val = animcurve_channel_evaluate(_canal, _pos);
	
	return _val;
}