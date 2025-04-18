require 'set'
require './loan_status'
require './loan'

module BankBusiness
  def persist_loans(raw_loans)
    raw_loans.each do |loan|
      name, product_type, amount = loan.strip.split(',')
      self.loans << Loan.new(
        name: name, 
        product_type: product_type.to_i, 
        amount: amount_to_f(amount)
      )
    end
  end

  def process_loans
    self.loans.each do |loan|
      accept_loan(loan)
      reject_customer(loan)
    end
    average_amount_by_product_type_without_rejected_loan
  end

  private
  def accept_loan(loan)
    if loan.amount >= 400
      loan.status = (loan.amount < 700 ? LoanStatus::Accepted : LoanStatus::Review)
      self.accepted_loans << loan 
    end
  end

  def reject_customer(loan)
    if loan.amount < 400
      loan.status = LoanStatus::Rejected
      self.rejected_customers.add(loan.name)
    end
  end
  
  def average_amount_by_product_type_without_rejected_loan
    self.accepted_loans.each do |loan|
      self.average_amount_by_product_type[loan.product_type] << loan.amount
    end
    self.average_amount_by_product_type.transform_values! { |amounts| (amounts.inject(&:+) / amounts.length.to_f).round }
  end

  def amount_to_f(amount)
    amount.start_with?('$') ? amount[1..-1].to_f.round(2) : amount.to_f.round(2)
  end
end