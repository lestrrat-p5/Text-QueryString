use strict;
use Benchmark qw(cmpthese);

use Text::QueryString;
use Text::QueryString::PP;

# Sneaky. don't do this
@Text::QueryString::PP::ISA = qw(Text::QueryString);

my $xs = Text::QueryString->new;
my $pp = Text::QueryString::PP->new;
my @query_string = (
    "foo=bar",
    "foo=bar&bar=1",
    "foo=bar;bar=1",
    "foo=bar&foo=baz",
    "foo=bar&foo=baz&bar=baz",
    "foo_only",
    "foo&bar=baz",
);

cmpthese(-1, {
    xs => sub {
        foreach my $qs (@query_string) {
            my @q = $xs->parse($qs);
        }
    },
    pp => sub {
        foreach my $qs (@query_string) {
            my @q = $pp->parse($qs);
        }
    }
});
