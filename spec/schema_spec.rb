require File.join(File.dirname(File.expand_path(__FILE__)), 'spec_helper')

describe "DB#upgrade_table?" do
  before do
    @db = Sequel.mock
  end

  specify "should pass to create_table if the table does not exist" do
    created = false
    meta_def(@db, :table_exists?){|a| false}
    meta_def(@db, :create_table){|*a| created = true}
    @db.upgrade_table?(:cats){}
    created.should == true
  end

  specify "should request schema if table exists" do
    requested = false
    meta_def(@db, :table_exists?){|a| true}
    meta_def(@db, :schema){|*a| requested = true; []}
    @db.upgrade_table?(:cats){}
    requested.should == true
  end

  specify "should call add_column for non-existing column and only for it" do
    meta_def(@db, :table_exists?){|a| true}
    meta_def(@db, :schema){|*a| requested = true; [[:id, {:type=>:integer}], [:name, {:type=>:string}]]}
    @db.upgrade_table?(:cats) do
      primary_key :id
      column :name, String
      column :title, String, :default => 'foobar'
    end
    @db.sqls.should == ["ALTER TABLE cats ADD COLUMN title varchar(255) DEFAULT 'foobar'"]
  end
end
