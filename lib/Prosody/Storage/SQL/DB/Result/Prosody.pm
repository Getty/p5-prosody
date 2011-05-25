package Prosody::Storage::SQL::DB::Result::Prosody;
# ABSTRACT: Result class for the prosody table

use Moose;
use DBIx::Class::Candy;

table 'prosody';

column host => {
	data_type => 'text',
	is_nullable => 1,
};

column user => {
	data_type => 'text',
	is_nullable => 1,
};

column store => {
	data_type => 'text',
	is_nullable => 1,
};

column key => {
	data_type => 'text',
	is_nullable => 1,
};

column type => {
	data_type => 'text',
	is_nullable => 1,
};

column value => {
	data_type => 'text',
	is_nullable => 1,
};

1;
