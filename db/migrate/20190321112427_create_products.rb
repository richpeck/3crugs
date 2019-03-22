class CreateProducts < ActiveRecord::Migration::Current
  include ActiveRecord::Concerns::Base

  #########################################
  #########################################

    # => Up
    def up
      create_table table, options do |t|
        t.string      :vad_variant_code, unique: true
        t.string      :vad_description
        t.bigint      :vad_ean_code
        t.integer     :free_stock
        t.integer     :on_order
        t.date        :eta
        t.datetime    :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
        t.datetime    :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      end
    end

  #########################################
  #########################################

end
