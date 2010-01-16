###########################
# Author : Jeff Mo
# Date : 01/04/2009
# Version : 1.0
###########################
package MyApp::Controller::Log;

use strict;
use warnings;
use base qw(Catalyst::Controller);

sub index : Private {
	my ( $self, $c ) = @_;
	$c->stash->{template} = "log.tt2";
}
1;