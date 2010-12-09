#
# Script que pega todo o material do livro "THE ELEMENTS OF COMPUTING SYSTEMS"
#
# "Nao estou aqui para roubar..."
#
# Comprei o livro, por enquanto está sendo boa leitura e recomendo a todos que me perguntam sobre ele.
# Fiz esse script porque queria ter o material do livro para ler do meu android novo (yeah :), quando tiver na fila do banco.
#
# Como eu fiz essa parada por diversão e em poucos minutos é ÓBVIO que não me preocupei com design OO, testes e aquela firulada toda.
# Nem os métodos tem nomes legais. Dormirei tranquilo essa noite.
#
# Viva o nokogiri!
#
# Use por sua conta e risco.
#
require "rubygems"
require "pp"
require "nokogiri"
require "open-uri"
require "fileutils"

ROOT_DIR = "/home/daltojr/projects/programming/elements-of-computing-systems/"
ROOT_URL = "http://www1.idc.ac.il/tecs/"

def study_plan_page
  open("#{ROOT_URL}plan.html") { |html_stream| html_stream.read }
end

def print_header(tr)
  titles = tr.children.map do |children|
    children.text.strip.gsub(":", "")
  end

  len = titles.map { |t| t.size }.max
  titles.map do |t|
    t.center(len)
  end[0..-2].join(" | ")
end

def parse_body(trs)
  trs.each do |tr|
    elements = tr.children
    name = elements.first.text.strip

    puts "name: #{name}"

    readings = elements.css("td a").map do |a|
      { :url => ROOT_URL + a.attr("href"), :name => a.text.strip.gsub(/\s/, "\ ") }
    end

    puts "links: #{readings.join(", ")}"

    dirname = File.join(ROOT_DIR, name.gsub(/\s/, "\ "))
    puts "creating directory: #{dirname}"

    FileUtils.mkdir(dirname)

    readings.each do |reading|
      pp reading

      filename = File.basename(reading[:url])
      filepath = File.join(dirname, filename)

      pp :filename => filename, :filepath => filepath

      File.open(filepath, "w") do |file|
        file.puts(open(reading[:url]))
      end
    end
  end
end

html = Nokogiri::HTML(study_plan_page)
trs = html.css("table table tr")

puts print_header(trs.shift)
puts parse_body(trs)
