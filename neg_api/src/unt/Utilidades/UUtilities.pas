unit UUtilities;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, Vcl.Forms, FireDAC.Comp.Client;

type

  TFeriados = (frAnoNovo,
               frCarnaval,
               frQuartaCinzas,
               frSextaSanta,
               frPascoa,
               frTiradentes,
               frDiaTrabalho,
               frCorpusChristi,
               frIndependencia,
               frNossaSenhoraAparecida,
               frFinados,
               frProclamacaoRepublica,
               frNatal);

  function formatarIntSQL(valor : Integer): String;
  function formatarStrSQL(valor : String): String;
  function formatarDatSQL(valor : TDateTime): String;
  function formatarCurSQL(valor : Currency): String;
  function formatarBoolSQL(valor: Boolean): String;
  function formatarDtmSQL(valor : TDateTime): String; overload;
  function formatarDtmSQL(valor : TDateTime; strHoraInicialFinal : string): String; overload;
  function topSQL(qtdeRegistros: Integer; tipoBancoDados: String; posInicio: Integer = 0; usarPaginacao: Boolean = False): String;

  function FStrToCurrency(Value : string): Currency;
  function FStrToDateTime(Value : string): TDateTime;
  function FStrToDate(Value : string): TDateTime;
  function FStrToBoolean(Value : string): Boolean;
  function FStrToInteger(Value : string): Integer;

  function StrLeftPreenche( sString, sPreenchedor : String; iQuantidade : Integer ) : String;
  function StrRightPreenche( sString, sPreenchedor : String; iQuantidade : Integer ) : String;
  function StrLeft( sString : String; iQuantidade : Integer ) : String;
  function StrRight( sString : String; iQuantidade : Integer ) : String;
  Function PadEsquerda(sString: String; iTamanho: Integer; cChar:Char = ' ' ): String;

  function modificaDataParaNomeBackup(data : TDateTime): string;
  function FimMes(dDateTime: TDateTime): TDateTime;
  function IniMes(dDateTime: TDateTime): TDateTime;
  function Day(dData : TDateTime): Byte;
  function Month( dData : TDateTime ): Byte;
  function Year(dData : TDateTime): Integer;
  function CalculaFeriado(AAno: Word; ATipo: TFeriados): TDateTime;
  function CalculaPascoa(AAno: Word): TDateTime;
  function DiasUteisMes(dData: TDateTime; CodFilial : Integer; lAtediaCorrente : Boolean = False): Integer;

  procedure TrimAppMemorySize;

implementation

uses
 untDMConexao;

function CalculaPascoa(AAno: Word): TDateTime;
var
  R1, R2, R3, R4, R5 : Longint;
  FPascoa            : TDateTime;
  VJ, VM, VD         : Word;
begin
  R1 := AAno mod 19;
  R2 := AAno mod 4;
  R3 := AAno mod 7;
  R4 := (19 * R1 + 24) mod 30;
  R5 := (6 * R4 + 4 * R3 + 2 * R2 + 5) mod 7;
  FPascoa := EncodeDate(AAno, 3, 22);
  FPascoa := FPascoa + R4 + R5;
  DecodeDate(FPascoa, VJ, VM, VD);
  case VD of
    26 : FPascoa := EncodeDate(Aano, 4, 19);
    25 : if R1 > 10 then
            FPascoa := EncodeDate(AAno, 4, 18);
  end;
  Result:= FPascoa;
end;

function CalculaFeriado(AAno: Word; ATipo: TFeriados): TDateTime;
var
  Aux : TDateTime;
begin
  Aux := CalculaPascoa(AAno);
  Case ATipo of
    frCarnaval              : Aux := Aux - 47;
    frQuartaCinzas          : Aux := Aux - 46;
    frSextaSanta            : Aux := Aux - 2;
    frCorpusChristi         : Aux := Aux + 60;
    frAnoNovo               : Aux := EncodeDate(Aano, 1, 1);
    frTiradentes            : Aux := EncodeDate(Aano, 4, 21);
    frDiaTrabalho           : Aux := EncodeDate(Aano, 5, 1);
    frIndependencia         : Aux := EncodeDate(Aano, 9, 7);
    frNossaSenhoraAparecida : Aux := EncodeDate(Aano, 10, 12);
    frFinados               : Aux := EncodeDate(Aano, 11, 2);
    frProclamacaoRepublica  : Aux := EncodeDate(Aano, 11, 15);
    frNatal                 : Aux := EncodeDate(Aano, 12, 25);
  end;
  Result := Aux;
end;

function Day( dData : TDateTime ): Byte;
var
  iwYear  : word;
  iwMonth : word;
  iwDay   : word;
begin
  DecodeDate(dData, iwYear, iwMonth, iwDay);
  Result := iwDay;
end;

function IniMes( dDateTime: TDateTime ): TDateTime;
var
  iwYear  : word;
  iwMonth : word;
  iwDay   : word;
begin
  DecodeDate( dDateTime, iwYear, iwMonth, iwDay );
  Result := dDateTime - iwDay + 1;
