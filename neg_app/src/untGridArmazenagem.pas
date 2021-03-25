unit untGridArmazenagem;

interface

uses
  untDMPrincipal,
  untPropriedadesArmazenagem,
  UArmazenagem,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  untBaseGrid, System.Rtti, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Edit, FMX.Layouts, FMX.Grid,
  FMX.Objects, FMX.Ani, FMX.Effects, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope;

type
  TfrmGrigArmazenagem = class(TfrmBaseGrid)
    fqry_regID: TIntegerField;
    fqry_regPESO_INICIAL_BRUTO: TFMTBCDField;
    fqry_regPERCENTUAL_HUMIDADE: TFMTBCDField;
    fqry_regPESO_FINAL: TFMTBCDField;
    fqry_regPESO_FINAL_ARMAZENADO: TFMTBCDField;
    fqry_regVALOR_TOTAL: TBCDField;
    fqry_regVALIDADO: TSmallintField;
    fqry_regDESCRICAO: TStringField;
    fqry_regCPFCNPJ: TStringField;
    fqry_regNOME: TStringField;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    procedure btn_editarClick(Sender: TObject);
    procedure btn_addClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure grd_fornecedorDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGrigArmazenagem: TfrmGrigArmazenagem;

implementation

{$R *.fmx}

procedure TfrmGrigArmazenagem.btn_addClick(Sender: TObject);
begin
  inherited;

  if frmPropriedadesArmazenagem = nil then
    Application.CreateForm(TfrmPropriedadesArmazenagem, frmPropriedadesArmazenagem);

  try
    frmPropriedadesArmazenagem.id := 0;
    frmPropriedadesArmazenagem.ShowModal;
    fqry_reg.Refresh;
  finally
    FreeAndNil(frmPropriedadesArmazenagem);
  end;

end;

procedure TfrmGrigArmazenagem.btn_editarClick(Sender: TObject);
begin
  inherited;

  if frmPropriedadesArmazenagem = nil then
    Application.CreateForm(TfrmPropriedadesArmazenagem, frmPropriedadesArmazenagem);

  try
    frmPropriedadesArmazenagem.id := fqry_regID.AsInteger;
    frmPropriedadesArmazenagem.ShowModal;
    fqry_reg.Refresh;
  finally
    FreeAndNil(frmPropriedadesArmazenagem);
  end;

end;

procedure TfrmGrigArmazenagem.btn_excluirClick(Sender: TObject);
var
  Armazenagem : TArmazenagem; 
begin
  inherited;

  Armazenagem := TArmazenagem.create;
    
  try
    Armazenagem.setID(fqry_regID.AsInteger);
    Armazenagem := Armazenagem.delete;

    if Armazenagem <> nil then
    begin
      ShowMessage('Dado excluido com êxito!');
      fqry_reg.Refresh;
    end;
   
  finally
    FreeAndNil(Armazenagem);
  end;   

end;

procedure TfrmGrigArmazenagem.FormShow(Sender: TObject);
begin
  inherited;
  fqry_reg.Open();
end;

procedure TfrmGrigArmazenagem.grd_fornecedorDblClick(Sender: TObject);
begin
  inherited;
  btn_editarClick(Self);
end;

end.
