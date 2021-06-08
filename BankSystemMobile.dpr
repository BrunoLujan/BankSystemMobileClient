program BankSystemMobile;

uses
  System.StartUpCopy,
  FMX.Forms,
  LoginScreen in 'LoginScreen.pas' {Form1},
  Account in 'Models\Account.pas',
  Cards in 'Models\Cards.pas',
  Transaction in 'Models\Transaction.pas',
  HttpRest in 'Network\HttpRest.pas',
  Enums in 'Enums.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
