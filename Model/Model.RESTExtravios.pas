unit Model.RESTExtravios;

interface

uses Web.HTTPApp, System.JSON, REST.Types, System.SysUtils, System.Classes;

type
  TRESTExtravios = class
  private
    procedure StartRestClient(sFile: String);
    procedure StartRestRequest(sFile: String);
  public
    function SearchExtraviosEntregador(sentregador: String): Boolean;
    function SearchExtraviosExtrato(sextrato: String): Boolean;
  end;
const
  API = '/api/dc';

implementation

uses Common.Notificacao, Common.Params, DM.Main;

{ TRESTExtravios }

function TRESTExtravios.SearchExtraviosExtrato(sextrato: String): Boolean;
begin
  Result  := False;
  StartRestRequest('/dc_extravios_extrato.php');
  DM_Main.RESTResponseDataSetAdapter.Dataset := DM_Main.memTableExtrato;
  DM_Main.RESTRequest.AddParameter('extratos', sextrato, pkGETorPOST);
  DM_Main.RESTResponseDataSetAdapter.Dataset := DM_Main.memTableExtravios;
  DM_Main.RESTResponseDataSetAdapter.Active := True;
  DM_Main.RESTRequest.Execute;
  if DM_Main.memTableExtravios.IsEmpty then Exit;
  Result := True;
end;

procedure TRESTExtravios.StartRestClient(sFile: String);
begin
  DM_Main.RESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  DM_Main.RESTClient.AcceptCharset := 'utf-8, *;q=0.8';
  DM_Main.RESTClient.BaseURL := Common.Params.paramBaseURL + API + sFile;
  DM_Main.RESTClient.RaiseExceptionOn500 := False;
end;

procedure TRESTExtravios.StartRestRequest(sFile: String);
begin
  StartRestClient(sfile);
  DM_Main.RESTRequest.Client := DM_Main.RESTClient;
  DM_Main.RESTRequest.Accept := DM_Main.RESTClient.Accept;
  DM_Main.RESTRequest.AcceptCharset := DM_Main.RESTClient.AcceptCharset;
  DM_Main.RESTRequest.Method := rmPOST;
end;

function TRESTExtravios.SearchExtraviosEntregador(sentregador: String): Boolean;
begin
  Result  := False;
  StartRestRequest('/dc_extravios_entregador.php');
  DM_Main.RESTResponseDataSetAdapter.Dataset := DM_Main.memTableExtrato;
  DM_Main.RESTRequest.AddParameter('entregador', sentregador, pkGETorPOST);
  DM_Main.RESTResponseDataSetAdapter.Dataset := DM_Main.memTableExtravios;
  DM_Main.RESTResponseDataSetAdapter.Active := True;
  DM_Main.RESTRequest.Execute;
  if DM_Main.memTableExtravios.IsEmpty then Exit;
  Result := True;
end;

end.
