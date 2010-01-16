package MyApp::Controller::Event;

use strict;
use warnings;
use MyApp::Util;
use base qw/Catalyst::Controller/;

sub insert {
	my ( $self, $c, $act, $obj ) = @_;
	my $row = $c->model('MyAppDB::Event')->create(
		{
			uid    => $c->user->obj->username(),
			desc   => $act,
			target => $obj,
			e_time => MyApp::Util::now()
		}
	);
}

1;
