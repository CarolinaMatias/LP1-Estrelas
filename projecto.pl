% lp24 - ist1114295 - projecto 
:- use_module(library(clpfd)). % para poder usar transpose/2
:- set_prolog_flag(answer_write_options,[max_depth(0)]). % ver listas completas
:- [puzzles]. % Ficheiro dado. A avaliac?a?o tera? mais puzzles.
:- [codigoAuxiliar]. % Ficheiro dado. Na?o alterar.
% Atenc?a?o: nao deves copiar nunca os puzzles para o teu ficheiro de co?digo
% Nao remover nem modificar as linhas anteriores. Obrigado.
% Segue-se o co?digo
%%%%%%%%%%%%

/**------------------------------------------------------------------------------------------------------------
visualiza(Lista): 
    |   A aplicação deste predicado permite escrever, por linha, cada elemento da lista Lista.

Argumentos:
    |   [H|T] - Lista que contém os elementos que serão escritos por linha.
---------------------------------------------------------------------------------------------------------------
*/

visualiza([]).
visualiza([H|T]):-
    write(H),nl,
    visualiza(T).

/**------------------------------------------------------------------------------------------------------------
visualizaLinha(L): 
    |    Predicado auxiliar que incui o índice de cada elemento da lista

Arguementos:
    |   L - Lista que contém os os elementos que serão escritos por linha.
---------------------------------------------------------------------------------------------------------------
*/

visualizaLinha(L):- 
    visualizaLinha(L,1). 

/**------------------------------------------------------------------------------------------------------------
visualizaLinha(Lista,Indice): 
    |   A aplicação deste predicado permite escrever cada elemento da lista 
    |   antecedido pelo número do seu índice e por ":" (exemplo: "1: a").

Arguemntos:
    |   Lista - Lista que contém os elementos que serão escritos por linha;
    |   Indice - Índice do elemento atual.
---------------------------------------------------------------------------------------------------------------
*/

visualizaLinha([],_).
visualizaLinha([H|T],Indice):-
    write(Indice),write(': '),writeln(H), 
    Novo_indice is Indice+1, % incrementa sempre +1 de modo a obter o índice seguinte
    visualizaLinha(T,Novo_indice). 

/**------------------------------------------------------------------------------------------------------------
insereObjecto((L,C),Tabuleiro,Obj): 
    |   A aplicação deste predicado permite inserir o Obj no tabuleiro nas coordenadas (L,C), 
    |    caso essas coordenadas estejam livres. Se as coordenadas estiverem fora do tabuleiro, 
        o predicado não altera o tabuleiro.

Argumentos:
    |   (L,C) - Coordenadas de uma posição do tabuleiro;
    |   Tabuleiro - Tabuleiro que, após a aplicação do predicado, passa a ter o objeto Obj nas coordenadas (L,C);
    |   Obj - Objeto que será inserido caso a posição esteja vazia.
---------------------------------------------------------------------------------------------------------------
*/

insereObjecto((L,C),Tabuleiro,Obj):- 
    aux_limites_tab(Tabuleiro,L,C),  % Verifica se a posição está dentro dos limites do tabuleiro
    nth1(L,Tabuleiro,Linha),
    nth1(C,Linha,Pos), 
    var(Pos),Pos=Obj,true,!. 
    
insereObjecto((L,C),Tabuleiro,_):-
    aux_limites_tab(Tabuleiro,L,C),
    nth1(L,Tabuleiro,Linha),
    nth1(C,Linha,Pos),
    \+var(Pos),!.

insereObjecto((L,C),Tabuleiro,_):- 
    \+aux_limites_tab(Tabuleiro,L,C).

/**------------------------------------------------------------------------------------------------------------
aux_limites_tab(Tabuleiro,L,C): 
    |   Predicado auxiliar que verifica se uma coordenada (L,C) está dentro dos limites do tabuleiro.

Argumentos:
    |   Tabuleiro - Tabuleiro onde a posição será verificada;
    |   L - Linha específica do tabuleiro;
    |   C - Coluna específica do tabuleiro.
---------------------------------------------------------------------------------------------------------------
*/

