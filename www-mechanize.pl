use WWW::Mechanize ();
use HTML::TreeBuilder;
use open qw( :std :encoding(UTF-8) );

my $mech = WWW::Mechanize->new();

my $url = "https://quotes.toscrape.com/";
my $root = HTML::TreeBuilder->new();

my $request = $mech->get($url);
my $next_page = $mech->find_link(text_regex => qr/Next/);

while ($next_page) {
    $root->parse($mech->content);
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

    $mech->follow_link(url => $next_page->url);
    $next_page = $mech->find_link(text_regex => qr/Next/);
}