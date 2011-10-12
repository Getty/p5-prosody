package App::CopyProsodyDB;
# ABSTRACT: Class of the copy_prosody_db script

use Moose;
use Moose::Util::TypeConstraints;
use Prosody::Storage::SQL;

with qw(
	MooseX::Getopt
);

has src_driver => (
	is => 'ro',
	isa => enum(["SQLite3","MySQL","PostgreSQL"]),
	required => 1,
);

has src_database => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

has src_username => (
	is => 'ro',
	isa => 'Str',
	predicate => 'has_src_username',
);

has src_password => (
	is => 'ro',
	isa => 'Str',
	predicate => 'has_src_password',
);

has trg_driver => (
	is => 'ro',
	isa => enum(["SQLite3","MySQL","PostgreSQL"]),
	required => 1,
);

has trg_database => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

has trg_username => (
	is => 'ro',
	isa => 'Str',
	predicate => 'has_trg_username',
);

has trg_password => (
	is => 'ro',
	isa => 'Str',
	predicate => 'has_trg_password',
);

has _src => (
	is => 'ro',
	isa => 'Prosody::Storage::SQL',
	lazy_build => 1,
);

sub _build__src {
	my ( $self ) = @_;
	my %vars = (
		driver => $self->src_driver,
		database => $self->src_database,
	);
	$vars{username} = $self->src_username if $self->has_src_username;
	$vars{password} = $self->src_password if $self->has_src_password;
	return Prosody::Storage::SQL->new(%vars);
}

has _trg => (
	is => 'ro',
	isa => 'Prosody::Storage::SQL',
	lazy_build => 1,
);

sub _build__trg {
	my ( $self ) = @_;
	my %vars = (
		driver => $self->trg_driver,
		database => $self->trg_database,
	);
	$vars{username} = $self->trg_username if $self->has_trg_username;
	$vars{password} = $self->trg_password if $self->has_trg_password;
	return Prosody::Storage::SQL->new(%vars);
}

use Data::Printer;

sub BUILD {
	my ( $self ) = @_;
	for ($self->_src->rs->search({})->all) {
		$self->_trg->rs->create({
			host => $_->host,
			key => $_->key,
			store => $_->store,
			type => $_->type,
			user => $_->user,
			value => $_->value,
		});
	}
}

1;