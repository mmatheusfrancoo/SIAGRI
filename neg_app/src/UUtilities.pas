unit UUtilities;

interface

uses
{$IFDEF Android}
  Androidapi.JNI.App,
  Androidapi.JNI.Dalvik,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Hardware,
  Androidapi.JNI.InputMethodService,
  Androidapi.JNI.Java.Security,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Location,
  Androidapi.JNI.Media,
  Androidapi.JNI.Net,
  Androidapi.JNI.OpenGL,
  Androidapi.JNI.Os,
  Androidapi.JNI.Provider,
  Androidapi.JNI.Telephony,
  Androidapi.JNI.Util,
  Androidapi.JNI.VideoView,
  Androidapi.JNI.Webkit,
  Androidapi.JNI.Widget,
  Androidapi.JNI.Support,
  Androidapi.JNI.Embarcadero,
  Androidapi.JNI.AdMob,
  Androidapi.JNI.Analytics,
  Androidapi.JNI.Licensing,
  Androidapi.JNI.InAppBilling,
  Androidapi.JNI.PlayServices,
  Androidapi.JNI.ApkExpansion,
  Androidapi.JNI.PlayServices.GCM,
  Androidapi.Helpers,
{$ENDIF}

{$IFDEF IOS}
  iOSapi.UIKit,
  Posix.SysSysctl,
  Posix.StdDef,
  iOSapi.Foundation,
  Macapi.Helpers,
  iOSapi.Helpers,
  FMX.Platform.Ios,
  FMX.Helpers.iOS,
  Macapi.ObjcRuntime,
  iOSapi.CocoaTypes,
{$ENDIF}

{$IFDEF MSWINDOWS}
  Winapi.ShellAPI,
  Winapi.Windows,
  Vcl.Controls,
{$ENDIF}

  IdGlobalProtocols,
  Soap.EncdDecd,
  system.IOUtils,
  FMX.Dialogs,
  Data.DBXPlatform,
  IdURI,
  System.SysUtils,
  System.Classes,
  IdHTTP,
  System.JSON,
  FireDAC.Comp.Client,
  System.UITypes;

type
  Device = record
    sManufacture : string;
    sModel       : string;
    sProduct     : string;
    sUniqueID    : string;
    sOS          : string;
    sPlatform    : string;
    sVersion     : string;
  end;

    function RemoverCaracterEspecial(Valor: string; Extra: Boolean = False): string;
    function MiliSegundoshora(milisegundo: LongInt): string;
    Function HoraMilisegundos(Hora: TTime): LongInt;
    Function BooleanSQL(bBoolean: Boolean): String;
    Function BooleanInt(bBoolean: Boolean): Integer;
    Function IntegerSQL(iInteger: Integer): String;
    Function CurrencySQL(rcCurrency: Currency): String;
    Function DateToTimeSQL(dDateTime: TDateTime): String;
    Function DateToSQL(dDate: TDate): String;
    function StrToCurValue(Value:string):Currency;

    function FStrToCurrency(Value : string): Currency;
    function FStrToDateTime(Value : string): TDateTime;
    function FStrToDate(Value : string): TDateTime;
    function FStrToBoolean(Value : string): Boolean;
    function FStrToInteger(Value : string): Integer;

    function IniMes( dDateTime: TDateTime ): TDateTime;
    Function FimMes( dDateTime: TDateTime ): TDateTime;
    function StrLeftPreenche( sString, sPreenchedor : String; iQuantidade : Integer ) : String;
    function StrRight( sString : String; iQuantidade : Integer ) : String;
    function StrRightPreenche( sString, sPreenchedor : String; iQuantidade : Integer ) : String;
    function StrLeft( sString : String; iQuantidade : Integer ) : String;
    function JsonToStr(JSON, Value: String): String;
    function VerifivarInternet: Boolean;
    function DataHoraInicial( dDateTime: TDateTime ): TDateTime;
    function DataHoraFinal( dDateTime: TDateTime ): TDateTime;
    function Trunca02( Valor: Currency): Currency;
    function Resto( x, y: Real ): Real;
    function LPad(S: string; Ch: Char; Len: Integer): string;
    function RPad(S: string; Ch: Char; Len: Integer): string;
    function ZeroLeft(vZero: string; vQtd: integer): string;

    procedure ViewFichero(Ruta_Fichero : String);
    procedure SendFichero(Ruta_Fichero : String);

    function DataFichero(data : TDateTime): string;

    {$IFDEF IOS}
      function GetDeviceModelString: String;
      function GetParentView: UIView;
      function GetSharedApplication: UIApplication;
      function MakeNSRect(ox, oy, sx, sy: Single): NSRect;
    {$ENDIF}

    function getDevice: Device;
    // Retorna um Json
    function Dispositivos(CodEmpresa, CodFilial, CodUsuario: Integer) : String;

