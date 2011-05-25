package Prosody::Storage::SQL::DB;
# ABSTRACT: DBIx::Class::Schema for the prosody database

use Moose;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;

1;
