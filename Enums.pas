unit Enums;

interface

type
  CARD_STATUS = (
    ACTIVE = 0,
    SUSPENDED = 1,
    BLOCKED = 2,
    CANCELED = 3
  );
  CARD_TYPE = (
    DEBIT = 0,
    CREDIT = 1
  );
  TRANSACTION_TYPE = (
    TRANSFER_OF_FUNDS = 0,
    DEPOSIT = 1,
    WITHDRAWAL = 2,
    PAYMENT = 3,
    MONTHLY_PAYMENT = 4,
    SURCHARGE_PAYMENT = 5
  );
  ROLE_TYPE = (
    CLIENT = 0,
    EXECUTIVE = 1,
    BRANCH_MANAGER = 2,
    CASHIER = 3
  );

implementation

end.
