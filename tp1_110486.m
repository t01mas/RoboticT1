% %% 
% function tp1_110486(offset)
% 
% %% Parametros Iniciais
% 
% if nargin < 0.01
%     offset = 0; % valor por omissão
%end

%% Parametros de teste

clear, clc,

offset = 0.2;

%% Parametros Base do Robo

% Carregar Robo

mdl_ur10

% Criar a ponta (linha de 15 cm no eixo z do último elo)

TamanhoPonta = 0.15;
ur10.tool = transl(0, 0, TamanhoPonta);

Home =[-pi/2 -pi/2 0 -pi/2 -pi/2 0]; % Posição Home
ur10.base = transl(0, 0, 0); % Situar a Base no (0,0,0)

%% Criação da Mesa e Blocos

figure;

CriaBloco('retangulo', [0 0.7 0], 'c', [1 1 0.1]); % Mesa
BlocoVerde = CriaBloco('cubo', [0.6+offset 0.4 0], 'g', 0.2); % Cubo verde
BlocoAzul = CriaBloco('cubo', [-0.6-offset 0.4 0], 'b', 0.2); % Cubo Azul


%% Plot Robo       

ur10.plot(Home, 'noarrow') % noarrow porque fica mais facil de perceber

% Parametros para Visualização

if offset >= 0.5
    XLimAument = 1;
else
    XLimAument = 0;
end

xlim([-1-XLimAument 1+XLimAument]);
ylim([-0.4 1.5]);
zlim([0 1.6]);
view(150, 25)

title('TP1')


%% Mover o Bloco Verde

a = text(0,0,1.6,'Mover o Bloco Verde','FontName','Impact','FontSize',20);

PickPosVrd  = [0.6+offset 0.4 0.2 + TamanhoPonta/2]; % posição acima do bloco (z)
PickPosVrd2 = [0.6+offset 0.4 0.4 + TamanhoPonta/2]; % posição acima do bloco (z aumentado com segurança)
PlacePosVrd2 = [0.25 0.8 0.4 + TamanhoPonta/2]; % posição acima do bloco (z aumentado com segurança)
PlacePosVrd = [0.25 0.8 0.2 + TamanhoPonta];        % posição de destino

% Matrizes das posiçoes alvo

MRot = trotx(pi); % Rotação 180° em X (para pegar no bloco por cima)

MPickVrd  = transl(PickPosVrd) * MRot;
MPickVrd2  = transl(PickPosVrd2) * MRot;
MPlaceVrd2  = transl(PlacePosVrd2) * MRot;
MPlaceVrd = transl(PlacePosVrd) * MRot;

% Calcula juntas ( Testes !!!!!! )

%Q_Guess = [-pi -pi/2 pi/2 -pi/2 -pi/2 0];

%CheckPosicao(MPickVrd,ur10)

JPickVrd  = ur10.ikine(MPickVrd);
JPickVrd2 = ur10.ikine(MPickVrd2);
JPlaceVrd2 = ur10.ikine(MPlaceVrd2);
JPlaceVrd = ur10.ikine(MPlaceVrd);
 

% Calcula Trajetórias 
NSteps = 50;

if ~isempty(JPickVrd) && ~isempty(JPickVrd2) && ~isempty(JPlaceVrd2) && ~isempty(JPlaceVrd)

    % Trajetória de pick
    TrajPickVrd = jtraj(Home, JPickVrd, NSteps); % 50 passos

    % Trajetória de pick2
    TrajPickVrd2 = jtraj(JPickVrd, JPickVrd2, NSteps); % 50 passos

    % Trajetória de place
    TrajPlaceVrd2 = jtraj(JPickVrd2, JPlaceVrd2, NSteps); % 50 passos

    % Trajetória de place
    TrajPlaceVrd = jtraj(JPlaceVrd2, JPlaceVrd, NSteps); % 50 passos

    % Trajetória de Home
    TrajHomeVrd = jtraj(JPlaceVrd, Home, NSteps); % 50 passos

    % Anima Trajetórias

    % Trajetória de pick
    ur10.animate(TrajPickVrd)

    % Trajetória para colocar
    for i=1:NSteps
        ur10.plot(TrajPickVrd2(i,:), 'delay', 0.05);

        AtualizaBloco(BlocoVerde,TrajPickVrd2,ur10,i)
    end

    % Trajetória para colocar
    for i=1:NSteps
        ur10.plot(TrajPlaceVrd2(i,:), 'delay', 0.05);

        AtualizaBloco(BlocoVerde,TrajPlaceVrd2,ur10,i)
    end

    % Trajetória para colocar
    for i=1:NSteps
        ur10.plot(TrajPlaceVrd(i,:), 'delay', 0.05);

        AtualizaBloco(BlocoVerde,TrajPlaceVrd,ur10,i)
    end

    % Trajetória de Home
    ur10.animate(TrajHomeVrd)

    A = 0;
else

    disp('Uma ou mais matrizes estão vazias na Parte a)');

    A = 1;
end

%% Mover o Bloco Azul
delete(a);
a = text(0,0,1.6,'Mover o Bloco Azul','FontName','Impact','FontSize',20);

PickPosAzl  = [-0.6-offset 0.4 0.2 + TamanhoPonta/2]; % posição acima do bloco (z)
PickPosAzl2 = [-0.6-offset 0.4 0.4 + TamanhoPonta/2]; % posição acima do bloco (z aumentado com segurança)
PlacePosAzl = [-0.25 0.8 0.2 + TamanhoPonta];        % posição de destino

% Matrizes das posiçoes alvo

