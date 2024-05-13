use Mojo::UserAgent;
use Mojo::DOM;

my $ua  = Mojo::UserAgent->new;
my $res = $ua->get('https://quotes.toscrape.com/')->result;

if ($res->is_success) {
    my $dom = Mojo::DOM->new($res->body);
    my @quotes = $dom->find('div.quote')->each;

    foreach my $quote (@quotes) {
        my $text = $quote->find('span.text')->map('text')->join;
        my $author = $quote->find('small.author')->map('text')->join;

        print "$text: $author\n";
    }
} else {
    print "Cannot parse the result. " . $res->message . "\n";
}