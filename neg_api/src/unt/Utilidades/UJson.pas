unit UJson;

interface

uses
  System.DateUtils,
  System.SysUtils, System.Classes, System.Json, FireDAC.Comp.Client, System.Variants,
  Winapi.Windows, Vcl.Forms, Data.DB, FireDAC.Comp.DataSet, Data.FmtBcd,
  Data.SqlTimSt, Data.DBXPlatform;

type

  TFDQueryHelper = class helper for TFDQuery
  private
    procedure JsonToRecord(sJson: string; AAppend: boolean);
  public
    procedure OpenAnonimous(proc: TProc);
    procedure Run(AProc:TProc<TFDQuery>);
    procedure Append(AEvent: TProc<TFDQuery>); overload;
    procedure Append(AEvent: TProc); overload;
    procedure Post(AEvent: TProc); overload;
    procedure Post(AEvent: TProc<TFDQuery>); overload;
    function ToJson(version: Integer = 0): String;
    function ToJsonObject(version: Integer):TJSONArray;
    procedure ChangeAllValuesTo(AFieldName: string; AValue: Variant); overload;
    procedure ChangeAllValuesTo(AFieldName: string; AValue: Variant; AConfirm: TFunc<boolean>); overload;
    procedure AppendFromJson(sJson: string);
    procedure CopyFromJson(sJosn: string);
    procedure DoLoopEvent(AEvent: TProc); overload;
    procedure DoLoopEvent(AEvent: TProc<TFDQuery>); overload;
    procedure DoEventIf(AFieldName: string; AValue: Variant; AEvent: TProc); overload;
    procedure DoEventIf(AFieldName: string; AValue: Variant; AEvent: TProc<TFDQuery>); overload;
    procedure Value(AField:string;AValue:variant);overload;
    function Value(AField:string):Variant;overload;
    procedure AppendRecords(ADataSet:TFDQuery);
    procedure FieldMask(fld:String;mask:string);
    procedure FieldTitle(AFld:string;ATitle:string);
    function FieldChanged(fld: string): Boolean;
    procedure TrimAppMemorySize;

  end;

  TFieldsHelper = class helper for TFields
  private
  public
    function JsonObject(var AJSONObject: TJsonObject; ANulls: boolean = true; version: Integer = 0):integer;
    function ToJson(ANulls:boolean = true): string;
  end;
     
//  function QryToJoson(QryDAO : TFDQuery; Versao : Integer = 0): TJSONArray;
//  function JsonToStr(JSON: String; Value: String): String;

implementation
  
(*
function JsonToStr(JSON, Value: String): String;
var
  LJSONObject: TJSONObject;
  jSubPar: TJSONPair;
  J: Integer;
begin

  LJSONObject := nil;

  try

    LJSONObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(JSON), 0) as TJSONObject;

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

function QryToJoson(QryDAO : TFDQuery; Versao : Integer = 0): TJSONArray;

  Function BooleanSQL(bBoolean: Boolean): String;
  Begin
    If bBoolean then
      Result := '1'
    Else
      Result := '0';
  End;

  Function IntegerSQL(iInteger: Integer): String;
  begin
    Result := IntToStr(iInteger);
  end;

  Function CurrencySQL(rcCurrency: Currency): String;
  Var
    sValor : String;
  Begin

    if Versao = 1 then
    begin
      sValor := FloatToStr(rcCurrency);
      sValor := StringReplace( sValor, ',' , '.', [rfReplaceAll, rfIgnoreCase]);
      Result := sValor;
    end else
    begin
      sValor := FloatToStr(rcCurrency);
      Result := sValor;
    end;

  End;

  Function DateTimeTimeSQL(dDateTime: TDateTime): String;
  Begin
    Result := FormatDateTime('yyyy-mm-dd hh:mm:ss', dDateTime);
  End;

var
  I, Y          : Integer;
  JObjectResult : TJSONObject;
