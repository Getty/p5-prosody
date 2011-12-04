package Prosody::Mod::Data::Access;

use Moose;
use LWP::UserAgent;
use JSON;
use Encode;

our $VERSION ||= '0.0development';

has hostname => (
	is => 'ro',
	isa => 'Str',
	lazy_build => 1,
);

sub _build_hostname { 'localhost' }

has port => (
	is => 'ro',
	isa => 'Int',
	lazy_build => 1,
);

sub _build_port { '5280' }

sub first_path_part { 'data' }

has jid => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

has password => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

sub http_agent { __PACKAGE__.'/'.$VERSION }
sub realm { 'WallyWorld' }

has _useragent => (
	is => 'ro',
	isa => 'LWP::UserAgent',
	lazy_build => 1,
);

sub _build__useragent {
	my ( $self ) = @_;
	my $ua = LWP::UserAgent->new;
	$ua->agent($self->http_agent);
	$ua->credentials($self->hostname.':'.$self->port,$self->realm,$self->jid,$self->password);
	return $ua;
}

sub get {
	my ( $self, $user, $store ) = @_;
	$store = 'accounts' if !$store;
	my @jid_parts = split('@',$self->jid);
	my $url = 'http://'.$self->hostname.':'.$self->port.'/'.$self->first_path_part.'/'.$jid_parts[1].'/'.$user.'/'.$store.'/json';
	my $res = $self->_useragent->get($url);
	if ($res->is_success) {
		return decode_json(encode('utf8', $res->content));
	} else {
		die __PACKAGE__." error on HTTP request: ".$res->status_line;
	}
}

1;