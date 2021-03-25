unit untPrincipal;

interface

uses
  untGridProdutor,
  untGridGraos,
  untGridArmazenagem,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Menus;

type
  TfrmPrincipal = class(TForm)
    mmPrincipal: TMainMenu;
    mniManutencaoProduto: TMenuItem;
    mniManutencaoGrãos: TMenuItem;
    mniContratoArmazenagem: TMenuItem;
    mniArquivo: TMenuItem;
    mniSair: TMenuItem;
    mniManutencoes: TMenuItem;
    procedure mniSairClick(Sender: TObject);
    procedure mniManutencaoProdutoClick(Sender: TObject);
    procedure mniManutencaoGrãosClick(Sender: TObject);
    procedure mniContratoArmazenagemClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}

procedure TfrmPrincipal.mniContratoArmazenagemClick(Sender: TObject);
begin

  if frmGrigArmazenagem = nil then
    Application.CreateForm(TfrmGrigArmazenagem, frmGrigArmazenagem);

  try
    frmGrigArmazenagem.ShowModal;
  finally
    FreeAndNil(frmGrigArmazenagem);
  end;

end;

procedure TfrmPrincipal.mniManutencaoGrãosClick(Sender: TObject);
begin

  if frmGridGraos = nil then
    Application.CreateForm(TfrmGridGraos, frmGridGraos);

  try
    frmGridGraos.ShowModal;
  finally
    FreeAndNil(frmGridGraos);
  end;

end;

procedure TfrmPrincipal.mniManutencaoProdutoClick(Sender: TObject);
begin

  if frmGridProdutor = nil then
    Application.CreateForm(TfrmGridProdutor, frmGridProdutor);

  try
    frmGridProdutor.ShowModal;
  finally
    FreeAndNil(frmGridProdutor);
  end;

end;

procedure TfrmPrincipal.mniSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

end.
