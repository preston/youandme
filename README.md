# youandme

An unofficial Ruby library and command-line application ("youandme") for quickly parsing 23andme raw data files into a plain Ruby structures for quick processing and analysis.

## Installation ##

    gem install youandme

## Command-Line Usage

The primary command-line script is "youandme", which generates a simple side-by-side comparison report for two given 23andme raw data files. To generate the reports, grab a few raw 23andme data files (from 23andme.com, SNPedia etc.), and compare them like so:

    youandme --directory <output_directory> --left <23andme_data_file.txt> --right <23andme_data_file.txt>

After the script completes, four plain-text files will be placed in the specified directory in the following formats:

* **report.md** MultiMarkdown version of the report.
* **report.ltx** LaTeX version of the report.
* **report.html** HTML version of the report.
* **report.css** Stylesheet for the HTML file.

For "full" files, this will take a LONG time to run. (As in, probably more than 24 hours.) I recommend breaking down the data files into chromosome-size chunks, and running each comparison through this script individually.

## Authors ##

Preston Lee

## Copyright

Copyright (c) 2011 Preston Lee. See LICENSE.txt for further details.
