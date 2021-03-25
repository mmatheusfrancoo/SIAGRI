unit untGridGraos;

interface

uses
  untDMPrincipal,
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
  TfrmGridGraos = class(TfrmBaseGrid)
    fqry_regID: TIntegerField;
    fqry_regDESCRICAO: TStringField;
    fqry_regVALOR: TBCDField;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    procedure FormShow(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_addClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGridGraos: TfrmGridGraos;

implementation

{$R *.fmx}

procedure TfrmGridGraos.btn_addClick(Sender: TObject);
begin
  inherited;
  fqry_reg.Append;
end;

procedure TfrmGridGraos.btn_excluirClick(Sender: TObject);
begin
  inherited;
  fqry_reg.Delete;
end;

procedure TfrmGridGraos.FormShow(Sender: TObject);
begin
  inherited;
  fqry_reg.Open();
end;

end.
