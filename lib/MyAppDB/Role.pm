package MyAppDB::Role;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components( "InflateColumn::DateTime", "Core" );
__PACKAGE__->table("roles");
__PACKAGE__->add_columns(
	"id",
	{
		data_type     => "INTEGER",
		default_value => undef,
		is_nullable   => 0,
		size          => undef,
	},
	"role",
	{
		data_type     => "TEXT",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
	"map_role_user", "MyAppDB::UserRole",
	{ "foreign.role_id" => "self.id" },
);
#__PACKAGE__->many_to_many( users => 'map_role_user', 'role' );

# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-01-07 17:32:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EuvDmEJvT6nI9kgyUHbZ+g

# You can replace this text with custom content, and it will be preserved on regeneration
1;
