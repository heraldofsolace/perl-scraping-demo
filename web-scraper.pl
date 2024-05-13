use URI;
use Web::Scraper;
use Encode;
 
my $quotes = scraper {
    # Parse all `div` with class `quote`
    process 'div.quote', "quotes[]" => scraper {
      # And, in each div, find `span` with class `text`
      process_first "span.text", text => 'TEXT';
      # get `small` with class `author`
      process_first "small", author => 'TEXT';
    };
};
 
my $res = $quotes->scrape( URI->new("https://quotes.toscrape.com/") );
 
# iterate over the array
for my $quote (@{$res->{quotes}}) {
    print Encode::encode("utf8", "$quote->{text}: $quote->{author}\n");
}