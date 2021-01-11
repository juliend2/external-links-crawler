require 'anemone'
require 'nokogiri'
require 'uri'

external_links = []

domain = "juliendesrosiers.com"
full_domain = "www.#{domain}"

# Index External links
Anemone.crawl("https://#{full_domain}/") do |anemone|
  anemone.on_every_page do |page|
    if page.doc
      page.doc.css('a').each do |link|
        href = link.attributes['href']

        uri = begin
                URI.parse(href.to_s)
              rescue => e
                nil
              end
        isnt_internal = href.to_s !~ /#{domain}/
        is_external = href.to_s =~ /^https?:\/\//
        still_unseen = uri && !external_links.include?(uri.host)
        if isnt_internal && is_external && still_unseen
          puts "#{uri.host}"
          external_links << uri.host
        end
      end
    end
  end
end
