unit Model.RESTBoletos;

interface

uses Web.HTTPApp, System.JSON, REST.Types, System.SysUtils, System.Classes;

type
  TRESTBoletos = class
  private
    procedure StartRestClient(sFile: String);
    procedure StartRestRequest(sFile: String);
  public
    function SalvaBoleto(sExtrato, sData, sLinha, sValor, sEntregador, sUserName: String): boolean;
    function BoletoExiste(sLinha: String): boolean;
    function ListaBoletos(sentregador: String): Boolean;
    function BaixaBoleto(sLinha, sUserName: String): boolean;
  end;
const
  API = '/api/dc';

implementation

uses Common.Notificacao, Common.Params, DM.Main;

{ TRESTBoletos }

procedure TRESTBoletos.StartRestClient(sFile: String);
begin
  DM_Main.RESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  DM_Main.RESTClient.AcceptCharset := 'utf-8, *;q=0.8';
  DM_Main.RESTClient.BaseURL := Common.Params.paramBaseURL + API + sFile;
  DM_Main.RESTClient.RaiseExceptionOn500 := False;
end;

procedure TRESTBoletos.StartRestRequest(sFile: String);
begin
  StartRestClient(sFile);
  DM_Main.RESTRequest.Client := DM_Main.RESTClient;
  DM_Main.RESTRequest.Accept := DM_Main.RESTClient.Accept;
  DM_Main.RESTRequest.AcceptCharset := DM_Main.RESTClient.AcceptCharset;
  DM_Main.RESTRequest.Method := rmPOST;
end;

function TRESTBoletos.BaixaBoleto(sLinha, sUserName: String): boolean;
begin
  Result := False;
  StartRestRequest('/dc_baixa_boleto.php');
  DM_Main.RESTRequest.AddParameter('linha', sLinha, pkGETorPOST);
  DM_Main.RESTRequest.AddParameter('username', sUserName, pkGETorPOST);
  DM_Main.RESTResponseDataSetAdapter.Active := False;
  DM_Main.RESTRequest.Execute;
  if DM_Main.RESTResponse.JSONText = 'false' then
  begin
    Exit;
  end;
  Result := True;
end;

function TRESTBoletos.BoletoExiste(sLinha: String): boolean;
begin
  Result := False;
  StartRestRequest('/dc_boleto_existe.php');
  DM_Main.RESTRequest.AddParameter('linha', sLinha, pkGETorPOST);
  DM_Main.RESTResponseDataSetAdapter.Active := False;
  DM_Main.RESTRequest.Execute;
  if DM_Main.RESTResponse.JSONText = 'false' then
  begin
    Exit;
  end;
  Result := True;
end;

function TRESTBoletos.ListaBoletos(sentregador: String): Boolean;
begin
  Result := False;
  StartRestRequest('/dc_lista_boletos_abertos.php');
  DM_Main.RESTRequest.AddParameter('entregador', sentregador, pkGETorPOST);
  DM_Main.RESTResponseDataSetAdapter.Dataset := DM_Main.memTableBoletos;
  DM_Main.RESTResponseDataSetAdapter.Active := True;
  DM_Main.RESTRequest.Execute;
  if DM_Main.RESTResponse.JSONText = 'false' then
  begin
    Exit;
  end;
  Result := True;
end;

function TRESTBoletos.SalvaBoleto(sExtrato, sData, sLinha, sValor, sEntregador, sUserName: String): boolean;
begin
  Result := False;
  StartRestRequest('/dc_salva_boleto.php');
  DM_Main.RESTRequest.AddParameter('extrato', sExtrato, pkGETorPOST);
  DM_Main.RESTRequest.AddParameter('data', sData, pkGETorPOST);
  DM_Main.RESTRequest.AddParameter('linha', sLinha, pkGETorPOST);
  DM_Main.RESTRequest.AddParameter('valor', sValor, pkGETorPOST);
  DM_Main.RESTRequest.AddParameter('entregador', sEntregador, pkGETorPOST);
  DM_Main.RESTRequest.AddParameter('username', sUserName, pkGETorPOST);
  DM_Main.RESTResponseDataSetAdapter.Active := False;
  DM_Main.RESTRequest.Execute;
  if DM_Main.RESTResponse.JSONText = 'false' then
  begin
    Exit;
  end;
  Result := True;
end;

end.
