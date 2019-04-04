#!/usr/bin/env perl

use utf8;

binmode(STDERR, ":utf8");
binmode(STDIN,  ":utf8");
binmode(STDOUT, ":utf8");

while (<>) {
  tr/qwertyuiop[]asdfghjkl;'zxcvbnm,.&/йцукенгшщзхъфывапролджэячсмитьбю?/;
} continue {
  print
}

#perl -Mutf8 -CS -lpe "tr/qwertyuiop[]asdfghjkl;'zxcvbnm,.&/йцукенгшщзхъфывапролджэячсмитьбю?/"
