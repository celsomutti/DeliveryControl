unit Model.RESTLogin;

interface

uses Web.HTTPApp, System.JSON, REST.Types, System.SysUtils, System.Classes;

type
  TRESTLogin = class
  private
    procedure StartRestClient(sFile: String);
    procedure StartRestRequest(sFile: String);
  public
    function UsuarioAtivo(sUsername: String): boolean;
    function ValidaLogin(sUsername: String; sPassword: String): Boolean;
  end;
const
  API = '/api/dc';

implementation

uses Common.Notificacao, Common.Params, DM.Main;

{ TRESTLogin }

procedure TRESTLogin.StartRestClient(sFile: String);
begin
  DM_Main.RESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  DM_Main.RESTClient.AcceptCharset := 'utf-8, *;q=0.8';
  DM_Main.RESTClient.BaseURL := Common.Params.paramBaseURL + API + sFile;
  DM_Main.RESTClient.RaiseExceptionOn500 := False;
end;

procedure TRESTLogin.StartRestRequest(sFile: String);
begin
  StartRestClient(sFile);
  DM_Main.RESTRequest.Client := DM_Main.RESTClient;
  DM_Main.RESTRequest.Accept := DM_Main.RESTClient.Accept;
  DM_Main.RESTRequest.AcceptCharset := DM_Main.RESTClient.AcceptCharset;
  DM_Main.RESTRequest.Method := rmPOST;
end;

function TRESTLogin.UsuarioAtivo(sUsername: String): boolean;
var
  sretorno: string;
begin
  Result  := False;
  StartRestRequest('/dc_usuario_ativo.php');
  DM_Main.RESTRequest.AddParameter('cpf', sUserName, pkGETorPOST);
  DM_Main.RESTRequest.Execute;
  sretorno := DM_Main.RESTRequest.Response.JSONText;
  if sretorno = 'false' then
  begin
    Exit;
  end;
  Result := True;
end;

function TRESTLogin.ValidaLogin(sUsername, sPassword: String): Boolean;
var
  jsonObj, jo: TJSONObject;
  jvEMail: TJSONValue;
  ja: TJSONArray;
  i: integer;
  sretorno: string;
begin
  Result  := False;
  StartRestRequest('/dc_login.php');
  DM_Main.RESTRequest.AddParameter('username', sUserName, pkGETorPOST);
  DM_Main.RESTRequest.AddParameter('password', sPassword, pkGETorPOST);
  DM_Main.RESTRequest.Execute;
  sretorno := DM_Main.RESTRequest.Response.JSONText;
  if sretorno = 'false' then
  begin
    Exit;
  end;
  if DM_Main.RESTResponse.JSONValue is TJSONArray then
  begin
    ja := DM_Main.RESTResponse.JSONValue as TJSONArray;
    jsonObj := (ja.Get(0) as TJSONObject);
    jvEMail := jsonObj.Get(3).JsonValue;
    Common.Params.paramEMailEntregador := jvEMail.Value;
  end
  else
  begin
    Exit;
  end;
  Result := True;
end;

end.
