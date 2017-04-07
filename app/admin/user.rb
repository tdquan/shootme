ActiveAdmin.register User do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  permit_params :first_name, :last_name, :email, :address, :city, :country, :postal_code, :role, :password, :password_confirmation

  form do |f|
    f.inputs 'Details' do
    f.input :first_name
    f.input :last_name
    f.input :email
    f.input :password
    f.input :password_confirmation
    f.input :address
    f.input :city
    f.input :country, :as => :string
    f.input :role
    f.input :admin
    end
    f.actions
  end

    index do
    selectable_column
    column :id
    column :first_name
    column :last_name
    column :email
    column :created_at
    column :address
    column :city
    # column :country, :as => :string
    column :role
    column :role
    column :admin
    actions
  end
end