begin

  Result := TJSONArray.Create;

  if not QryDAO.IsEmpty then
  begin

    Y := QryDAO.FieldCount - 1;

    QryDAO.First;
    while not QryDAO.Eof do
    begin

      JObjectResult := TJSONObject.Create;

      try

        for I := 0 to Y do
        begin

          if QryDAO.Fields[I].DataType = ftBoolean then
          begin
            JObjectResult.AddPair(QryDAO.Fields[I].FieldName, TJSONString.Create(UTF8Encode(BooleanSQL(QryDAO.Fields[I].AsBoolean))));
            Continue;
          end else if QryDAO.Fields[I].DataType = ftString then
          begin
            JObjectResult.AddPair(QryDAO.Fields[I].FieldName, TJSONString.Create(UTF8Encode(QryDAO.Fields[I].AsString)));
            Continue;
          end else if QryDAO.Fields[I].DataType = ftSmallint then
          begin
            JObjectResult.AddPair(QryDAO.Fields[I].FieldName, TJSONString.Create(UTF8Encode(IntegerSQL(QryDAO.Fields[I].AsInteger))));
            Continue;
          end else if QryDAO.Fields[I].DataType = ftInteger then
          begin
            JObjectResult.AddPair(QryDAO.Fields[I].FieldName, TJSONString.Create(UTF8Encode(IntegerSQL(QryDAO.Fields[I].AsInteger))));
            Continue;
          end else if QryDAO.Fields[I].DataType = ftFloat then
          begin
            JObjectResult.AddPair(QryDAO.Fields[I].FieldName, TJSONString.Create(UTF8Encode(CurrencySQL(QryDAO.Fields[I].AsFloat))));
            Continue;
          end else if QryDAO.Fields[I].DataType = ftCurrency then
          begin
            JObjectResult.AddPair(QryDAO.Fields[I].FieldName, TJSONString.Create(UTF8Encode(CurrencySQL(QryDAO.Fields[I].AsCurrency))));
            Continue;
          end else if QryDAO.Fields[I].DataType = ftBCD then
          begin
            JObjectResult.AddPair(QryDAO.Fields[I].FieldName, TJSONString.Create(UTF8Encode(CurrencySQL(QryDAO.Fields[I].AsCurrency))));
            Continue;
          end else if QryDAO.Fields[I].DataType = ftDate then
          begin
            JObjectResult.AddPair(QryDAO.Fields[I].FieldName, TJSONString.Create(UTF8Encode(DateTimeTimeSQL(QryDAO.Fields[I].AsDateTime))));
            Continue;
          end else if QryDAO.Fields[I].DataType = ftDateTime then
          begin
            JObjectResult.AddPair(QryDAO.Fields[I].FieldName, TJSONString.Create(UTF8Encode(DateTimeTimeSQL(QryDAO.Fields[I].AsDateTime))));
            Continue;
          end else if QryDAO.Fields[I].DataType = ftTimeStamp then
          begin
            JObjectResult.AddPair(QryDAO.Fields[I].FieldName, TJSONString.Create(UTF8Encode(DateTimeTimeSQL(QryDAO.Fields[I].AsDateTime))));
            Continue;
          end else if QryDAO.Fields[I].DataType = ftByte then
          begin
            JObjectResult.AddPair(QryDAO.Fields[I].FieldName, TJSONString.Create(UTF8Encode(IntegerSQL(QryDAO.Fields[I].AsInteger))));
            Continue;
          end else if QryDAO.Fields[I].DataType = ftBytes then
          begin
            JObjectResult.AddPair(QryDAO.Fields[I].FieldName, TJSONString.Create(UTF8Encode(IntegerSQL(QryDAO.Fields[I].AsInteger))));
            Continue;
          end else if QryDAO.Fields[I].DataType = ftMemo then
          begin
            JObjectResult.AddPair(QryDAO.Fields[I].FieldName, TJSONString.Create(UTF8Encode(QryDAO.Fields[I].AsString)));
            Continue;
          end else
          begin
            JObjectResult.AddPair(QryDAO.Fields[I].FieldName, TJSONString.Create(UTF8Encode(QryDAO.Fields[I].AsString)));
            Continue;
          end;

        end;

        Result.AddElement(TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(JObjectResult.ToJSON),0));

      finally
        FreeAndNil(JObjectResult);
      end;

      QryDAO.Next;

    end;

  end else
    Result := TJSONArray.Create;

