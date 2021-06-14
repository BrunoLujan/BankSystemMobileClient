unit Account;

interface

uses
  System.JSON, HttpRest, Enums, System.SysUtils, Cards;

type
  TAccount = class
    private
      _id: integer;
      _name: string;
      _lastName: string;
      _email: string;
      _password: string;
      _birthdate: string;
      _cellphoneNumber: string;
      _colony: string;
      _street: string;
      _intNumber: string;
      _extNumber: string;
      _zipCode: string;
      _username: string;
      _homePhone: string;
      _role: ROLE_TYPE;
    public
      class var Current: TAccount;
      property Id: integer read _id;
      property Name: string read _name;
      property Role: ROLE_TYPE read _role;
      constructor Create(
        const email: string;
        const password: string
      ); overload;
      procedure Load;
      procedure Register;
      function RegisterDebitCard(): TDebitCard;
      function RegisterCreditCard(): TCreditCard;
      class function GetCards(const accountId: string): TCardArray;
    published
      constructor Create(
        const email: string;
        const name: string;
        const lastName: string;
        const birthdate: string;
        const cellphoneNumber: string;
        const colony: string;
        const street: string;
        const intNumber: string;
        const extNumber: string;
        const homePhone: string;
        const zipCode: string;
        const username: string;
        const password: string
      ); overload;
  end;

implementation

constructor TAccount.Create(const email: string; const password: string);
begin
  _email := email;
  _password := password;
end;

constructor TAccount.Create(
  const email: string;
  const name: string;
  const lastName: string;
  const birthdate: string;
  const cellphoneNumber: string;
  const colony: string;
  const street: string;
  const intNumber: string;
  const extNumber: string;
  const homePhone: string;
  const zipCode: string;
  const username: string;
  const password: string
);
begin
  _name := name;
  _email := email;
  _lastName := lastName;
  _birthdate := birthdate;
  _cellphoneNumber := cellphoneNumber;
  _colony := colony;
  _street := street;
  _intNumber := intNumber;
  _extNumber := extNumber;
  _zipCode := zipCode;
  _username := username;
  _homePhone := homePhone;
  _password := password;
end;

procedure TAccount.Load();
var
  params: TJSONObject;
  postResult: THttpResponse;
  accountData: TJSONValue;
begin
  params := TJSONObject.Create;
  params.AddPair('email', _email);
  params.AddPair('password', _password);
  postResult := THttpRest.SendPost('/account/login', params);
  accountData := postResult.Data.FindValue('account');
  _id := accountData.FindValue('accountId').Value.ToInteger();
  _name := accountData.FindValue('name').Value;
  _lastName := accountData.FindValue('lastName').Value;
  _role := ROLE_TYPE(StrToInt(accountData.FindValue('role').Value));
  THttpRest.Token := 'Bearer ' + postResult.Data.FindValue('token').FindValue('access_token').Value;
end;

procedure TAccount.Register;
var
  params: TJSONObject;
  postResult: THttpResponse;
begin
  params := TJSONObject.Create;
  params.AddPair('name', _name);
  params.AddPair('lastName', _lastName);
  params.AddPair('username', _username);
  params.AddPair('birthdate', _birthdate);
  params.AddPair('street', _street);
  params.AddPair('extNumber', _extNumber);
  params.AddPair('intNumber', _intNumber);
  params.AddPair('colony', _colony);
  params.AddPair('zipCode', _zipCode);
  params.AddPair('cellphoneNumber', _cellphoneNumber);
  params.AddPair('homePhone', _homePhone);
  params.AddPair('email', _email);
  params.AddPair('password', _password);
  postResult := THttpRest.SendPost('/account/signUp', params);
  _id := postResult.Data.FindValue('accountId').Value.ToInteger;
end;

function TAccount.RegisterDebitCard: TDebitCard;
var
  params: TJSONObject;
  postResult: THttpResponse;
  format: TFormatSettings;
  debitCard: TDebitCard;
