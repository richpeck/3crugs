class CreateProducts < ActiveRecord::Migration::Current
  include ActiveRecord::Concerns::Base

  #########################################
  #########################################

    # => Up
    def up
      create_table table do |t|

        # => Items
        t.string      :vad_variant_code
        t.string      :vad_description
        t.bigint      :vad_ean_code
        t.integer     :free_stock
        t.integer     :on_order
        t.date        :eta
        t.datetime    :synced_at
        t.datetime    :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
        t.datetime    :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }

        # => Index
        t.index       :vad_variant_code, unique: true
      end
    end

  #########################################
  #########################################

end