end;
*)
{ TFDQueryHelper }

procedure TFDQueryHelper.Append(AEvent: TProc<TFDQuery>);
begin
  Append;
  AEvent(self);
end;

procedure TFDQueryHelper.Append(AEvent: TProc);
begin
  Append(procedure(ds: TFDQuery)
  begin
    AEvent;
  end);
end;

procedure TFDQueryHelper.AppendFromJson(sJson: string);
begin
  JsonToRecord(sJson, true);
end;

procedure TFDQueryHelper.AppendRecords(ADataSet: TFDQuery);
var
  book: TBookMark;
begin
  book := GetBookmark;
  try
    DisableControls;
    ADataset.first;
    while ADataset.Eof=false do
    begin
        append;
        CopyFields(ADataset);
        Post;
        ADataset.next;
    end;
  finally
     GotoBookmark(book);
     FreeBookmark(book);
     EnableControls;
  end;
end;

procedure TFDQueryHelper.ChangeAllValuesTo(AFieldName: string; AValue: Variant; AConfirm: TFunc<boolean>);
var
  book: TBookMark;
  fld : TField;
begin
  fld := FindField(AFieldName);
  if fld = nil then
    exit;
    
  book := GetBookmark;
  DisableControls;
  try
    first;
    while eof = false do
    begin
      if AConfirm then
      begin
        if fld.Calculated then
          FieldByName(AFieldName).Value := AValue
        else if FieldByName(AFieldName).Value <> AValue then
        begin
          Edit;
          FieldByName(AFieldName).Value := AValue;
          Post;
        end;
      end;
      next;
    end;
    
  finally
    if BookmarkValid(book) then
      GotoBookmark(book);
    FreeBookmark(book);
    EnableControls;
  end;

end;

procedure TFDQueryHelper.ChangeAllValuesTo(AFieldName: string; AValue: Variant);
begin
  ChangeAllValuesTo(AFieldName, AValue, function: boolean
  begin
    result := true;
  end);
end;

procedure TFDQueryHelper.CopyFromJson(sJosn: string);
begin
  JsonToRecord(sJosn, false);
end;

procedure TFDQueryHelper.DoEventIf(AFieldName: string; AValue: Variant; AEvent: TProc);
begin
  DoEventIf(AFieldName, AValue, procedure(ds: TFDQuery)
  begin
    AEvent;
  end);
end;

procedure TFDQueryHelper.DoEventIf(AFieldName: string; AValue: Variant; AEvent: TProc<TFDQuery>);
var
  book: TBookMark;
  fld: TField;
begin
  if not assigned(AEvent) then
    exit;
  fld := FindField(AFieldName);
  if fld = nil then
    exit;
  book := GetBookmark;
  DisableControls;
  try
    first;
    while eof = false do
    begin
      if FieldByName(AFieldName).Value = AValue then
        AEvent(self) // quando exclui uma linha, ja salta para o item seguinte.
                     // o next fica por conta da rotina que chamou;
      else
        next; // nao excluir nada, apontar para o proximo
    end;
  finally
    if BookmarkValid(book) and (eof <> bof) then
    begin
      GotoBookmark(book);
    end;
    FreeBookmark(book);
    EnableControls;
  end;
end;

procedure TFDQueryHelper.DoLoopEvent(AEvent: TProc);
begin
  DoLoopEvent(procedure(ds: TFDQuery)
  begin                        
    AEvent;
  end);
end;

