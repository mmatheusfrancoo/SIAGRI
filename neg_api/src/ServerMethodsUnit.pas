unit ServerMethodsUnit;

interface

uses
  untDMConexao,
  // Vcl.Clipbrd,
  Soap.EncdDecd,
  System.DateUtils,
  Winapi.Windows,

  UJson,
  //Data.DB.Helper,
  System.SysUtils,
  System.Json,
  Data.DBXPlatform,
  System.Classes,

  DataSnap.DSProviderDataModuleAdapter,
  Datasnap.DSServer, Datasnap.DSAuth, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Comp.UI, FireDAC.Phys.ODBCBase, FireDAC.Phys.MSSQL,
  Datasnap.DBClient,  Data.Win.ADODB,
  REST.Response.Adapter, Data.Bind.Components, Data.Bind.ObjectScope,
  REST.Client;

type
  TSM = class(TDSServerModule)
    procedure DSServerModuleCreate(Sender: TObject);
    procedure DSServerModuleDestroy(Sender: TObject);
  private

  public
    function get_contratos: string;
    function post_contratos(id,valida:Integer): string;

  end;

implementation

{$R *.dfm}

{ TSM }

function TSM.get_contratos: string;
var
  QryADO : TFDQuery;
begin

  QryADO := TFDQuery.Create(nil);

  try

    QryADO.Close;
    QryADO.Connection := DM.con;
    QryADO.SQL.Clear;
    QryADO.SQL.Add('SELECT');
    QryADO.SQL.Add('  A.ID');
    QryADO.SQL.Add('  ,A.PESO_INICIAL_BRUTO');
    QryADO.SQL.Add('  ,A.PERCENTUAL_HUMIDADE');
    QryADO.SQL.Add('  ,A.PESO_FINAL');
    QryADO.SQL.Add('  ,A.PESO_FINAL_ARMAZENADO');
    QryADO.SQL.Add('  ,A.VALOR_TOTAL');
    QryADO.SQL.Add('  ,A.VALIDADO');
    QryADO.SQL.Add('  ,G.DESCRICAO');
    QryADO.SQL.Add('  ,P.CPFCNPJ');
    QryADO.SQL.Add('  ,P.NOME');
    QryADO.SQL.Add('      FROM ARMAZENAGEM AS A');
    QryADO.SQL.Add('INNER JOIN GRAO        AS G ON A.GRAO_ID = G.ID');
    QryADO.SQL.Add('INNER JOIN PRODUTOR    AS P ON A.PRODUTOR_ID = P.ID');

    QryADO.Open();

    if not QryADO.IsEmpty then
      Result := QryADO.ToJson();

  finally
    FreeAndNil(QryADO);
  end;

end;

function TSM.post_contratos(id, valida: Integer): string;
var
  QryADO  : TFDQuery;
  JObject : TJSONObject;
  JArray  : TJSONArray;
begin

  JArray := TJSONArray.Create;

  try

    QryADO := TFDQuery.Create(nil);

    try

      QryADO.Close;
      QryADO.Connection := DM.con;
      QryADO.SQL.Clear;
      QryADO.SQL.Add('UPDATE ARMAZENAGEM SET VALIDADO = ' + IntToStr(valida));
      QryADO.SQL.Add('WHERE ID = ' + IntToStr(id));

      QryADO.ExecSQL;

    finally
      FreeAndNil(QryADO);
    end;

    JObject := TJSONObject.Create;
    JObject.AddPair('result'  , TJSONString.Create(UTF8Encode('True')));
    JObject.AddPair('message' , TJSONString.Create(UTF8Encode('')));
    JArray.AddElement(JObject);

  except
    on E : Exception do
    begin

      JObject := TJSONObject.Create;
      JObject.AddPair('result'  , TJSONString.Create(UTF8Encode('False')));
      JObject.AddPair('message' , TJSONString.Create(UTF8Encode(E.ClassName + ' error raised, with message : ' + E.Message)));
      JArray.AddElement(JObject);

    end;
  end;

  GetInvocationMetadata().ResponseCode    := 200;
  GetInvocationMetadata().ResponseContent := JArray.ToString;

  Result := JArray.ToString;

end;

procedure TSM.DSServerModuleCreate(Sender: TObject);
begin

  if DM= nil then
    DM := TDM.Create(nil);

end;

procedure TSM.DSServerModuleDestroy(Sender: TObject);
begin
  FreeAndNil(DM);
end;

end.

