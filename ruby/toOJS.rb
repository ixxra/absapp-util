require 'json'


class Article
    attr_accessor :title, :authors, :keywords, :source, :abstract
    def initialize(art_hash)
        @title = art_hash["title"]
        @authors = parse_authors art_hash["authors"]
        @keywords = art_hash["article"]["category"][11..-1]
        @source = art_hash["source"]
        @abstract = art_hash["abstract"]
    end

    def parse_authors(aut_str)
        authors = aut_str.slice(9..-1).split(',')
        authors.map do |author|
            tokens = author.split
            first = tokens.first
            middle = nil
            last = nil

            if tokens.last.match '-'
                last = tokens.last
                if tokens.length > 2
                    middle = tokens.slice(1..-2).join(" ")
                end
            else
                if tokens.length == 2
                    last = tokens.last
                elsif tokens.length == 3
                    last = tokens[-2] + '-' + tokens[-1]
                else
                    last = tokens[-2] + '-' + tokens[-1]
                    middle = tokens.slice(1..-3).join(" ")
                end
            end
            
            if middle
                {:first_name => first, 
                 :middle_name => middle, 
                 :last_name => last}
            else
                {:first_name => first, :last_name => last}
            end
        end
    end

    def to_s
        authors = ""
        @authors.each do |a|
            if a.has_key? :middle_name
            authors += "
<author>
    <first_name>#{a[:first_name]}</first_name>
    <middle_name>#{a[:middle_name]}</middle_name>
    <last_name>#{a[:last_name]}</last_name>
    <email> </email>
</author>"
            else
            authors += "
<author>
    <first_name>#{a[:first_name]}</first_name>
    <last_name>#{a[:last_name]}</last_name>
    <email> </email>
</author>"
            end
        end
<<eos
<article>
  <title>#{@title}</title>
  #{authors}
  <indexing>
    <subject locale="es_MX">#{@keywords}</subject>
  </indexing>
  <abstract>
    #{@abstract}
  </abstract>
  <galley>
    <label>PDF</label>
    <file>
      <href src="#{@source}" mimetype="application/pdf"/>
    </file>
  </galley>
</article>
eos
    end
end


class Issue
    attr_accessor :volume, :year, :articles 
    
    def initialize(hash_data)
        @volume = hash_data["volume"].match(/\d+/).to_s
        @year = hash_data["year"]
        @articles = []
        hash_data["contents"].each do |a|
            @articles.push Article.new a
        end
    end

    def to_s
        articles = @articles.map{|a| a.to_s}.join

        <<eol
<issue attlist="vol_year" published="true" current="false">
  <volume>#{@volume}</volume>
  <year>#{@year}</year>
  <articles>
    #{articles}
  </articles>
</issue>
eol
    end
end


abs = JSON.parse(ARGF.read())
abs.each do |h|
    issue = Issue.new h
    puts issue
end

