unit Transaction;

interface

uses
  Enums, HttpRest, System.Classes, System.JSON, System.SysUtils;

type
  TTransaction = class
    private
      _cardId: integer;
      _type: TRANSACTION_TYPE;
      _createdAt: TDateTime;
      _amount: double;
      _reference: string;
      _concept: string;
      _interestRate: double;
      _surchargeRate: double;
    public
      constructor Create(
        const cardId: integer;
        const transactionType: TRANSACTION_TYPE;
        const createdAt: TDateTime;
        const amount: double;
        const reference: string;
        const concept: string;
        const interestRate: double;
        const surchargeRate: double
      );
      procedure Save;
  end;

implementation

constructor TTransaction.Create(
  const cardId: integer;
  const transactionType: TRANSACTION_TYPE;
  const createdAt: TDateTime;
  const amount: double;
  const reference: string;
  const concept: string;
  const interestRate: double;
  const surchargeRate: double
);
begin
  _cardId := cardId;
  _type := transactionType;
  _createdAt := createdAt;
  _amount := amount;
  _reference := reference;
  _concept := concept;
  _interestRate := interestRate;
  _surchargeRate := surchargeRate;
end;

procedure TTransaction.Save;
var
  params: TJSONObject;
  resource: string;
  postResult: THttpResponse;
begin
  params := TJSONObject.Create;
  params.AddPair('originCardId', '');
  params.AddPair('amount', _amount.ToString);
  params.AddPair('reference', _reference);
  params.AddPair('concept', _concept);
  if _type = TRANSACTION_TYPE.DEPOSIT then
    resource := 'deposit'
  else if _type = TRANSACTION_TYPE.WITHDRAWAL then
    resource := 'withdraw'
  else if _type = TRANSACTION_TYPE.MONTHLY_PAYMENT then
    resource := 'monthlyPayment';
  postResult := THttpRest.SendPost('/card/' + _cardId.ToString + '/transaction/' + resource, params);
end;

end.
