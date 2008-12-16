# EXPERIMENTAL!! Probably not great for Production.
# This is merely an ActionController after_filter. Easiest way to use:
#
#   class Application < ActionController::Base
#     ... all your filters here
#     after_filter ERBApologist::Filters::ReadableHTML
#   end
#
# -or-
#   class Application < ActoinController::Base
#     ... all your filters here
#     cleanup_html
#   end


module ERBApologist
  module HelperMethods
    def cleanup_html
      after_filter ERBApologist::Filters::ReadableHTML
    end
  end

  module Filters
    class ReadableHTML
      NEWLINE = "\n"
      INDENT = "\t" # change this to spaces if you don't like tabs, ^o^

      def self.indented(el)
        INDENT * @@indent_counter + el.output('')
      end

      def self.filter(controller)
        doc, new_doc = Hpricot(controller.response.body), ''
        @@indent_counter = 0

        empty_elements = lambda { |el| el.respond_to?(:children) ? (el.children.reject!(&empty_elements); false) : (el.to_html.strip.empty?) }
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
        pretty_print = lambda do |el, i|
          if el.respond_to?(:children)
            if el.children.empty? 
              # isn't there a less hackish way to turn a tag into a self-ending tag?
              _el = Hpricot::Elem.new(Hpricot::STag.parse(el.name, el.attributes, nil, nil))
              new_doc << indented(_el)
              new_doc << NEWLINE
            else
              new_doc << indented(el.stag) + NEWLINE # add start tag
              unless el.children.empty?
                @@indent_counter += 1
                el.children.each_with_index(&pretty_print)
                @@indent_counter -= 1
                new_doc << indented(el.etag) + NEWLINE if el.etag # add end tag
              end
            end
          else
            case el
            when Hpricot::DocType # need to do anything special to the doc type?
              new_doc << indented(el) + NEWLINE
            else
              new_doc << indented(el) + NEWLINE
            end
          end
        end

        doc.children.reject!(&empty_elements).map!(&stripped_down).each_with_index(&pretty_print)

        controller.response.body = new_doc
      end  
    end
  end
end