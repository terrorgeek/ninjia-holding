require 'rspec'
require_relative '../loan'
require_relative '../loan_status'
require_relative '../bank'
require 'set'

RSpec.describe Loan do
  it 'initializes with name, product_type, and amount' do
    loan = Loan.new(name: 'John Doe', product_type: 1, amount: 500.00)
    expect(loan.name).to eq('John Doe')
    expect(loan.product_type).to eq(1)
    expect(loan.amount).to eq(500.00)
    expect(loan.status).to be_nil
  end

  it 'allows setting and getting status' do
    loan = Loan.new(name: 'Jane Doe', product_type: 2, amount: 600.00)
    loan.status = LoanStatus::Accepted
    expect(loan.status).to eq(LoanStatus::Accepted)
  end
end