end;

function Year( dData : TDateTime ): Integer;
var
  iwYear  : word;
  iwMonth : word;
  iwDay   : word;
begin
  DecodeDate(dData, iwYear, iwMonth, iwDay);
  Result := iwYear;
end;

function Month( dData : TDateTime ): Byte;
var
  iwYear  : word;
  iwMonth : word;
  iwDay   : word;
begin
  DecodeDate(dData, iwYear, iwMonth, iwDay);
  Result := iwMonth;
end;

function FimMes( dDateTime: TDateTime ): TDateTime;
var
  iwYear  : word;
  iwMonth : word;
  iwDay   : word;
begin
  DecodeDate( dDateTime, iwYear, iwMonth, iwDay );

  if iwMonth < 12 then
    Result := StrToDateTime( '01/' + StrLeftPreenche( IntToStr( iwMonth + 1 ), '0', 2 ) + '/' + StrRightPreenche( IntToStr( iwYear ), '0', 4 ) )
  else
    Result := StrToDateTime( '01/01/' + StrRightPreenche( IntToStr( iwYear + 1 ), '0', 4 ) );

  Result := Result -1;
end;

//retorna o numero de dias uteis no mes da data
function DiasUteisMes(dData: TDateTime; CodFilial : Integer; lAtediaCorrente : Boolean = False): Integer;
var
  iDiasUteis : Integer;
  iDiasMes   : Integer;
  ix         : Integer;
  dDateTime  : TDateTime;
  aDiasUteis : array of Integer;
  FDQuery    : TFDQuery;
//Matriz de dias do mes (posicao), conteudo  0=Feriado 1=dia util -> sistema permite marcar o mesmo feriado duas vezes sem duplicar
//pois existe possibilidade de sobreposição de feriados, cadastrados e fixos, ou mesmo feriado cair em Sabado e Domingo.
begin
  dDateTime  := IniMes(dData);           //data do inicio do mes
  if lAtediaCorrente then
     iDiasMes := Day(dData)           //numero de dias ate a presente dData Dias Uteis parcial no mes ate a data corrente (recebida em parametro)
  else
     iDiasMes := Day(FimMes(dData));  //numero de dias totais no mes

  SetLength(aDiasUteis, iDiasMes);        //=Feriado 1=dia util

  //Pesquisar Feriados
  For ix := 0 to iDiasMes -1 do            //(-1) porque array começa com zero
  begin
    aDiasUteis[ix] := 1;  //preenche inicialmente como dia util
    //Remover Sabados e Domingos
    case DayOfWeek(dDateTime) of
      7:  aDiasUteis[ix] := 0;
      1:  aDiasUteis[ix] := 0;
    end;
    //remover Feriados Fixos
    if CalculaFeriado(Year(dDateTime), frAnoNovo) = dDateTime then
       aDiasUteis[ix] := 0;
    if CalculaFeriado(Year(dDateTime), frCarnaval) = dDateTime then
       aDiasUteis[ix] := 0;
    if CalculaFeriado(Year(dDateTime), frSextaSanta) = dDateTime then
       aDiasUteis[ix] := 0;
    if CalculaFeriado(Year(dDateTime), frQuartaCinzas) = dDateTime then
       aDiasUteis[ix] := 0;
    if CalculaFeriado(Year(dDateTime), frTiradentes) = dDateTime then
       aDiasUteis[ix] := 0;
    if CalculaFeriado(Year(dDateTime), frDiaTrabalho) = dDateTime then
       aDiasUteis[ix] := 0;
    if CalculaFeriado(Year(dDateTime), frCorpusChristi) = dDateTime then
       aDiasUteis[ix] := 0;
    if CalculaFeriado(Year(dDateTime), frIndependencia) = dDateTime then
       aDiasUteis[ix] := 0;
    if CalculaFeriado(Year(dDateTime), frNossaSenhoraAparecida) = dDateTime then
       aDiasUteis[ix] := 0;
    if CalculaFeriado(Year(dDateTime), frFinados) = dDateTime then
       aDiasUteis[ix] := 0;
    if CalculaFeriado(Year(dDateTime), frProclamacaoRepublica) = dDateTime then
       aDiasUteis[ix] := 0;
    if CalculaFeriado(Year(dDateTime), frNatal) = dDateTime then
       aDiasUteis[ix] := 0;
    if ix < iDiasMes -1 then      //Não incrementar no ultimo dia, pois pode passar da data final
      dDateTime := dDateTime + 1;
  end;

  FDQuery := TFDQuery.Create(nil);

  try

    //Busca na tabela de Feriados aqueles fixos (repetem todo ano) ou definidos para este mes corrente
    FDQuery.close;
    FDQuery.Connection := DM.con;
    FDQuery.SQL.Clear;
    FDQuery.SQL.Add('Select DataFeriado From Feriados f');
    FDQuery.SQL.Add('Where');
    FDQuery.SQL.Add('f.Codfilial = ' + IntToStr(CodFilial));
    FDQuery.SQL.Add('and (f.DataFeriado between ' + QuotedStr(FormatDateTime('YYYY-MM-DD', IniMes(dData))));

    if lAtediaCorrente then
      FDQuery.SQL.Add('and ' + QuotedStr(FormatDateTime('YYYY-MM-DD', dDateTime)) + ')')
    else
      FDQuery.SQL.Add('and ' + QuotedStr(FormatDateTime('YYYY-MM-DD', FimMes(dDateTime))) + ')');

    FDQuery.SQL.Add('or ( f.FeriadoFixo = 1');
    FDQuery.SQL.Add('and f.DataFeriado between  CAST(CONVERT(VARCHAR(10), CAST( CAST(year(DataFeriado) as CHAR(4)) + ' + QuotedStr('-'+ IntToStr(Month(IniMes(dData)))));
    FDQuery.SQL.Add(' + ' + QuotedStr('-' + IntToStr(Day(IniMes(dData)))) + ' as DATE), 101) as DATETIME)');
    FDQuery.SQL.Add('and CAST(CONVERT(VARCHAR(10), CAST( CAST(year(DataFeriado) as CHAR(4)) + ' + QuotedStr('-' + IntToStr(Month(FimMes(dDateTime)))));

    if lAtediaCorrente then
      FDQuery.SQL.Add(' + ' + QuotedStr('-' + IntToStr(Day(dDateTime)) ) + ' as DATE), 101) as DATETIME))')
    else
      FDQuery.SQL.Add(' + ' + QuotedStr('-' + IntToStr(Day(FimMes(dDateTime))) ) + ' as DATE), 101) as DATETIME))');

    FDQuery.Open;

    if not FDQuery.IsEmpty then
    begin
      FDQuery.First;

      while not FDQuery.Eof do
      begin
        aDiasUteis[Day(FDQuery.FieldByName('DataFeriado').AsDateTime)-1] := 0;
        FDQuery.Next;
      end;

    end;

  finally
    FreeAndNil(FDQuery);
  end;

  iDiasUteis := 0;
  For ix := 0 to iDiasMes -1 do
     if aDiasUteis[ix] = 1 then
        iDiasUteis := iDiasUteis +1;

  Result := iDiasUteis;
