class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  after_commit :set_defaults

  validates_presence_of :name,
                        :description,
                        :price,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def not_active?
    return true if self.active? == false
  end

  def self.top_five
    joins(:item_orders).select("items.*, sum(item_orders.quantity) as quantity").group(:id).order("quantity desc").limit(5)
  end

  def self.bottom_five
    joins(:item_orders).select("items.*, sum(item_orders.quantity) as quantity").group(:id).order("quantity asc").limit(5)
  end

  def set_defaults
    self.image = 'https://media3.s-nbcnews.com/j/newscms/2019_33/2203981/171026-better-coffee-boost-se-329p_67dfb6820f7d3898b5486975903c2e51.fit-760w.jpg' if self.image == ''
  end
end
