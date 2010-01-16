###########################
# Author : Jeff Mo
# Date : 01/04/2009
# Version : 1.0
###########################
package MyApp::Controller::User;

use strict;
use warnings;
use base qw(Catalyst::Controller::FormBuilder);

sub history : Local {
	my ( $self, $c ) = @_;
	if ( !$c->user_exists ) {
		$c->stash->{error} = "You need to log in first to use this function.";
		$c->stash->{template} = 'result.tt2';
		return 0;
	}
	my $rs;
	if ( $c->check_user_roles(qw/admin/) ) {
		$rs =
		  $c->model('MyAppDB::Event')
		  ->search( undef, { rows => 10, order_by => { -desc => 'e_time' } } );
	}
	else {
		$rs =
		  $c->model('MyAppDB::Event')
		  ->search( { uid => $c->user->obj->username() },
			{ rows => 10, order_by => { -desc => 'e_time' } } );
	}

	#page navigation
	my $page = $c->req->param('page');
	$page               = 1 if ( $page !~ /^\d+$/ );
	$rs                 = $rs->page($page);
	$c->stash->{pager}  = $rs->pager();
	$c->stash->{events} = $rs;
}

sub add : Local Form {
	my ( $self, $c ) = @_;
	my $form = $self->formbuilder;

	if ( $form->submitted && $form->validate ) {

		# form was submitted and it validated
		my $person = $c->model('MyAppDB::User')->find_or_new();
		$person->first_name( $form->field('fname') );
		$person->last_name( $form->field('lname') );
		$person->email_address( $form->field('email') );
		$person->username( $form->field('uid') );
		$person->password( $form->field('pwd') );
		$person->update_or_insert();
		$c->flash->{message} = 'Added ' . $person->first_name;
		$c->response->redirect( $c->uri_for('/login') );
	}
}

sub active : Local {
	my ( $self, $c, $arg, $id ) = @_;
	#my $form = $self->formbuilder;
	#if ( $form->submitted && $form->validate ) {
		my $user = $c->model('MyAppDB::User')->find( { username => $id } );
		$user->active($arg);
		$user->update_or_insert();
		my $status = $arg ? ' activated ' : ' deactivated ';
		my $result = $c->model('MyAppDB::Event')->create(
			{
				uid    => $c->user->obj->username(),
				desc   => $status . '  account : ',
				target => $id,
				e_time => MyApp::Util::now()
			}
		);
		$c->flash->{message} = 'Success!';
		$c->response->redirect( $c->uri_for('/user/view') );
	#}
}

sub edit : Local Form {
	my ( $self, $c, $id ) = @_;
	my $form = $self->formbuilder;
	my $user = $c->model('MyAppDB::User')->find( { username => $id } );
	if ( $form->submitted && $form->validate ) {
		$user->first_name( $form->field('fname') );
		$user->last_name( $form->field('lname') );
		$user->email_address( $form->field('email') );
		$user->password( $form->field('pwd') );
		$user->update_or_insert();
		my $result = $c->model('MyAppDB::Event')->create(
			{
				uid    => $c->user->obj->username(),
				desc   => ' edited account : ',
				target => $id,
				e_time => MyApp::Util::now()
			}
		);
		$c->flash->{message} = 'Edited ' . $user->first_name;
		$c->response->redirect( $c->uri_for('/menu') );
	}
	else {
		$form->field(
			name  => 'fname',
			value => $user->first_name
		);
		$form->field(
			name  => 'lname',
			value => $user->last_name
		);
		$form->field(
			name  => 'email',
			value => $user->email_address
		);
		$form->field(
			name  => 'pwd',
			value => $user->password
		);
	}
}

sub view : Local {
	my ( $self, $c, $uid ) = @_;
	if ( !$c->user_exists ) {
		$c->stash->{error} = "You need to log in first to use this function.";
		$c->stash->{template} = 'result.tt2';

		#$c->res->redirect( $c->uri_for('/menu') );
		return 0;
	}
	if ( $c->check_user_roles(qw/admin/) ) {
		$c->stash->{users} = $c->model('MyAppDB::User');
	}
	else {
		$c->stash->{users} =
		  $c->model('MyAppDB::User')
		  ->search( { username => $c->user->obj->username() } );
	}
}

sub delete : Local {
	my ( $self, $c, $id ) = @_;
	if ( $c->check_user_roles(qw/admin/) ) {
		$c->model('MyAppDB::User')->find($id)->delete();
		my $result = $c->model('MyAppDB::Event')->create(
			{
				uid    => $c->user->obj->username(),
				desc   => ' deleted ',
				target => $id,
				e_time => MyApp::Util::now()
			}
		);
		$c->flash->{message} = "User deleted";
	}
	else {
		$c->flash->{error} = "You are not authorized to delete this.";
	}
	$c->res->redirect( $c->uri_for('/user/view') );
}

#return a resultset
#sub search_uids {
#	my ( $self, $c, $uid ) = @_;
#	my $username = $uid ? $uid : $c->user->obj->username();
#	return $c->model('MyAppDB::User')->search( { username => $username } );
#}

1;