end;

procedure TrimAppMemorySize;
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

Function PadEsquerda(sString: String; iTamanho: Integer; cChar:char): String;
Var
  x    : Integer;
Begin
  sString := Trim(sString);
  x := length(sString);
  If x = iTamanho Then
    Result := sString;

  If x < iTamanho Then
  Begin
    Result := sString;

    While x < iTamanho Do
    Begin
      Result := cChar + Result;
      x := x + 1;
    End;
  End;

  If x > iTamanho Then
    Result := Copy( sString, 1, iTamanho);

End;

function modificaDataParaNomeBackup(data : TDateTime): string;
begin
  Result := DateTimeToStr(data);
  Result := StringReplace(Result, ':', '_', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '/', '_', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, ' ', '_', [rfReplaceAll, rfIgnoreCase]);
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

function formatarIntSQL(valor : Integer): String;
begin
  Result := IntToStr(valor);
end;

function formatarStrSQL(valor : String): String;
begin
  Result := QuotedStr(valor);
end;

function formatarDatSQL(valor : TDateTime): String;
var
  strValor : String;
begin

  if valor = 0 then
    strValor := 'NULL'
  else
    strValor := QuotedStr(FormatDateTime('yyyy/MM/dd hh:mm:ss', valor));

  Result := strValor;

end;

function formatarCurSQL(valor : Currency): String;
var
  strValor : String;
begin

  strValor := StringReplace(FloatToStr(valor), ',', '.', [rfReplaceAll, rfIgnoreCase]);
  Result   := strValor;

end;

function formatarBoolSQL(valor: Boolean): String;
begin

  if valor then
    Result := '1'
  else
    Result := '0';

end;

function formatarDtmSQL(valor : TDateTime): String;
var
  strValor : String;
begin

  if valor = 0 then
    strValor := 'NULL'
  else
    strValor := QuotedStr(FormatDateTime('yyyy/MM/dd hh:mm:ss', valor));

  Result := strValor;

end;

function formatarDtmSQL(valor : TDateTime; strHoraInicialFinal : string): String;
var
  strValor : String;
begin

  if valor = 0 then
    strValor := 'NULL'
  else
    strValor := QuotedStr(FormatDateTime('yyyy/MM/dd ' + Trim(strHoraInicialFinal), valor));

  Result := strValor;

end;

function topSQL(qtdeRegistros: Integer; tipoBancoDados: String; posInicio: Integer = 0; usarPaginacao: Boolean = False): String;
var
  sql : String;
begin

  if qtdeRegistros <= 0 then
  begin
    Result := '';
    Exit;
  end;

  sql := 'TOP ' + IntToStr(qtdeRegistros);

  Result := sql;

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

function StrLeft( sString : String; iQuantidade : Integer ) : String;
begin

  if iQuantidade >= 1 then
    Result := Copy( sString, 1, iQuantidade )
  else
    Result := '';

end;

end.
