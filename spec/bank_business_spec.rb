require_relative '../bank_business'

RSpec.describe BankBusiness do
  let(:bank) { Bank.new }

  describe '#persist_loans' do
    it 'parses raw loan data and creates Loan objects' do
      raw_loans = ["Alice,0,$500.00\n", "Bob,1,600.50\n"]
      bank.persist_loans(raw_loans)
      expect(bank.loans.count).to eq(2)
      expect(bank.loans[0].name).to eq('Alice')
      expect(bank.loans[0].product_type).to eq(0)
      expect(bank.loans[0].amount).to eq(500.00)
      expect(bank.loans[1].name).to eq('Bob')
      expect(bank.loans[1].product_type).to eq(1)
      expect(bank.loans[1].amount).to eq(600.50)
    end

    it 'handles amounts without a dollar sign' do
      raw_loans = ["Charlie,0,450\n"]
      bank.persist_loans(raw_loans)
      expect(bank.loans[0].amount).to eq(450.00)
    end

    it 'handles empty input' do
      bank.persist_loans([])
      expect(bank.loans).to be_empty
    end
  end

  describe '#process_loans' do
    before do
      bank.persist_loans(["Alice,0,$350.00\n", "Bob,1,600.00\n", "Charlie,0,750.00\n", "David,1,400.00\n"])
      bank.process_loans
    end

    it 'flags loans over $700 for review' do
      expect(bank.accepted_loans.find { |loan| loan.name == 'Charlie' }&.status).to eq(LoanStatus::Review)
    end

    it 'accepts loans between $400 and $700' do
      expect(bank.accepted_loans.find { |loan| loan.name == 'Bob' }&.status).to eq(LoanStatus::Accepted)
      expect(bank.accepted_loans.find { |loan| loan.name == 'David' }&.status).to eq(LoanStatus::Accepted)
    end

    it 'rejects loans under $400' do
      expect(bank.rejected_customers).to include('Alice')
      expect(bank.accepted_loans.none? { |loan| loan.name == 'Alice' }).to be_truthy
    end

    it 'calculates the average offer amount per product type, ignoring rejected loans' do
      expect(bank.average_amount_by_product_type[0]).to eq(750) # Only Charlie's loan is > 400
      expect(bank.average_amount_by_product_type[1]).to eq(500) # Average of Bob (600) and David (400)
    end

    it 'handles cases with no accepted loans for a product type' do
      bank = Bank.new
      bank.persist_loans(["Alice,0,$350.00\n", "Bob,1,$300.00\n"])
      bank.process_loans
      expect(bank.average_amount_by_product_type).to be_empty
    end

    it 'handles cases with only rejected loans' do
      bank = Bank.new
      bank.persist_loans(["Alice,0,$350.00\n", "Bob,1,$200.00\n"])
      bank.process_loans
      expect(bank.accepted_loans).to be_empty
      expect(bank.rejected_customers).to include('Alice', 'Bob')
      expect(bank.average_amount_by_product_type).to be_empty
    end

    it 'handles cases with all accepted loans within the $400-$700 range' do
      bank = Bank.new
      bank.persist_loans(["Eve,2,$450.00\n", "Frank,2,$650.00\n"])
      bank.process_loans
      expect(bank.accepted_loans.all? { |loan| loan.status == LoanStatus::Accepted }).to be_truthy
      expect(bank.average_amount_by_product_type[2]).to eq(550)
      expect(bank.rejected_customers).to be_empty
    end

    it 'handles cases with all accepted loans over $700' do
      bank = Bank.new
      bank.persist_loans(["Grace,3,$720.00\n", "Heidi,3,$800.00\n"])
      bank.process_loans
      expect(bank.accepted_loans.all? { |loan| loan.status == LoanStatus::Review }).to be_truthy
      expect(bank.average_amount_by_product_type[3]).to eq(760)
      expect(bank.rejected_customers).to be_empty
    end
  end
end