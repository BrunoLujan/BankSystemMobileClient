unit LoginScreen;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, Account, RegularExpressions,
  Enums, FMX.Objects;

type
  TLoginForm = class(TForm)
    LoginButton: TButton;
    Label1: TLabel;
    EmailTF: TEdit;
    Label2: TLabel;
    PasswordTF: TEdit;
    Label3: TLabel;
    Rectangle1: TRectangle;
    procedure LoginButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoginForm: TLoginForm;

implementation

{$R *.fmx}

procedure TLoginForm.LoginButtonClick(Sender: TObject);
var
  account: TAccount;
begin
  if (EmailTF.Text = '') or (PasswordTF.Text = '') then
  begin
    ShowMessage('Faltan campos por completar.');
    exit;
  end;
  if not TRegEx.IsMatch(EmailTF.Text, '^[a-zA-Z0-9_]+@[a-zA-Z0-9]+.[a-zA-Z]+$') then
  begin
    ShowMessage('Debes introducir datos v�lidos.');
    exit;
  end;
  account := TAccount.Create(EmailTF.Text, PasswordTF.Text);
  try
    account.Load;
    TAccount.Current := account;
    if account.Role = ROLE_TYPE.CLIENT then
    begin
      {createTransactionForm := TCreateTransactionSetCardNumberForm.Create(nil);
      createTransactionForm.ShowModal;
      createTransactionForm.Release;}
      ShowMessage('Login successful');
    end
    else
      ShowMessage('Acceso exclusivo para clientes.');
  except
    on ex: Exception do begin
      ShowMessage(ex.Message);
    end;
  end;
end;

end.
