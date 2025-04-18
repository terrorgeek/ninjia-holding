require './bank_business'
require './bank_presenter'

class Bank
  attr_accessor :loans, :accepted_loans, :rejected_customers, :average_amount_by_product_type
  include BankBusiness
  include BankPresenter

  def initialize
    self.loans = []
    self.accepted_loans = []
    self.rejected_customers = Set[]
    self.average_amount_by_product_type = Hash.new {|h, k| h[k] = []}
  end

  def print_answer
    puts "#{print_accepted_loans}\n\n#{print_average_loan_amount}\n\n#{print_rejected_customers}"
  end
end