class Merchant::OrdersController < Merchant::BaseController

  def index
  end

  def show
    @current_order = Order.find(params[:id])
    @item_orders = @current_order.merchant_orders(current_user.merchant_id)
  end

  def update
    item_order = ItemOrder.find(params[:item_order_id])
    item = Item.find(item_order.item_id)
    if item_order.fulfilled_by_merchant
      unfulfill(item_order, item)
    else
      fulfill(item_order, item)
    end
    redirect_to "/merchant/orders/#{item_order.order_id}"
  end

  private
    def check_fulfilled?(item_order)
      order = Order.find(item_order.order_id)
      package_order = order.item_orders.all? {|item_ord| item_ord.fulfilled_by_merchant}
      order.update(status: "Packaged") if package_order
    end

    def fulfill(item_order, item)
      item_order.update(fulfilled_by_merchant: true)
      item.update(inventory: (item.inventory - item_order.quantity))
      flash[:happy] = 'Item fulfilled'
      check_fulfilled?(item_order)
    end

    def unfulfill(item_order, item)
      item_order.update(fulfilled_by_merchant: false)
      item.update(inventory: (item.inventory + item_order.quantity))
      flash[:sad] = 'Item unfulfilled'
    end
end
