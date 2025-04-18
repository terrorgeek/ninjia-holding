require 'csv'
require './bank'

raw_loans = []
File.foreach('./data.csv') do |line|
  raw_loans << line
end
bank = Bank.new
bank.persist_loans(raw_loans)
bank.process_loans
bank.print_answer
