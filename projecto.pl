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
    |   A aplica��o deste predicado permite escrever, por linha, cada elemento da lista Lista.

Argumentos:
    |   [H|T] - Lista que cont�m os elementos que ser�o escritos por linha.
---------------------------------------------------------------------------------------------------------------
*/

visualiza([]).
visualiza([H|T]):-
    write(H),nl,
    visualiza(T).

/**------------------------------------------------------------------------------------------------------------
visualizaLinha(L): 
    |    Predicado auxiliar que incui o �ndice de cada elemento da lista

Arguementos:
    |   L - Lista que cont�m os os elementos que ser�o escritos por linha.
---------------------------------------------------------------------------------------------------------------
*/

visualizaLinha(L):- 
    visualizaLinha(L,1). 

/**------------------------------------------------------------------------------------------------------------
visualizaLinha(Lista,Indice): 
    |   A aplica��o deste predicado permite escrever cada elemento da lista 
    |   antecedido pelo n�mero do seu �ndice e por ":" (exemplo: "1: a").

Arguemntos:
    |   Lista - Lista que cont�m os elementos que ser�o escritos por linha;
    |   Indice - �ndice do elemento atual.
---------------------------------------------------------------------------------------------------------------
*/

visualizaLinha([],_).
visualizaLinha([H|T],Indice):-
    write(Indice),write(': '),writeln(H), 
    Novo_indice is Indice+1, % incrementa sempre +1 de modo a obter o �ndice seguinte
    visualizaLinha(T,Novo_indice). 

/**------------------------------------------------------------------------------------------------------------
insereObjecto((L,C),Tabuleiro,Obj): 
    |   A aplica��o deste predicado permite inserir o Obj no tabuleiro nas coordenadas (L,C), 
    |    caso essas coordenadas estejam livres. Se as coordenadas estiverem fora do tabuleiro, 
        o predicado n�o altera o tabuleiro.

Argumentos:
    |   (L,C) - Coordenadas de uma posi��o do tabuleiro;
    |   Tabuleiro - Tabuleiro que, ap�s a aplica��o do predicado, passa a ter o objeto Obj nas coordenadas (L,C);
    |   Obj - Objeto que ser� inserido caso a posi��o esteja vazia.
---------------------------------------------------------------------------------------------------------------
*/

insereObjecto((L,C),Tabuleiro,Obj):- 
    aux_limites_tab(Tabuleiro,L,C),  % Verifica se a posi��o est� dentro dos limites do tabuleiro
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
    |   Predicado auxiliar que verifica se uma coordenada (L,C) est� dentro dos limites do tabuleiro.

Argumentos:
    |   Tabuleiro - Tabuleiro onde a posi��o ser� verificada;
    |   L - Linha espec�fica do tabuleiro;
    |   C - Coluna espec�fica do tabuleiro.
---------------------------------------------------------------------------------------------------------------
*/

aux_limites_tab(Tabuleiro,L,C):-
    nth1(L,Tabuleiro,Linha),
    length(Linha,Dim),
    L>0,C>0,C=<Dim.

/**--------------------------------------------------------------------------------------------------------------
insereVariosObjectos(ListaCoords,Tabuleiro,ListaObjs): 
    |    O predicado que insere objetos de ListaObjs nas coordenadas correspondentes de ListaCoords
    |    ignorando posi��es inv�lidas ou ocupadas, mas falha se as listas tiverem tamanhos diferentes.

Argumentos:
    |   ListaCoords - Lista de coordenadas onde os objetos ser�o inseridos;
    |   Tabuleiro - O tabuleiro onde os objetos ser�o inseridos;
    |   ListaObjs - Lista de objetos que ser�o inseridos nas coordenadas especificadas.    
-----------------------------------------------------------------------------------------------------------------
*/

insereVariosObjectos([],_,[]). 
insereVariosObjectos([(L,C)|Coordenadas_rest],Tabuleiro,[Obj|Objs]):-
    insereObjecto((L,C),Tabuleiro,Obj),
    insereVariosObjectos(Coordenadas_rest,Tabuleiro,Objs),!. 

/**--------------------------------------------------------------------------------------------------------------
inserePontosVolta(Tabuleiro,(L,C)): 
    |   Predicado em que ap�s a sua aplica��o, o tabuleiro passa a ter pontos
    |   inseridos em todas as posi��es ao redor das coordenadas (L,C).

Arguementos:
    |   Tabuleiro - Tabuleiro onde os pontos ser�o inseridos;
    |   (L,C) - Coordenadas de uma posi��o do tabuleiro.
-----------------------------------------------------------------------------------------------------------------
*/