aux_limites_tab(Tabuleiro,L,C):-
    nth1(L,Tabuleiro,Linha),
    length(Linha,Dim),
    L>0,C>0,C=<Dim.

/**--------------------------------------------------------------------------------------------------------------
insereVariosObjectos(ListaCoords,Tabuleiro,ListaObjs): 
    |    O predicado que insere objetos de ListaObjs nas coordenadas correspondentes de ListaCoords
    |    ignorando posições inválidas ou ocupadas, mas falha se as listas tiverem tamanhos diferentes.

Argumentos:
    |   ListaCoords - Lista de coordenadas onde os objetos serão inseridos;
    |   Tabuleiro - O tabuleiro onde os objetos serão inseridos;
    |   ListaObjs - Lista de objetos que serão inseridos nas coordenadas especificadas.    
-----------------------------------------------------------------------------------------------------------------
*/

insereVariosObjectos([],_,[]). 
insereVariosObjectos([(L,C)|Coordenadas_rest],Tabuleiro,[Obj|Objs]):-
    insereObjecto((L,C),Tabuleiro,Obj),
    insereVariosObjectos(Coordenadas_rest,Tabuleiro,Objs),!. 

/**--------------------------------------------------------------------------------------------------------------
inserePontosVolta(Tabuleiro,(L,C)): 
    |   Predicado em que após a sua aplicação, o tabuleiro passa a ter pontos
    |   inseridos em todas as posições ao redor das coordenadas (L,C).

Arguementos:
    |   Tabuleiro - Tabuleiro onde os pontos serão inseridos;
    |   (L,C) - Coordenadas de uma posição do tabuleiro.
-----------------------------------------------------------------------------------------------------------------
*/

inserePontosVolta(Tabuleiro,(L,C)):-
    % Coordenadas possíveis ao redor da posição (L, C)
    Coords_possiveis=[(-1,-1),(-1,0),(-1,1),(0,-1),(0,1),(1,-1),(1,0),(1,1)],
    % Encontra todas as coordenadas possíveis ao redor da posição (L, C) que estão dentro dos limites do tabuleiro
    findall((NL,NC),
    (member((DeslocaLin,DeslocaCol),Coords_possiveis), NL is L+DeslocaLin, NC is C+DeslocaCol, aux_limites_tab(Tabuleiro,NL,NC)), 
    ListaCoords),
    inserePontos(Tabuleiro,ListaCoords).

/**--------------------------------------------------------------------------------------------------------------
inserePontos(Tabuleiro,ListaCoord): 
    |   O predicado insere pontos (p) no tabuleiro nas coordenadas 
    |   de ListaCoord, ignorando posições já ocupadas por objetos.

Arguementos:
    |   Tabuleiro - Tabuleiro onde os pontos serão inseridos;
    |   ListaCoord - Lista de coordenadas onde os pontos serão inseridos.
-----------------------------------------------------------------------------------------------------------------
*/

inserePontos(_,[]).
inserePontos(Tabuleiro,[(L,C)|Coordenadas_rest]):-
    % Insere um objeto na posição (L, C) e chama a função recursivamente para inserir os restantes objetos
    insereObjecto((L,C),Tabuleiro,p),
    inserePontos(Tabuleiro,Coordenadas_rest),!.

/**--------------------------------------------------------------------------------------------------------------
objectosEmCoordenadas(ListaCoords,Tabuleiro,ListaObjs): 
    |   O predicado é verdadeiro se ListaObjs contiver, na mesma ordem, os objetos nas
    |   coordenadas de ListaCoords. Falha se alguma coordenada não existir no tabuleiro.

Arguementos:
    |   ListaCoords - Lista de coordenadas onde os objetos serão procurados;
    |   Tabuleiro - Tabuleiro onde os objetos serão procurados;
    |   ListaObjs - Lista de objetos que serão encontrados nas coordenadas especificadas.
-----------------------------------------------------------------------------------------------------------------
*/

objectosEmCoordenadas([],_,[]).
objectosEmCoordenadas([(L,C)|Resto],Tabuleiro,[Obj|Objs]):-
    aux_limites_tab(Tabuleiro,L,C),
    nth1(L,Tabuleiro,Linha),
    nth1(C,Linha,Obj),
    objectosEmCoordenadas(Resto,Tabuleiro,Objs),!.