begin
  format := TFormatSettings.Create;
  format.ShortDateFormat := 'yyyy-mm-dd';
  format.DateSeparator := '-';

  params := TJSONObject.Create;
  postResult := THttpRest.SendPost('/account/' + _id.ToString + '/card/debit/register', params);
  debitCard := TDebitCard.Create(
    postResult.Data.FindValue('cardId').Value.ToInteger,
    postResult.Data.FindValue('card').FindValue('cardNumber').Value,
    postResult.Data.FindValue('card').FindValue('cvv').Value.ToInteger,
    StrToDate(postResult.Data.FindValue('card').FindValue('expirationDate').Value, format),
    0,
    StrToDateTime(postResult.Data.FindValue('card').FindValue('createdAt').Value, format),
    CARD_STATUS(postResult.Data.FindValue('card').FindValue('status').Value.ToInteger),
    postResult.Data.FindValue('balance').Value.ToDouble
  );
  Result := debitCard;
end;

function TAccount.RegisterCreditCard: TCreditCard;
var
  params: TJSONObject;
  postResult: THttpResponse;
  format: TFormatSettings;
  creditCard: TCreditCard;
begin
  format := TFormatSettings.Create;
  format.ShortDateFormat := 'yyyy-mm-dd';
  format.DateSeparator := '-';

  params := TJSONObject.Create;
  postResult := THttpRest.SendPost('/account/' + _id.ToString + '/card/credit/register', params);
  creditCard := TCreditCard.Create(
    postResult.Data.FindValue('cardId').Value.ToInteger,
    postResult.Data.FindValue('card').FindValue('cardNumber').Value,
    postResult.Data.FindValue('card').FindValue('cvv').Value.ToInteger,
    StrToDate(postResult.Data.FindValue('card').FindValue('expirationDate').Value, format),
    0,
    StrToDateTime(postResult.Data.FindValue('card').FindValue('createdAt').Value, format),
    CARD_STATUS(postResult.Data.FindValue('card').FindValue('status').Value.ToInteger),
    postResult.Data.FindValue('credit').Value.ToDouble,
    postResult.Data.FindValue('positiveBalance').Value.ToDouble,
    TCreditCardType.Create(
      postResult.Data.FindValue('credit_card_type').FindValue('fundingLevel').Value,
      postResult.Data.FindValue('credit_card_type').FindValue('interestRate').Value.ToDouble,
      postResult.Data.FindValue('credit_card_type').FindValue('credit').Value.ToDouble
    )
  );
  Result := creditCard;
end;

class function TAccount.GetCards(const accountId: string): TCardArray;
var
  dataArray: TJSONArray;
  cards: TCardArray;
  request: THttpResponse;
  format: TFormatSettings;
  i : integer;
begin
  request := THttpRest.SendGet('/account/' + accountId + '/cards/get');
  format := TFormatSettings.Create;
  format.ShortDateFormat := 'yyyy-mm-dd';
  format.DateSeparator := '-';
  dataArray := request.Data as TJSONArray;
  SetLength(cards, dataArray.Count);
  for i := 0 to dataArray.Count - 1 do
    if dataArray.Items[i].FindValue('type').Value.ToInteger = integer(CARD_TYPE.CREDIT) then

        cards[i] := TCreditCard.Create(
        dataArray.Items[i].FindValue('cardId').Value.ToInteger,
        dataArray.Items[i].FindValue('cardNumber').Value,
        dataArray.Items[i].FindValue('cvv').Value.ToInteger,
        StrToDateTime(dataArray.Items[i].FindValue('expirationDate').Value, format),
        0,
        StrToDateTime(dataArray.Items[i].FindValue('createdAt').Value, format),
        CARD_STATUS(dataArray.Items[i].FindValue('status').Value.ToInteger),
        dataArray.Items[i].FindValue('credit').Value.ToDouble,
        dataArray.Items[i].FindValue('positiveBalance').Value.ToDouble,
        TCreditCardType.Create('type', 0.015, 8000)
      )
    else
        cards[i] := TDebitCard.Create(
        dataArray.Items[i].FindValue('cardId').Value.ToInteger,
        dataArray.Items[i].FindValue('cardNumber').Value,
        dataArray.Items[i].FindValue('cvv').Value.ToInteger,
        StrToDateTime(dataArray.Items[i].FindValue('expirationDate').Value, format),
        0,
        StrToDateTime(dataArray.Items[i].FindValue('createdAt').Value, format),
        CARD_STATUS(dataArray.Items[i].FindValue('status').Value.ToInteger),
        dataArray.Items[i].FindValue('balance').Value.ToDouble);
      Result := cards;
end;
end.




