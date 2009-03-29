package Test::Class::Nested;

use strict;
use warnings;

use base 'Test::Class';
use Test::More;

our %testcases;

sub Test : ATTR(CODE,RAWDATA) {
    my ( $pkg, $funct, $code, $attr, $detail ) = @_;

    $detail ||= 1;

    my ( undef, $num_tests ) = Test::Class::_parse_attribute_args($detail);

    # override the number of tests for Test::Class
    $_[4] = 1;

    no warnings;    # black magic starts here

    my $func_name = *{$funct}{NAME};
    my $fullname  = $pkg . '::' . $func_name;

    push @{ $testcases{$pkg} }, $func_name;

    *{$funct} = sub {
        subtest $fullname => sub {
            plan $num_tests
              ? ( tests => $num_tests )
              : 'no_plan';
            $code->();
          }
    };

    Test::Class::Test(@_);
}

# copied verbatim from Test::Class, so
# that the call can be intercepted in
# Test::Class::Nested
sub Tests : ATTR(CODE,RAWDATA) {
    my ( $class, $symbol, $code_ref, $attr, $args ) = @_;
    $args ||= 'no_plan';
    Test( $class, $symbol, $code_ref, $attr, $args );
}

1;