implementation

function LPad(S: string; Ch: Char; Len: Integer): string;
var   RestLen: Integer;
begin   Result  := S;
  RestLen := Len - Length(s);
  if RestLen < 1 then Exit;
  Result := S + StringOfChar(Ch, RestLen);
end;

function RPad(S: string; Ch: Char; Len: Integer): string;
var   RestLen: Integer;
begin   Result  := S;
  RestLen := Len - Length(s);
  if RestLen < 1 then Exit;
  Result := StringOfChar(Ch, RestLen) + S;
end;

function ZeroLeft(vZero: string; vQtd: integer): string;
var
  i, vTam: integer;
  vAux   : string;
begin

  vAux  := vZero;
  vTam  := length( vZero );
  vZero := '';

  for i := 1 to vQtd - vTam do
    vZero := '0' + vZero;

  vAux   := vZero + vAux;
  result := vAux;

end;

function Resto( x, y: Real ): Real;
Var
  rDiv1:  Real;
  iInt:   Integer;
  iPos:   Integer;
  sTxt:   String;
begin
  Result := 0;
  rDiv1  := x / y;
  sTxt   := FloatToStr( rDiv1 );
  iPos   := Pos( ',', sTxt );

  If iPos > 0 Then
  begin
    Result := StrToFloat( '0' + Copy( sTxt, iPos, Length( sTxt )) ) * y;
  end;

end;

function Trunca02( Valor: Currency): Currency;
begin
  Result := Trunc(Valor * 100) / 100; //Truca para 2 casas decimais
end;

function DataFichero(data : TDateTime): string;
begin
  Result := DateTimeToStr(data);
  Result := StringReplace(Result, ':', '_', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '/', '_', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, ' ', '_', [rfReplaceAll, rfIgnoreCase]);
end;

procedure ViewFichero(Ruta_Fichero : String);
var
  FileDirectory : string;
  FileName      : string;
  path          : string;
  BSPDF         : TBytesStream;
  SSPDF         : TStringStream;
{$IFDEF ANDROID}
  Intent        : JIntent;
  URI           : Jnet_Uri;
{$ENDIF}
{$IF DEFINED(IOS)}
  FController : UIDocumentInteractionController;
  URL         : NSURL;
  success     : Boolean;
{$ENDIF}
begin

  if Ruta_Fichero <> '' then
  begin

    FileName := 'report_cotacao_' + DataFichero(Now) + '.pdf';

    {$IFDEF ANDROID}
      FileDirectory := '/sdcard/Android/data/canion.com.br.ForcaVendas/files/';
    {$ENDIF}

    {$IF DEFINED(IOS)}
      FileDirectory := TPath.GetDocumentsPath + PathDelim;
    {$ENDIF}

    {$IFDEF MSWINDOWS}
      FileDirectory := ExtractFilePath(ExtractFilePath(ParamStr(0)));
    {$ENDIF}

    path  := FileDirectory + FileName;

    BSPDF := TBytesStream.Create;

    try

      SSPDF := TStringStream.Create(Ruta_Fichero, TEncoding.ASCII);

      try

        SSPDF.Position := 0;
        Soap.EncdDecd.DecodeStream(SSPDF, BSPDF);
        BSPDF.Position   := 0;

      finally
        FreeAndNil(SSPDF);
      end;

      if not(DirectoryExists(FileDirectory))then
        ForceDirectories(FileDirectory);

      BSPDF.SaveToFile(path);

    finally
      FreeAndNil(BSPDF);
    end;

    {$IFDEF ANDROID}

      if FileExists(path) then
      begin

        URI := TJnet_Uri.JavaClass.parse(StringToJString('file:///' + path));

        intent := TJIntent.Create;
        intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
        intent.setDataAndType(URI,StringToJString('application/pdf'));
        SharedActivity.startActivity(TJIntent.JavaClass.createChooser(intent, StrToJCharSequence('Visualizar')));

      end;

    {$ENDIF}

    {$IFDEF IOS}

      if FileExists(path) then
      begin

        FController := TUIDocumentInteractionController.Wrap(TUIDocumentInteractionController.Alloc.init);
        URL         := TNSUrl.Wrap(TNSUrl.OCClass.fileURLWithPath(StrToNSStr(path)));

        FController.setURL(URL);
        FController.setUTI(StrToNSStr('com.adobe.pdf'));

        success     := FController.presentOpenInMenuFromRect(MakeNSRect(0, 0, 0, 0), GetParentView, True)

      end;

    {$ENDIF}

    {$IFDEF MSWINDOWS}
      ShellExecute(0, nil, PChar(path), nil, nil, SW_SHOWNORMAL);
    {$ENDIF}

  end;