inserePontosVolta(Tabuleiro,(L,C)):-
    % Coordenadas poss�veis ao redor da posi��o (L, C)
    Coords_possiveis=[(-1,-1),(-1,0),(-1,1),(0,-1),(0,1),(1,-1),(1,0),(1,1)],
    % Encontra todas as coordenadas poss�veis ao redor da posi��o (L, C) que est�o dentro dos limites do tabuleiro
    findall((NL,NC),
    (member((DeslocaLin,DeslocaCol),Coords_possiveis), NL is L+DeslocaLin, NC is C+DeslocaCol, aux_limites_tab(Tabuleiro,NL,NC)), 
    ListaCoords),
    inserePontos(Tabuleiro,ListaCoords).

/**--------------------------------------------------------------------------------------------------------------
inserePontos(Tabuleiro,ListaCoord): 
    |   O predicado insere pontos (p) no tabuleiro nas coordenadas 
    |   de ListaCoord, ignorando posi��es j� ocupadas por objetos.

Arguementos:
    |   Tabuleiro - Tabuleiro onde os pontos ser�o inseridos;
    |   ListaCoord - Lista de coordenadas onde os pontos ser�o inseridos.
-----------------------------------------------------------------------------------------------------------------
*/

inserePontos(_,[]).
inserePontos(Tabuleiro,[(L,C)|Coordenadas_rest]):-
    % Insere um objeto na posi��o (L, C) e chama a fun��o recursivamente para inserir os restantes objetos
    insereObjecto((L,C),Tabuleiro,p),
    inserePontos(Tabuleiro,Coordenadas_rest),!.

/**--------------------------------------------------------------------------------------------------------------
objectosEmCoordenadas(ListaCoords,Tabuleiro,ListaObjs): 
    |   O predicado � verdadeiro se ListaObjs contiver, na mesma ordem, os objetos nas
    |   coordenadas de ListaCoords. Falha se alguma coordenada n�o existir no tabuleiro.

Arguementos:
    |   ListaCoords - Lista de coordenadas onde os objetos ser�o procurados;
    |   Tabuleiro - Tabuleiro onde os objetos ser�o procurados;
    |   ListaObjs - Lista de objetos que ser�o encontrados nas coordenadas especificadas.
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
    |   ordenadas pela mesma ordem que as coordenadas e falha caso alguma coordenada n�o esteja 
    |   no tabuleiro. Funciona tamb�m para vari�veis.

Arguementos:
    |   Objecto - Objeto que ser� procurado nas coordenadas;
    |   Tabuleiro - Tabuleiro onde o objeto ser� procurado;
    |   ListaCoords - Lista de coordenadas onde o objeto ser� procurado;
    |   ListaCoordObjs - Lista de coordenadas onde o objeto foi encontrado;
    |   NumObjectos - N�mero de objetos encontrados.
-----------------------------------------------------------------------------------------------------------------
*/

coordObjectos(Obj,Tabuleiro,ListaCoords,ListaCoordObjs,NumObjs):-
    objectosEmCoordenadas(ListaCoords,Tabuleiro,ListaObjs),
    % Encontra todas as coordenadas em que (L, C) � igual a Obj ou � uma vari�vel
    findall((L,C),(nth1(I,ListaObjs,Elem),nth1(I,ListaCoords,(L,C)),(var(Obj),var(Elem);Obj==Elem)),ListaObjsNOrdenada),
    sort(ListaObjsNOrdenada,ListaCoordObjs),
    length(ListaCoordObjs,NumObjs).

/**--------------------------------------------------------------------------------------------------------------
coordenadasVars(Tabuleiro, ListaVars): 
    |   O predicado � verdadeiro se ListaVars contiver as coordenadas de todas as vari�veis 
    |   presentes no Tabuleiro. A ListaVars est� ordenada por linhas e colunas.

Arguementos:
    |   Tabuleiro - Tabuleiro onde as vari�veis ser�o procuradas;
    |   ListaVars - Lista de coordenadas onde as vari�veis foram encontradas.
-----------------------------------------------------------------------------------------------------------------
*/

coordenadasVars(Tabuleiro,ListaVars):-
    findall((L,C),(nth1(L,Tabuleiro,Linha),nth1(C,Linha,Var),var(Var)),ListaVarsNF),
    sort(ListaVarsNF,ListaVars).

