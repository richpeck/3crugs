class CreateProducts < ActiveRecord::Migration::Current
  include ActiveRecord::Concerns::Base

  #########################################
  #########################################

    # => Up
    def up
      create_table table, options do |t|
        t.string      :vad_variant_code
        t.string      :vad_description
        t.integer     :vad_ean_code
        t.integer     :free_stock
        t.integer     :on_order
        t.date        :eta
        t.timestamps
      end
    end

  #########################################
  #########################################

end
