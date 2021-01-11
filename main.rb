require 'anemone'
require 'nokogiri'
require 'uri'

external_links = []

# First argument: domain (ex: nouvellevie.com)
full_domain = ARGV.shift

domain =
  if full_domain =~ /^www\./
    _, domain = full_domain.split('.', 2)
    domain
  else
    full_domain
  end

# Index External links
Anemone.crawl("http://#{full_domain}/") do |anemone|
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
