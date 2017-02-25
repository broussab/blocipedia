class ChargesController < ApplicationController
  def new
    @stripe_btn_data = {
      key: Rails.configuration.stripe[:publishable_key].to_s,
      description: "Premium Membership - #{current_user.username}",
      amount: 1500
    }
  end

  def create
    # Creates a Stripe Customer object, for associating
    # with the charge
    token = params[:stripeToken]
    customer = Stripe::Customer.create(
      email: current_user.email,
      source: token
    )

    charge = Stripe::Charge.create(
      customer: customer.id, # Note -- this is NOT the user_id
      amount: 1500,
      description: "Premium Membership - #{current_user.email}",
      currency: 'usd'
    )

    if charge.save
      current_user.update_attributes(role: 'premium')
      flash[:notice] = "Thank you for your Premium Membership purchase, #{current_user.email}! You may now create private wikis!"
      redirect_to wikis_path(current_user)
    else
      flash[:notice] = 'Something went wrong'
      redirect_to root_path
    end

    # Stripe will send back CardErrors, with friendly messages
    # when something goes wrong.
    # This `rescue block` catches and displays those errors.
    rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to new_charge_path
    end

  def downgrade
    current_user.update_attributes(role: 'standard')
    if current_user.standard?
      flash[:notice] = 'You now have a Standard Membership'
      redirect_to wikis_path(current_user)
    else
      flash[:notice] = 'An error has occurred'
      redirect_to wikis_path(current_user)
    end
  end
end