end;

procedure SendFichero(Ruta_Fichero : String);
var
  FileDirectory : string;
  FileName      : string;
  path          : string;
  BSPDF         : TBytesStream;
  SSPDF         : TStringStream;
{$IFDEF ANDROID}
  intent        : JIntent;
  fileuri       : JParcelable;
{$ENDIF}
{$IF DEFINED(IOS)}
  FController : UIDocumentInteractionController;
  URL         : NSURL;
  success     : Boolean;
{$ENDIF}
begin

  if Ruta_Fichero <> '' then
  begin

    FileName := 'report_cotacao_' + DataFichero(Now) + '.pdf';

    {$IFDEF ANDROID}
      FileDirectory := '/sdcard/Android/data/canion.com.br.ForcaVendas/files/';
    {$ENDIF}

    {$IF DEFINED(IOS)}
      FileDirectory := TPath.GetDocumentsPath + PathDelim;
    {$ENDIF}

    {$IFDEF MSWINDOWS}
      FileDirectory := ExtractFilePath(ExtractFilePath(ParamStr(0)));
    {$ENDIF}

    path  := FileDirectory + FileName;

    BSPDF := TBytesStream.Create;

    try

      SSPDF := TStringStream.Create(Ruta_Fichero, TEncoding.ASCII);

      try

        SSPDF.Position := 0;
        Soap.EncdDecd.DecodeStream(SSPDF, BSPDF);
        BSPDF.Position   := 0;

      finally
        FreeAndNil(SSPDF);
      end;

      if not(DirectoryExists(FileDirectory))then
        ForceDirectories(FileDirectory);

      BSPDF.SaveToFile(path);

    finally
      FreeAndNil(BSPDF);
    end;

    {$IFDEF ANDROID}

      if FileExists(path) then
      begin

        intent := TJIntent.Create;
        intent.setAction (TJIntent.JavaClass.ACTION_SEND);
        intent.setType (StringToJString('application/pdf'));
        fileuri := JParcelable(TJNet_Uri.JavaClass.fromFile(TJFile.JavaClass.init(StringToJString(path))));
        intent.putExtra(TJIntent.JavaClass.EXTRA_STREAM, fileuri);
        SharedActivity.startActivity(TJIntent.JavaClass.createChooser(intent, StrToJCharSequence('Compartilhar')));

      end;

    {$ENDIF}

    {$IFDEF IOS}

      if FileExists(path) then
      begin

        FController := TUIDocumentInteractionController.Wrap(TUIDocumentInteractionController.Alloc.init);
        URL         := TNSUrl.Wrap(TNSUrl.OCClass.fileURLWithPath(StrToNSStr(path)));

        FController.setURL(URL);
        FController.setUTI(StrToNSStr('com.adobe.pdf'));

        success     := FController.presentOpenInMenuFromRect(MakeNSRect(0, 0, 0, 0), GetParentView, True)

      end;

    {$ENDIF}

    {$IFDEF MSWINDOWS}
      ShellExecute(0, nil, PChar(path), nil, nil, SW_SHOWNORMAL);
    {$ENDIF}

  end;

end;

function DataHoraInicial( dDateTime: TDateTime ): TDateTime;
Begin
  Result := StrToDateTime(FormatDateTime('dd/mm/yy 00:00:00', dDateTime));
End;

function DataHoraFinal( dDateTime: TDateTime ): TDateTime;
Begin
  Result := StrToDateTime(FormatDateTime('dd/mm/yy 23:59:00', dDateTime));