procedure TFDQueryHelper.DoLoopEvent(AEvent: TProc<TFDQuery>);
var
  book: TBookMark;
begin
  book := GetBookmark;
  try
    DisableControls;
    first;
    while eof = false do
    begin
      AEvent(self);
      next;
    end;
  finally
    GotoBookmark(book);
    FreeBookmark(book);
    EnableControls;
  end;
end;

function TFDQueryHelper.FieldChanged(fld: string): Boolean;
var
  fd: TField;
begin
  result := false;
  fd := FindField(fld);
  if fd = nil then
    exit;
  try
    if VarIsNull(fd.OldValue) and VarIsNull(fd.Value) then
      exit;
  except
  end;
  if not(State in [dsEdit, dsInsert]) then
    exit;
  try
    if State in [dsEdit] then
      if fd.OldValue = fd.Value then
        exit;
    if State in [dsInsert] then
      if VarIsNull(fd.Value) then
        exit;
    result := true;
  except
  end;
end;

procedure TFDQueryHelper.FieldMask(fld, mask: string);
var 
  f : TField;
begin
  f := FindField(fld);
  if not assigned(f) then exit;
  case f.DataType of
    ftFloat,
    ftCurrency : TFloatField(f).DisplayFormat := mask;
    ftDate     : TDateField(f).DisplayFormat := mask;
    ftDateTime : TDateTimeField(f).DisplayFormat := mask;
    ftString   : begin
                   TStringField(f).DisplayLabel := mask;
                   TStringField(f).EditMask     := mask;
                 end;
  end;
end;

procedure TFDQueryHelper.FieldTitle(AFld, ATitle: string);
var 
 f : TField;
begin
  f := findField(AFld);
  if not assigned(f) then exit;
  f.DisplayLabel := ATitle;
end;

procedure TFDQueryHelper.JsonToRecord(sJson: string; AAppend: boolean);
begin

end;

procedure TFDQueryHelper.OpenAnonimous(proc: TProc);
begin
  open;
  if active and assigned(proc) then
    proc;
end;

procedure TFDQueryHelper.Post(AEvent: TProc<TFDQuery>);
begin
  AEvent(self);
  Post;
end;

procedure TFDQueryHelper.Post(AEvent: TProc);
begin
  Post(procedure(ds: TFDQuery)
  begin
    AEvent;
  end);
end;

procedure TFDQueryHelper.Run(AProc: TProc<TFDQuery>);
begin
  TThread.CreateAnonymousThread(procedure
  begin
    if assigned(AProc) then
      AProc(self);
  end).Start;
end;

function TFDQueryHelper.ToJson(version : Integer): String;
begin
  result := ToJsonObject(version).ToString;
end;

function TFDQueryHelper.ToJsonObject(version : Integer): TJSONArray;
var
  book          : TBookMark;
  I, Y          : Integer;
  JObjectResult : TJSONObject;
begin

  Result := TJSONArray.Create;
  book   := GetBookmark;

  try

    if not IsEmpty then
    begin

      First;

      while not Eof do
      begin

        JObjectResult := TJSONObject.Create;

        try

          Fields.JsonObject(JObjectResult, False, version);

          Result.AddElement(TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(JObjectResult.ToString),0));

        finally
          FreeAndNil(JObjectResult);
        end;

        Next;
      end;

    end;

  finally
    EnableControls;
    GotoBookmark(book);
    FreeBookmark(book); 
    
    GetInvocationMetadata().ResponseCode    := 200;
    GetInvocationMetadata().ResponseContent := Result.ToString;  
     
    TrimAppMemorySize;
  end;

end;

procedure TFDQueryHelper.TrimAppMemorySize;
var
  MainHandle : THandle;
begin
  try

    try
      MainHandle := OpenProcess(PROCESS_ALL_ACCESS, false, GetCurrentProcessID) ;
      SetProcessWorkingSetSize(MainHandle, $FFFFFFFF, $FFFFFFFF) ;
      CloseHandle(MainHandle) ;
    except
      //
    end;

  finally
    Application.ProcessMessages;
  end;
