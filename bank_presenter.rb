require './loan_status'

module BankPresenter
  AcceptedOffersTitle = 'Accepted Offers'.freeze
  AverageLoanAmountTitle = 'Average offer amount'.freeze
  RejectedCustomersTitle = 'Rejected Customers'.freeze

  def print_accepted_loans
    return "#{AcceptedOffersTitle}: N/A" if self.accepted_loans.empty?
    accepted_offers_presentation = self.accepted_loans.map {|loan| "  #{loan.name}: $#{sprintf("%.2f", loan.amount)}#{(loan.status == LoanStatus::Review ? '*' : '')}\n" }
    "#{AcceptedOffersTitle}:\n#{accepted_offers_presentation.join}"
  end

  def print_rejected_customers
    return "#{RejectedCustomersTitle}: N/A" if self.rejected_customers.empty?
    reject_customers_presentation = self.rejected_customers.map {|customer| "  #{customer}\n" }
    "#{RejectedCustomersTitle}:\n#{reject_customers_presentation.join}"
  end

  def print_average_loan_amount
    return "#{AverageLoanAmountTitle}: N/A" if self.average_amount_by_product_type.empty?
    avg_presentation = self.average_amount_by_product_type.to_a.sort_by {|product| product[0] }.map {|product| "  #{product[0]}: $#{product[1]}\n" }
    "#{AverageLoanAmountTitle}:\n#{avg_presentation.join}"
  end
end