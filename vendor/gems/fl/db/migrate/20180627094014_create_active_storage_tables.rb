class CreateActiveStorageTables < ActiveRecord::Migration::Current
  include ActiveRecord::Concerns::Base

  #########################################
  #########################################

  # => Introduced in Rails 5.2, ActiveStorage removes Paperclip
  # => Now, rather than having a single "asset" model, we can attach objects directly to different models/records

  # => For example, if you have a Profile model with a single Avatar attachment, rather than routing through two other models - you can now just add the attachment directly to the Profile model

  #########################################
  #########################################


    # => Up
    def up

      # => Blobs Table
      create_table :active_storage_blobs do |t|
        t.string   :key,        null: false
        t.string   :filename,   null: false
        t.string   :content_type
        t.text     :metadata
        t.bigint   :byte_size,  null: false
        t.string   :checksum,   null: false
        t.datetime :created_at, null: false

        t.index [ :key ], unique: true
      end

      # => Attachments Table
      create_table :active_storage_attachments do |t|
        t.string     :name,     null: false
        t.references :record,   null: false, polymorphic: true, index: false
        t.references :blob,     null: false

        t.datetime :created_at, null: false

        t.index [ :record_type, :record_id, :name, :blob_id ], name: "index_active_storage_attachments_uniqueness", unique: true
      end
    end

    #########################################
    #########################################

    # => Down
    def down
      %i(active_storage_blobs active_storage_attachments).each do |t|
        drop_table t, if_exists: true
      end
    end

  #########################################
  #########################################

end
