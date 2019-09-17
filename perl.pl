#!/usr/bin/env perl

use 5.016;     
use warnings;
use autodie;
use DBI;

# -------------------------------------------------------------------------------
# Avant de lancer ce programme, n'oubliez pas d'installer la librarie DBD::SQLite
# à l'aide de la commande : sudo cpanm DBD::SQLite
# -------------------------------------------------------------------------------

my $dbh = DBI->connect('DBI:SQLite:dbname=base.db', undef, undef, { RaiseError => 1 }) 
   or die $DBI::errstr;

my $sth = $dbh->prepare( 'SELECT titre from articles;' );

if($sth->execute() or die $DBI::errstr) {
    while(my @row = $sth->fetchrow_array()) {
        say $row[0];
    }
}

$sth->finish();
$dbh->disconnect();