package MyAppDB::User;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components( "InflateColumn::DateTime", "Core" );
__PACKAGE__->table("users");
__PACKAGE__->add_columns(
	"username",
	{
		data_type     => "TEXT",
		default_value => undef,
		is_nullable   => 0,
		size          => undef,
	},
	"password",
	{
		data_type     => "TEXT",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
	"email_address",
	{
		data_type     => "TEXT",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
	"first_name",
	{
		data_type     => "TEXT",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
	"last_name",
	{
		data_type     => "TEXT",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
	"active",
	{
		data_type     => "INTEGER",
		default_value => 1,
		is_nullable   => 1,
		size          => undef,
	},
);
__PACKAGE__->set_primary_key("username");

__PACKAGE__->has_many(
	"events", "MyAppDB::Event",
	{ "foreign.uid" => "self.username" },
);

__PACKAGE__->has_many(
  "map_user_role",
  "MyAppDB::UserRole",
  { "foreign.user_id" => "self.username" },
);
#roles : field name of User
__PACKAGE__->many_to_many( roles => 'map_user_role', 'role' );

__PACKAGE__->has_many(
  "items",
  "MyAppDB::Item",
  { "foreign.uid" => "self.username" },
);

# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-01-07 17:32:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:h4vM1uJ8X7pBH9BAPVhmKg

# You can replace this text with custom content, and it will be preserved on regeneration
1;
