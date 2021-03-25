unit untPropriedadesArmazenagem;

interface

uses
  UArmazenagem,
  untDMPrincipal,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  untBasePropriedades, FMX.Objects, FMX.Edit, FMX.TabControl,
  FMX.ListView.Types, FMX.ListView, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, System.Actions,
  FMX.ActnList;

type
  TfrmPropriedadesArmazenagem = class(TfrmBasePropriedades)
    grpProdutor: TGroupBox;
    grpGrao: TGroupBox;
    lbl_PesoInicialBruto: TLabel;
    lbl_PercentualHumidade: TLabel;
    lbl_PesoFinal: TLabel;
    lbl_PesoFinalArmazenado: TLabel;
    lbl_ValorTotal: TLabel;
    tbcArmazengem: TTabControl;
    tbi_dados: TTabItem;
    tbi_Produtor: TTabItem;
    tbi_grao: TTabItem;
    lv_Produtor: TListView;
    fqry_Produtor: TFDQuery;
    fqry_Grao: TFDQuery;
    fqry_GraoID: TIntegerField;
    fqry_GraoDESCRICAO: TStringField;
    fqry_GraoVALOR: TBCDField;
    fqry_ProdutorID: TIntegerField;
    fqry_ProdutorNOME: TStringField;
    fqry_ProdutorCPFCNPJ: TStringField;
    lv_Grao: TListView;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    BindSourceDB2: TBindSourceDB;
    LinkListControlToField2: TLinkListControlToField;
    img_Grao: TImage;
    img_Produtor: TImage;
    lbl_Grao: TLabel;
    lbl_Produtor: TLabel;
    LinkPropertyToFieldText: TLinkPropertyToField;
    LinkPropertyToFieldText2: TLinkPropertyToField;
    actlst: TActionList;
    act_grao: TChangeTabAction;
    act_produtor: TChangeTabAction;
    act_dados: TChangeTabAction;
    edt_PesoInicialBruto: TEdit;
    edt_PesoFinalArmazenado: TEdit;
    edt_PercentualHumidade: TEdit;
    edt_PesoFinal: TEdit;
    edt_ValorTotal: TEdit;
    procedure grpGraoClick(Sender: TObject);
    procedure grpProdutorClick(Sender: TObject);
    procedure lv_GraoItemClick(const Sender: TObject; const AItem: TListViewItem);
    procedure lv_ProdutorItemClick(const Sender: TObject; const AItem: TListViewItem);
    procedure edt_PesoInicialBrutoChange(Sender: TObject);
    procedure edt_PercentualHumidadeKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edt_PesoFinalKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edt_PesoInicialBrutoKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edt_PercentualHumidadeChange(Sender: TObject);
    procedure edt_PesoFinalChange(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPropriedadesArmazenagem: TfrmPropriedadesArmazenagem;

implementation

{$R *.fmx}

procedure TfrmPropriedadesArmazenagem.btnSalvarClick(Sender: TObject);
var
  oArmazenagem : TArmazenagem;
begin
  inherited;

  oArmazenagem := TArmazenagem.Create;

  try

    if id <> 0 then
    begin
      oArmazenagem.setID(id);
      oArmazenagem := oArmazenagem.getById;

      if oArmazenagem = nil then
      begin
        oArmazenagem := TArmazenagem.Create;

        oArmazenagem.setPRODUTOR_ID(fqry_ProdutorID.AsInteger);
        oArmazenagem.setGRAO_ID(fqry_GraoID.AsInteger);
        oArmazenagem.setPESO_INICIAL_BRUTO(StrToCurr(edt_PesoInicialBruto.Text));
        oArmazenagem.setPERCENTUAL_HUMIDADE(StrToCurr(edt_PercentualHumidade.Text));
        oArmazenagem.setPESO_FINAL(StrToCurr(edt_PesoFinal.Text));
        oArmazenagem.setPESO_FINAL_ARMAZENADO(StrToCurr(edt_PesoFinalArmazenado.Text));
        oArmazenagem.setVALOR_TOTAL(StrToCurr(edt_ValorTotal.Text));
        oArmazenagem.setVALIDADO(0);

        oArmazenagem := oArmazenagem.insert;
      end else
      begin

        oArmazenagem.setPRODUTOR_ID(fqry_ProdutorID.AsInteger);
        oArmazenagem.setGRAO_ID(fqry_GraoID.AsInteger);
        oArmazenagem.setPESO_INICIAL_BRUTO(StrToCurr(edt_PesoInicialBruto.Text));
        oArmazenagem.setPERCENTUAL_HUMIDADE(StrToCurr(edt_PercentualHumidade.Text));
        oArmazenagem.setPESO_FINAL(StrToCurr(edt_PesoFinal.Text));
        oArmazenagem.setPESO_FINAL_ARMAZENADO(StrToCurr(edt_PesoFinalArmazenado.Text));
        oArmazenagem.setVALOR_TOTAL(StrToCurr(edt_ValorTotal.Text));
        oArmazenagem.setVALIDADO(0);

        oArmazenagem := oArmazenagem.update;

      end;

    end else
    begin

      oArmazenagem.setPRODUTOR_ID(fqry_ProdutorID.AsInteger);
      oArmazenagem.setGRAO_ID(fqry_GraoID.AsInteger);
      oArmazenagem.setPESO_INICIAL_BRUTO(StrToCurr(edt_PesoInicialBruto.Text));
      oArmazenagem.setPERCENTUAL_HUMIDADE(StrToCurr(edt_PercentualHumidade.Text));
      oArmazenagem.setPESO_FINAL(StrToCurr(edt_PesoFinal.Text));
      oArmazenagem.setPESO_FINAL_ARMAZENADO(StrToCurr(edt_PesoFinalArmazenado.Text));
      oArmazenagem.setVALOR_TOTAL(StrToCurr(edt_ValorTotal.Text));
      oArmazenagem.setVALIDADO(0);

      oArmazenagem := oArmazenagem.insert;

    end;


    if oArmazenagem = nil then
    begin
      ShowMessage('Não foi possivel gravar o dado! Erro inesperado');
      Abort;
    end else
      ShowMessage('Dado gravado com êxito!');

  finally
    FreeAndNil(oArmazenagem);
  end;

  Close;

end;

procedure TfrmPropriedadesArmazenagem.edt_PercentualHumidadeChange(Sender: TObject);
begin
  inherited;
  edt_PesoFinalArmazenado.Text := CurrToStr( (StrToFloat(edt_PesoInicialBruto.Text) - StrToFloat(edt_PesoFinal.Text)) * (1 - (StrToFloat(edt_PercentualHumidade.Text) / 100)) );
  edt_ValorTotal.Text          := CurrToStr( StrToFloat(edt_PesoFinalArmazenado.Text) * fqry_GraoVALOR.AsCurrency );
end;

procedure TfrmPropriedadesArmazenagem.edt_PercentualHumidadeKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;

  if not fqry_Grao.Active then
  begin
    ShowMessage('Por favor informar um grão!');
    abort;
  end;

  if not (KeyChar in ['0'..'9',',']) then
    KeyChar :=#0;
end;

procedure TfrmPropriedadesArmazenagem.edt_PesoFinalChange(Sender: TObject);
begin
  inherited;
  edt_PesoFinalArmazenado.Text := CurrToStr( (StrToFloat(edt_PesoInicialBruto.Text) - StrToFloat(edt_PesoFinal.Text)) * (1 - (StrToFloat(edt_PercentualHumidade.Text) / 100)) );
  edt_ValorTotal.Text          := CurrToStr( StrToFloat(edt_PesoFinalArmazenado.Text) * fqry_GraoVALOR.AsCurrency );
end;

procedure TfrmPropriedadesArmazenagem.edt_PesoFinalKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;

  if not fqry_Grao.Active then
  begin
    ShowMessage('Por favor informar um grão!');
    abort;
  end;

  if not (KeyChar in ['0'..'9',',']) then
    KeyChar :=#0;
end;

procedure TfrmPropriedadesArmazenagem.edt_PesoInicialBrutoChange(Sender: TObject);
begin
  inherited;
  edt_PesoFinalArmazenado.Text := CurrToStr( (StrToFloat(edt_PesoInicialBruto.Text) - StrToFloat(edt_PesoFinal.Text)) * (1 - (StrToFloat(edt_PercentualHumidade.Text) / 100)) );
  edt_ValorTotal.Text          := CurrToStr( StrToFloat(edt_PesoFinalArmazenado.Text) * fqry_GraoVALOR.AsCurrency );
end;

procedure TfrmPropriedadesArmazenagem.edt_PesoInicialBrutoKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;

  if not fqry_Grao.Active then
  begin
    ShowMessage('Por favor informar um grão!');
    abort;
  end;

  if not (KeyChar in ['0'..'9',',']) then
    KeyChar :=#0;
end;

procedure TfrmPropriedadesArmazenagem.FormShow(Sender: TObject);
var
  oArmazenagem : TArmazenagem;
begin
  inherited;

  if id <> 0 then
  begin

    ActivityDialogThread := TThread.CreateAnonymousThread(procedure
    begin

      oArmazenagem := TArmazenagem.Create;

      try

        oArmazenagem.setID(id);

        oArmazenagem := oArmazenagem.getById;

        if oArmazenagem <> nil then
        begin

          TThread.Synchronize(nil, procedure
          begin
            fqry_Grao.Close;
            fqry_Grao.Open();
          end);

          TThread.Synchronize(nil, procedure
          begin
            fqry_Produtor.Close;
            fqry_Produtor.Open();
          end);

          Sleep(100);

          TThread.Synchronize(nil, procedure
          begin

            fqry_Grao.First;

            while not fqry_Grao.Eof do
            begin

              if fqry_GraoID.AsInteger = oArmazenagem.getGRAO_ID then
              begin
                Exit;
              end;

              fqry_Grao.Next;
            end;

          end);

          Sleep(100);

          TThread.Synchronize(nil, procedure
          begin

            fqry_Produtor.First;

            while not fqry_Produtor.Eof do
            begin

              if fqry_ProdutorID.AsInteger = oArmazenagem.getPRODUTOR_ID then
              begin
                Exit;
              end;

              fqry_Produtor.Next;
            end;

          end);

          Sleep(100);

          TThread.Synchronize(nil, procedure
          begin

            edt_PesoInicialBruto.Text    := CurrToStr(oArmazenagem.getPESO_INICIAL_BRUTO);
            edt_PercentualHumidade.Text  := CurrToStr(oArmazenagem.getPERCENTUAL_HUMIDADE);
            edt_PesoFinal.Text           := CurrToStr(oArmazenagem.getPESO_FINAL);
            edt_PesoFinalArmazenado.Text := CurrToStr(oArmazenagem.getPESO_FINAL_ARMAZENADO);
            edt_ValorTotal.Text          := CurrToStr(oArmazenagem.getVALOR_TOTAL);

          end);

        end;

      finally
        FreeAndNil(oArmazenagem);
      end;

    end);

    ActivityDialogThread.FreeOnTerminate := False;
    ActivityDialogThread.Start;

  end;

end;

procedure TfrmPropriedadesArmazenagem.grpGraoClick(Sender: TObject);
begin
  inherited;

  ActivityDialogThread := TThread.CreateAnonymousThread(procedure
  begin

    TThread.Synchronize(nil, procedure
    begin
      fqry_Grao.Close;
      fqry_Grao.Open();
    end);

    Sleep(100);

    TThread.Synchronize(nil, procedure
    begin
      act_grao.ExecuteTarget(Self);
    end);

  end);

  ActivityDialogThread.FreeOnTerminate := False;
  ActivityDialogThread.Start;

end;

procedure TfrmPropriedadesArmazenagem.grpProdutorClick(Sender: TObject);
begin
  inherited;

  ActivityDialogThread := TThread.CreateAnonymousThread(procedure
  begin

    TThread.Synchronize(nil, procedure
    begin
      fqry_Produtor.Close;
      fqry_Produtor.Open();
    end);

    Sleep(100);

    TThread.Synchronize(nil, procedure
    begin
      act_produtor.ExecuteTarget(Self);
    end);

  end);

  ActivityDialogThread.FreeOnTerminate := False;
  ActivityDialogThread.Start;

end;

procedure TfrmPropriedadesArmazenagem.lv_GraoItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  inherited;
  act_dados.ExecuteTarget(Self);
end;

procedure TfrmPropriedadesArmazenagem.lv_ProdutorItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  inherited;
  act_dados.ExecuteTarget(Self);
end;

end.
