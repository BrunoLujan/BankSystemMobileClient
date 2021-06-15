unit CheckAccountStatement;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Transaction, Cards,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.ListBox,
  FMX.Edit, Enums;

type
  TCheckAccountStatementForm = class(TForm)
    Rectangle1: TRectangle;
    Label1: TLabel;
    CheckAccountStatementButton: TButton;
    Panel2: TPanel;
    Label3: TLabel;
    Panel1: TPanel;
    Label2: TLabel;
    CardsListBox: TListBox;
    Label4: TLabel;
    Label7: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    Panel3: TPanel;
    Label9: TLabel;
    Panel4: TPanel;
    CardTypeLabel: TLabel;
    CardNumberLabel: TLabel;
    AmountTypeLabel: TLabel;
    CardAmountLabel: TLabel;
    Label10: TLabel;
    MonthCombobox: TComboBox;
    YearTF: TEdit;
    Panel5: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure CheckAccountStatementButtonClick(Sender: TObject);
  private
    _card: TCard;
    creditCard : TCreditCard;
    debitCard : TDebitCard;
    transactions : TTransactionArray;
  public
    constructor Create(AOwner: TComponent; const card: TCard); reintroduce; overload;
  end;

var
  CheckAccountStatementForm: TCheckAccountStatementForm;

implementation

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiTb.fmx ANDROID}

constructor TCheckAccountStatementForm.Create(AOwner: TComponent; const card: TCard);
begin
  inherited Create(AOwner);
  _card := card;
end;

procedure TCheckAccountStatementForm.FormCreate(Sender: TObject);
begin

  if _card is TCreditCard then
  begin
     creditCard := _card as TCreditCard;
     CardTypeLabel.Text := 'Tarjeta de crédito';
     AmountTypeLabel.Text := 'Crédito:';
     CardNumberLabel.Text := creditCard.CardNumber;
     CardAmountLabel.Text := creditCard.Credit.ToString;
  end
  else if _card is TDebitCard then
  begin
     debitCard := _card as TDebitCard;
     CardTypeLabel.Text := 'Tarjeta de débito';
     AmountTypeLabel.Text := 'Saldo:';
     CardNumberLabel.Text := debitCard.CardNumber;
     CardAmountLabel.Text := debitCard.Balance.ToString;
  end;
end;

procedure TCheckAccountStatementForm.CheckAccountStatementButtonClick(Sender: TObject);
var
  transactionAux : TTransaction;
begin
  CardsListBox.Clear;
   if monthComboBox.ItemIndex = -1 then
   begin
    ShowMessage('Seleccione un mes.');
    exit;
   end
   else if YearTF.Text = '' then
   begin
    ShowMessage('Escriba un año.');
    exit;
   end
   else
   begin
     try
      transactions:= _card.GetCardTransactionsByDate(_card.CardId,YearTF.Text, monthComboBox.ItemIndex + 1);
      CardsListBox.Items.BeginUpdate;
      for transactionAux in transactions do
      begin
        CardsListBox.Items.Add(DateTimeToStr(transactionAux.CreatedAt));
        CardsListBox.Items.Add(transactionAux.Concept);
        if transactionAux.TypeT = TRANSACTION_TYPE.TRANSFER_OF_FUNDS then
          CardsListBox.Items.Add('Transferencia de fondos')
        else if transactionAux.TypeT = TRANSACTION_TYPE.DEPOSIT then
          CardsListBox.Items.Add('Deposito')
        else if transactionAux.TypeT = TRANSACTION_TYPE.WITHDRAWAL  then
          CardsListBox.Items.Add('Retiro de fondos')
        else if transactionAux.TypeT = TRANSACTION_TYPE.PAYMENT   then
          CardsListBox.Items.Add('Pago')
        else if transactionAux.TypeT = TRANSACTION_TYPE.MONTHLY_PAYMENT   then
          CardsListBox.Items.Add('Pago mensual');
        CardsListBox.Items.Add(transactionAux.Reference);
        CardsListBox.Items.Add(transactionAux.Amount.ToString);
      end;
      CardsListBox .Items.EndUpdate;
    except
      on ex: Exception do begin
        ShowMessage(ex.ToString);
      end;
    end;
   end;

end;

end.
