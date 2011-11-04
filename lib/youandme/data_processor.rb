module YouAndMe
	
	class DataProcessor
		
		attr_accessor :left
		attr_accessor :right
		attr_accessor :rsid_same
		attr_accessor :rsid_diff
		attr_accessor :both_rsid
		
		
		def initialize(left, right)
			@left = left
			@right = right
			# @rsid_same = nil
			# @rsid_diff = nil
			# @both_rsid = nil
			# process
		end
		
		def to_multimarkdown(left_file, right_file)
			@left_file = left_file
			@right_file = right_file
			dir = File.dirname(File.expand_path(__FILE__))
			template_file = File.join(dir, 'report.md.erb')
			template = ERB.new(File.read(template_file))
			template.result(binding)
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