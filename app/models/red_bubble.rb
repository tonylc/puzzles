# print number of distinct numbers given an array of sorted integers (both negative and positive)
class AbsDinstinct
  def self.absDistinct(arr)
    hash = {}
    arr.each do |el|
      el = el.abs
      unless hash[el]
        hash[el] = true
      end
    end
    hash.count
  end
end

# p AbsDinstinct.absDistinct([-5,-3,-1,0,3,6])
# p AbsDinstinct.absDistinct([-2147483648,2147483648])

# print number of 1 bit's given a hexidecimal big endian string
class HexBitCount
  BITMAP_COUNT = {
    '0' => 0, # 0
    '1' => 1, # 1
    '2' => 1, # 10
    '3' => 2, # 11
    '4' => 1, #100
    '5' => 2, #101
    '6' => 2, #110
    '7' => 3, #111
    '8' => 1, #1000
    '9' => 2, #1001
    'A' => 2, #1010
    'B' => 3, #1011
    'C' => 2, #1100
    'D' => 3, #1101
    'E' => 3, #1110
    'F' => 4  #1111
  }
  
  def self.hex_bitcount(s)
    count = 0
    s.each_char do |c|
      count += BITMAP_COUNT[c.upcase]
    end
    count
  end
end

#p HexBitCount.hex_bitcount('0')
# p HexBitCount.hex_bitcount('123')
# p HexBitCount.hex_bitcount('F')
# p HexBitCount.hex_bitcount('1')
# p HexBitCount.hex_bitcount('123FE98')

# A number is considered heavy if the avg values of the digits is > 7
# Given 2 non negative integers a,b where a <= b
# print the count of heavy numbers between a and b.
class HeavyCount
  def num_digits(a,b)
    count = 0
    (a..b).each do |n|
      count += 1 if heavy?(n)
    end
    count
  end
  
  def heavy?(num)
    avg_val(num) > 7
  end
  
  def avg_val(num)
    sum = 0
    num.to_s.each_char do |c|
      sum += c.to_i
    end
    sum.to_f / num.to_s.length
  end
  
  def num_digits2(a,b)
    count = 0
    cur_num = a
    while cur_num <= b
      val = diff_with_seven(cur_num)
      if val <= 1
        # next heavy digit
        cur_num = 1 - val + cur_num
      end
      count += 1 if heavy?(cur_num)
      cur_num += 1
    end
    count
  end
  
  def diff_with_seven(num)
    sum = 0
    num.to_s.each_char do |c|
      sum += (c.to_i - 7)
    end
    sum
  end
end

hc = HeavyCount.new
p hc.num_digits2(8675, 8689)
p hc.diff_with_seven(8675)
p hc.diff_with_seven(8687)
