require_relative '../bank_presenter'
require_relative '../loan_status'
require_relative '../bank'

RSpec.describe BankPresenter do
  let(:bank) { Bank.new }

  before do
    bank.accepted_loans = [
      Loan.new(name: 'Alice', product_type: 0, amount: 500.00),
      Loan.new(name: 'Bob', product_type: 1, amount: 750.50),
      Loan.new(name: 'Charlie', product_type: 0, amount: 600.00)
    ]
    bank.accepted_loans[0].status = LoanStatus::Accepted
    bank.accepted_loans[1].status = LoanStatus::Review
    bank.accepted_loans[2].status = LoanStatus::Accepted

    bank.rejected_customers.add('David')
    bank.rejected_customers.add('Eve')
    bank.average_amount_by_product_type = { 0 => 550, 1 => 751 }
  end

  describe '#print_accepted_loans' do
    it 'formats accepted loans with asterisks for review' do
      expected_output = "Accepted Offers:\n  Alice: $500.00\n  Bob: $750.50*\n  Charlie: $600.00\n"
      expect(bank.print_accepted_loans).to eq(expected_output)
    end

    it 'handles empty accepted loans' do
      bank.accepted_loans = []
      expect(bank.print_accepted_loans).to eq("Accepted Offers: N/A")
    end
  end

  describe '#print_rejected_customers' do
    it 'formats rejected customers' do
      expected_output = "Rejected Customers:\n  David\n  Eve\n"
      expect(bank.print_rejected_customers).to eq(expected_output)
    end

    it 'handles empty rejected customers' do
      bank.rejected_customers = Set.new
      expect(bank.print_rejected_customers).to eq("Rejected Customers: N/A")
    end
  end

  describe '#print_average_loan_amount' do
    it 'formats average loan amounts by product type' do
      expected_output = "Average offer amount:\n  0: $550\n  1: $751\n"
      expect(bank.print_average_loan_amount).to eq(expected_output)
    end

    it 'handles empty average amounts' do
      bank.average_amount_by_product_type = {}
      expect(bank.print_average_loan_amount).to eq("Average offer amount: N/A")
    end
  end
end