# This extension is designed to automatically upgrade database schema to
# correspond to the model definition. It performs basic auto migration.
#
# Usage (models/account.rb):
#
#   DB.upgrade_table? :accounts do
#     primary_key :id
#     column :title, String, :default => 'foobar'
#   end
#   class Account < Sequel::Model
#   end
#
# The :accounts table is created if it does not exist.
# If it exists and lacks :id or :key column, the corresponding column
# is added with ALTER TABLE. If the table already has the column,
# no action is performed on it.

module Sequel
  module AutoMigration
  end

  class Database
  
    # Upgrades the table if it exists, or passes to create_table.
    #
    #   DB.upgrade_table?(:accounts){column :title, String, :default => 'foobar'}
    #   # SELECT NULL AS `nil` FROM `accounts` LIMIT 1 -- check existence
    #   # DESCRIBE `accounts`                          -- or similar to get database schema
    #   # ALTER TABLE `accounts` ADD COLUMN `title` varchar(255) DEFAULT 'foobar'
    #
    # NOTE: this method ignores column definition if the column already is in the database
    # schema. This behavior is to evade possible DESTRUCTIVE action.
    def upgrade_table?( name, options={}, &block )
      return create_table(name, options, &block)  unless table_exists?(name)
      current_schema = Hash[schema name]
      create_table_generator(&block).columns.each do |column|
        if current_schema[column[:name]]
          next
        else
          add_column name, column.delete(:name), column.delete(:type), column
        end
      end
    end
  end

  Database.register_extension(:auto_migration, AutoMigration)
end
