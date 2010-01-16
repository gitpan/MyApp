package MyApp::Util;

use strict;
use warnings;
use HTTP::Date;

sub now {
	return HTTP::Date::time2iso(time);
}

1;