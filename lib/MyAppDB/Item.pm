package MyAppDB::Item;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components( "InflateColumn::DateTime", "Core" );
__PACKAGE__->table("item");
__PACKAGE__->add_columns(
	"id",
	{
		data_type     => "INTEGER",
		default_value => undef,
		is_nullable   => 0,
		size          => undef,
	},
	"title",
	{
		data_type     => "TEXT",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
	"plot",
	{
		data_type     => "TEXT",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
	"year",
	{
		data_type     => "INTEGER",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
	"release_date",
	{
		data_type     => "TEXT",
		default_value => undef,
		is_nullable   => 1,
		size          => undef,
	},
	"uid",
	{
		data_type     => "TEXT",
		default_value => undef,
		is_nullable   => 0,
		size          => undef,
	},
	"img",
	{
		data_type     => "TEXT",
		default_value => undef,
		is_nullable   => 0,
		size          => undef,
	},
);
__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many( "genre_items", "MyAppDB::GenreItems",
	{ "foreign.i_id" => "self.id" },
);

__PACKAGE__->many_to_many( genres => 'genre_items', 'genre' );

__PACKAGE__->belongs_to( "oneuser", "MyAppDB::Users", { username => "uid" } );

# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-01-14 17:48:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:a9nC7/w0TnF0St0SePYqMA

# You can replace this text with custom content, and it will be preserved on regeneration
1;
