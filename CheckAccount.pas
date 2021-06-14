unit CheckAccount;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

type
  TCheckAccountForm = class(TForm)
    Rectangle1: TRectangle;
    Label1: TLabel;
    Panel1: TPanel;
    Label2: TLabel;
    CheckAccountStatementButton: TButton;
    ListView1: TListView;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CheckAccountForm: TCheckAccountForm;

implementation

{$R *.fmx}



end.