/**--------------------------------------------------------------------------------------------------------------
fechaListaCoordenadas(Tabuleiro, ListaCoord): 
    |   Implementa as seguintes regras para transformar as coordenadas de `ListaCoord` 
    |   em estrelas (e) e pontos (p) com base nas condi��es definidas:

        *    1. H1: Se a linha, coluna ou regi�o associada � ListaCoord j� contiver duas estrelas, 
        *    preenche todas as coordenadas restantes com pontos;
        *    2. H2: Se houver exatamente uma estrela e apenas uma posi��o livre, insere uma estrela 
        *    na posi��o livre e preenche com pontos as coordenadas ao redor dessa nova estrela;
        *    3. H3: Se n�o houver nenhuma estrela e existirem exatamente duas posi��es livres,
        *    insere uma estrela em cada posi��o e preenche com pontos ao redor de ambas as estrelas inseridas.

    |   Caso nenhuma das condi��es (H1, H2 ou H3) seja atendida, o tabuleiro permanece inalterado, 
    |   e o predicado n�o falha.

Arguemntos:
    |   Tabuleiro - Tabuleiro onde as estrelas e pontos ser�o inseridos;
    |   ListaCoord - Lista de coordenadas onde as estrelas e pontos ser�o inseridos.  
-----------------------------------------------------------------------------------------------------------------
*/ 

fechaListaCoordenadas(Tabuleiro, ListaCoords):-
    findall(Obj,(member((L,C),ListaCoords),nth1(L,Tabuleiro,Linha),nth1(C,Linha,Obj)),Objetos),
    % Coloca todas as estrelas (e) numa lista
    findall(Obj,(member(Obj,Objetos),Obj==e),Estrelas),
    % Coloca todas as variav�is (var) numa lista
    findall(Obj,(member(Obj,Objetos),var(Obj)),Variaveis),
    (length(Estrelas,2)->estrategia_h1(Tabuleiro,ListaCoords); 
    length(Estrelas,1),length(Variaveis,1)->estrategia_h2(Tabuleiro,ListaCoords);
    length(Estrelas,0),length(Variaveis,2)->estrategia_h3(Tabuleiro,ListaCoords); 
    true). 
    
/**--------------------------------------------------------------------------------------------------------------
estretegia_h1(Tabuleiro,ListaCoords): 
    |   Predicado auxiliar usado na fun��o fechaListaCoordenadas que
    |   resolve o ponto 1 da fun��o fechaListaCoordenadas.

Argumentos:    
    |   Tabuleiro - Tabuleiro onde as estrelas e pontos ser�o inseridos;
    |   ListaCoords - Lista de coordenadas onde as estrelas e pontos ser�o inseridos.  
-----------------------------------------------------------------------------------------------------------------
*/ 

estrategia_h1(Tabuleiro,ListaCoords):-
    findall((L,C),(member((L,C),ListaCoords),nth1(L,Tabuleiro,Linha),nth1(C,Linha,Obj),var(Obj)),CoordenadasLivres),
    inserePontos(Tabuleiro,CoordenadasLivres).

/**--------------------------------------------------------------------------------------------------------------
estretegia_h2(Tabuleiro,ListaCoords): 
    |   Predicado auxiliar usado na fun��o fechaListaCoordenadas que
    |   resolve o ponto 2 da fun��o fechaListaCoordenadas.

Argumentos:    
    |   Tabuleiro - Tabuleiro onde as estrelas e pontos ser�o inseridos;
    |   ListaCoords - Lista de coordenadas onde as estrelas e pontos ser�o inseridos.  
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
    |   Predicado auxiliar usado na fun��o fechaListaCoordenadas que
    |   resolve o ponto 3 da fun��o fechaListaCoordenadas.

Argumentos:    
    |   Tabuleiro - Tabuleiro onde as estrelas e pontos ser�o inseridos;
    |   ListaCoords - Lista de coordenadas onde as estrelas e pontos ser�o inseridos.  
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
    |   Tabuleiro - Tabuleiro onde as estrelas e pontos ser�o inseridos;
    |   ListaListasCoord - Lista de listas de coordenadas onde as estrelas e pontos ser�o inseridos.
-----------------------------------------------------------------------------------------------------------------
*/

fecha(_,[]).
fecha(Tabuleiro,[ListasCoords|Resto]):-
    fechaListaCoordenadas(Tabuleiro,ListasCoords),
    fecha(Tabuleiro,Resto),true,!.

