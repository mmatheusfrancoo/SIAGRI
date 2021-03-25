unit untBaseGrid;

interface

uses
  untDMPrincipal,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.StdCtrls, FMX.Edit, FMX.Layouts, FMX.Grid, FMX.Objects, FMX.Ani,
  FMX.Effects, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Datasnap.DBClient;

type
  TfrmBaseGrid = class(TForm)
    lyt: TLayout;
    clrt_fornecedor: TCalloutRectangle;
    tse_fornecedor: TShadowEffect;
    fa_fornecedor: TFloatAnimation;
    lt_btn_cadastro: TLayout;
    btn_cadastro_ok: TSpeedButton;
    img_cadastro_ok: TImage;
    btn_cadastro_close: TSpeedButton;
    img_cadastro_close: TImage;
    Layout1: TLayout;
    Layout3: TLayout;
    SpeedButton1: TSpeedButton;
    Image1: TImage;
    Grid1: TGrid;
    Layout2: TLayout;
    edt_cnpj: TEdit;
    edt_email: TEdit;
    edt_razao_social: TEdit;
    lbl_cnpj: TLabel;
    lbl_email: TLabel;
    lbl_razao_social: TLabel;
    edt_contato: TEdit;
    lbl_contato: TLabel;
    grd_fornecedor: TGrid;
    lt_add: TLayout;
    btn_add: TSpeedButton;
    img_add: TImage;
    btn_excluir: TSpeedButton;
    img_excluir: TImage;
    btn_editar: TSpeedButton;
    img_editar: TImage;
    fqry_reg: TFDQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBaseGrid: TfrmBaseGrid;

implementation

{$R *.fmx}

end.
