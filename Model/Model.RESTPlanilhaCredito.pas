unit Model.RESTPlanilhaCredito;

interface

uses Web.HTTPApp, System.JSON, REST.Types, System.SysUtils, System.Classes;

type
  TRESTPlanilhaCredito = class
  private
    procedure StartRestClient(sFile: String);
    procedure StartRestRequest(sFile: String);
  public
    function SearchDatas(sEntregador: String): Boolean;
    function SearchValorBoleto(sentregador, sData: String): String;
    function SalvaStatusBoleto(sExtrato: String): boolean;
  end;
const
  API = '/api/dc';

implementation

uses Common.Notificacao, Common.Params, DM.Main;

{ TRESTPlanilhaCredito }

function TRESTPlanilhaCredito.SearchValorBoleto(sentregador, sData: String): String;
var
  sretorno: string;
  jsonObj, jo: TJSONObject;
  jvValor, jvExtrato: TJSONValue;
  ja: TJSONArray;
  sDataConv: String;
  i: integer;
begin
  Result  := '0';
  sDataConv := FormatDateTime('yyyy-mm-dd', StrToDate(sData));
  StartRestRequest('/dc_valor_boleto.php');
  DM_Main.RESTRequest.AddParameter('entregador', sEntregador, pkGETorPOST);
  DM_Main.RESTRequest.AddParameter('data', sDataConv, pkGETorPOST);
  DM_Main.RESTResponseDataSetAdapter.Active := False;
  DM_Main.RESTRequest.Execute;
  sretorno := DM_Main.RESTResponse.Content;
  if sretorno = 'false' then
  begin
    Exit;
  end;
  if DM_Main.RESTResponse.JSONValue is TJSONArray then
  begin
    ja := DM_Main.RESTResponse.JSONValue as TJSONArray;
    jsonObj := (ja.Get(0) as TJSONObject);
    jvValor := jsonObj.Get(1).JsonValue;
    jvExtrato := jsonObj.Get(0).JsonValue;
    sretorno := jvValor.Value;
    Common.Params.paramNumeroExtrato := jvExtrato.Value;
  end
  else
  begin
    Exit;
  end;
  Result := sretorno;
end;

procedure TRESTPlanilhaCredito.StartRestClient(sFile: String);
begin
  DM_Main.RESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  DM_Main.RESTClient.AcceptCharset := 'utf-8, *;q=0.8';
  DM_Main.RESTClient.BaseURL := Common.Params.paramBaseURL + API + sFile;
  DM_Main.RESTClient.RaiseExceptionOn500 := False;
end;

procedure TRESTPlanilhaCredito.StartRestRequest(sFile: String);
begin
  StartRestClient(sFile);
  DM_Main.RESTRequest.Client := DM_Main.RESTClient;
  DM_Main.RESTRequest.Accept := DM_Main.RESTClient.Accept;
  DM_Main.RESTRequest.AcceptCharset := DM_Main.RESTClient.AcceptCharset;
  DM_Main.RESTRequest.Method := rmPOST;
end;

function TRESTPlanilhaCredito.SalvaStatusBoleto(sExtrato: String): boolean;
begin
  Result := False;
  StartRestRequest('/dc_salva_status_boleto.php');
  DM_Main.RESTRequest.AddParameter('extrato', sExtrato, pkGETorPOST);
  DM_Main.RESTResponseDataSetAdapter.Active := False;
  DM_Main.RESTRequest.Execute;
  if DM_Main.RESTResponse.JSONText = 'false' then
  begin
    Exit;
  end;
  Result := True;
end;

function TRESTPlanilhaCredito.SearchDatas(sEntregador: String): Boolean;
begin
  Result  := False;
  StartRestRequest('/dc_datas_creditos.php');
  DM_Main.RESTRequest.AddParameter('entregador', sEntregador, pkGETorPOST);
  DM_Main.RESTResponseDataSetAdapter.Dataset := DM_Main.memTableDatasCreditos;
  DM_Main.RESTResponseDataSetAdapter.Active := True;
  DM_Main.RESTRequest.Execute;
  if DM_Main.memTableDatasCreditos.IsEmpty then
  begin
    Exit;
  end;
  Result := True;
end;

end.
