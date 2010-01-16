###########################
# Author : Jeff Mo
# Date : 01/04/2009
# Version : 1.0
###########################
package MyAppDB;

use base qw/DBIx::Class::Schema/;

__PACKAGE__->load_classes({
    MyAppDB => [qw/User Item Genre Event Role UserRole GenreItems/]
});

1;
