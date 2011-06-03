class Sequence
  def self.find_sequence(sequence_array)
    first = sequence_array.delete_at(0)
    second = sequence_array.delete_at(0)

    diff = second - first
    scale = second / first.to_f

    # maybe arithemtic sequence
    prev_seq = second
    sequence_array.each do |val|
      if prev_seq + diff == val
        prev_seq += diff
      else
        prev_seq = nil
        break
      end
    end

    return prev_seq + diff if prev_seq != nil

    # maybe geom sequence
    prev_seq = second
    sequence_array.each do |val|
      if prev_seq * scale == val
        prev_seq *= scale.to_f
      else
        prev_seq = nil
        break
      end
    end

    return prev_seq * scale if prev_seq != nil
    return nil
  end
end