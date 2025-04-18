RSpec.describe Bank do
  let(:bank) { Bank.new }

  describe '#initialize' do
    it 'initializes empty loans, accepted_loans, and average_amount_by_product_type' do
      expect(bank.loans).to be_empty
      expect(bank.accepted_loans).to be_empty
      expect(bank.rejected_customers).to be_a(Set)
      expect(bank.rejected_customers).to be_empty
      expect(bank.average_amount_by_product_type).to be_empty
    end
  end

  describe '#print_answer' do
    it 'prints the formatted accepted loans, average amounts, and rejected customers' do
      bank.accepted_loans = [Loan.new(name: 'Test', product_type: 2, amount: 600.00)]
      bank.accepted_loans[0].status = LoanStatus::Accepted
      bank.rejected_customers.add('Reject')
      bank.average_amount_by_product_type = { 2 => 600 }
      expected_output = "Accepted Offers:\n  Test: $600.00\n\n\nAverage offer amount:\n  2: $600\n\n\nRejected Customers:\n  Reject\n"
      expect { bank.print_answer }.to output(expected_output).to_stdout
    end

    it 'handles empty data for printing' do
      expected_output = "Accepted Offers: N/A\n\nAverage offer amount: N/A\n\nRejected Customers: N/A\n"
      expect { bank.print_answer }.to output(expected_output).to_stdout
    end
  end

  # Integration test to ensure the whole process works together
  describe 'integration test' do
    let(:data_file) { 'test_data.csv' }
    let(:expected_output) do
      "Accepted Offers:\n  Bob: $600.00\n  Charlie: $750.00*\n  David: $400.00\n\n\nAverage offer amount:\n  0: $750\n  1: $500\n\n\nRejected Customers:\n  Alice\n"
    end

    before do
      File.open(data_file, 'w') do |f|
        f.puts "Alice,0,$350.00"
        f.puts "Bob,1,600.00"
        f.puts "Charlie,0,750.00"
        f.puts "David,1,400.00"
      end
    end

    after do
      File.delete(data_file)
    end

    it 'reads data, processes loans, and prints the correct report' do
      raw_loans = []
      File.foreach(data_file) { |line| raw_loans << line }
      bank = Bank.new
      bank.persist_loans(raw_loans)
      bank.process_loans
      expect { bank.print_answer }.to output(expected_output).to_stdout
    end
  end
end