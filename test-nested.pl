#!/usr/bin/perl 

package MyTests;

use strict;
use warnings;

use base 'Test::Class::Nested';
use Test::More;

sub failingTest :Test {
    ok 1 for 1..2;
}

sub passingTest :Tests(2) {
    ok 1 for 1..2;
}

sub FailingTest2 :Tests(2) {
    ok 0;
    ok 1;
}

Foo->runtests;

