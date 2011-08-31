module Globalize2
  module Compatibility
    module Sheets
      module SheetExtensions
        def self.included(base)  
      
          base.class_eval do

            def self.root
              Page.find_by_slug('/').children.first(:conditions => {:class_name => self.to_s})
              rescue NoMethodError => e
                e.extend Sheet::InvalidHomePage
                raise e
            end


            def self.create_root
              s = self.new_with_defaults
              s.parent_id = Page.find_by_slug('/').id
              s.slug = self.name == 'StylesheetPage' ? 'css' : 'js'
              s.save!

              translation = s.translations.find_or_initialize_by_locale(Globalize2Extension.default_language.to_s)
              Globalize2Extension::GLOBALIZABLE_CONTENT[Page].each do |column|
                translation[column] = s[column]
              end
              translation.save!

            end

          end
        end
      end
    end
  end
end