MRot = trotx(pi); % Rotação 180° em X
MPickAzl  = transl(PickPosAzl) * MRot;
MPickAzl2  = transl(PickPosAzl2) * MRot;
MPlaceAzl = transl(PlacePosAzl) * MRot;

% Calcula juntas ( Testes !!!!!! )

%CheckPosicao(MPickAzl,ur10)

JPickAzl  = ur10.ikine(MPickAzl);
JPickAzl2  = ur10.ikine(MPickAzl2);
JPlaceAzl = ur10.ikine(MPlaceAzl);

% Calcula Trajetórias 

if ~isempty(JPickAzl) && ~isempty(JPickAzl2) && ~isempty(JPlaceAzl)

    % Trajetória de pick
    TrajPickAzl = jtraj(Home, JPickAzl, NSteps); % 50 passos

    % Trajetória de pick2
    TrajPickAzl2 = jtraj(JPickAzl, JPickAzl2, NSteps); % 50 passos

    % Trajetória de place
    TrajPlaceAzl = jtraj(JPickAzl2, JPlaceAzl, NSteps); % 50 passos

    % Trajetória de Home
    TrajHomeAzl = jtraj(JPlaceAzl, Home, NSteps); % 50 passos

    % Anima Trajetórias

    % Trajetória de pick
    ur10.animate(TrajPickAzl)


    % Trajetória para colocar
    for i=1:NSteps
        ur10.plot(TrajPickAzl2(i,:), 'delay', 0.05);

        AtualizaBloco(BlocoAzul,TrajPickAzl2,ur10,i)
    end

    % Trajetória para colocar
    for i=1:NSteps
        ur10.plot(TrajPlaceAzl(i,:), 'delay', 0.05);

        AtualizaBloco(BlocoAzul,TrajPlaceAzl,ur10,i)
    end

    % Trajetória de Home
    ur10.animate(TrajHomeAzl)

    B = 0;
else

    disp('Uma ou mais matrizes estão vazias na Parte b)');
    B = 1;
end

%% Fazer linha entre 2 vertices dos blocos

delete(a);
a = text(0,0,1.6,'Fazer linha entre 2 vertices dos blocos','FontName','Impact','FontSize',20);

StartPos = [0.05 0.9 0.35 - TamanhoPonta];
FinishPos = [-0.05 0.9 0.35 - TamanhoPonta]; 

% Matrizes das posiçoes alvo

MRot = trotx(pi); % Rotação 180° em X
MStart = transl(StartPos) * MRot;
MFinish = transl(FinishPos) * MRot;

% Calcula juntas ( Testes !!!!!! )

JStart = ur10.ikine(MStart);
JFinish = ur10.ikine(MFinish);

% Calcula Trajetórias

C = A + B;

if ~isempty(JStart) && ~isempty(JFinish) && C == 0

    % Trajetória de JStart
    TrajLineStart = jtraj(Home, JStart, NSteps); % 50 passos

    % Trajetória de JFinish
    TrajLine = jtraj(JStart, JFinish, NSteps); % 50 passos

    % Trajetória de Home
    TrajLineFinish = jtraj(JFinish, Home, NSteps); % 50 passos

    % Anima Trajetória da linha
    ur10.animate(TrajLineStart);
    ur10.animate(TrajLine);
    ur10.animate(TrajLineFinish);

    delete(a);
    a = text(0,0,1.6,'END','FontName','Impact','FontSize',20);
else

    disp('Uma ou mais matrizes estão vazias ou não foram movidos os 2 Blocos');
    
    
end

%end

%% Funçoes auciliares

    
function B = CriaBloco(Tipo, Pos, Cor, Dimensoes)

% Valores padrão

if nargin < 4, Dimensoes = [1 1 1]; end
if nargin < 3, Cor = 'g'; end
if nargin < 2, Pos = [0 0 0]; end

% Dimensões

% L -> Length -> comprimento;
% W -> Width -> largura;
% H -> Height -> altura;

switch lower(Tipo)
    case 'cubo'
        L = Dimensoes(1);
        W = Dimensoes(1); 
        H = Dimensoes(1);
    case 'retangulo'
        L = Dimensoes(1);
        W = Dimensoes(2);
        H = Dimensoes(3);
    otherwise
        error('Use "cubo" ou "retangulo".');
end

% Vértices base

vertices = [
    0 0 0;
    L 0 0;
    L W 0;
    0 W 0;
    0 0 H;
    L 0 H;
    L W H;
    0 W H];

% Faces (índices dos vértices)

faces = [
    1 2 3 4;
    5 6 7 8;
    1 2 6 5;
    2 3 7 6;
    3 4 8 7;
    4 1 5 8];

% Posicionar no centro

vertices(:,1) = vertices(:,1) - mean([0 L]) + Pos(1); % Da posiçao do bloco em x e aterra-o
vertices(:,2) = vertices(:,2) - mean([0 W]) + Pos(2); % Da posiçao do bloco em y e aterra-o 
vertices(:,3) = vertices(:,3) + Pos(3); % Da posiçao do bloco em z

% PLot

B = patch('Vertices', vertices, 'Faces', faces, ...
      'FaceColor', Cor, 'FaceAlpha', 1, 'EdgeColor', 'k');

% Ajustes

axis equal;
xlabel('X'); ylabel('Y'); zlabel('Z');
grid on;hold on;
    

end

function AtualizaBloco(Bloco,traj,Robo,i)
% Esta função deve ser chamada dentro de um ciclo for 

    Vertices = get(Bloco, 'Vertices');
    CentroAtual = mean(Vertices,1);
    Deslocamento = Robo.fkine(traj(i,:))*Robo.tool.t - CentroAtual';
    Vertices = Vertices + Deslocamento';
    set(Bloco, 'Vertices', Vertices);

end
