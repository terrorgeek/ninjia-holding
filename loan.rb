class Loan
  attr_accessor :status, :name, :amount, :product_type

  def initialize(name:, product_type:, amount:)
    self.name = name
    self.amount = amount
    self.product_type = product_type
  end
end