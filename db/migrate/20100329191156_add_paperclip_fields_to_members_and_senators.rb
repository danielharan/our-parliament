class AddPaperclipFieldsToMembersAndSenators < ActiveRecord::Migration
  def self.up
    add_column :mps, :image_file_name,    :string
    add_column :mps, :image_content_type, :string
    add_column :mps, :image_file_size,    :integer
    add_column :mps, :image_updated_at,   :datetime

    add_column :senators, :image_file_name,    :string
    add_column :senators, :image_content_type, :string
    add_column :senators, :image_file_size,    :integer
    add_column :senators, :image_updated_at,   :datetime
  end

  def self.down
    remove_column :mps, :image_updated_at
    remove_column :mps, :image_file_size
    remove_column :mps, :image_content_type
    remove_column :mps, :image_file_name

    remove_column :senators, :image_updated_at
    remove_column :senators, :image_file_size
    remove_column :senators, :image_content_type
    remove_column :senators, :image_file_name
  end
end