/**--------------------------------------------------------------------------------------------------------------
coordObjectos(Objecto,Tabuleiro,ListaCoords,ListaCoordObjs,NumObjectos):
    |   Encontra as coordenadas de ListaCoords onde Objecto aparece no tabuleiro e retorna-as 
    |   ordenadas pela mesma ordem que as coordenadas e falha caso alguma coordenada não esteja 
    |   no tabuleiro. Funciona também para variáveis.

Arguementos:
    |   Objecto - Objeto que será procurado nas coordenadas;
    |   Tabuleiro - Tabuleiro onde o objeto será procurado;
    |   ListaCoords - Lista de coordenadas onde o objeto será procurado;
    |   ListaCoordObjs - Lista de coordenadas onde o objeto foi encontrado;
    |   NumObjectos - Número de objetos encontrados.
-----------------------------------------------------------------------------------------------------------------
*/

coordObjectos(Obj,Tabuleiro,ListaCoords,ListaCoordObjs,NumObjs):-
    objectosEmCoordenadas(ListaCoords,Tabuleiro,ListaObjs),
    % Encontra todas as coordenadas em que (L, C) é igual a Obj ou é uma variável
    findall((L,C),(nth1(I,ListaObjs,Elem),nth1(I,ListaCoords,(L,C)),(var(Obj),var(Elem);Obj==Elem)),ListaObjsNOrdenada),
    sort(ListaObjsNOrdenada,ListaCoordObjs),
    length(ListaCoordObjs,NumObjs).

/**--------------------------------------------------------------------------------------------------------------
coordenadasVars(Tabuleiro, ListaVars): 
    |   O predicado é verdadeiro se ListaVars contiver as coordenadas de todas as variáveis 
    |   presentes no Tabuleiro. A ListaVars está ordenada por linhas e colunas.

Arguementos:
    |   Tabuleiro - Tabuleiro onde as variáveis serão procuradas;
    |   ListaVars - Lista de coordenadas onde as variáveis foram encontradas.
-----------------------------------------------------------------------------------------------------------------
*/

coordenadasVars(Tabuleiro,ListaVars):-
    findall((L,C),(nth1(L,Tabuleiro,Linha),nth1(C,Linha,Var),var(Var)),ListaVarsNF),
    sort(ListaVarsNF,ListaVars).

/**--------------------------------------------------------------------------------------------------------------
fechaListaCoordenadas(Tabuleiro, ListaCoord): 
    |   Implementa as seguintes regras para transformar as coordenadas de `ListaCoord` 
    |   em estrelas (e) e pontos (p) com base nas condições definidas:

        *    1. H1: Se a linha, coluna ou região associada à ListaCoord já contiver duas estrelas, 
        *    preenche todas as coordenadas restantes com pontos;
        *    2. H2: Se houver exatamente uma estrela e apenas uma posição livre, insere uma estrela 
        *    na posição livre e preenche com pontos as coordenadas ao redor dessa nova estrela;
        *    3. H3: Se não houver nenhuma estrela e existirem exatamente duas posições livres,
        *    insere uma estrela em cada posição e preenche com pontos ao redor de ambas as estrelas inseridas.

    |   Caso nenhuma das condições (H1, H2 ou H3) seja atendida, o tabuleiro permanece inalterado, 
    |   e o predicado não falha.

Arguemntos:
    |   Tabuleiro - Tabuleiro onde as estrelas e pontos serão inseridos;
    |   ListaCoord - Lista de coordenadas onde as estrelas e pontos serão inseridos.  
-----------------------------------------------------------------------------------------------------------------
*/ 

fechaListaCoordenadas(Tabuleiro, ListaCoords):-
    findall(Obj,(member((L,C),ListaCoords),nth1(L,Tabuleiro,Linha),nth1(C,Linha,Obj)),Objetos),
    % Coloca todas as estrelas (e) numa lista
    findall(Obj,(member(Obj,Objetos),Obj==e),Estrelas),
    % Coloca todas as variavéis (var) numa lista
    findall(Obj,(member(Obj,Objetos),var(Obj)),Variaveis),
    (length(Estrelas,2)->estrategia_h1(Tabuleiro,ListaCoords); 
    length(Estrelas,1),length(Variaveis,1)->estrategia_h2(Tabuleiro,ListaCoords);
    length(Estrelas,0),length(Variaveis,2)->estrategia_h3(Tabuleiro,ListaCoords); 
    true). 
    