End;

{$IFDEF IOS}
function GetDeviceModelString: String;
var
  Size: size_t;
  DeviceModelBuffer: array of Byte;
begin
  sysctlbyname('hw.machine', nil, @Size, nil, 0);

  if Size > 0 then
  begin
    SetLength(DeviceModelBuffer, Size);
    sysctlbyname('hw.machine', @DeviceModelBuffer[0], @Size, nil, 0);
    Result := UTF8ToString(MarshaledAString(DeviceModelBuffer));
  end
  else
    Result := EmptyStr;
end;

function GetParentView: UIView;
var
  app : UIApplication;
  wn  : UIWindow;
begin
  Result := nil;
  app    := GetSharedApplication;
  if Assigned(app) then
  begin
    wn := app.keyWindow;
    if Assigned(wn) then
      if Assigned(wn.rootViewController) then
        Result := wn.rootViewController.view;
  end;
end;

function GetSharedApplication: UIApplication;
begin
  Result := TUIApplication.Wrap(TUIApplication.OCClass.sharedApplication);
end;

function MakeNSRect(ox, oy, sx, sy: Single): NSRect;
begin
  Result.origin.x    := ox;
  Result.origin.y    := oy;
  Result.size.width  := sx;
  Result.size.height := sy;
end;

{$ENDIF}

function getDevice: Device;
var
  OSVersion    : TOSVersion;
  MANUFACTURER : String;
  MODEL        : String;
  PRODUCT      : String;
  UniqueID     : string;
begin

  Result.sManufacture := '';
  Result.sModel       := '';
  Result.sProduct     := '';
  Result.sUniqueID    := '';
  Result.sOS          := '';
  Result.sPlatform    := '';
  Result.sVersion     := '';

{$IFDEF Android}

  MANUFACTURER := JStringToString(TJBuild.JavaClass.MANUFACTURER);
  MODEL        := JStringToString(TJBuild.JavaClass.MODEL);
  PRODUCT      := JStringToString(TJBuild.JavaClass.PRODUCT);
  UniqueID     := JStringToString(TJSettings_Secure.JavaClass.getString(TAndroidHelper.ContentResolver, TJSettings_Secure.JavaClass.ANDROID_ID));

{$ENDIF}
{$IFDEF IOS}

  MANUFACTURER := 'AppleCare';
  MODEL        := GetDeviceModelString;
  PRODUCT      := NSStrToStr(TiOSHelper.CurrentDevice.localizedModel);
  UniqueID     := NSStrToStr(TiOSHelper.CurrentDevice.identifierForVendor.UUIDString);

{$ENDIF}

  Result.sManufacture := Format('%s', [ MANUFACTURER ] );
  Result.sModel       := Format('%s', [ MODEL ] );
  Result.sProduct     := Format('%s', [ PRODUCT ] );
  Result.sUniqueID    := Format('%s', [ UniqueID ] );
  Result.sOS          := Format('%s', [ OSVersion.Name ]);
  Result.sPlatform    := Format('%d', [ Ord(OSVersion.Platform) ]);
  Result.sVersion     := Format('%d.%d.%d', [OSVersion.Major , OSVersion.Minor, OSVersion.Build]);

end;

function Dispositivos(CodEmpresa, CodFilial, CodUsuario: Integer) : String;
var
  JSONObjectResult : TJSONObject;
  JSONArrayResult  : TJSONArray;
