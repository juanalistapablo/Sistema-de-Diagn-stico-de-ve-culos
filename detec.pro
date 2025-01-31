/***************
 * 1. DECLARAÇÃO DE PREDICADOS DINÂMICOS
 ***************/
:- dynamic(falha_ignicao/0).
:- dynamic(temperatura_motor/1).
:- dynamic(luz_check_engine/0).
:- dynamic(luz_bateria/0).
:- dynamic(sensor_oxigenio/1).
:- dynamic(nivel_oleo/1).
:- dynamic(rotacao_motor/1).
:- dynamic(barulho_incomum/0).

/***************
 * 2. FATOS BÁSICOS (SINTOMAS E CAUSAS)
 ***************/
/* Exemplos adicionais de causas */
causa(sensor_posicao_virabrequim_defeituoso).
causa(vazamento_oleo).
causa(problema_sistema_arrefecimento).

/***************
 * 3. REGRAS DE DIAGNÓSTICO PRINCIPAIS
 ***************/

% Diagnóstico de falha de ignição
diagnostico(falha_ignicao) :-
    luz_check_engine,
    luz_bateria,
    bateria(Tensao),
    Tensao < 12.

% Diagnóstico de superaquecimento
diagnostico(superaquecimento) :-
    temperatura_motor(T),
    T > 100,
    luz_check_engine.

% Diagnóstico de baixa tensão na bateria
diagnostico(bateria_fraca) :-
    bateria(Tensao),
    Tensao < 12.

% Diagnóstico de falha no sensor de oxigênio
diagnostico(sensor_oxigenio_defeituoso) :-
    sensor_oxigenio(Valor),
    Valor > 1.2.

% Diagnóstico de vazamento de óleo
diagnostico(vazamento_oleo) :-
    nivel_oleo(Nivel),
    Nivel < 2.0.

% Diagnóstico de barulho incomum no motor
diagnostico(barulho_motor) :-
    barulho_incomum,
    \+ luz_check_engine.

% Diagnóstico de problema de transmissão
diagnostico(problema_transmissao) :-
    barulho_incomum,
    luz_check_engine,
    rotacao_motor(RPM),
    RPM > 3000.

/***************
 * 4. RECOMENDAÇÕES DE AÇÃO
 ***************/
recomendacao(bateria_fraca, 'Recarregar ou substituir a bateria').
recomendacao(superaquecimento, 'Verificar radiador, bomba de água e fluido de arrefecimento').
recomendacao(sensor_oxigenio_defeituoso, 'Substituir o sensor de oxigênio').
recomendacao(vazamento_oleo, 'Checar por vazamentos no sistema de óleo').
recomendacao(barulho_motor, 'Inspecionar o motor para possíveis danos internos').
recomendacao(problema_transmissao, 'Verificar caixa de transmissão e componentes relacionados').

/***************
 * 5. PREDICADO PRINCIPAL DE DIAGNÓSTICO
 ***************/
diagnosticar :-
    findall(Causa, diagnostico(Causa), ListaCausas),
    ( ListaCausas \= []
    -> format('Possíveis problemas diagnosticados: ~w~n', [ListaCausas]),
       listar_recomendacoes(ListaCausas)
    ;  write('Nenhum problema foi diagnosticado com as informações atuais.'), nl
    ).

listar_recomendacoes([]).
listar_recomendacoes([Causa|Resto]) :-
    recomendacao(Causa, Rec),
    format(' -> Para ~w, recomenda-se: ~w~n', [Causa, Rec]),
    listar_recomendacoes(Resto).

/***************
 * 6. CASOS DE TESTE
 ***************/
caso_teste_1 :-
    write('=== Caso de Teste 1: Partida Inconsistente ==='), nl,
    limpar_estado,
    assertz(falha_ignicao),
    assertz(luz_bateria),
    assertz(bateria(11.8)),
    diagnosticar,
    limpar_estado.

caso_teste_2 :-
    write('=== Caso de Teste 2: Superaquecimento no Motor ==='), nl,
    limpar_estado,
    assertz(temperatura_motor(105)),
    assertz(nivel_oleo(1.5)),
    assertz(luz_check_engine),
    diagnosticar,
    limpar_estado.

caso_teste_3 :-
    write('=== Caso de Teste 3: Sensor de Oxigênio Defeituoso ==='), nl,
    limpar_estado,
    assertz(sensor_oxigenio(1.3)),
    diagnosticar,
    limpar_estado.

caso_teste_4 :-
    write('=== Caso de Teste 4: Ruídos no Motor ==='), nl,
    limpar_estado,
    assertz(barulho_incomum),
    diagnosticar,
    limpar_estado.

limpar_estado :-
    retractall(bateria(_)),
    retractall(temperatura_motor(_)),
    retractall(nivel_oleo(_)),
    retractall(sensor_oxigenio(_)),
    retractall(luz_check_engine),
    retractall(luz_bateria),
    retractall(falha_ignicao),
    retractall(barulho_incomum),
    retractall(rotacao_motor(_)).

/***************
 * 7. INICIALIZAÇÃO
 ***************/
:- initialization(main).

main :-
    write('=== Executando Sistema de Diagnóstico ==='), nl,
    caso_teste_1,
    caso_teste_2,
    caso_teste_3,
    caso_teste_4,
    halt.
