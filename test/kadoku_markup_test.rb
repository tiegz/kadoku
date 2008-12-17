require(File.join(File.dirname(__FILE__), 'test_helper'))

class KadokuMarkupTest < Test::Unit::TestCase
  def setup
    @bad_html = %Q!
  <html>  
          <HEAD>  <title>My page</tiTLE></HEAD>
    <body >
          <h1> WOAH WHAT'S HAPPENING    <span>I DON'T KNOW</span>
            </h1>
            
<p>Here, I'll explain. </p>
    </body>
    
</html>
!
  @good_html = %Q!
<html>
\t<head>
\t\t<title>
\t\t\tMy page
\t\t</title>
\t</head>
\t<body>
\t\t<h1>
\t\t\t WOAH WHAT'S HAPPENING 
\t\t\t<span>
\t\t\t\tI DON'T KNOW
\t\t\t</span>
\t\t</h1>
\t\t<p>
\t\t\tHere, I'll explain. 
\t\t</p>
\t</body>
</html>!
  @good_html_with_asterisk_indentation = %Q!
<html>
*<head>
**<title>
***My page
**</title>
*</head>
*<body>
**<h1>
*** WOAH WHAT'S HAPPENING 
***<span>
****I DON'T KNOW
***</span>
**</h1>
**<p>
***Here, I'll explain. 
**</p>
*</body>
</html>!
  end

  def test_should_instantiate_new_markup
    markup = Kadoku::Markup.new(@bad_html)
    assert markup.is_a?(Kadoku::Markup)
    assert_not_nil markup.hpricot
    assert markup.hpricot.is_a?(Hpricot::Doc)
  end
  
  def test_to_html_should_return_hpricots_to_html
    markup = Kadoku::Markup.new(@bad_html)
    assert_equal markup.to_html, markup.hpricot.to_html
  end

  def test_should_clean_basic_markup
    markup = Kadoku::Markup.new(@bad_html)
    assert_equal @good_html.strip, markup.to_clean_html.strip
  end
  
  def test_should_clean_basic_markup_with_asterisks_instead_of_tabs
    markup = Kadoku::Markup.new(@bad_html, :clean_indent => "*")
    assert_equal @good_html_with_asterisk_indentation.strip, markup.to_clean_html.strip
  end
end
