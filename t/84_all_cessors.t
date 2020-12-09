use strict; use warnings;
use Test::More tests => 181;

use Graph::Directed;
use Graph::Undirected;

sub test_graphs {
  my ($graphs, $methods, $label) = @_;
  for my $m (sort keys %$methods) {
    my $this_m = $methods->{$m};
    for my $k (sort keys %$this_m) {
      my $g = $graphs->{$k};
      my $gs = $g->stringify;
      for my $call ( @{ $this_m->{$k} } ) {
	my ($arg, $expected) = @$call;
	is "@{[sort $g->$m($arg)]}", $expected, "$label $k($gs) $m ($arg)";
      }
    }
  }
}

sub make_graphs {
    my ($spec, $class, $l) = @_;
    +{ map {
	my ($V, $E) = @{ $spec->{$_} };
	my $g = $class->new;
	$g->add_vertices(@$V);
	$g->add_edge(@$_) for @$E;
	($l.$_ => $g);
    } keys %$spec };
}

my %V_E = (
    0 => [ [], [] ],
    1 => [ [qw(a)], [] ],
    '2a' => [ [qw(a b)], [] ],
    '2b' => [ [], [[qw(a b)]] ],
    '2c' => [ [], [[qw(a b)], [qw(b a)]] ],
    3 => [ [], [[qw(a b)], [qw(a c)], [qw(b d)], [qw(b e)], [qw(c f)], [qw(c g)]] ],
    4 => [ [], [[qw(a b)], [qw(b a)], [qw(a a)]] ],
    5 => [ [], [[qw(a a)]] ],
);

{
    my $dg = make_graphs(\%V_E, 'Graph::Directed', 'd');
    test_graphs($dg, {
	successors => {
	    d0 => [ ['a', ""] ],
	    d1 => [ ['a', ""] ],
	    d2a => [ ['a', ""], ['b', ""] ],
	    d2b => [ ['a', "b"], ['b', ""] ],
	    d2c => [ ['a', "b"], ['b', "a"] ],
	    d3 => [ ['a', "b c"], ['b', "d e"], ['c', "f g"], ['d', ""], ['e', ""], ['f', ""], ['g', ""] ],
	    d4 => [ ['a', "a b"], ['b', "a"] ],
	    d5 => [ ['a', "a"] ],
	},
	all_successors => {
	    d0 => [ ['a', ""] ],
	    d1 => [ ['a', ""] ],
	    d2a => [ ['a', ""], ['b', ""] ],
	    d2b => [ ['a', "b"], ['b', ""] ],
	    d2c => [ ['a', "a b"], ['b', "a b"] ],
	    d3 => [ ['a', "b c d e f g"], ['b', "d e"], ['c', "f g"], ['d', ""], ['e', ""], ['f', ""], ['g', ""] ],
	    d4 => [ ['a', "a b"], ['b', "a b"] ],
	    d5 => [ ['a', "a"] ],
	},
	predecessors => {
	    d0 => [ ['a', ""] ],
	    d1 => [ ['a', ""] ],
	    d2a => [ ['a', ""], ['b', ""] ],
	    d2b => [ ['a', ""], ['b', "a"] ],
	    d2c => [ ['a', "b"], ['b', "a"] ],
	    d3 => [ ['a', ""], ['b', "a"], ['c', "a"], ['d', "b"], ['e', "b"], ['f', "c"], ['g', "c"] ],
	    d4 => [ ['a', "a b"], ['b', "a"] ],
	    d5 => [ ['a', "a"] ],
	},
	all_predecessors => {
	    d0 => [ ['a', ""] ],
	    d1 => [ ['a', ""] ],
	    d2a => [ ['a', ""], ['b', ""] ],
	    d2b => [ ['a', ""], ['b', "a"] ],
	    d2c => [ ['a', "a b"], ['b', "a b"] ],
	    d3 => [ ['a', ""], ['b', "a"], ['c', "a"], ['d', "a b"], ['e', "a b"], ['f', "a c"], ['g', "a c"] ],
	    d4 => [ ['a', "a b"], ['b', "a b"] ],
	    d5 => [ ['a', "a"] ],
	},
	all_neighbors => {
	    d0 => [ ['a', ""] ],
	    d1 => [ ['a', ""] ],
	    d2a => [ ['a', ""], ['b', ""] ],
	    d2b => [ ['a', "b"], ['b', "a"] ],
	    d2c => [ ['a', "b"], ['b', "a"] ],
	    d3 => [ ['a', "b c d e f g"], ['b', "a c d e f g"], ['c', "a b d e f g"], ['d', "a b c e f g"], ['e', "a b c d f g"], ['f', "a b c d e g"], ['g', "a b c d e f"] ],
	    d4 => [ ['a', "a b"], ['b', "a"] ],
	    d5 => [ ['a', "a"] ],
	},
	all_reachable => {
	    d0 => [ ['a', ""] ],
	    d1 => [ ['a', ""] ],
	    d2a => [ ['a', ""], ['b', ""] ],
	    d2b => [ ['a', "b"], ['b', ""] ],
	    d2c => [ ['a', "a b"], ['b', "a b"] ],
	    d3 => [ ['a', "b c d e f g"], ['b', "d e"], ['c', "f g"], ['d', ""], ['e', ""], ['f', ""], ['g', ""] ],
	    d4 => [ ['a', "a b"], ['b', "a b"] ],
	    d5 => [ ['a', "a"] ],
	},
    }, 'directed');
}

