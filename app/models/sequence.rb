class Sequence
  def self.find_sequence(sequence_array)
    first = sequence_array.delete_at(0)
    second = sequence_array.delete_at(0)

    # maybe arithemtic sequence
    diff = second - first
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
    begin
      scale = second / first.to_f
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
    rescue
      # possible divide by 0 case, must be an error,
      # other wise it would've been handled in the arithmetic case and returned 0
    end

    # neither sequence or error
    return nil
  end
end