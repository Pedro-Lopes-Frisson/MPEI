%% 2.3 Secção para avaliação
% Considere uma empresa fabricante de brinquedos que produz um determinado brinquedo. 
% O brinquedo é composto por dois componentes (1 e 2) que são produzidos separadamente 
% e posteriormente montados. No final, os brinquedos são embalados para comercialização 
% em caixas com n brinquedos cada. O processo de fabrico do Componente 1 produz 
% p1 = 0, 2% de componentes com defeito. O processo de fabrico do Componente 2 
% produz p2 = 0, 5% de componentes com defeito. Um brinquedo está com defeito 
% se pelo menos um de seus componentes estiver com defeito. O processo de montagem 
% produz pa = 1% de brinquedos com defeito (mesmo quando nenhum dos 2 componentes 
% esta com defeito).
% 1. (Peso de avaliação = 20 %) Considere o evento ”A - uma caixa de brinquedos tem pelo menos 1 brinquedo com defeito”.
% (a) Estime por simulação a probabilidade do evento A quando n = 8 brinquedos. 

N=1e5;                                                  % numero de experiencias
n = 8;                                                  % numero de brinquedos por caixa
experiencias = rand(n,N);                               % fabrico de peças p1
p1  = experiencias < 0.002;                             % peças p1 com defeito
experiencias = rand(n,N);                               % fabrico de peças p2
p2  = experiencias < 0.005;                             % peças p2 com defeito
experiencias = rand(n,N);                               % processo de montagem pa
pa  = experiencias < 0.01;                              % defeitos na montagem pa com defeito
ndefeitos = p1 + p2 + pa;                               % numero de defeitos por brinquedo
defeitos = ndefeitos > 0;                               % brinquedos com defeito
nbrinquedos = sum(defeitos);                            % numero de brinquedos com defeito
caixas = nbrinquedos >=1;                               % soma das caixas com pelo menos um brinquedo com defeito
aprobSimulacao= sum(caixas)/N                           %calculo da probabilidade do acontecimento
% (b) Estime por simulação do numero médio de brinquedos defeituosos apenas devido ao processo de montagem quando ocorre o evento A.

medias = 0;                                             % definir média para somar médias e veer valor médio das experiencias
counter = 0;                                            % definir counter para contar caixas com pelo menos 1 defeito
N=1e5;                                                  % numero de experiencias
n = 8;                                                  % numero de brinquedos por caixa
experiencias = rand(n,N);                               % fabrico de peças p1
p1  = experiencias < 0.002;                             % peças p1 com defeito
experiencias = rand(n,N);                               % fabrico de peças p2
p2  = experiencias < 0.005;                             % peças p2 com defeito
experiencias = rand(n,N);                               % processo de montagem pa
pa  = experiencias < 0.01;                              % defeitos na montagem pa com defeito
ndefeitos = p1 + p2 + pa;                               % numero de defeitos por brinquedo
defeitos = ndefeitos > 0;                               % brinquedos com defeito  
todosdef = sum(defeitos);                               % soma de todos os brinquedos defeitoosos por caixa 
mdefeitos = (p1+p2)>0;                                  % calculo de defeitos provocados por peças 
mdefeitos = (mdefeitos ~= pa) & pa;                     % calculo de defeitos provocados só por montagem
nmdefeitos = sum(mdefeitos);                            % numero de brinquedos com o defeito só de montagem
for d = 1:N                                             % for para iteração das matrizes
    if(todosdef(d) ~=0)                                 % verificação se existe pelo menos 1 brinquedo com defeito por caixa
        medias= medias + nmdefeitos(d)/todosdef(d);     % soma das médias de brinquedos defeitoosos devido a montagem em comparação aos defeitos totais por caixa
        counter = counter + 1;                          % contador de casos com pelo menos um defeito por caixa
    end                                                 % 
end                                                     %
result = medias/counter                                 % média final das médias obtidas