require 'anemone'
require 'nokogiri'

external_links = []

domain = "juliendesrosiers.com"
full_domain = "www.#{domain}"

# Index External links
Anemone.crawl("https://#{full_domain}/") do |anemone|
  anemone.on_every_page do |page|
    if page.doc
      page.doc.css('a').each do |link|
        href = link.attributes['href']

        isnt_internal = href.to_s !~ /#{domain}/
        is_external = href.to_s =~ /^https?:\/\//
        still_unseen = !external_links.include?(href.to_s)
        if isnt_internal && is_external && still_unseen
          puts "#{link.attributes['href']}"
          external_links << href.to_s
        end
      end
    end
  end
end
