use strict;
package Games::Set;
use Games::Set::Card;
use Algorithm::ChooseSubsets;
use Algorithm::GenerateSequence;
use List::Util qw( max );
use base 'Class::Accessor::Fast';
__PACKAGE__->mk_accessors(qw( deck ));
our $VERSION = 0.01;

=head1 NAME

Games::Set - The rules for the game of Set

=head1 SYNOPSIS

  my $game = Games::Set->new({ deck => [ Games::Set->standard_deck ] });
  $game->shuffle;
  my @cards = map { $game->deal } 1..3; # give me 3 cards
  print $game->set( @cards ) ? "set\n" : "no set\n";

=head1 DESCRIPTION

=head1 METHODS

=head2 new

Class::Accessor inherited constructor

=head2 deck

The current deck

=head2 shuffle

Shuffle the current deck

=cut

# the fisher-yates shuffle from perlfaq4

sub shuffle {
    my $self = shift;
    my $deck = $self->deck;

    my $i = @$deck;
    while ($i--) {
        my $j = int rand ($i+1);
        @$deck[$i,$j] = @$deck[$j,$i];
    }
}

=head2 deal

Take a card from the top of the current deck

=cut

sub deal {
    my $self = shift;
    shift @{ $self->deck };
}

=head2 standard_deck

calculates the standard deck as a list of Games::Set::Card objects

=cut

sub standard_deck {
    my $self = shift;
    my $iter = Algorithm::GenerateSequence->new(
        values %Games::Set::Card::properties
       );
    map {
        my %h; @h{ keys %Games::Set::Card::properties } = @$_;
        Games::Set::Card->new(\%h)
      } $iter->as_list;
}

=head2 random_deck( $n )

create a random deck of $n cards, as a list of Games::Set::Card objects

=cut

sub random_deck {
    my $self  = shift;
    my $count = shift;
    map { Games::Set::Card->random } 1..$count;
}

=head2 set( @cards )

returns true if the cards make a set

=cut

sub set {
    my $self = shift;
    for my $property ( keys %Games::Set::Card::properties ) {
        my %seen;
        $seen{ $_->$property() }++ for @_;
        next if (keys %seen)       == 1; # all same
        next if (max values %seen) == 1; # all different
        return;
    }
    return 1;
}

=head2 find_sets( @cards )

return all the possible sets within @cards as array references

=cut

sub find_sets {
    my $self = shift;

    my @found;
    my $iter = Algorithm::ChooseSubsets->new( \@_, 3 );
    while (my $set = $iter->next) {
        push @found, $set if $self->set(@$set);
    }
    return @found;
}


1;
__END__

