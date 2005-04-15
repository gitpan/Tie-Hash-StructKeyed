use strict; use warnings;
use Test::More tests => 16;
use Tie::Hash::StructKeyed;

# hakim@fotango.com 13 April 2005

tie my %hash, 'Tie::Hash::StructKeyed';

isa_ok(\%hash, 'HASH');
isa_ok(tied(%hash), 'Tie::Hash::StructKeyed');

$hash{foo} = "Foo";
$hash{bar} = "Bar";
is($hash{foo}, 'Foo',
  'Basic (non-array) thing still works');
is($hash{bar}, 'Bar');
is($hash{baz}, undef, 'undef value');

$hash{['wibble', 'foo','bar','baz']} = "WibbleFooBarBaz";
$hash{['wobble', 'foo','bar','baz']} = "WobbleFooBarBaz";

is($hash{['wibble', 'foo','bar','baz']}, 'WibbleFooBarBaz', 
  '[subscripted key] works');
is($hash{['wobble', 'foo','bar','baz']}, 'WobbleFooBarBaz');
is($hash{['wurble', 'foo','bar','baz']}, undef, "Undef");

$hash{['UK', 'English']} = 100;
$hash{['UK', 'German']}  = 10;
$hash{['DE', 'German']}  = 90;
$hash{['DE', 'English']} = 20;

is($hash{['UK', 'English']}, 100, 'multi-path tests');
is($hash{['UK', 'German']},  10);
is($hash{['DE', 'German']},  90);
is($hash{['DE', 'English']}, 20);

$hash{['foo','bar','baz']} =   "FooBarBaz";
is($hash{['foo','bar','baz']}, 'FooBarBaz', 
    '[subscripted key] works');

my @keys = keys %hash;
is_deeply(\@keys, [ 
          [
            'UK',
            'German'
          ],
          'bar',
          [
            'DE',
            'German'
          ],
          [
            'DE',
            'English'
          ],
          [
            'UK',
            'English'
          ],
          'foo',
          [
            'wobble',
            'foo',
            'bar',
            'baz'
          ],
          [
            'wibble',
            'foo',
            'bar',
            'baz'
          ],
          [
            'foo',
            'bar',
            'baz'
          ]
    ],
    'Keys returned (in order expected by my machine - I guess this is not a good test though...)');

$hash{ {anon => [1, {complex => 2}]} } = 'complex1';
$hash{ ['list', { foo => 'bar'}] }     = 'complex2';

is ($hash{ {anon => [1, {complex => 2}]} }, 'complex1', 'complex 1');
is ($hash{ ['list', { foo => 'bar'}] }    , 'complex2', 'complex 2');
