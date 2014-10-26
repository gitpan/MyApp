###########################
# Author : Jeff Mo
# Date : 01/04/2009
# Version : 1.0
###########################
package MyApp::Controller::Logout;

use strict;
use warnings;
use base qw(Catalyst::Controller);

sub index : Private {
    my ($self, $c) = @_;

    # Clear the user's state
    $c->logout;
	$c->flash->{message} = 'Sign out successfully.';
    # Send the user to the starting point
    $c->res->redirect($c->uri_for('/menu'));
}

1;
