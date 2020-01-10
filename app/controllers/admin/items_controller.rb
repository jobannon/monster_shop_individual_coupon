class Admin::ItemsController < Admin::BaseController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    item = Item.find(params[:id])

    if params[:status] == 'deactivate'
      deactivate(item)
    elsif params[:status] == 'activate'
      activate(item)
    end

    redirect_back fallback_location: "/admin/#{item.merchant_id}/items"
  end

  private

  def deactivate(item)
    item.update(active?: false)
    flash[:happy] = 'Item Deactivated'
  end

  def activate(item)
    item.update(active?: true)
    flash[:happy] = 'Item Activated'
  end
end