end;

function TFDQueryHelper.Value(AField: string): Variant;
begin
  result := FieldByName(AField).Value;
end;

procedure TFDQueryHelper.Value(AField: string; AValue: variant);
begin
  FieldBYName(AField).Value := AValue;
end;

function ISOCurrencyToString(ACurrency: Currency; version: Integer = 0): string;
Var
  sValor : String;
Begin

  case version of

  1 : begin
        sValor := FloatToStr(ACurrency);
        sValor := StringReplace(sValor, ',' , '.', [rfReplaceAll, rfIgnoreCase]);
        Result := sValor;
      end;

  else
    sValor := FloatToStr(ACurrency);
    Result := sValor;
  end;

end;

function ISODateToString(ADate: TDatetime): string;
begin
  result := FormatDateTime('YYYY-MM-DD', ADate);
end;

function ISODateTimeToString(ADateTime: TDatetime): string;
begin
  result := System.DateUtils.DateToISO8601(ADateTime, false);
end;

function ISOBooleanToInteger(dados: Boolean): integer;
begin

  if not dados then
    Result := 0
  else
    Result := 1;

end;

{ TFieldsHelper }

function TFieldsHelper.JsonObject(var AJSONObject: TJsonObject; ANulls: boolean; version: Integer):integer;
var
  it : TField;
begin
  result := 0;

  if not Assigned(AJSONObject) then
     raise Exception.Create('Error Message'); exception.Create('Error Message, not init JSONOject ');

  for it in Self do
  begin

    if it.IsNull then
    begin
      if not ANulls then
        continue;

      AJSONObject.AddPair(it.FieldName, TJSONNull.Create);
      Continue;
    end;

    case it.DataType of

      TFieldType.ftInteger,
      TFieldType.ftAutoInc,
      TFieldType.ftSmallint,
      TFieldType.ftShortint : AJSONObject.AddPair(it.FieldName, TJSONNumber.Create(it.AsInteger));

      TFieldType.ftLargeint : AJSONObject.AddPair(it.FieldName, TJSONNumber.Create(it.AsLargeInt));

      TFieldType.ftSingle,
      TFieldType.ftFloat    : AJSONObject.AddPair(it.FieldName, ISOCurrencyToString(it.AsFloat, version));

      ftWideString,
      ftMemo,
      ftWideMemo            : AJSONObject.AddPair(it.FieldName, it.AsWideString);

      ftString              : AJSONObject.AddPair(it.FieldName, it.AsString);

      TFieldType.ftDate     : AJSONObject.AddPair(it.FieldName, ISODateToString(it.AsDateTime));

      TFieldType.ftDateTime : AJSONObject.AddPair(it.FieldName, ISODateTimeToString(it.AsDateTime));

      TFieldType.ftTimeStamp: AJSONObject.AddPair(it.FieldName, SQLTimeStampToStr('yyyy-mm-dd hh:nn:ss', it.AsSQLTimeStamp));

      TFieldType.ftCurrency,
      TFieldType.ftBCD,
      TFieldType.ftFMTBcd   : AJSONObject.AddPair(it.FieldName, ISOCurrencyToString(it.AsCurrency, version));

      TFieldType.ftBoolean   : AJSONObject.AddPair(it.FieldName, TJSONNumber.Create(ISOBooleanToInteger(it.AsBoolean)));

    else
      AJSONObject.AddPair(it.FieldName, it.AsString);
    end;

    inc(Result);
  end;

end;

function TFieldsHelper.ToJson(ANulls: boolean): string;
var
  AJsonObject :TJSONObject;
begin

  AJsonObject := TJSONObject.Create;

  try
    JSONObject(AJsonObject,ANulls);
    result := AJsonObject.ToString;
  finally
    AJsonObject.Free;
  end;

end;

end.
