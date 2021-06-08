unit Cards;

interface

uses
  Enums, HttpRest, System.Classes, System.SysUtils, System.JSON;

type
  TCard = class abstract
    protected
      _cardId: integer;
      _cardNumber: string;
      _cvv: integer;
      _expirationDate: TDate;
      _pin: integer;
      _createdAt: TDateTime;
      _status: CARD_STATUS;
    public
      property CardId: integer read _cardId write _cardId;
      property CardNumber: string read _cardNumber;
      class function GetByCardNumber(const cardNumber: string): TCard;
  end;

  TDebitCard = class(TCard)
    private
      _balance: double;
    public
      constructor Create(
        const cardId: integer;
        const cardNumber: string;
        const cvv: integer;
        const expDate: TDate;
        const pin: integer;
        const createdAt: TDateTime;
        const status: CARD_STATUS;
        const balance: double
      );
  end;

  TCreditCardType = class
    private
      _fundingLevel: string;
      _interestRate: double;
      _credit: double;
    public
      constructor Create(
        const fundingLevel: string;
        const interestRate: double;
        const credit: double
      );
      property InterestRate: double read _interestRate;
  end;
  
  TCreditCard = class(TCard)
    private
      _credit: double;
      _positiveBalance: double;
      _creditCardType: TCreditCardType;
    public
      constructor Create(
        const cardId: integer;
        const cardNumber: string;
        const cvv: integer;
        const expDate: TDate;
        const pin: integer;
        const createdAt: TDateTime;
        const status: CARD_STATUS;
        const credit: double;
        const positiveBalance: double;
        const creditCardType: TCreditCardType
      );
      property CreditCardType: TCreditCardType read _creditCardType;
      function GetDebt(): TJSONValue;
  end;

implementation

class function TCard.GetByCardNumber(const cardNumber: string): TCard;
var
  request: THttpResponse;
  format: TFormatSettings;
begin
  request := THttpRest.SendGet('/card/' + cardNumber + '/get');
  format := TFormatSettings.Create;
  format.ShortDateFormat := 'yyyy-mm-dd';
  format.DateSeparator := '-';
  if request.Data.FindValue('type').Value.ToInteger = integer(CARD_TYPE.CREDIT) then
    Result := TCreditCard.Create(
      request.Data.FindValue('cardId').Value.ToInteger,
      request.Data.FindValue('cardNumber').Value,
      0,
      StrToDateTime(request.Data.FindValue('expirationDate').Value, format),
      0,
      StrToDateTime(request.Data.FindValue('createdAt').Value, format),
      CARD_STATUS(request.Data.FindValue('status').Value.ToInteger),
      request.Data.FindValue('credit').Value.ToDouble,
      request.Data.FindValue('positiveBalance').Value.ToDouble,
      TCreditCardType.Create('type', 0.015, 8000)
    )
  else
    Result := TDebitCard.Create(
      request.Data.FindValue('cardId').Value.ToInteger,
      request.Data.FindValue('cardNumber').Value,
      0,
      StrToDateTime(request.Data.FindValue('expirationDate').Value, format),
      0,
      StrToDateTime(request.Data.FindValue('createdAt').Value, format),
      CARD_STATUS(request.Data.FindValue('status').Value.ToInteger),
      request.Data.FindValue('balance').Value.ToDouble
    );
end;

constructor TDebitCard.Create(
  const cardId: integer;
  const cardNumber: string;
  const cvv: integer;
  const expDate: TDate;
  const pin: integer;
  const createdAt: TDateTime;
  const status: CARD_STATUS;
  const balance: double
);
begin
  _cardId := cardId;
  _cardNumber := cardNumber;
  _cvv := cvv;
  _expirationDate := expDate;
  _pin := pin;
  _createdAt := createdAt;
  _status := status;
  _balance := balance;
end;

constructor TCreditCardType.Create(
  const fundingLevel: string;
  const interestRate: double;
  const credit: double
);
begin
  _fundingLevel := fundingLevel;
  _interestRate := interestRate;
  _credit := credit;
end;

constructor TCreditCard.Create(
  const cardId: integer;
  const cardNumber: string;
  const cvv: integer;
  const expDate: TDate;
  const pin: integer;
  const createdAt: TDateTime;
  const status: CARD_STATUS;
  const credit: double;
  const positiveBalance: double;
  const creditCardType: TCreditCardType
);
begin
  _cardId := cardId;
  _cardNumber := cardNumber;
  _cvv := cvv;
  _expirationDate := expDate;
  _pin := pin;
  _createdAt := createdAt;
  _status := status;
  _credit := credit;
  _positiveBalance := positiveBalance;
  _creditCardType := creditCardType;
end;

function TCreditCard.GetDebt(): TJSONValue;
var
  request: THttpResponse;
begin
  request := THttpRest.SendGet('/card/' + _cardNumber + '/getDebt');
  Result := request.Data;
end;

end.
