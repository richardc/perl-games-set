#!perl -w
use strict;
use Test::More tests => 12;

require_ok( 'Games::Set' );
my $game = Games::Set->new;

isa_ok( $game, 'Games::Set' );

my ($card) = $game->random_deck( 1 );
isa_ok( $card, 'Games::Set::Card' );

ok( $game->deck([ $card ]) );

is( $game->deal, $card, "dealt card" );
is( $game->deal, undef, "deck empty" );

my @set = map { Games::Set::Card->new({
    count   => 'one',
    colour  => 'red',
    shape   => 'squiggle',
    pattern => 'solid'
   }) } 1..3;

is( scalar @set, 3, "made 3 cards" );
ok( $game->set( @set ), "which are a set" );

ok( $set[0]->colour("green") );
ok( !$game->set( @set ), "now not a set" );

ok( $set[1]->colour("purple") );
ok( $game->set( @set ), "and now a set again" );
