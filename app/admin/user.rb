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
  permit_params :first_name, :last_name, :email, :address, :city, :country, :postal_code, :role

    index do
    selectable_column
    column :id
    column :first_name
    column :last_name
    column :email
    column :created_at
    column :address
    column :city
    column :country
    column :role
    column :fee_cents
    column :admin
    actions
  end
end
