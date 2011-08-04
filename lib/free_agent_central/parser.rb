# I made no assumption about column ordering.  I assume there is a line that lists the header columns before
# the actual data. The idea is to parse that header first to determine column ordering, and then parse
# each subsequent line and write to the output

if ARGV.size != 1
  p "Usage: ruby parser.rb <input_file>"
  exit
end

# straight copied from rails
class String #:nodoc:
  def blank?
    self !~ /\S/
  end
end

input_file = ARGV.first
out_f = File.new('parsed.csv', 'w')
out_f.write("Date,Description,Amount\n")

past_header = false
column_hash = {}

File.open(input_file, 'r').each_line do |line|

  if past_header && !line.start_with?('Page')
    # start parsing
    parts = line.match(/(.*)(\".*\")(.*)/)
    if parts
      post_processed_line = parts[1] + parts[2].gsub(',','').gsub('"','') + parts[3]
      line_parts = post_processed_line.split(',')
      next if line_parts.empty?
      amount = "-#{line_parts[column_hash['Debit']]}" if line_parts[column_hash['Credit']].blank?
      amount = line_parts[column_hash['Credit']] if line_parts[column_hash['Debit']].blank?
      out_f.write("#{line_parts[column_hash['Date']]},#{line_parts[column_hash['Description']]},#{amount}\n")
    end
  else
    # make no assumptions about column ordering...
    line_parts = line.strip.split(',')
    if line_parts.size >= 4
      line_parts.each_with_index do |header_type, index|
        if header_type.include?('Date')
          column_hash['Date'] = index
        end
        if header_type.include?('Description')
          column_hash['Description'] = index
        end
        if header_type.include?('Credit')
          column_hash['Credit'] = index
        end
        if header_type.include?('Debit')
          column_hash['Debit'] = index
        end
      end
      past_header = true if column_hash.size == 4
    end
  end
end

out_f.close

# Customer: SPEIGEL LIMITED (A07OKP)
# Account: 12398712328732 SPEIGEL,,,
# Date ,FROM : 17/08/2010, TO : 17/08/2010,,,,,,
# Today's Cleared Balance:,"16,445.34",,,,,,,
# Today's Uncleared Balance:,"16,445.34",,,,,,,
# ,,Transactions,,,,,
# Report Date:,,17/08/2010
#  Date,Description,Bank        Reference,Customer Reference,   Credit,     Debit,    Additional Information
# 09/08/10,A Purchase,4988243063101327,1327 BLAH 3287,,"89.10",
# 10/08/10,INVOICE 0101,A CLIENT,BOAETENL,"4,269.15",,ORIG ACCOUNT - 12398712328732
# 10/08/10,Books,AMZ,Amazon,,"23.99",ORIGINATING ACCOUNT - 12398712328732
# ,,,
# Page 1,of 1