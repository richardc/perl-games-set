use strict;
package Games::Set::Card;
use base 'Class::Accessor::Fast';
our %properties = ( count   => [ qw( one      two       three   ) ],
                    colour  => [ qw( red      green     purple  ) ],
                    shape   => [ qw( oval     squiggle  diamond ) ],
                    pattern => [ qw( solid    open      striped ) ],
                   );
__PACKAGE__->mk_accessors( keys %properties );

=head2 random

construct a new card at random

=cut

sub random {
    my $class = shift;
    $class->new({ map {
        $_ => $properties{$_}[ rand @{ $properties{$_} } ]
    } keys %properties });
}

1;
__END__
