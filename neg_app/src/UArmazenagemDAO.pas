unit UArmazenagemDAO;

interface
uses
  SysUtils, Classes, Data.FMTBcd, Data.DB,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  UArmazenagem
  ,UUtilities;

type
  TArmazenagemDAO = class(TComponent)

  private

    class function load(queryDAO: TFDQuery): TArmazenagem;

  public

    // Manipulação de dados
    class function insert(Armazenagem: TArmazenagem): TArmazenagem;
    class function update(Armazenagem: TArmazenagem): TArmazenagem;
    class function delete(Armazenagem: TArmazenagem): TArmazenagem;
    class function getById(Armazenagem: TArmazenagem): TArmazenagem;

  end;

implementation
uses
  untDMPrincipal;

class function TArmazenagemDAO.load(queryDAO: TFDQuery): TArmazenagem;
var
  Armazenagem: TArmazenagem;
begin

  Armazenagem := TArmazenagem.create;

  Armazenagem.setID                    (queryDAO.FieldByName('ID').AsInteger);
  Armazenagem.setPRODUTOR_ID           (queryDAO.FieldByName('PRODUTOR_ID').AsInteger);
  Armazenagem.setGRAO_ID               (queryDAO.FieldByName('GRAO_ID').AsInteger);
  Armazenagem.setPESO_INICIAL_BRUTO    (queryDAO.FieldByName('PESO_INICIAL_BRUTO').AsCurrency);
  Armazenagem.setPERCENTUAL_HUMIDADE   (queryDAO.FieldByName('PERCENTUAL_HUMIDADE').AsCurrency);
  Armazenagem.setPESO_FINAL            (queryDAO.FieldByName('PESO_FINAL').AsCurrency);
  Armazenagem.setPESO_FINAL_ARMAZENADO (queryDAO.FieldByName('PESO_FINAL_ARMAZENADO').AsCurrency);
  Armazenagem.setVALOR_TOTAL           (queryDAO.FieldByName('VALOR_TOTAL').AsCurrency);
  Armazenagem.setVALIDADO              (queryDAO.FieldByName('VALIDADO').AsInteger);


  Result := Armazenagem;

end;

class function TArmazenagemDAO.getById(Armazenagem: TArmazenagem): TArmazenagem;
var
  queryDAO: TFDQuery;
begin
  queryDAO := TFDQuery.create(nil);
  try
    try
      queryDAO.Close;
      queryDAO.Connection := DMPrincipal.con;
      queryDAO.SQL.Clear;
      queryDAO.SQL.Add(' SELECT * ');
      queryDAO.SQL.Add('   FROM ARMAZENAGEM');
      queryDAO.SQL.Add('  WHERE ID = ' + IntToStr(Armazenagem.getID));
      queryDAO.Open;

      FreeAndNil(Armazenagem);

      if not queryDAO.IsEmpty then
      begin
        queryDAO.First;

        Armazenagem := load(queryDAO);
        Result      := Armazenagem;

      end else
        Result := nil;

    except
      Result := nil;
    end;

  finally
    FreeAndNil(queryDAO);
  end;
end;

class function TArmazenagemDAO.delete(Armazenagem: TArmazenagem): TArmazenagem;
var
  queryDAO: TFDQuery;
begin

  queryDAO := TFDQuery.create(nil);
  try
    try

      queryDAO.Close;
      queryDAO.Connection := DMPrincipal.con;
      queryDAO.SQL.Clear;
      queryDAO.SQL.Add(' DELETE ');
      queryDAO.SQL.Add('   FROM ARMAZENAGEM ');
      queryDAO.SQL.Add('  WHERE ID = ' + IntToStr(Armazenagem.getID));

      queryDAO.ExecSQL;

      Result := Armazenagem;

    except
      Result := nil;
    end;

  finally
    FreeAndNil(queryDAO);
  end;

end;

class function TArmazenagemDAO.update(Armazenagem: TArmazenagem): TArmazenagem;
var
  queryDAO: TFDQuery;
