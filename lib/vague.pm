package vague;

use Exporter;
use vars qw($VERSION @ISA @EXPORT $VERSION %AMOUNTS $AUTOLOAD $ness $rnd_index $rnd_indexw @rnd_words @rnd_numbers);

# define our vagueness terms
%AMOUNTS = (
	none => 0,
	hardly => 0.08,
	few => 0.10,
	some => 0.25,
	many => 0.40,
	quite => 0.50,
	lots => 0.65,
	most => 0.80,
	almost => 0.90,
	nearly => 0.95,
	all => 1,
);

@rnd_words = qw(country horizon halibut glockespiel pipe water sun he epworth cloying relax pluck matted tissue bye-bye eight llanblethian didn't supple wenge);
@rnd_numbers = qw(4 8 6 15 2 3 12 17 9 20 16 18 10 11 7 13 14 1 5 19 );
$rnd_indexw = int( rand( scalar(@rnd_words) ) ); 
$rnd_index = int( rand( scalar(@rnd_numbers) ) );

# default vagueness
$ness = 0.15;

# Exporter stuff
@ISA = 'Exporter';
@EXPORT = (keys(%AMOUNTS) , qw(of roughly any generally probably random word number));
($VERSION) = ('$Revision: 1.3 $' =~ /([\d\.]+)/);

### Main Methods ############################

# we use this as the generic list operator
sub AUTOLOAD {
	my $quality = $AUTOLOAD;
	$quality =~ s/^.*://;
	
	# only work if we know the adjective in question
	if (exists $AMOUNTS{$quality}) {
		if ($#_ > 0) {
			# if operating on an array return 'some' of it
			return ( grep { rand(1) < roughly($AMOUNTS{$quality}, 1, 0) } @_ );
		} elsif ($#_ == 0) {
			# if given a single scalar, so scale it
			return _rough_scalar($_[0], $quality);
		}
	} else {
		warn("vague.pm probably doesn't know how to handle $quality");
	}
}

# well it doesn't really mean much, but it allows a much more English style of perl
sub of { return @_; }

# depending on context either return the whole thing, shuffled
# or return 'any element' of the list
sub any {
	if (wantarray()) {
		my @new = ();
		while (@_) {
			push(@new, splice(@_, rand @_, 1));
		}
		return @new;
	} else {
		return $_[ int( rand( scalar( @_ ) ) ) ];
	}
}

# Return a rough version of the supplied scalar. Other args optional
sub roughly {
	my $mean = shift;
	my $ceil = shift;
	my $floor = shift;
	my $dev = shift || ( $ness * $mean );
	
	my $rand = (rand() * 2) - 1;
	my $delta = $dev * ( $rand * abs($rand) ) * 2; # 2 because we want all of the values within $dev
	
	my $rv = $mean + $delta;
	if (defined($ceil) && $rv > $ceil) { $rv = $ceil; }
	if (defined($floor) && $rv < $floor) { $rv = $floor; }
	return $rv;
}

# probably execute a coderef - makes most sense in a loop
sub generally {
	my $ref = shift;
	if ( (rand() < $AMOUNTS{'most'}) && (ref($ref) eq 'CODE') ) {
		&$ref;
	};
}

# a synonym that reads best outside a loop construct
*probably = *generally;

# return a pseudo-random number or word.
sub random {
	my $type = shift;
	my $rv;
	
	if ($type eq 'word') {
		$rnd_indexw++;
		$rv = (rand() < 0.04)? 'feck!' : $rnd_words[ $rnd_indexw % scalar(@rnd_words) ];
	} else {
		$rnd_index++;
		$rv = (rand() < 0.04)? 22/7 : $rnd_numbers[ $rnd_index % scalar(@rnd_numbers) ];
	}
	if (wantarray()) {
		return ($rv, @_);
	} else {
		return $rv;
	}
}

# just to stop strict complaining
sub word { 'word' }

sub number { 'number' }

### Private ####################

sub _rough_scalar {
	my ($scalar, $adjective) = @_;
	
	my $amount = roughly($AMOUNTS{$adjective}, 1, 0);
	
	if ($scalar =~ m/^[\d\.\-eE]+$/) {
		# if given a single numeric scalar, multiply it
		return ($amount * $scalar);
	} else {
		# if given a single text scalar, give back 'some' of the string
		return substr($scalar, 0, int( $amount * length($scalar) ));
	}
}

=head1 NAME

vague - Perl pragma to reduce precision in your programming constructs

=head1 SYNOPSIS

    use vague;

=head1 DESCRIPTION

This pragma exports a set of new, imprecise keywords into your namespace to
facilitate fuzzy programming methodologies and nondeterministic algorithms.

=over 4

=item none, hardly, few, some, many, quite, lots, most, almost, nearly, all

If given a list of arguments these methods return some random subset of the list, from roughly 'none' items to roughly 'all' of them.
If given a single scalar that is numeric they return a number that is appropriately smaller than the input variable.
If given a string they return an appropriately long substring, starting at the start of the string.

=item any (@list)

In scalar context it returns an element from its list of arguments. In list context it returns the entire list, shuffled.

	$x = any of qw(a b c d e f g h i j);
	foreach ( any qw(a b c d e f g h i j) ) {
	#...

=item roughly ($scalar [ $ceiling [ $floor [ $spread ]]])

Returns a number that is roughly $scalar. Optionally you can supply a ceiling, and a floor, to limit the range returned.
The $spread argument just says how wide the deviations can be.

=item generally $coderef B<or> probably $coderef

Probably execute the code referred to. You can say, for example:

	probably sub { print "Hello world\n"; };
	generally \&trace('message');

=item random number, random word

Returns a pseudo-random word if followed by 'word', or pseudo-random integer otherwise. The sequence repeats every 20 
calls to this functions. Occasionally you will get 'feck!' or 22/7 returned instead of one of the usual values. 
This is normal behaviour.

=item of

Does nothing, but allows nice English-like constructions such as:

	for (most of 1..20) { # etc...

=back

=head1 EXAMPLES

	print some of 1, 2, 3, 4, 5, 6, 7, 8, 9, 10;
	print nearly all of "And did those feet in ancient times walk upon England's mountains green.";
	print hardly any of "And did those feet in ancient times walk upon England's mountains green.";

	my $number = roughly 20;
	$number = almost 20;

	my @widgets = qw(a b c d e f g);
	my $x = any @widgets;

	for (most of 1..20) {
		generally \&foo('hello');
	}

	probably sub { foo('prob') };

	for (1..30) {
		print random word, " ", random number, "\n";
	}

	sub foo { my $msg = shift; print "In foo msg $msg\n"; }

=head1 AUTHOR AND COPYRIGHT

P Kent, pause@selsyn.co.uk Nov 2001 This is covered by the same terms as Perl itself.

$Id: vague.pm,v 1.3 2001/12/20 05:13:24 piers Exp $

=cut

