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

N=1e5;                              % numero de experiencias
n = 8;                              % numero de brinquedos por caixa
experiencias = rand(n,N);           % fabrico de peças p1
p1  = experiencias < 0.002;         % peças p1 com defeito
experiencias = rand(n,N);           % fabrico de peças p2
p2  = experiencias < 0.005;         % peças p2 com defeito
experiencias = rand(n,N);           % processo de montagem pa
pa  = experiencias < 0.01;          % defeitos na montagem pa com defeito
ndefeitos = p1 + p2 + pa;           % numero de defeitos por brinquedo
defeitos = ndefeitos > 0;           % brinquedos com defeito
nbrinquedos = sum(defeitos);        % numero de brinquedos com defeito
caixas = nbrinquedos >1;            % soma das caixas com pelo menos um brinquedo com defeito
aprobSimulacao= sum(caixas)/N       %calculo da probabilidade do acontecimento
%%
% (b) Estime por simulação do numero médio de brinquedos defeituosos apenas
% devido ao processo de montagem quando ocorre o evento A.

N=1e5;                              % numero de experiencias
n = 8;                              % numero de brinquedos por caixa
experiencias = rand(n,N);           % fabrico de peças p1
p1  = experiencias < 0.002;         % peças p1 com defeito
experiencias = rand(n,N);           % fabrico de peças p2
p2  = experiencias < 0.005;         % peças p2 com defeito
experiencias = rand(n,N);           % processo de montagem pa
pa  = experiencias < 0.01;          % defeitos na montagem pa com defeito
ndefeitos = p1 + p2 + pa;           % numero de defeitos por brinquedo
defeitos = ndefeitos > 0;           % brinquedos com defeito
todosdef = sum(defeitos,'all');     % soma de todos os brinquedos defeitoosos  Acho que podes substituir por sum(a,'all)
defeitos = defeitos + pa;           % calculos dos brinquedos com defeito de montagem
mdefeitos = defeitos > 1;           % filtração dos brinquedos com defeito de montagem
nmdefeitos = sum(mdefeitos,'all');  % numero de brinquedos com o defeito de montagem
med = nmdefeitos/todosdef           % numero médio de brinquedos defeituosos apenas devido ao processo de montagem quando ocorre o evento A