/**--------------------------------------------------------------------------------------------------------------
encontraSequencia(Tabuleiro, N, ListaCoords, Seq): 
    |    Predicado que verifica se Seq � uma sublista de ListaCoords com tamanho N, composta por vari�veis
    |    consecutivas (em linha, coluna ou regi�o). Al�m disso, Seq deve poder ser concatenada � direita
    |    � esquerda por listas (vazias ou contendo pontos) para formar ListaCoords. O predicado falha se houver
    |    mais de N vari�veis consecutivas na sequ�ncia.

Argumentos:
    |   Tabuleiro - Tabuleiro onde as estrelas e pontos ser�o inseridos;
    |   N - Tamanho da sequ�ncia a ser encontrada;
    |   ListaCoords - Lista de coordenadas onde a sequ�ncia ser� procurada;
    |   Seq - Sequ�ncia de vari�veis consecutivas.
----------------------------------------------------------------------------------------------------------------   
*/  

encontraSequencia(Tabuleiro,N,ListaCoords,Seq):-
    coordenadasVars(Tabuleiro,ListaVars), 
    % Porcura os elementos que est�o na lista de coordenadas e na lista de vari�veis e adiciona-os � sequ�ncia
    findall(Elem,(member(Elem,ListaCoords),member(Elem,ListaVars)),Seq),
    length(Seq,N),
    % Para garantir que seq pode ser concatenada � esquerda e � direita de modo a formar a ListaCoords
    append([Esq,Seq,Dir],ListaCoords),
    % Listas da direita e esquerda compostas por vari�veis ou pontos
    (length(Dir,0);(coordObjectos(p,Tabuleiro,Dir,_,NObjs),NObjs>=1)),
    (length(Esq,0);(coordObjectos(p,Tabuleiro,Esq,_,NObjs),NObjs>=1)),!.
    
/**--------------------------------------------------------------------------------------------------------------
aplicaPadraoI(Tabuleiro,[(L1,C1),(L2,C2),(L3,C3)]): 
    |   O predicado � verdadeiro se, ap�s sua aplica��o, o tabuleiro tiver estrelas (e) 
    |   inseridas nas posi��es (L1,C1) e (L3,C3) e pontos ao redor de cada coordenada.

Argumentos:
    |   Tabuleiro - Tabuleiro onde as estrelas e pontos ser�o inseridos;
    |   (L1,C1),(L2,C2),(L3,C3) - Lista de coordenadas.
----------------------------------------------------------------------------------------------------------------
*/

aplicaPadraoI(Tabuleiro,[(L1,C1),_,(L3,C3)]):-
    insereVariosObjectos([(L1,C1),(L3,C3)],Tabuleiro,[e,e]),
    inserePontosVolta(Tabuleiro,(L1,C1)),
    inserePontosVolta(Tabuleiro,(L3,C3)).

/**--------------------------------------------------------------------------------------------------------------
aplicaPadroes(Tabuleiro,ListaListaCoords): 
    |   O predicado aplica a fun��o 'AplicaPadrao' a cada lista de coordenadas em ListaListaCoords.

Argumentos:
    |   Tabuleiro - Tabuleiro onde as estrelas e pontos ser�o inseridos;
    |   ListaListaCoords - Lista de listas de coordenadas onde as estrelas e pontos ser�o inseridos.
----------------------------------------------------------------------------------------------------------------
*/

aplicaPadroes(_,[]).
aplicaPadroes(Tabuleiro,ListaListaCoords):-
    maplist(aplicaPadrao(Tabuleiro),ListaListaCoords),true,!.

/**--------------------------------------------------------------------------------------------------------------
aplicaPadrao(Tabuleiro,ListaCoords): 
    |   O predicado auxiliar encontra sequ�ncias de tamanho 3 ou 4 e aplica os padr�es I ou T.

Argumentos:
    |   Tabuleiro - Tabuleiro onde as estrelas e pontos ser�o inseridos;
    |   ListaCoords - Lista de coordenadas onde as estrelas e pontos ser�o inseridos.
----------------------------------------------------------------------------------------------------------------
*/

aplicaPadrao(Tabuleiro,ListaCoords):-
    (encontraSequencia(Tabuleiro,3,ListaCoords,_)->aplicaPadraoI(Tabuleiro,ListaCoords),!;
    encontraSequencia(Tabuleiro,4,ListaCoords,_)->aplicaPadraoT(Tabuleiro,ListaCoords),!;
    true).