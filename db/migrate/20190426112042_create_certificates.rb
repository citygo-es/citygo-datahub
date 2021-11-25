class CreateCertificates < ActiveRecord::Migration[5.2]
  def change
    create_table :certificates do |t|
      t.string :name
      t.references :point_of_interest, index: { name: :index_certificates_point_of_interest }
      t.timestamps
    end
  end
end
