package Text::QueryString;
use strict;
use XSLoader;
our $VERSION;
BEGIN {
    $VERSION = '0.01';
    if ($ENV{PERL_TEXT_QUERYSTRING_BACKEND} eq 'PP') {
        require Text::QueryString::PP;
        no strict 'refs';
        *parse = \&Text::QueryString::PP::parse;
    } else {
        eval {
            XSLoader::load(__PACKAGE__, $VERSION);
            require constant;
            constant->import(BACKEND => "XS");
        };
        if ($@) {
            warn "Failed to require Text::QueryString XS backend: $@";
            require Text::QueryString::PP;
            no strict 'refs';
            *parse = \&Text::QueryString::PP::parse;
        }
    }
}

sub new { bless {}, shift }

1;

__END__

=head1 NAME

Text::QueryString - Fast QueryString Parser

=cut