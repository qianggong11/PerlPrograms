#!/usr/bin/perl
use strict;
use warnings;
## Original author: Weiwei Zhai
## Rewrite it in Perl: Qiang Gong

sub fst {
    my ( $a1, $a2, $n1, $n2 ) = @_;
    my $p1  = $a1 / $n1;
    my $p2  = $a2 / $n2;
    my $msp = ( $n1 + $n2 ) * ( $p1 - $p2 ) ^ 2 / 4;
    print "$msp\n";
    my $nc = 2 * $n1 * $n2 / ( $n1 + $n2 );
    my $sasq = ( $p1 - $p2 ) ^ 2 / 2;
    my $t1 =
      $sasq - 1 /
      ( ( $n1 + $n2 ) / 2 - 1 ) *
      ( ( $p1 + $p2 ) / 2 * ( 1 - ( $p1 + $p2 ) / 2 ) - $sasq );
    my $t2 =
      ( $nc - 1 ) /
      ( ( $n1 + $n2 ) / 2 - 1 ) *
      ( $p1 + $p2 ) / 2 *
      ( 1 - ( $p1 + $p2 ) / 2 ) +
      ( 1 + ( ( $n1 + $n2 ) / 2 - $nc ) / ( ( $n1 + $n2 ) / 2 - 1 ) ) *
      $sasq / 2;
    my $fst = $t1 / $t2;
    $fst;
}

print &fst( 3, 4, 10, 20 ), "\n";