begin

  JSONArrayResult := TJSONArray.Create;

  try

    JSONObjectResult := TJSONObject.Create;

    try

      JSONObjectResult.AddPair('cod_empresa'   , TJSONString.Create(UTF8Encode(IntToStr(CodEmpresa))));
      JSONObjectResult.AddPair('cod_filial'    , TJSONString.Create(UTF8Encode(IntToStr(CodFilial))));
      JSONObjectResult.AddPair('cod_usuario'   , TJSONString.Create(UTF8Encode(IntToStr(CodUsuario))));
      JSONObjectResult.AddPair('manufacture'   , TJSONString.Create(UTF8Encode(getDevice.sManufacture)));
      JSONObjectResult.AddPair('model'         , TJSONString.Create(UTF8Encode(getDevice.sModel)));
      JSONObjectResult.AddPair('product'       , TJSONString.Create(UTF8Encode(getDevice.sProduct)));
      JSONObjectResult.AddPair('unique_id'     , TJSONString.Create(UTF8Encode(getDevice.sUniqueID)));
      JSONObjectResult.AddPair('os'            , TJSONString.Create(UTF8Encode(getDevice.sOS)));
      JSONObjectResult.AddPair('platform'      , TJSONString.Create(UTF8Encode(getDevice.sPlatform)));
      JSONObjectResult.AddPair('version'       , TJSONString.Create(UTF8Encode(getDevice.sVersion)));

      JSONArrayResult.AddElement(TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(JSONObjectResult.ToString),0));

    finally
      FreeAndNil(JSONObjectResult);
    end;

    GetInvocationMetadata().ResponseCode    := 200;
    GetInvocationMetadata().ResponseContent := JSONArrayResult.ToString;

    Result := JSONArrayResult.ToString;

    // Converter caracteres inválidos para tabela ACSII
    Result := StringReplace(Result, '{', '%7B', [rfreplaceall]);
    Result := StringReplace(Result, '}', '%7D', [rfreplaceall]);
    Result := StringReplace(Result, '/', '%2F', [rfreplaceall]);
    Result := StringReplace(Result, '\', '%5C', [rfreplaceall]);

  finally
    FreeAndNil(JSONArrayResult);
  end;

end;

function FStrToCurrency(Value : string): Currency;
begin

  if Value <> '' then
  begin
    Value  := StringReplace(Value, '.', ',', [rfReplaceAll, rfIgnoreCase]);
    Result := StrToCurr(Value);
  end else
    Result := 0;

end;

function FStrToDateTime(Value : string): TDateTime;
var
  ANO  : string;
  MES  : string;
  DIA  : string;
  HORA : string;
  DATAHORA : string;
begin

  ANO  := Copy(Value,3, 2);
  MES  := Copy(Value,6, 2);
  DIA  := Copy(Value,9, 2);
  HORA := Copy(Value,12, 8);
  DATAHORA := DIA + '/' + MES + '/' + ANO + ' ' + HORA;

  if DATAHORA <> '' then
    Result := StrToDateTimeDef(DATAHORA,0)
  else
    Result := 0;

end;

function FStrToDate(Value : string): TDateTime;
var
  ANO  : string;
  MES  : string;
  DIA  : string;
  HORA : string;
  DATA : string;
begin

  ANO  := Copy(Value,3, 2);
  MES  := Copy(Value,6, 2);
  DIA  := Copy(Value,9, 2);
  DATA := DIA + '/' + MES + '/' + ANO + ' 00:00:00';

  if DATA <> '' then
    Result := StrToDateTimeDef(DATA,0)
  else
    Result := 0;

end;

function FStrToBoolean(Value : string): Boolean;
begin

  if Value <> '' then
    if Value = '0' then
      Result := False
    else
      Result := True
  else
    Result := False;

end;

function FStrToInteger(Value : string): Integer;
begin

  if Value <> '' then
    Result := StrToInt(Value)
  else
    Result := 0;

end;

function VerifivarInternet: Boolean;
var
  lHTTP: TIdHTTP;
  POST : TStringStream;
begin

  POST   := TStringStream.Create('');
  lHTTP  := TIdHTTP.Create(nil);
  Result := True;

  try

    try
      lHTTP.ConnectTimeout := 100;
      lHTTP.Get('http://www.google.com.br', POST);
    except
      Result := False;
    end;

  finally
    lHTTP.Free;
  end;

end;

function JsonToStr(JSON, Value: String): String;
var
  LJSONObject : TJSONObject;
  jSubPar     : TJSONPair;
  J           : Integer;
begin

  LJSONObject := nil;

  try

    LJSONObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(JSON), 0)
      as TJSONObject;

    for J := 0 to LJSONObject.Size - 1 do
    begin
      jSubPar := LJSONObject.Get(J); // pega o par no índice j
      if (trim(jSubPar.JsonString.Value) = Value) then
        Result := jSubPar.JsonValue.Value;
    end;

  finally
    LJSONObject.Free;
  end;

end;


function GETJsonstring(URL:string):string;
var
  HTTP : TIdHTTP;
  GET  : TStringStream;
