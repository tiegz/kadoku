require 'hpricot'

module Kadoku
  class Markup
    attr_accessor :hpricot

    def initialize(content, options={})
      @clean_newline = "#{options[:clean_newline] || "\n"}"
      @clean_indent  = "#{options[:clean_indent] || "\t"}"
      @hpricot = Hpricot(content)
      @indent_counter = 0
    end
  
    # Returns the original document parsed by Hpricot without cleanup
    def to_html
      @hpricot.to_html
    end

    # Returns the original markup parsed by Hpricot with extra cleanup
    def to_clean_html
      str = ''

      # A recursive lambda that rejects any empty (includes newlines/spaces/tabs) nodes
      empty_elements = lambda { |el| el.respond_to?(:children) ? (el.children.reject!(&empty_elements); false) : (el.to_html.strip.empty?) }

      # A recursive lambda that re-maps the nodes with all newlines and extra spaces stripped out
      stripped_down = lambda do |el|
        if el.respond_to?(:children)
          el.children.map(&stripped_down) # iterate over children if possible
        else
          #unless el.parent.respond_to?(:name) && el.parent.name == 'script' # preserve JS newlines
            el.content.gsub!(/\n/, '') if el.is_a?(Hpricot::Text) || el.is_a?(Hpricot::Comment) # remove newlines from text
            el.content.gsub!(/\s+/, ' ') if el.is_a?(Hpricot::Text) || el.is_a?(Hpricot::Comment) # convert all groups of spaces into one space
          #end
        end
        el
      end

      # A recursive lambda that iterates over each node and rebuilds the html
      pretty_print = lambda do |el, i|
        if el.respond_to?(:children)
          if el.children.empty? 
            # isn't there a less hackish way to turn a tag into a self-ending tag?
            _el = Hpricot::Elem.new(Hpricot::STag.parse(el.name, el.attributes, nil, nil))
            str << indented(_el) + @clean_newline
          else
            str << indented(el.stag) + @clean_newline # add start tag
            unless el.children.empty?
              @indent_counter += 1
              el.children.each_with_index(&pretty_print)
              @indent_counter -= 1
              str << indented(el.etag) + @clean_newline if el.etag # add end tag
            end
          end
        else
          case el
          when Hpricot::DocType # need to do anything special to the doc type?
            str << indented(el) + @clean_newline
          else
            str << indented(el) + @clean_newline
          end
        end
      end

      @hpricot.children.reject!(&empty_elements).map!(&stripped_down).each_with_index(&pretty_print)
      @indent_counter = 0 # reset

      str
    end

    protected
    def indented(el)
      @clean_indent * @indent_counter + el.output('')
    end
  end
end