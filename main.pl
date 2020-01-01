use v5.26.1;
use strict;
use warnings;

my @campo = (
    [" "," "," "],
    [" "," "," "],
    [" "," "," "]
);

# esta função imprime uma matriz 3x3 (campo do Jogo da Velha)
sub imprime_campo {
    say "       0  1  2";
    for(my $i = 0; $i < 3; ++$i) {
        print "    $i ";
        for(my $j = 0; $j < 3; ++$j) {
            print "|", $campo[$i][$j], "|";
        }

        say ""; # quebra de linha para imprimir a próxima linha (parte) do Jogo da Velha
    }
}

# esta função verifica se um jogador ganhou. Recebe como parâmetro o símbolo do jogador que vai testar se ganhou ('x' ou 'o')
sub ganhou {

    # Posições vencedoras (todas testadas):
    # [0][0], [0][1], [0][2] OK
    # [1][0], [1][1], [1][2] OK
    # [2][0], [2][1], [2][2] OK
    # [0][0], [1][0], [2][0] OK
    # [0][1], [1][1], [2][1] OK
    # [0][2], [1][2], [2][2] OK
    # [0][0], [1][1], [2][2] OK
    # [0][2], [1][1], [2][0] OK
    #
    #    0  1  2
    # 0 | || || |
    # 1 | || || |
    # 2 | || || |
    
    my $jog = $_[0]; # ´$jog´ recebe o parâmetro que é o símbolo do jogador que vai testar se ganhou

    if($campo[0][0] eq $jog && $campo[0][1] eq $jog && $campo[0][2] eq $jog ||
       $campo[1][0] eq $jog && $campo[1][1] eq $jog && $campo[1][2] eq $jog ||
       $campo[2][0] eq $jog && $campo[2][1] eq $jog && $campo[2][2] eq $jog ||
       $campo[0][0] eq $jog && $campo[1][0] eq $jog && $campo[2][0] eq $jog ||
       $campo[0][1] eq $jog && $campo[1][1] eq $jog && $campo[2][1] eq $jog ||
       $campo[0][2] eq $jog && $campo[1][2] eq $jog && $campo[2][2] eq $jog ||
       $campo[0][0] eq $jog && $campo[1][1] eq $jog && $campo[2][2] eq $jog ||
       $campo[0][2] eq $jog && $campo[1][1] eq $jog && $campo[2][0] eq $jog) {
       return 1; # retorna verdadeiro (1) se o jogador ganhou
    }
    
    return 0; # retorna falso (0) se o jogador não ganhou
}

my $lin; # linha
my $col; # coluna

while(1) {

    print "\e[0;0H\e[2J"; # limpa a tela

    imprime_campo();
    
    # verifica se o jogador 2 ganhou
    if(ganhou("\033[1;32mo\033[1;0m")) {
	say "Jogador 2 ganhou, parabéns!";
	last;
    }
    
    say "\n********************";
    say "* Vez do jogador 1 *";
    say "********************";

    # pede a linha e a coluna e verifica se tal lugar está disponível
    while(1) {
	print "Linha: ";
	$lin = <STDIN>;
	print "Coluna: ";
	$col = <STDIN>;

	if($campo[$lin][$col] ne " ") {
	    say "Local ocupado, use outro.";
	} else {
	    last;
	}
    }
    
    $campo[$lin][$col] = "\033[1;31mx\033[1;0m"; # coloca o 'x' colorido no campo

    print "\e[0;0H\e[2J"; # limpa a tela

    imprime_campo();

    # verifica se o jogo empatou. O jogo empata quando todos os quadrados são usados e nenhum jogador ganha.
    if($campo[0][0] ne " " && $campo[0][1] ne " " && $campo[0][2] ne " " &&
       $campo[1][0] ne " " && $campo[1][1] ne " " && $campo[1][2] ne " " &&
       $campo[2][0] ne " " && $campo[2][1] ne " " && $campo[2][2] ne "") {
	say "O jogo terminou em um empate.";
	last;
    }

    # verifica se o jogador 1 ganhou
    if(ganhou("\033[1;31mx\033[1;0m")) {
        say "Jogador 1 ganhou, parabéns!";
	last;
    }

    while(1) {
        say "\n********************";
        say "* Vez do jogador 2 *";
        say "********************";

	# pede a linha e a coluna e verifica se o local já está ocupado
	while(1) {
	    print "Linha: ";
	    $lin = <STDIN>;
	    print "Coluna: ";
	    $col = <STDIN>;

	    if($campo[$lin][$col] ne " ") {
	        say "Local ocupado, use outro.";
	    } else {
		last;
	    }
	}
        
        $campo[$lin][$col] = "\033[1;32mo\033[1;0m"; # coloca o 'o' colorido no campo

        last; # interrompe o ciclo (vez) do jogador 2 e passa a vez para o jogador 1
    }
}
