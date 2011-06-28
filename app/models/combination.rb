class Combination
  def self.combinations(str); comb2('', str); end
  def self.comb2(prefix, str)
    p prefix unless prefix == ''
    index = 1
    str.each_char do |letter|
      comb2(prefix + letter, str.slice(index, str.length-1));
      index += 1
    end
  end
end

Combination.combinations('ABCDE')
