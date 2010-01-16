package MyAppDB::GenreItems;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("genre_items");
__PACKAGE__->add_columns(
  "g_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "i_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("g_id", "i_id");
__PACKAGE__->belongs_to("item", "MyAppDB::Item", { id => "i_id" });
__PACKAGE__->belongs_to("genre", "MyAppDB::Genre", { id => "g_id" });


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-01-14 17:48:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RMo6yDp2WSbTppVuDZlFMQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
