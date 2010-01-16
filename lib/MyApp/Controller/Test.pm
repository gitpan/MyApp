package MyApp::Controller::Test;

use strict;
use warnings;
use base qw(Catalyst::Controller);

sub index : Private {
	my ( $self, $c ) = @_;
	my @people_fields = qw/name/;
	my @tokens        = qw/a/;
	@people_fields = cross( \@people_fields, \@tokens );

	$c->stash->{fields} = \@people_fields;

	# result is a resultset
	my $rs =
	  $c->model('MyAppDB::Item')
	  ->search( \@people_fields, { rows => 3,, order_by => 'name' } );

	my $page = $c->req->param('page');
	$page              = 1 if ( $page !~ /^\d+$/ );
	$rs                = $rs->page($page);
	$c->stash->{pager} = $rs->pager();
	$c->stash->{items}    = $rs;
	
	$c->stash->{template} = 'test.tt2';

#	$c->stash->{users} =
#	  $c->model('MyAppDB::User')
#	  ->search( undef, { rows => 3, order_by => 'username' } );
}

#generates a list of all columns paired with all the search tokens
sub cross {
	my $columns = shift || [];
	my $tokens  = shift || [];
	map { s/%/\\%/g } @$tokens;
	my @result;
	foreach my $column (@$columns) {
		push @result, ( map +{ $column => { -like => "%$_%" } }, @$tokens );
	}
	return @result;
}

1;
