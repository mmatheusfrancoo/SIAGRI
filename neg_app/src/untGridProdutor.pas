unit untGridProdutor;

interface

uses
  untDMPrincipal,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  untBaseGrid, System.Rtti, FMX.Edit, FMX.Layouts, FMX.Grid, FMX.Objects,
  FMX.Ani, FMX.Effects, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope;

type
  TfrmGridProdutor = class(TfrmBaseGrid)
    fqry_regID: TIntegerField;
    fqry_regNOME: TStringField;
    fqry_regCPFCNPJ: TStringField;
    BindSourceDB: TBindSourceDB;
    BindingsList: TBindingsList;
    LinkGridToDataSourceBindSourceDB: TLinkGridToDataSource;
    procedure FormShow(Sender: TObject);
    procedure btn_addClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGridProdutor: TfrmGridProdutor;

implementation

{$R *.fmx}

procedure TfrmGridProdutor.btn_addClick(Sender: TObject);
begin
  inherited;
  fqry_reg.Append;
end;

procedure TfrmGridProdutor.btn_excluirClick(Sender: TObject);
begin
  inherited;
  fqry_reg.Delete;
end;

procedure TfrmGridProdutor.FormShow(Sender: TObject);
begin
  inherited;
  fqry_reg.Open();
end;

end.
