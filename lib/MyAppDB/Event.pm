package MyAppDB::Event;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("event");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
  "uid",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "desc",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "target",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "e_time",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to("uid1", "MyAppDB::User", { username => "uid" });


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-01-06 10:56:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ItVrN3jxIXibZGNfmcnPKQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
