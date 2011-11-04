require 'xml'
require 'libxslt'
require 'fileutils'


module YouAndMe
	
	class DataProcessor
		
		attr_accessor :left
		attr_accessor :right
		attr_accessor :rsid_same
		attr_accessor :rsid_diff
		attr_accessor :both_rsid
		
		attr_accessor :multimarkdown_text
		
		
		def initialize(left, right)
			@left = left
			@right = right
			# @rsid_same = nil
			# @rsid_diff = nil
			# @both_rsid = nil
			# process
		end
		
		def write_multimarkdown(path)
			file_path = File.join(path, "report.md")
			puts "\tMultiMarkdown #{file_path}..."
			report = File.open(file_path, 'w')
			report.write @multimarkdown_text
			report.close	
		end

		def write_latex(path)
			file_path = File.join(path, "report.ltx")
			puts "\tLaTeX #{file_path}..."
			report = File.open(file_path, 'w')
			mmd = MultiMarkdown.new(@multimarkdown_text)
			report.write mmd.to_latex
			report.close	
		end

		def write_html(path)
			# Write the default file first.
			file_path = File.join(path, "report.html")
			puts "\tHTML #{file_path}..."
			report = File.open(file_path, 'w')
			mmd = MultiMarkdown.new(@multimarkdown_text, :smart, :filter_html)
			report.write mmd.to_html
			report.close

			# Load the XSL Transform.
			stylesheet_doc = XML::Document.file(File.join(File.dirname(__FILE__), 'xhtml-toc.xslt'))
			stylesheet = LibXSLT::XSLT::Stylesheet.new(stylesheet_doc)

			# Apply it and re-write the document.
			old_html = XML::Document.file(file_path)
			new_html = stylesheet.apply(old_html)
			report = File.open(file_path, 'w')
			report.write new_html
			report.close
			
			# Copy the CSS file into place.
			css_src = File.join(File.dirname(__FILE__), 'report.css')
			css_dest = File.join(path, 'report.css')
			FileUtils.copy(css_src, css_dest)
		end
		
		def to_multimarkdown(left_file, right_file)
			@left_file = left_file
			@right_file = right_file
			dir = File.dirname(File.expand_path(__FILE__))
			template_file = File.join(dir, 'report.md.erb')
			template = ERB.new(File.read(template_file))
			@multimarkdown_text = template.result(binding)
		end
		
		def process(status = false)
			puts "Creating indexes..." if status
			puts "\tIndexing left data..." if status
			@left_rsid					= @left.collect do |n| n[:rsid] end
			@left_chromosome		= @left.collect do |n| n[:chromosome] end
			@left_position			= @left.collect do |n| n[:position] end
			@left_genotype			= @left.collect do |n| n[:genotype] end

			puts "\tIndexing right data..." if status
			@right_rsid				= @right.collect do |n| n[:rsid] end
			@right_chromosome	= @right.collect do |n| n[:chromosome] end
			@right_position		= @right.collect do |n| n[:position] end
			@right_genotype		= @right.collect do |n| n[:genotype] end

			puts "Computing stuff..." if status
			puts "\tDetecting basic commonalities..." if status
			@both_rsid					= @left_rsid & @right_rsid
			both_position					= @left_position & @right_position

			puts "\tFinding dissimilar genotypes..." if status
			@rsid_same = []
			@rsid_diff = []
			@both_rsid.each do |rsid|
				l = left[@left_rsid.index(rsid)]
				r = right[@right_rsid.index(rsid)]
				if l[:genotype] == r[:genotype]
					@rsid_same << [l, r]
				else
					@rsid_diff << [l, r]
				end
			end
			
		end
		
	end
	
end