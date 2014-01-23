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

Combination.combinations('12345')



# shittier way...
@debug = false
@arr = []

def print_subset(arr)
  num_sets = arr.length
  for i in 0..num_sets
    print_all_combinations(arr.slice(0, i), arr.slice(i, num_sets-i))
    print_subset(arr.slice(i, num_sets-i)) if i != 0
  end
end

# print selected_set and choose one from left over set
# need to call this again w/ left over sets
def print_all_combinations(selected_set, left_over_set)
debug("first #{selected_set} - left over #{left_over_set}")
  left_over_set.each do |left_over|
    save(selected_set + [left_over])
  end
end

def save(current_set)
  debug("**** #{current_set}")
  current_arr_index = current_set.join("").to_i
  @arr[current_arr_index] = current_arr_index
end

def debug(message)
  if @debug
    p "****** #{message}"
  end
end

print_subset([1,2,3,4,5])
p "***** #{@arr.compact.inspect}"