###########################
# Author : Jeff Mo
# Date : 01/04/2009
# Version : 1.0
###########################
package MyApp::Controller::Item;

use strict;
use warnings;
use MyApp::Util;
use base qw/Catalyst::Controller::FormBuilder/;

sub add : Local Form {
	my ( $self, $c ) = @_;
	my $form = $self->formbuilder;

	$form->field(
		name => 'genre',
		options =>
		  [ map { [ $_->id, $_->name ] } $c->model('MyAppDB::Genre')->all ]
	);

	if ( $form->submitted && $form->validate ) {
		$c->log->debug( 'cmo:genre=' . $form->field('genre') );
		my $row = $c->model('MyAppDB::Item')->create(
			{
				title        => $form->field('title'),
				plot         => $form->field('plot'),
				year         => $form->field('year'),
				img          => $form->field('img'),
				release_date => MyApp::Util::now(),
				genre_items  => [ { g_id => $form->field('genre') }, ],
				uid          => $c->user->obj->username()
			}
		);
		my $result = $c->model('MyAppDB::Event')->create(
			{
				uid    => $c->user->obj->username(),
				desc   => ' created ',
				target => $row->title,
				e_time => MyApp::Util::now()
			}
		);
		$c->flash->{message} = 'Created ' . $row->title;
		$c->res->redirect( $c->uri_for('add') );
	}
}

sub detail : Local {
	my ( $self, $c, $id ) = @_;

	#my $genre = $c->session->{genre};
	my $result = $c->model('MyAppDB::Item')->find($id);
	$c->stash->{item} = $result;
}

sub search : Local {
	my ( $self, $c ) = @_;
	$c->stash->{genres} = $c->model('MyAppDB::Genre');
}

sub search_do : Local {
	my ( $self, $c ) = @_;
	my $genre  = $c->req->params->{sel};
	my $string = $c->req->params->{txt};
	$c->session->{genre}  = $genre;
	$c->stash->{string}   = $string;
	$c->stash->{template} = "item/search_result.tt2";
	$c->forward('search_result');
}

sub search_result : Local {
	my ( $self, $c ) = @_;
	my $genre = $c->session->{genre};
	my $result;
	if ($genre) {
		$result = $c->model('MyAppDB::Genre')->search( { id => $genre } );
	}
	else {
		$result = $c->model('MyAppDB::Genre');

		#->search( undef, { rows => 10, order_by => 'release_date' } );
	}
	$c->stash->{items} = $result;
}

sub delete : Local {
	my ( $self, $c, $id, $info ) = @_;
	if ( $c->check_user_roles(qw/admin/) ) {
		$c->model('MyAppDB::Item')->find($id)->delete();
		my $result = $c->model('MyAppDB::Event')->create(
			{
				uid    => $c->user->obj->username(),
				desc   => ' deleted ',
				target => $info,
				e_time => MyApp::Util::now()
			}
		);
		$c->flash->{message} = "Item deleted";
	}
	else {
		$c->flash->{error} = "You are not authorized to delete this.";
	}
	$c->res->redirect( $c->uri_for('search_result') );
}

sub checkout_do : Local {
	my ( $self, $c, $id, $info ) = @_;
	if ( !$c->user_exists ) {
		$c->flash->{error} = "You need to log in first to use this function.";
		$c->res->redirect( $c->uri_for('search_result') );
		return 0;
	}
	my $row = $c->model('MyAppDB::Event')->create(
		{
			uid    => $c->user->obj->username(),
			desc   => ' watched ',
			target => $info,
			e_time => MyApp::Util::now()
		}
	);
	if ($row) {
		$c->flash->{message} = 'Your checkout "' . $info . '" is completed.';
	}
	else {
		$c->flash->{message} = 'Your checkout "' . $info . '" is failed.';
	}
	$c->res->redirect( $c->uri_for('search_result') );
}

1;
