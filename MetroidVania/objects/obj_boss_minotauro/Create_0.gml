/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor

// Inherit the parent event
event_inherited();

// adicionando atributos do boss
vida_max = 12;
vida_atual = vida_max;

max_velh = 3;
max_velv = 3;

timer_estado = 0;

ataque = 1;

massa = 3;

provocar_delay = room_speed * 2;
tempo_provocar = provocar_delay;

//subState
ataque = irandom(2);