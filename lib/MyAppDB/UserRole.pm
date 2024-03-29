package MyAppDB::UserRole;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components( "InflateColumn::DateTime", "Core" );
__PACKAGE__->table("user_roles");
__PACKAGE__->add_columns(
	"user_id",
	{
		data_type     => "INTEGER",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
	"role_id",
	{
		data_type     => "INTEGER",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
);
__PACKAGE__->set_primary_key( "user_id", "role_id" );

#
# Set relationships:
#

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
__PACKAGE__->belongs_to( "user_id_", "MyAppDB::User", { username => "user_id" },
);
__PACKAGE__->belongs_to( "role", "MyAppDB::Role", { id => "role_id" } );

# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-01-07 17:32:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:O3fCfAfzJMlpZYGMvVhbEg

# You can replace this text with custom content, and it will be preserved on regeneration
1;
