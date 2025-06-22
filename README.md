# my_fpu

Este trabalho e parte da diciplina de sistemas digitais

O objetivo é desenvolver uma sistema de soma e subtração usando um padrão IEEE-754 modificado de acordo com o uma soma.

# Descrição

O projeto consiste no desenvolvimnto de um programa em VHDL ou SystemVerilog que recebe dois numeros representados por um padrão IEEE-754. Contudo, neste trabalho específico, o padrão é modificado de acordo com um cálculo fornecido pelo professor.

no caso o recebido foi
  8 + ((2+4+1+0+3+2+7+1+3) mod 4)
  o que deu 11
  sendo 11 o numero do expoente.
  a partir desse numero consegui o a mantisa por 31 - 11 o que deu 20 para mantisa
  e 1 padrão de uma fpu

# limites
Maior numero normal é aproximadamente 1,9974368165×10^308
Minimo numero normal é aproximadamente 2,472304287x10^-308

![image](https://github.com/user-attachments/assets/ba6ab631-bed2-4d39-9f48-65f881e8d1c9)
![image](https://github.com/user-attachments/assets/2b3323c1-1fa4-469c-be31-fec1e1954d21)

# tecnologias usadas
VHDL (VHSIC Hardware Description Language)
Simulações feitas com ferramentas como ModelSim/Quartus

# Como Executar

1.Abra o projeto em sua ferramenta de simulação ou desenvolvimento VHDL.
2.Execute o arquivo sim.do já providenciado, que compila e inicia a simulação, já adicionando as ondas e rodando os testbenches.

# Status do Projeto
Estrutura básica implementada.
Finalizado, com a calculadora funcionando corretamente, para os testes.
Documentação concluída

# Autor
Felipe de Lemos Chaves Dos Santos
