unit Model.RESTEentregasDia;

interface

uses Web.HTTPApp, System.JSON, REST.Types, System.SysUtils, System.Classes, FMX.Dialogs;

type
  RESTEntregasDia = class
  private
    procedure StartRestClient(sFile: String);
    procedure StartRestRequest;
  public
    function SearchEntregas(sentregador, sdataini, sdatafim: String): Boolean;
  end;
const
  API = '/api/dc';

implementation

uses Common.Notificacao, Common.Params, DM.Main;

{ RESTEntregas }

procedure RESTEntregasDia.StartRestClient(sFile: String);
begin
  DM_Main.RESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  DM_Main.RESTClient.AcceptCharset := 'utf-8, *;q=0.8';
  DM_Main.RESTClient.BaseURL := Common.Params.paramBaseURL + API + sFile;
  DM_Main.RESTClient.RaiseExceptionOn500 := False;
end;

procedure RESTEntregasDia.StartRestRequest;
begin
  StartRestClient('/dc_entregas_dia.php');
  DM_Main.RESTRequest.Client := DM_Main.RESTClient;
  DM_Main.RESTRequest.Accept := DM_Main.RESTClient.Accept;
  DM_Main.RESTRequest.AcceptCharset := DM_Main.RESTClient.AcceptCharset;
  DM_Main.RESTRequest.Method := rmPOST;
end;

function RESTEntregasDia.SearchEntregas(sentregador, sdataini, sdatafim: String): Boolean;
begin
  Result  := False;
  StartRestRequest;
  DM_Main.RESTRequest.AddParameter('entregador', sentregador, pkGETorPOST);
  DM_Main.RESTRequest.AddParameter('dataini', sdataini, pkGETorPOST);
  DM_Main.RESTRequest.AddParameter('datafim', sdatafim, pkGETorPOST);
  DM_Main.RESTResponseDataSetAdapter.Dataset := DM_Main.memTableEntregasDia;
  DM_Main.RESTResponseDataSetAdapter.Active := True;
  DM_Main.RESTRequest.Execute;
  if DM_Main.memTableEntregasDia.IsEmpty then Exit;
  Result := True;
end;

end.
