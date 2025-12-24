# Simulação de Manipulação com Robô UR10 - MATLAB

Este projeto foi desenvolvido para a unidade curricular de Introdução à Robótica da Licenciatura em Automação Industrial na Universidade de Aveiro. O objetivo principal é simular o robô industrial UR10 a realizar tarefas de manipulação e desenho em ambiente 3D.

* [Vídeo de demonstação](https://youtu.be/Y7lUG2VKP8M)

---
**Autor:** Tomás Espincho (110486) **Data:** Novembro de 2025
--- 

## Tecnologias e Requisitos

* **MATLAB:** Ambiente de desenvolvimento.

* **Robotics Toolbox for MATLAB (Peter Corke):** Necessário para as funções de modelação do UR10, ikine, fkine e jacob0. 

--- 

## Funcionalidades

O projeto simula uma sequência lógica de operações:

* **Pick & Place (Bloco Verde):** O robô sai da posição Home, recolhe o bloco verde e coloca-o na mesa usando cinemática inversa (ikine).

* **Pick & Place (Bloco Azul):** O processo repete-se para o bloco azul, posicionando-o a 50 cm de distância do primeiro.

* **Desenho de Linha:** Após o posicionamento, o robô utiliza a ferramenta para desenhar uma linha reta entre dois vértices dos blocos, utilizando o Jacobiano Geométrico para calcular a trajetória.

* **Atualização Dinâmica:** Durante o transporte, a posição dos blocos é atualizada em tempo real com base na cinemática direta (fkine) do robô.

--- 

## Estrutura do Código

* **tp1_110486.m:** Script principal contendo a lógica de movimento, cálculos de trajetória e funções auxiliares.

    * **CriaBloco:** Função para gerar a geometria da mesa e dos blocos usando patch.

    * **AtualizaBloco:** Função que sincroniza o movimento do bloco com a ponta da ferramenta (tool).

* **Relatorio_IR.pdf:** Documentação detalhada explicando a teoria e implementação.

--- 

## Como Executar

Certifique-se de que o Robotics Toolbox de Peter Corke está instalado e adicionado ao path do MATLAB.

Execute a função principal no terminal do MATLAB:
```Matlab
tp1_110486(0) % O argumento da função permite ajustar a distância inicial dos blocos em relação a mesa
```
---
Este projeto é distribuído sob a licença GNU GENERAL PUBLIC LICENSE. Para mais informações, consulte o ficheiro [LICENSE](.\COPYING) presente neste repositório.

---