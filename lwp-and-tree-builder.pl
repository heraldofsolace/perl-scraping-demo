use LWP::UserAgent;
use HTML::TreeBuilder;

my $ua = LWP::UserAgent->new;
$ua->agent("Quotes Scraper");

my $url = "https://quotes.toscrape.com/";
my $root = HTML::TreeBuilder->new();

my $request = $ua->get($url) or die "An error occurred $!\n";

if ($request->is_success) {
    $root->parse($request->content);
    my @quotes = $root->look_down(
        _tag => 'div',
        class => 'quote'
    );

    foreach my $quote (@quotes) {
        my $text = $quote->look_down(
            _tag => 'span',
            class => 'text'
        )->as_text;

        my $author = $quote->look_down(
            _tag => 'small',
            class => 'author'
        )->as_text;

        print "$text: $author\n";
    }

} else {
  print "Cannot parse the result. " . $request->status_line . "\n";
}
