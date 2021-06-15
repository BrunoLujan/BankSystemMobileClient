program BankSystemMobile;

uses
  System.StartUpCopy,
  FMX.Forms,
  LoginScreen in 'LoginScreen.pas' {Form1},
  Account in 'Models\Account.pas',
  Cards in 'Models\Cards.pas',
  Transaction in 'Models\Transaction.pas',
  HttpRest in 'Network\HttpRest.pas',
  Enums in 'Enums.pas',
  CheckAccount in 'CheckAccount.pas' {Form2},
  CheckAccountStatement in 'CheckAccountStatement.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TLoginForm, LoginForm);
  Application.CreateForm(TCheckAccountForm, CheckAccountForm);
  Application.CreateForm(TCheckAccountStatementForm, CheckAccountStatementForm);
  Application.Run;
end.
