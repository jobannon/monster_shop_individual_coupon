class Admin::DashboardController < Admin::BaseController
  def index
    @orders = Order.custom_sort
  end
end
