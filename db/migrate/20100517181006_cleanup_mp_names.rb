class CleanupMpNames < ActiveRecord::Migration
  def self.up
    Mp.update_all("name = SUBSTRING(name, 12)", "name LIKE 'Right Hon. %'")
    Mp.update_all("name = SUBSTRING(name, 6)", "name LIKE 'Hon. %'")
  end

  def self.down
  end
end
