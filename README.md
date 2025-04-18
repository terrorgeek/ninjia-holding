# Intro
We appreciate the time you spent talking to us! Our engineering team is excited to continue the conversation with you, but as a part of that conversation we ask that you complete a very simple coding sample for us first. The sample should take no longer than 1-2 hours and will be reviewed by our engineering team promptly.

For this challenge we ask that you use any programming language that you’re most proficient in-- we want to see your best work. That said, we ask that you try and stick to common programming languages if possible to help our reviewers out when reading your code.

Any project structure can be used, with any conventions, so long as the structure and conventions make sense and are used consistently throughout.

# The gist of the prompt
Submitted solutions must reflect how you would write production level code. The requirements are simple on purpose, but the code should reflect good, well modeled, reasonable engineering principles.

Submissions should not aim to achieve the answers in the fewest lines of code, nor should submissions aim to inflate their program with needless complexity. Submissions provided without tests will be rejected.

Please add a bit to the "Reasoning and Design" section at the bottom of this file. You do not need to include much, but listing the general thought process behind the design of the program as well as any assumptions made would be helpful for reviewers reading the code.

When complete, push your solution up to github (pushing to `main` is fine). We will revoke access to this repository once the prompt has been completed.

# The prompt itself
Given the following input (provided at the end) where the columns are:
1. Customer Name
2. Product Type (an integer value)
3. Loan amount offered in dollars


Create a program that:
1. Reads the input from STDIN or a file
2. Flags loan amount offers over $700 for additional review
3. Rejects loan amount offers under $400
4. Generates a report and prints it to STDOUT or a file

The report should show the following (sample to follow):
- Each customer with non-rejected loan amounts, including an asterisk for those loans that need additional review
- The average offer amount per product type, ignoring dollar amounts from rejected loan offers rounded to the nearest dollar
- All customers with rejected loan amounts

So given the following input:

```
John,1,399
Paul,1,650
Ringo,1,750.42
George,0,740.25
Susie,1,800.0
Mary,0,425.50
Susie,1,$350.01
Jesse,0,123.45
Alicia,1,415.50
Richard,1,$500
Steven,0,$550.0
Robert,1,325
```


The program should output the following:

```
Accepted Offers:
  Paul: $650.00
  Ringo: $750.42*
  George: $740.25*
  Susie: $800.00*
  Mary: $425.50
  Alicia: $415.50
  Richard: $500.00
  Steven: $550.00

Average offer amount: 
  Product 0: $572
  Product 1: $623

Rejected Customers:
  John
  Suzie
  Jesse
  Robert
```

# Reasoning and Design

## Overview
All the input data is in data.csv
### How it works:
  Run the app, in command line, run:
    ```
      ruby main.rb
    ```

  Run tests, in command line run:
    ```
      rspec
    ```

### Classes:
  Bank
    Bank class represents an actual bank that processes loans
  BankBusiness
    BankBusiness represents the actual implementation of business logic that a bank does.
  BankPresenter
    As the name indicates, it represents the "view" how the data is displayed on screen for the readers. It should have nothing
    to do or being involved in the business logic of a bank.
  Loan
    Simply represents a specific loan, or a row in the input, e.g. "John,1,399"
  LoanStatus
    It's not actually a class but the statuses of a loan, it's very important so it's being extracted out in here.

### Reasoning:
  There are actually endless ways to finish this assessment, but I would rather use a simple one which is easy to understand and straightforward, and I won't predict the future so much but will only do a little bit catering to some potentials needs.

  Due to the requirements of the output, I think a thoughts of put the loans/offers separately and treat the loan as an identity would be a very good choice. Meanwhile, we could and it might be more scalable but it might be unnecessary to also create a customer identity/class for customers. 

  Then I'm separating the core business of the Bank into a specific Ruby model called "BankBusiness", here I put all business logic plus some util methods like amount_to_f and I 
  also put some methods that are unnecessarily to be public to be private. BankBusiness has persist_loans and process_loans, and persist should go before process because persist 
  is to store the loans into the bank first and only then the bank is able to process the loans. I also wrapped the accpet, reject and calculate average for the product's amount into average_amount_by_product_type_without_rejected_loan and called it after all loans are iterated. I intentionally made the "status" field not in the initializer of Loan because it's weird to just give it a default status and I don't want to add a placeholder status as default to add complexity.

  Then we come to the BankPresenter, this is a simple class that is dedicated to render the output to meet the requirement. However, it doesn't dump all output in 1 shot, but rather, it includes 3 methods that are responsible accepted, rejected and avg of product amount respectively. The reason I'm doing this way is to make the includer(Bank) easier to customize, so that the bank can add/remove the output whatever it wants.

  Then in the Bank class, we can see it has a "print_answer" method to print the final answer. Also I make the Bank class to only hold data as the properties defined, and it includes the BankBusiness and BankPresenter modules to get their methods.
