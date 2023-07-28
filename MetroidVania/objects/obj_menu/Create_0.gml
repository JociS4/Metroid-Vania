/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor

//criando menu
audio_play_sound(snd_menu, 1, true);
//seleção menu
marg_val = 18;
marg_total = 32;

//controlando a página do menu
pag = 0;

#region //métodos

//Desenha menu
desenha_menu = function(_menu){

	//definindo a fonte do menu
	draw_set_font(fnt_menu);

	//alinhando o texto
	define_align(0, 0);

	//pegando o tamanho do menu
	var _qtd = array_length(_menu);

	//pegando altura da tela
	var _alt = display_get_gui_height();
	
	//pegando largura da tela
	var _larg = display_get_gui_width();

	//definindo o espaço entre linhas
	var _espaco_y = string_height("I") + 16;
	var _alt_menu = _espaco_y * _qtd;


	//desenhando opções
	for (var i = 0; i < _qtd; i++){
		var _cor = c_white, _marg_x = 0;
	
		//desenhando o item do menu
		var _texto = _menu[i][0];
	
		//checando se a seleção está no texto atual
		if(menus_sel[pag] == i){
		
			_cor = c_fuchsia;
			_marg_x = marg_val;
		}
	
		draw_text_color(20 + _marg_x, (_alt / 2) - _alt_menu / 2 + (i * _espaco_y), _texto, _cor, _cor, _cor, _cor, 1);
	
	}
	
	//desenhando as opções do menu(Quando existirem)
	//rodando pelo vetor
	for (var i = 0;	i < _qtd; i++){
		//checando se é preciso desenhar as opções
		switch(_menu[i][1]){
			case menu_acoes.ajustes_menu: 
			{
				//Desenhando as opções do lado direito
				//salvando o índice que estou
				var _indice = _menu[i][3];
				var _txt = _menu[i][4][_indice];
				
				//so pode ir para a esquerda SE somente SE eu não estou no indice 0
				var _esq = _indice > 0 ? "<< " : "";
				
				//so pode ir para a direita SE somente SE eu não estou no final do vetor
				var _dir = _indice < array_length(_menu[i][4]) - 1 ? " >>" : "";
				
				var _cor = c_white;
				
				//se estou alterando a opção muda a cor
				if (alterando && menus_sel[pag] == i){
					_cor = c_yellow;
				}
				
				draw_text_color(_larg / 2, (_alt / 2) - _alt_menu / 2 + (i * _espaco_y), _esq + _txt + _dir, _cor, _cor, _cor, _cor, 1);
				
				break;
			}
		}
	}

	//resetando os draw set
	draw_set_font(-1);
	define_align(-1, -1);
}

//controle do menu
controla_menu = function(_menu){

	//alteranco seleção
	//definindo teclas
	var _up, _down, _enter, _return, _left, _right;
	
	var _sel = menus_sel[pag];
	
	static _animar = false;

	_up = keyboard_check_pressed(vk_up);
	_down = keyboard_check_pressed(vk_down);
	_enter = keyboard_check_released(vk_enter);
	_return = keyboard_check_released(vk_space);
	_left = keyboard_check_pressed(vk_left);
	_right = keyboard_check_pressed(vk_right);

	//checando se NÃO estou alterando as opções do jogo
	if(!alterando){
		if (_up or _down){
			//mudando valor do sel
			menus_sel[pag] += _down - _up;
	
			//limitando sel dentro do vetor
			var _tam = array_length(_menu) - 1;
			menus_sel[pag] = clamp(menus_sel[pag], 0 , _tam);
		
			//avisando que pode fazer a animação
			_animar = true;
			
			audio_play_sound(snd_bip_menu, 2, false);
		}
	}
	else{
		//Estou alterando as opções 
		_animar = false;
		
		//se apertar para a esquerda ou direita, eu mudo as opções
		if (_right or _left){
			//achando o limite
			var _limite = array_length(_menu[_sel][4]) - 1;
			
			//mudando indice
			menus[pag][_sel][3] += _right - _left;
			
			//garantindo que não saia do limite
			menus[pag][_sel][3] = clamp(menus[pag][_sel][3], 0, _limite);
			
			audio_play_sound(snd_bip_menu, 2, false);
		}
	}
	
	//quando clicar enter em opções
	if (_enter){
		switch(_menu[_sel][1]){
			
			//case 0, roda um método
			case menu_acoes.roda_metodo:
				_menu[_sel][2]();
				break;
			
			//case 1, muda o valor da pagina(pag)
			case menu_acoes.carrega_menu:
				pag = _menu[_sel][2];
				break;
			
			case menu_acoes.ajustes_menu:
				alterando = !alterando;
				
				//rodando metodo
				if(!alterando){
					//salvando argumento do metodo
					var _arg = _menu[_sel][3];
					_menu[_sel][2](_arg);
				}
				
				break;
		}
	}
	
	//aumentando o marg_val
	if (_animar){
		marg_val = marg_total * valor_ca(ca_margem, _up ^^ _down, 0);
	}
}
	
//iniciando ações do menu
inicia_jogo = function(){
	//carrega a room de inicio do jogo
	audio_stop_sound(snd_menu);
	room_goto(Room1);
}

fechar_jogo = function(){
	game_end();
}

ajusta_tela = function(_valor){
	//checar se a tela esta no modo cheio ou janela
	switch(_valor){
		//tela cheia
		case 0:
			window_set_fullscreen(true);
			break;
		case 1:
			window_set_fullscreen(false);
			break;
	}
}

ajusta_dificuldade = function(_valor){
	switch(_valor){
		case 0:
			global.dificuldade = .5;
			break;
			
		case 1:
			global.dificuldade = 1;
			break;
			
		case 2:
			global.dificuldade = 1.5;
			break;
			
		case 3:
			global.dificuldade = 3;
			break;
	}
}

#endregion

menu_principal =	[
						["Iniciar", menu_acoes.roda_metodo, inicia_jogo],
						["Opções", menu_acoes.carrega_menu, menu_lista.opcoes],
						["Sair", menu_acoes.roda_metodo, fechar_jogo]
					];

menu_opcoes =	[
					["Tipo de Janela", menu_acoes.carrega_menu, menu_lista.tela],
					["Dificuldade", menu_acoes.carrega_menu, menu_lista.dificuldade],
					[ "Voltar", menu_acoes.carrega_menu, menu_lista.principal]
				];

menu_dificuldade =	[
						["Dificuldade", menu_acoes.ajustes_menu, ajusta_dificuldade, 1, ["Fácil", "Normal", "Difícil", "Impossível"]],
						["Voltar", menu_acoes.carrega_menu, menu_lista.opcoes]
					];

menu_tela =	[
				["Tipo de Tela", menu_acoes.ajustes_menu, ajusta_tela, 1, ["Tela Cheia", "Janela"]],
				["Voltar", menu_acoes.carrega_menu, menu_lista.opcoes]
			];

//salvando todos os menus criados
menus = [menu_principal, menu_opcoes, menu_tela, menu_dificuldade];

//salvando seleção de cada menu
menus_sel = array_create(array_length(menus), 0);

alterando = false;