/**--------------------------------------------------------------------------------------------------------------
estretegia_h1(Tabuleiro,ListaCoords): 
    |   Predicado auxiliar usado na função fechaListaCoordenadas que
    |   resolve o ponto 1 da função fechaListaCoordenadas.

Argumentos:    
    |   Tabuleiro - Tabuleiro onde as estrelas e pontos serão inseridos;
    |   ListaCoords - Lista de coordenadas onde as estrelas e pontos serão inseridos.  
-----------------------------------------------------------------------------------------------------------------
*/ 

estrategia_h1(Tabuleiro,ListaCoords):-
    findall((L,C),(member((L,C),ListaCoords),nth1(L,Tabuleiro,Linha),nth1(C,Linha,Obj),var(Obj)),CoordenadasLivres),
    inserePontos(Tabuleiro,CoordenadasLivres).

/**--------------------------------------------------------------------------------------------------------------
estretegia_h2(Tabuleiro,ListaCoords): 
    |   Predicado auxiliar usado na função fechaListaCoordenadas que
    |   resolve o ponto 2 da função fechaListaCoordenadas.

Argumentos:    
    |   Tabuleiro - Tabuleiro onde as estrelas e pontos serão inseridos;
    |   ListaCoords - Lista de coordenadas onde as estrelas e pontos serão inseridos.  
-----------------------------------------------------------------------------------------------------------------
*/

estrategia_h2(Tabuleiro,ListaCoords):-
    findall((L,C),(member((L,C),ListaCoords),nth1(L,Tabuleiro,Linha),nth1(C,Linha,Obj),var(Obj)),CoordenadasLivres),
    length(CoordenadasLivres,1),
    CoordenadasLivres=[(L,C)],
    insereObjecto((L,C),Tabuleiro,e),
    inserePontosVolta(Tabuleiro,(L,C)).

/**--------------------------------------------------------------------------------------------------------------
estretegia_h3(Tabuleiro,ListaCoords): 
    |   Predicado auxiliar usado na função fechaListaCoordenadas que
    |   resolve o ponto 3 da função fechaListaCoordenadas.

Argumentos:    
    |   Tabuleiro - Tabuleiro onde as estrelas e pontos serão inseridos;
    |   ListaCoords - Lista de coordenadas onde as estrelas e pontos serão inseridos.  
-----------------------------------------------------------------------------------------------------------------
*/
estrategia_h3(Tabuleiro,ListaCoords):-
    findall((L,C),(member((L,C),ListaCoords),nth1(L,Tabuleiro,Linha),nth1(C,Linha,Obj),var(Obj)),CoordenadasLivres),
    length(CoordenadasLivres,2),
    CoordenadasLivres=[(L1,C1),(L2,C2)],
    insereVariosObjectos([(L1,C1),(L2,C2)],Tabuleiro,[e,e]),
    inserePontosVolta(Tabuleiro,[(L1,C1),(L2,C2)]).

/**--------------------------------------------------------------------------------------------------------------
fecha(Tabuleiro,ListaListasCoord): 
    |   O predicado aplica 'fechaListaCoordenadas' a cada lista de coordenadas 
    |   em ListaListasCoord, resultando no tabuleiro final Tabuleiro.
Argumentos:
    |   Tabuleiro - Tabuleiro onde as estrelas e pontos serão inseridos;
    |   ListaListasCoord - Lista de listas de coordenadas onde as estrelas e pontos serão inseridos.
-----------------------------------------------------------------------------------------------------------------
*/

fecha(_,[]).
fecha(Tabuleiro,[ListasCoords|Resto]):-
    fechaListaCoordenadas(Tabuleiro,ListasCoords),
    fecha(Tabuleiro,Resto),true,!.

