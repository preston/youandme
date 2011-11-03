# Author: Preston Lee

module YouAndMe

	# Tool for loading raw data files from 23andme into native Ruby structures
	class RawDataFileLoader

		# Returns Markdown-formatted URLs for the given SNP hash.
		def markdown_links(snp)
			 "[dbSNP](http://www.ncbi.nlm.nih.gov/SNP/snp_ref.cgi?rs=#{snp[:rsid]}) [SNPedia](http://www.snpedia.com/index.php/#{snp[:rsid]})"
		end

		# Returns true if and only if the given file exists and is readable.
		def check_file(file_name)
			valid = false
			if(file_name != nil && File.file?(file_name) && File.readable?(file_name))
				valid = true
			end
			valid
		end

		# Reads the given raw 23andme data file, parses the data, and shoves it into a native Ruby data structure.
		# The returned data is an +Array+ full of +Hash+es, where each hash has key/value pairs for the columns in the data file.
		def load_file(file_name, max = 0)
			snps = []
			# Manually spliting seems to be faster than the built-in CSV parser for
			rows = File.read(file_name).split("\n")
			rows.each do |n|
				row = n.chomp.split("\t")
			# CSV.foreach(file_name, :col_sep => "\t") do |row|
				# Skip if the the line is a comment
				next if row[0][0] == '#'
				break if max > 0 && snps.length > max
				snp = {
					:rsid => row[0],
					:chromosome => row[1],
					:position => row[2],
					:genotype => row[3]				
				}
				# y snp
				snps << snp
			end
			snps
		end

	end

end
