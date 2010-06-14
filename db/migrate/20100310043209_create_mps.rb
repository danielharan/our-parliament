class CreateMps < ActiveRecord::Migration
  def self.up
    create_table :mps do |t|
      t.column :ed_id, :string
      t.column :parl_gc_id, :string
      t.column :parl_gc_constituency_id, :string
      t.column :constituency_name, :string
      t.column :party, :string
      t.column :name, :string
      t.column :email, :string
      t.column :website, :string
      t.column :parliamentary_phone, :string
      t.column :parliamentary_fax, :string
      t.column :preferred_language, :string
      t.column :constituency_address, :string
      t.column :constituency_city, :string
      t.column :constituency_province, :string
      t.column :constituency_postal_code, :string
      t.column :constituency_phone, :string
      t.column :constituency_fax, :string
    end
  end

  def self.down
    drop_table :mps
  end
end
