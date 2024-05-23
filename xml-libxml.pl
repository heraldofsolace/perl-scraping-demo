use LWP::UserAgent;
use XML::LibXML;
use open qw( :std :encoding(UTF-8) );

my $ua = LWP::UserAgent->new;
$ua->agent("Quotes Scraper");

my $url = "https://quotes.toscrape.com/";

my $request = $ua->get($url) or die "An error occurred $!\n";

if ($request->is_success) {
    $dom = XML::LibXML->load_html(string => $request->content, recover => 1, suppress_errors => 1);

    my $xpath = '//div[@class="quote"]';

    foreach my $quote ($dom->findnodes($xpath)) {
        my ($text) = $quote->findnodes('.//span[@class="text"]')->to_literal_list;

        my ($author) = $quote->findnodes('.//small[@class="author"]')->to_literal_list;

        print "$text: $author\n";
    }

} else {
  print "Cannot parse the result. " . $request->status_line . "\n";
}
