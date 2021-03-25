unit UArmazenagem;

interface

uses

  // Units Delphi
  Classes, SysUtils;

type

  TArmazenagem = class(TPersistent)

  private
    ID                    : Integer;
    PRODUTOR_ID           : Integer;
    GRAO_ID               : Integer;
    PESO_INICIAL_BRUTO    : Currency;
    PERCENTUAL_HUMIDADE   : Currency;
    PESO_FINAL            : Currency;
    PESO_FINAL_ARMAZENADO : Currency;
    VALOR_TOTAL           : Currency;
    VALIDADO              : Integer;


  public
    procedure setID(ID : Integer);
    procedure setPRODUTOR_ID(PRODUTOR_ID : Integer);
    procedure setGRAO_ID(GRAO_ID : Integer);
    procedure setPESO_INICIAL_BRUTO(PESO_INICIAL_BRUTO : Currency);
    procedure setPERCENTUAL_HUMIDADE(PERCENTUAL_HUMIDADE : Currency);
    procedure setPESO_FINAL(PESO_FINAL : Currency);
    procedure setPESO_FINAL_ARMAZENADO(PESO_FINAL_ARMAZENADO : Currency);
    procedure setVALOR_TOTAL(VALOR_TOTAL : Currency);
    procedure setVALIDADO(VALIDADO : Integer);

    function getID : Integer;
    function getPRODUTOR_ID : Integer;
    function getGRAO_ID : Integer;
    function getPESO_INICIAL_BRUTO : Currency;
    function getPERCENTUAL_HUMIDADE : Currency;
    function getPESO_FINAL : Currency;
    function getPESO_FINAL_ARMAZENADO : Currency;
    function getVALOR_TOTAL : Currency;
    function getVALIDADO : Integer;

    // Manipulação de dados
    function insert: TArmazenagem;
    function update: TArmazenagem;
    function delete: TArmazenagem;
    function getById: TArmazenagem;

  end;

implementation
uses
  UArmazenagemDAO;

// insert
function TArmazenagem.insert: TArmazenagem;
begin
  Result := TArmazenagemDAO.insert(Self);
end;

// update
function TArmazenagem.update: TArmazenagem;
begin
  Result := TArmazenagemDAO.update(Self);
end;

// delete
function TArmazenagem.delete: TArmazenagem;
begin
  Result := TArmazenagemDAO.delete(Self);
end;

// getById
function TArmazenagem.getById: TArmazenagem;
begin
  Result := TArmazenagemDAO.getById(Self);
end;

procedure TArmazenagem.setGRAO_ID(GRAO_ID: Integer);
begin
  Self.GRAO_ID := GRAO_ID;
end;

procedure TArmazenagem.setID(ID: Integer);
begin
  Self.ID := ID;
end;

procedure TArmazenagem.setPERCENTUAL_HUMIDADE(PERCENTUAL_HUMIDADE: Currency);
begin
  self.PERCENTUAL_HUMIDADE := PERCENTUAL_HUMIDADE;
end;

procedure TArmazenagem.setPESO_FINAL(PESO_FINAL: Currency);
begin
  Self.PESO_FINAL := PESO_FINAL;
end;

procedure TArmazenagem.setPESO_FINAL_ARMAZENADO(
  PESO_FINAL_ARMAZENADO: Currency);
begin
  Self.PESO_FINAL_ARMAZENADO := PESO_FINAL_ARMAZENADO;
end;

procedure TArmazenagem.setPESO_INICIAL_BRUTO(PESO_INICIAL_BRUTO: Currency);
begin
  Self.PESO_INICIAL_BRUTO := PESO_INICIAL_BRUTO;
end;

procedure TArmazenagem.setPRODUTOR_ID(PRODUTOR_ID: Integer);
begin
  Self.PRODUTOR_ID := PRODUTOR_ID;
end;

procedure TArmazenagem.setVALIDADO(VALIDADO: Integer);
begin
  Self.VALIDADO := VALIDADO;
end;

procedure TArmazenagem.setVALOR_TOTAL(VALOR_TOTAL: Currency);
begin
  Self.VALOR_TOTAL := VALOR_TOTAL;
end;

function TArmazenagem.getGRAO_ID: Integer;
begin
  Result := Self.GRAO_ID;
end;

function TArmazenagem.getID: Integer;
begin
  Result := Self.ID;
end;

function TArmazenagem.getPERCENTUAL_HUMIDADE: Currency;
begin
  Result := Self.PERCENTUAL_HUMIDADE;
end;

function TArmazenagem.getPESO_FINAL: Currency;
begin
  Result := Self.PESO_FINAL;
end;

function TArmazenagem.getPESO_FINAL_ARMAZENADO: Currency;
begin
  Result := Self.PESO_FINAL_ARMAZENADO;
end;

function TArmazenagem.getPESO_INICIAL_BRUTO: Currency;
begin
  Result := Self.PESO_INICIAL_BRUTO;
end;

function TArmazenagem.getPRODUTOR_ID: Integer;
begin
  Result := self.PRODUTOR_ID;
end;

function TArmazenagem.getVALIDADO: Integer;
begin
  Result := Self.VALIDADO;
end;

function TArmazenagem.getVALOR_TOTAL: Currency;
begin
  Result := Self.VALOR_TOTAL;
end;

end.
