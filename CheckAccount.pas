unit CheckAccount;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.Layouts, FMX.ListBox, Account, Cards, CheckAccountStatement;

type
  TCheckAccountForm = class(TForm)
    Rectangle1: TRectangle;
    Label1: TLabel;
    Panel1: TPanel;
    Label2: TLabel;
    CheckAccountStatementButton: TButton;
    CardsListBox: TListBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel2: TPanel;
    procedure FormShow(Sender: TObject);
    procedure CheckAccountStatementButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    cards: TCardArray;
  end;

var
  CheckAccountForm: TCheckAccountForm;

implementation

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiTb.fmx ANDROID}

procedure TCheckAccountForm.FormShow(Sender: TObject);
var
  card: TCard;
begin
  cards := TAccount.GetCards(TAccount.Current.Id.ToString);
  for card in cards do
  begin
    if card is TCreditCard then
    begin
      CardsListBox.Items.Add('Cr�dito');
      CardsListBox.Items.Add(card.CardNumber);
      CardsListBox.Items.Add((card as TCreditCard).Credit.ToString);
    end
    else
    begin
      CardsListBox.Items.Add('D�bito');
      CardsListBox.Items.Add(card.CardNumber);
      CardsListBox.Items.Add((card as TDebitCard).Balance.ToString);
    end;
    end;
  end;

procedure TCheckAccountForm.CheckAccountStatementButtonClick(Sender: TObject);
var
  CheckAccountStatementForm: TCheckAccountStatementForm;
  cardIndex: integer;
  index: integer;
begin
   if CardsListBox.ItemIndex = -1 then
   begin
    ShowMessage('Seleccione una tarjeta de la tabla.');
    exit;
   end
   else
   begin
    index := CardsListBox.ItemIndex + 1;
    cardIndex := index MOD 3;
    if cardIndex <> 0 then
      cardIndex := Trunc(index / 3) + 1
    else
      cardIndex := integer(Round(index / 3));
    CheckAccountStatementForm := TCheckAccountStatementForm.Create(
      Application, cards[cardIndex - 1]
    );
    CheckAccountStatementForm.ShowModal;
    CheckAccountStatementForm.Release;
   end;
end;

end.