/**--------------------------------------------------------------------------------------------------------------
encontraSequencia(Tabuleiro, N, ListaCoords, Seq): 
    |    Predicado que verifica se Seq é uma sublista de ListaCoords com tamanho N, composta por variáveis
    |    consecutivas (em linha, coluna ou região). Além disso, Seq deve poder ser concatenada à direita
    |    à esquerda por listas (vazias ou contendo pontos) para formar ListaCoords. O predicado falha se houver
    |    mais de N variáveis consecutivas na sequência.

Argumentos:
    |   Tabuleiro - Tabuleiro onde as estrelas e pontos serão inseridos;
    |   N - Tamanho da sequência a ser encontrada;
    |   ListaCoords - Lista de coordenadas onde a sequência será procurada;
    |   Seq - Sequência de variáveis consecutivas.
----------------------------------------------------------------------------------------------------------------   
*/  

encontraSequencia(Tabuleiro,N,ListaCoords,Seq):-
    coordenadasVars(Tabuleiro,ListaVars), 
    % Porcura os elementos que estão na lista de coordenadas e na lista de variáveis e adiciona-os à sequência
    findall(Elem,(member(Elem,ListaCoords),member(Elem,ListaVars)),Seq),
    length(Seq,N),
    % Para garantir que seq pode ser concatenada à esquerda e à direita de modo a formar a ListaCoords
    append([Esq,Seq,Dir],ListaCoords),
    % Listas da direita e esquerda compostas por variáveis ou pontos
    (length(Dir,0);(coordObjectos(p,Tabuleiro,Dir,_,NObjs),NObjs>=1)),
    (length(Esq,0);(coordObjectos(p,Tabuleiro,Esq,_,NObjs),NObjs>=1)),!.
    
/**--------------------------------------------------------------------------------------------------------------
aplicaPadraoI(Tabuleiro,[(L1,C1),(L2,C2),(L3,C3)]): 
    |   O predicado é verdadeiro se, após sua aplicação, o tabuleiro tiver estrelas (e) 
    |   inseridas nas posições (L1,C1) e (L3,C3) e pontos ao redor de cada coordenada.

Argumentos:
    |   Tabuleiro - Tabuleiro onde as estrelas e pontos serão inseridos;
    |   (L1,C1),(L2,C2),(L3,C3) - Lista de coordenadas.
----------------------------------------------------------------------------------------------------------------
*/

aplicaPadraoI(Tabuleiro,[(L1,C1),_,(L3,C3)]):-
    insereVariosObjectos([(L1,C1),(L3,C3)],Tabuleiro,[e,e]),
    inserePontosVolta(Tabuleiro,(L1,C1)),
    inserePontosVolta(Tabuleiro,(L3,C3)).

/**--------------------------------------------------------------------------------------------------------------
aplicaPadroes(Tabuleiro,ListaListaCoords): 
    |   O predicado aplica a função 'AplicaPadrao' a cada lista de coordenadas em ListaListaCoords.

Argumentos:
    |   Tabuleiro - Tabuleiro onde as estrelas e pontos serão inseridos;
    |   ListaListaCoords - Lista de listas de coordenadas onde as estrelas e pontos serão inseridos.
----------------------------------------------------------------------------------------------------------------
*/

aplicaPadroes(_,[]).
aplicaPadroes(Tabuleiro,ListaListaCoords):-
    maplist(aplicaPadrao(Tabuleiro),ListaListaCoords),true,!.

/**--------------------------------------------------------------------------------------------------------------
aplicaPadrao(Tabuleiro,ListaCoords): 
    |   O predicado auxiliar encontra sequências de tamanho 3 ou 4 e aplica os padrões I ou T.

Argumentos:
    |   Tabuleiro - Tabuleiro onde as estrelas e pontos serão inseridos;
    |   ListaCoords - Lista de coordenadas onde as estrelas e pontos serão inseridos.
----------------------------------------------------------------------------------------------------------------
*/

aplicaPadrao(Tabuleiro,ListaCoords):-
    (encontraSequencia(Tabuleiro,3,ListaCoords,_)->aplicaPadraoI(Tabuleiro,ListaCoords),!;
    encontraSequencia(Tabuleiro,4,ListaCoords,_)->aplicaPadraoT(Tabuleiro,ListaCoords),!;
    true).