begin
  queryDAO := TFDQuery.create(nil);
  try
    try

      queryDAO.Close;
      queryDAO.Connection := DMPrincipal.con;
      queryDAO.SQL.Clear;
      queryDAO.SQL.Add(' UPDATE ARMAZENAGEM ');
      queryDAO.SQL.Add('    SET ');
      queryDAO.SQL.Add('        PRODUTOR_ID            = ' + IntegerSQL(Armazenagem.getPRODUTOR_ID));
      queryDAO.SQL.Add('        ,GRAO_ID               = ' + IntegerSQL(Armazenagem.getGRAO_ID));
      queryDAO.SQL.Add('        ,PESO_INICIAL_BRUTO    = ' + CurrencySQL(Armazenagem.getPESO_INICIAL_BRUTO));
      queryDAO.SQL.Add('        ,PERCENTUAL_HUMIDADE   = ' + CurrencySQL(Armazenagem.getPERCENTUAL_HUMIDADE));
      queryDAO.SQL.Add('        ,PESO_FINAL            = ' + CurrencySQL(Armazenagem.getPESO_FINAL));
      queryDAO.SQL.Add('        ,PESO_FINAL_ARMAZENADO = ' + CurrencySQL(Armazenagem.getPESO_FINAL_ARMAZENADO));
      queryDAO.SQL.Add('        ,VALOR_TOTAL           = ' + CurrencySQL(Armazenagem.getVALOR_TOTAL));
      queryDAO.SQL.Add('        ,VALIDADO              = ' + IntegerSQL(Armazenagem.getVALIDADO));

      queryDAO.SQL.Add('  WHERE ID               = ' + IntToStr(Armazenagem.getID));

      // Clipboard.SetTextBuf(pchar(queryDAO.SQL.text));

      queryDAO.ExecSQL;

      Result := Armazenagem;

    except
      Result := nil;
    end;

  finally
    FreeAndNil(queryDAO);
  end;
end;

class function TArmazenagemDAO.insert(Armazenagem: TArmazenagem): TArmazenagem;
var
  queryDAO: TFDQuery;
begin

  queryDAO := TFDQuery.create(nil);
  try

    try
      // Insere na Tabela Armazenagem
      queryDAO.Close;
      queryDAO.Connection := DMPrincipal.con;
      queryDAO.SQL.Clear;
      queryDAO.SQL.Add(' INSERT ');
      queryDAO.SQL.Add('   INTO ARMAZENAGEM ( ');
      queryDAO.SQL.Add('        PRODUTOR_ID ');
      queryDAO.SQL.Add('        ,GRAO_ID ');
      queryDAO.SQL.Add('        ,PESO_INICIAL_BRUTO ');
      queryDAO.SQL.Add('        ,PERCENTUAL_HUMIDADE ');
      queryDAO.SQL.Add('        ,PESO_FINAL ');
      queryDAO.SQL.Add('        ,PESO_FINAL_ARMAZENADO ');
      queryDAO.SQL.Add('        ,VALOR_TOTAL ');
      queryDAO.SQL.Add('        ,VALIDADO ');
      queryDAO.SQL.Add(' ) VALUES (');
      queryDAO.SQL.Add('        ' + IntegerSQL(Armazenagem.getPRODUTOR_ID) );
      queryDAO.SQL.Add('        ,' + IntegerSQL(Armazenagem.getGRAO_ID) );
      queryDAO.SQL.Add('        ,' + CurrencySQL(Armazenagem.getPESO_INICIAL_BRUTO) );
      queryDAO.SQL.Add('        ,' + CurrencySQL(Armazenagem.getPERCENTUAL_HUMIDADE) );
      queryDAO.SQL.Add('        ,' + CurrencySQL(Armazenagem.getPESO_FINAL) );
      queryDAO.SQL.Add('        ,' + CurrencySQL(Armazenagem.getPESO_FINAL_ARMAZENADO) );
      queryDAO.SQL.Add('        ,' + CurrencySQL(Armazenagem.getVALOR_TOTAL) );
      queryDAO.SQL.Add('        ,' + IntegerSQL(Armazenagem.getVALIDADO) );
      queryDAO.SQL.Add(' ) ');

      // Clipboard.SetTextBuf(pchar(queryDAO.SQL.text));

      queryDAO.ExecSQL;

      Result := Armazenagem;

    except
      Result := nil;
    end;

  finally
    FreeAndNil(queryDAO);
  end;

end;

end.
