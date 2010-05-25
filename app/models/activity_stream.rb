require 'set'

class ActivityStream
  
  class Entry
    
    attr_accessor :date
    attr_accessor :object
    
    def initialize(date, object)
      @date = date
      @object = object
    end
  end

  def initialize()
    @entries = Set.new
    @entries_by_date = {}
  end

  def add_entries(new_entries)
    new_entries.each { |entry|
      @entries << entry
      date_key = entry.date.strftime("%Y-%m-%d")
      entry_set = @entries_by_date[date_key]
      if not entry_set
        entry_set = Set.new
        @entries_by_date[date_key] = entry_set
      end
      entry_set << entry
    }
  end

  def entries()
    return @entries.to_a.sort { |a,b|
      b.date <=> a.date
    }
  end

  def entries_by_date(date)
    return @entries_by_date[date].sort { |a,b|
      a.date <=> b.date
    }
  end
  
  def entry_dates()
    return @entries_by_date.keys.sort.reverse()
  end
  
  def truncate!(max_entries)
    entry_list = @entries.to_a.sort { |a,b|
      a.date <=> b.date
    }
    if entry_list.length > max_entries
      entry_list[0..-max_entries-1].each { |entry|
        date_key = entry.date.strftime("%Y-%m-%d")
        entry_set = @entries_by_date[date_key]
        entry_set.delete(entry)
        if entry_set.empty?
          @entries_by_date.delete(date_key)
        end
      }
      entry_list.slice!(0..-max_entries-1)
    end
    return entry_list
  end
  
end