begin

  HTTP := TIdHTTP.Create(nil);
  GET  := TStringStream.Create;

  try

    Result := HTTP.Post(URL, GET);

  finally
    FreeAndNil(HTTP);
  end;

  Result := StringReplace(Result, '[', '', [rfreplaceall]);
  Result := StringReplace(Result, ']', '', [rfreplaceall]);

end;

(*
function VercaoAPPWeb:Integer;
var
  JSON : string;
begin

  JSON   := GETJsonstring('http://apk.canion.com.br/GET_Versao.php');
  Result := StrToInt(JsonToStr( JSON , 'VersaoAPP'));

end;
*)

function StrLeft( sString : String; iQuantidade : Integer ) : String;
begin

  if iQuantidade >= 1 then
    Result := Copy( sString, 1, iQuantidade )
  else
    Result := '';

end;

function StrRightPreenche( sString, sPreenchedor : String; iQuantidade : Integer ) : String;
var
  iAdd : Integer;
  iX   : Integer;
  sAdd : String;
begin

  sString := TrimRight( sString );
  iAdd    := ( iQuantidade - Length( sString ) ) div Length( sPreenchedor );

  if iAdd >= 1 then
  begin
    for iX := 1 to iAdd do
    begin
      sAdd := sAdd + sPreenchedor;
    end;
  end;

  // Caso a string sPreenchedor tenha mais de um caracter
  // e o tamnho  nao permitiu colocar todos como sequencia
  // adiciona os da Direita para a Esquerda
  sString := sString + sAdd;

  if Length( sString ) < iQuantidade then
  begin

    sAdd := '';
    iAdd := Length( sPreenchedor );
    for iX := 1 to iAdd do begin
      sAdd := sAdd + sPreenchedor[ iX ];
    end;
    sString := sString + sAdd;

  end;

  Result := StrLeft( sString, iQuantidade );

end;

function StrRight( sString : String; iQuantidade : Integer ) : String;
var
  iTam : Integer;
begin

  iTam := Length( sString );

  if iQuantidade < iTam then
    Result := Copy( sString, ( iTam + 1 ) - iQuantidade, iQuantidade )
  else
    Result := sString;

end;

function StrLeftPreenche( sString, sPreenchedor : String; iQuantidade : Integer ) : String;
Var
  iAdd : Integer;
  iX   : Integer;
  sAdd : String;
begin

  sString := TrimLeft( sString );
  iAdd    := ( iQuantidade - Length( sString ) ) div Length( sPreenchedor );

  if iAdd >= 1 then
  begin
    for iX := 1 to iAdd do
    begin
      sAdd := sPreenchedor + sAdd;
    end;
  end;

  // Caso a string sPreenchedor tenha mais de um caracter
  // e o tamnho  nao permitiu colocar todos como sequencia
  // adiciona os da Direita para a Esquerda
  sString := sAdd + sString;
  if Length( sString ) < iQuantidade then
  begin
    sAdd := '';
    iAdd := Length( sPreenchedor );
    for iX := iAdd Downto 1 do
    begin
      sAdd := sPreenchedor[ iX ] + sAdd;
    end;
    sString := sAdd + sString;
  end;

  Result := StrRight( sString, iQuantidade );

end;

Function FimMes( dDateTime: TDateTime ): TDateTime;
var
  iwYear  : word;
  iwMonth : word;
  iwDay   : word;
Begin

  DecodeDate( dDateTime, iwYear, iwMonth, iwDay );

  If iwMonth < 12 Then
  Begin
    Result := StrToDateTime( '01/' +
                           StrLeftPreenche( IntToStr( iwMonth + 1 ), '0', 2 ) + '/' +
                           StrRightPreenche( IntToStr( iwYear ), '0', 4 ) );
  End Else
  Begin
    Result := StrToDateTime( '01/01/' + StrRightPreenche( IntToStr( iwYear + 1 ), '0', 4 ) );
  End;

  Result := Result -1;

End;

function IniMes( dDateTime: TDateTime ): TDateTime;
var
 iwYear  : word;
 iwMonth : word;
 iwDay   : word;
Begin
  DecodeDate( dDateTime, iwYear, iwMonth, iwDay );
  Result := dDateTime - iwDay + 1;
End;

function StrToCurValue(Value:string):Currency;
begin
  Value  := StringReplace(Value, '.', ',', [rfReplaceAll, rfIgnoreCase]);
  Result := StrToCurr(Value);
end;

