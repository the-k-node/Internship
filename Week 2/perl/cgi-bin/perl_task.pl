#!/usr/bin/perl -w

use CGI;
use List::MoreUtils qw(uniq);

my $cgi = new CGI;

print $cgi->start_html(
    -title=>'Nginx Log Summary',
    -bgcolor=>'gray',
    -vlink=>'black',
    -style => { -src => 'https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css' },
    -script => [
        { -src  => 'https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js' },
        { -src  => 'https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js' }
    ]
),

print $cgi->center($cgi->h3('Kiran Kumar S G')), "\n",
    $cgi->center('Week 2 | Perl Task'), "\n";

@dates=();
$LOGFILE = '../../access.log';

#Get All Dates from Logfile
open(LOGFILE) or die("ERROR: error opening LOGFILE");
foreach $line (<LOGFILE>){
    ($ip, $date) = split(' ', $line);
    #$time = substr($date, 12);
    $date = substr($date, 0, 11);
    push(@dates, $date);
}
close(LOGFILE);

#for each unique date, perform
@udate=uniq @dates;
print "<div class=\"container\"><div class=\"panel-group\" id=\"accordion\">\n";
for(my $i=0; $i <= $#udate; $i++){
    print "<div class=\"panel panel-default\">\n
      <div class=\"panel-heading\">\n
        <h4 class=\"panel-title\">\n
          <a data-toggle=\"collapse\" data-parent=\"#accordion\" data-target=\"#$i\">$udate[$i]</a>\n
        </h4>\n
      </div>\n";
    $ext = `source day_summary.sh; high_req $udate[$i]`;
    print "<div id=\"$i\" class=\"panel-collapse collapse\">\n
        <div class=\"panel-body\">$ext</div>\n
      </div>\n
    </div>\n";
}
print "</div>\n";

#use bash script to get the results
my $SCRIPTFILE = '../../script/bash_script.sh';

open(my $pipe, '-|', $SCRIPTFILE) or die $!;
while(my $line = <$pipe>){
    print "<p>$line</p>\n"
}

print "</div>\n",$cgi->end_html;
exit;