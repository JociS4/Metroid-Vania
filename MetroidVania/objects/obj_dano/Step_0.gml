/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor

var outro;
var outro_lista = ds_list_create();
var quantidade = instance_place_list(x, y, obj_entidade, outro_lista, 0);

//adicionando todos que foram tocados na lista para tomar dano
for(var i = 0; i < quantidade; i++){
	//checando o atual
	var atual = outro_lista[| i];
	
	//show_message(object_get_name(atual.object_index));
	
	//checando se a colisão é com o filho do meu pai
	if(object_get_parent(atual.object_index) != object_get_parent(pai.object_index)){
		
		
		//checar se o atual ja esta na lista
		var pos = ds_list_find_index(aplicar_dano, atual);
		if (pos == -1){
			
			//adicionando o atual a lista de dano 
			ds_list_add(aplicar_dano, atual);
		}
	
	}
}

//aplicando dano 
var tam = ds_list_size(aplicar_dano);
for (var i = 0; i < tam ; i++){
	outro = aplicar_dano[| i].id;
	if (outro.vida_atual > 0){
		
		outro.estado = "dano";
		outro.image_index = 0;
		outro.vida_atual -= dano;
		
		//preciso checar se estou acertando o inimigo
		//checando se sou filho do inimigo do meu pai
		if(object_get_parent(outro.object_index) == obj_inimigo_pai){
			//screenshake nos inimigos
			screenshake(2);
		}
	}
}

//destruindo listas
ds_list_destroy(aplicar_dano);
ds_list_destroy(outro_lista);
instance_destroy();

/*/Se esta tocando em alguem
if(outro){
	//Se não esta tocando no pai
	if(outro.id != pai){
		
		//checando quem é o pai do outro
		var papai = object_get_parent(outro.object_index);
		if (papai != object_get_parent(pai.object_index)){
			if(outro.vida_atual > 0){
				outro.estado = "dano";
				outro.image_index = 0;
				outro.vida_atual -= dano;
				instance_destroy();
			}
		}
	}
}
*/