{
    my $dg = make_graphs(\%V_E, 'Graph::Undirected', 'u');
    test_graphs($dg, {
	successors => {
	    u0 => [ ['a', ""] ],
	    u1 => [ ['a', ""] ],
	    u2a => [ ['a', ""], ['b', ""] ],
	    u2b => [ ['a', "b"], ['b', "a"] ],
	    u2c => [ ['a', "b"], ['b', "a"] ],
	    u3 => [ ['a', "b c"], ['b', "a d e"], ['c', "a f g"], ['d', "b"], ['e', "b"], ['f', "c"], ['g', "c"] ],
	    u4 => [ ['a', "a b"], ['b', "a"] ],
	    u5 => [ ['a', "a"] ],
	},
	predecessors => {
	    u0 => [ ['a', ""] ],
	    u1 => [ ['a', ""] ],
	    u2a => [ ['a', ""], ['b', ""] ],
	    u2b => [ ['a', "b"], ['b', "a"] ],
	    u2c => [ ['a', "b"], ['b', "a"] ],
	    u3 => [ ['a', "b c"], ['b', "a d e"], ['c', "a f g"], ['d', "b"], ['e', "b"], ['f', "c"], ['g', "c"] ],
	    u4 => [ ['a', "a b"], ['b', "a"] ],
	    u5 => [ ['a', "a"] ],
	},
	all_neighbors => {
	    u0 => [ ['a', ""] ],
	    u1 => [ ['a', ""] ],
	    u2a => [ ['a', ""], ['b', ""] ],
	    u2b => [ ['a', "b"], ['b', "a"] ],
	    u2c => [ ['a', "b"], ['b', "a"] ],
	    u3 => [ ['a', "b c d e f g"], ['b', "a c d e f g"], ['c', "a b d e f g"], ['d', "a b c e f g"], ['e', "a b c d f g"], ['f', "a b c d e g"], ['g', "a b c d e f"] ],
	    u4 => [ ['a', "a b"], ['b', "a"] ],
	    u5 => [ ['a', "a"] ],
	},
	all_reachable => {
	    u0 => [ ['a', ""] ],
	    u1 => [ ['a', ""] ],
	    u2a => [ ['a', ""], ['b', ""] ],
	    u2b => [ ['a', "b"], ['b', "a"] ],
	    u2c => [ ['a', "b"], ['b', "a"] ],
	    u3 => [ ['a', "b c d e f g"], ['b', "a c d e f g"], ['c', "a b d e f g"], ['d', "a b c e f g"], ['e', "a b c d f g"], ['f', "a b c d e g"], ['g', "a b c d e f"] ],
	    u4 => [ ['a', "a b"], ['b', "a"] ],
	    u5 => [ ['a', "a"] ],
	},
    }, 'undirected');
}

{
    my $d0  = Graph::Directed->new;
    $d0->add_edge(0,1);
    $d0->add_edge(1,0);
    my @g = sort $d0->all_successors(0);
    is_deeply \@g, [ 0, 1 ],
      'all_successors works on false names' or diag explain \@g;
}
