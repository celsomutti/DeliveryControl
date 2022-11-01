unit Model.RESTNFsFaturas;

interface

uses Web.HTTPApp, System.JSON, REST.Types, System.SysUtils, System.Classes;

type
  TRESTNFsFaturas = class
  private
    procedure StartRestClient(sFile: String);
    procedure StartRestRequest(sFile: String);
  public
    function SalvaNFsFatura(sCadastro, sVencimento, sArquivo, sLocalizacao: String): boolean;
  end;
const
  API = '/api/dc';

implementation

uses Common.Notificacao, Common.Params, DM.Main;

{ TRESTNFsFaturas }

procedure TRESTNFsFaturas.StartRestClient(sFile: String);
begin
  DM_Main.RESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  DM_Main.RESTClient.AcceptCharset := 'utf-8, *;q=0.8';
  DM_Main.RESTClient.BaseURL := Common.Params.paramBaseURL + API + sFile;
  DM_Main.RESTClient.RaiseExceptionOn500 := False;
end;

procedure TRESTNFsFaturas.StartRestRequest(sFile: String);
begin
  StartRestClient(sFile);
  DM_Main.RESTRequest.Client := DM_Main.RESTClient;
  DM_Main.RESTRequest.Accept := DM_Main.RESTClient.Accept;
  DM_Main.RESTRequest.AcceptCharset := DM_Main.RESTClient.AcceptCharset;
  DM_Main.RESTRequest.Method := rmPOST;
end;

function TRESTNFsFaturas.SalvaNFsFatura(sCadastro, sVencimento, sArquivo, sLocalizacao: String): boolean;
begin
  Result := False;
  StartRestRequest('/dc_salva_nfs_faturas.php');
  DM_Main.RESTRequest.AddParameter('cadastro', sCadastro, pkGETorPOST);
  DM_Main.RESTRequest.AddParameter('dataVencimento', sVencimento, pkGETorPOST);
  DM_Main.RESTRequest.AddParameter('arquivo', sArquivo, pkGETorPOST);
  DM_Main.RESTRequest.AddParameter('localizacao', sLocalizacao, pkGETorPOST);
  DM_Main.RESTResponseDataSetAdapter.Active := False;
  DM_Main.RESTRequest.Execute;
  if DM_Main.RESTResponse.JSONText = 'false' then
  begin
    Exit;
  end;
  Result := True;
end;

end.
