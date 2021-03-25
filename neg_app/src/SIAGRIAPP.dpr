program SIAGRIAPP;

uses
  FMX.Forms,
  untPrincipal in 'untPrincipal.pas' {frmPrincipal},
  untBasePropriedades in 'untBasePropriedades.pas' {frmBasePropriedades},
  untBaseGrid in 'untBaseGrid.pas' {frmBaseGrid},
  untDMPrincipal in 'untDMPrincipal.pas' {DMPrincipal: TDataModule},
  untGridProdutor in 'untGridProdutor.pas' {frmGridProdutor},
  untGridGraos in 'untGridGraos.pas' {frmGridGraos},
  untGridArmazenagem in 'untGridArmazenagem.pas' {frmGrigArmazenagem},
  untPropriedadesArmazenagem in 'untPropriedadesArmazenagem.pas' {frmPropriedadesArmazenagem},
  UArmazenagem in 'UArmazenagem.pas',
  UArmazenagemDAO in 'UArmazenagemDAO.pas',
  UUtilities in 'UUtilities.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDMPrincipal, DMPrincipal);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmPropriedadesArmazenagem, frmPropriedadesArmazenagem);
  Application.Run;
end.
