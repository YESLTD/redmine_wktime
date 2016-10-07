class CreateWkBilling < ActiveRecord::Migration
  def change
	create_table :wk_addresses do |t|
	  t.string :name
      t.string :address1
      t.string :address2
	  t.string :work_phone
      t.string :home_phone
	  t.string :mobile
      t.string :email
	  t.string :fax
      t.string :city
	  t.string :country
      t.date :state
      t.integer :pin
	  t.timestamps null: false
    end
  
    create_table :wk_accounts do |t|
      t.string :name
      t.string :account_type, :null => true, :limit => 1
	  t.references :address, :class => "wk_addresses", :null => true
	  t.timestamps null: false
    end
	add_index  :wk_accounts, :address_id
	
	create_table :wk_account_projects do |t|
      t.boolean :itemized_bill
	  t.boolean :apply_tax
      t.string :billing_tpe, :null => true, :limit => 1
      t.references :project, :null => true
	  t.references :account, :class => "wk_accounts", :null => true
	  t.timestamps null: false
    end
	add_index  :wk_account_projects, :project_id
	add_index  :wk_account_projects, :account_id
	
	create_table :wk_contracts do |t|
      t.references :project, :null => true
	  t.references :account, :class => "wk_accounts", :null => true
	  t.date :start_date
	  t.date :end_date
      t.string :name,         :null => false
      t.binary :data,         :null => false
      t.string :filename
      t.string :file_type
      t.timestamps null: false
    end
	add_index  :wk_contracts, :project_id
	add_index  :wk_contracts, :account_id
	
	create_table :wk_taxes do |t|
      t.string :name
      t.float :rate
      t.timestamps null: false
    end
	
	create_table :wk_project_taxes do |t|
      t.references :project, :null => false
      t.references :tax, :class => "wk_taxes", :null => false
      t.timestamps null: false
    end
	add_index  :wk_project_taxes, :project_id
	add_index  :wk_project_taxes, :tax_id
	
	create_table :wk_invoices do |t|
      t.string :status, :null => false, :limit => 1, :default => 'o'
      t.date :start_date
	  t.date :end_date
	  t.date :invoice_date
	  t.date :closed_on
	  t.references :modifier, :class => "User", :null => false
	  t.references :account_project, :class => "wk_account_projects", :null => false
	  t.timestamps null: false
    end
	add_index  :wk_invoices, :account_project_id
	
	create_table :wk_invoice_items do |t|
      t.string :name
	  t.float :rate
      t.float :amount
	  t.float :quantity
	  t.string :item_type, :null => false, :limit => 1, :default => 'i'
	  t.references :modifier, :class => "User", :null => false
	  t.references :invoice, :class => "wk_invoices", :null => false
	  t.timestamps null: false
    end
	add_index  :wk_invoice_items, :invoice_id
	
	create_table :wk_billing_schedules do |t|
	  t.string :milestone
      t.date :bill_date
      t.float :amount
	  t.column :currency, :string, :limit => 5, :default => '$'
	  t.references :invoice, :class => "wk_invoices", :null => true
	  t.references :account_project, :class => "wk_account_projects", :null => false
	  t.timestamps null: false
    end
	add_index  :wk_billing_schedules, :account_project_id
	add_index  :wk_billing_schedules, :invoice_id

  end
end