Function DateToTimeSQL;
Begin
  Result := FormatDateTime('yyyy-mm-dd hh:mm:ss', dDateTime);
End;

Function DateToSQL(dDate: TDate): String;
begin
  Result := FormatDateTime('yyyy-mm-dd', dDate);
end;

Function CurrencySQL;
Var
  sValor:       String;
  iPosVirgula:  Integer;
Begin
  sValor := FloatToStr(rcCurrency);
  sValor := StringReplace( sValor, ',' , '.', [rfReplaceAll, rfIgnoreCase]);
  Result := sValor;
End;

Function IntegerSQL;
Begin
  Result := IntToStr(iInteger);
End;

Function BooleanSQL;
Begin
  If bBoolean then
    Result := '1'
  Else
    Result := '0';
End;

Function BooleanInt;
Begin

  If bBoolean then
    Result := 1
  Else
    Result := 0;

End;

function RemoverCaracterEspecial(Valor: string; Extra: Boolean = False): string;
const
  // Lista de caracteres especiais
  xCarEsp: array [1 .. 38] of String = ('á', 'à', 'ã', 'â', 'ä', 'Á', 'À', 'Ã',
    'Â', 'Ä', 'é', 'è', 'É', 'È', 'í', 'ì', 'Í', 'Ì', 'ó', 'ò', 'ö', 'õ', 'ô',
    'Ó', 'Ò', 'Ö', 'Õ', 'Ô', 'ú', 'ù', 'ü', 'Ú', 'Ù', 'Ü', 'ç', 'Ç', 'ñ', 'Ñ');
  // Lista de caracteres para troca
  xCarTro: array [1 .. 38] of String = ('a', 'a', 'a', 'a', 'a', 'A', 'A', 'A',
    'A', 'A', 'e', 'e', 'E', 'E', 'i', 'i', 'I', 'I', 'o', 'o', 'o', 'o', 'o',
    'O', 'O', 'O', 'O', 'O', 'u', 'u', 'u', 'u', 'u', 'u', 'c', 'C', 'n', 'N');
  // Lista de Caracteres Extras
  xCarExt: array [1 .. 53] of string = ('<', '>', '!', '@', '#', '$', '%', '¨',
    '&', '*', '(', ')', '_', '+', '=', '{', '}', '[', ']', '?', ';', ':', ',',
    '|', '*', '"', '~', '^', '´', '`', '¨', 'æ', 'Æ', 'ø', '£', 'Ø', 'ƒ', 'ª',
    'º', '¿', '®', '½', '¼', 'ß', 'µ', 'þ', 'ý', 'Ý', '-', '.', '/', '\',
    '§');

var
  xTexto: string;
  i: Integer;
begin

  xTexto := Valor;

  for i := 1 to 38 do
  begin
    xTexto := StringReplace(xTexto, xCarEsp[i], xCarTro[i], [rfreplaceall]);
  end;

  // De acordo com o parâmetro aLimExt, elimina caracteres extras.
  if Extra = True then
  begin
    for i := 1 to 53 do
    begin
      xTexto := StringReplace(xTexto, xCarExt[i], '', [rfreplaceall]);
    end;
  end;

  Result := xTexto;

end;

Function HoraMilisegundos(Hora: TTime): LongInt;
var
  Ano  : Word;
  Mes  : Word;
  Dia  : Word;
  Hor  : Word;
  Min  : Word;
  Sec  : Word;
  MSec : Word;
begin
  DecodeTime(Hora, Hor, Min, Sec, MSec);
  HoraMilisegundos := MSec + (sec * 1000) + (min * 60000) + (hor * 3600000);
end;

function MiliSegundoshora(milisegundo: LongInt): string;
var
  Hrs    : word;
  Minut  : word;
  secut  : word;
  msecut : word;
begin

  Hrs         := milisegundo div 3600000;
  milisegundo := milisegundo mod 3600000;
  minut       := milisegundo div 60000;
  milisegundo := milisegundo mod 60000;
  secut       := milisegundo div 1000;
  msecut      := milisegundo mod 1000;
  Result      := Format('%d:%d:%d', [Hrs,Minut,Secut,msecut]);

end;

function GetSoundName: string;
begin
  {$IFDEF IOS}

  {$ENDIF}
  {$IFDEF ANDROID}

  {$ENDIF}
end;

end.
