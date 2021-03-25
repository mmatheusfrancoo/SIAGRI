unit untBasePropriedades;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls;

type
  TfrmBasePropriedades = class(TForm)
    rcgBottom: TRectangle;
    btnSair: TSpeedButton;
    imgSair: TImage;
    btnSalvar: TSpeedButton;
    imgSalvar: TImage;
    btnInformacoes: TSpeedButton;
    imgInformacoes: TImage;
    procedure btnSairClick(Sender: TObject);
  private
    FActivityDialogThread : TThread;
    Fid                   : Integer;
  public
    property ActivityDialogThread : TThread     read FActivityDialogThread write FActivityDialogThread;
    property id                   : Integer     read Fid                   write Fid default 0;
  end;

var
  frmBasePropriedades: TfrmBasePropriedades;

implementation

{$R *.fmx}

procedure TfrmBasePropriedades.btnSairClick(Sender: TObject);
begin
  Self.Close;
end;

end.
