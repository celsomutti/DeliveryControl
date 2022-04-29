unit Model.Usuarios;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, REST.Types, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Web.HTTPApp, System.JSON,
  FMx.Dialogs, DM.Main;

  type
    TUsuarios = class
    private
      FEMail: String;
      FAtivo: String;
      FExecutor: String;
      FCodigo: integer;
      FDiasExpira: Integer;
      FDataSenha: TDate;
      FNivel: Integer;
      FPrivilegio: String;
      FSenha: String;
      FManutencao: TDateTime;
      FPrimeiroAcesso: String;
      FLogin: String;
      FExpira: String;
      FNome: String;
      FGrupo: Integer;
      procedure StartRestClient(sFile: String);
      procedure StartRestRequest;
      procedure PopuleUsersModel(orow: TJSONObject);
    public
      property Codigo: integer read FCodigo write FCodigo;
      property Nome: String read FNome write FNome;
      property Login: String read FLogin write FLogin;
      property EMail: String read FEMail write FEMail;
      property Senha: String read FSenha write FSenha;
      property Grupo: Integer read FGrupo write FGrupo;
      property Privilegio: String read FPrivilegio write FPrivilegio;
      property Expira: String read FExpira write FExpira;
      property DiasExpira: Integer read FDiasExpira write FDiasExpira;
      property PrimeiroAcesso: String read FPrimeiroAcesso write FPrimeiroAcesso;
      property Ativo: String read FAtivo write FAtivo;
      property DataSenha: TDate read FDataSenha write FDataSenha;
      property Nivel: Integer read FNivel write FNivel;
      property Executor: String read FExecutor write FExecutor;
      property Manutencao: TDateTime read FManutencao write FManutencao;
      function ValidaLogin(sUsername: String; sPassword: String): Boolean;
    end;
const
  API = '/api/dc';

implementation

{ TUsuarios }

uses Common.Params;

procedure TUsuarios.PopuleUsersModel(orow: TJSONObject);
begin
  FCodigo := orow.GetValue('COD_USUARIO').Value.ToInteger;
  FNome := orow.GetValue('NOM_USUARIO').Value;
  FLogin := orow.GetValue('DES_LOGIN').Value;
  FEMail := orow.GetValue('DES_EMAIL').Value;
  FSenha := orow.GetValue('DES_SENHA').Value;
  FGrupo := orow.GetValue('COD_GRUPO').Value.ToInteger;
  FPrivilegio := orow.GetValue('DOM_PRIVILEGIO').Value;
  FExpira := orow.GetValue('DOM_EXPIRA').Value;
  FDiasExpira := orow.GetValue('QTD_DIAS_EXPIRA').Value.ToInteger;
  FPrimeiroAcesso := orow.GetValue('DOM_PRIMEIRO_ACESSO').Value;
  FAtivo :=  orow.GetValue('DOM_ATIVO').Value;
  FDataSenha := StrToDate(orow.GetValue('DAT_SENHA').Value);
  FNivel := orow.GetValue('COD_NIVEL').Value.ToInteger;
  FExecutor := orow.GetValue('NOM_EXECUTOR').Value;
  FManutencao := StrToDateTime(orow.GetValue('DAT_MANUTENCAO').Value);
end;

procedure TUsuarios.StartRestClient(sFile: String);
begin
  DM_Main.RESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  DM_Main.RESTClient.AcceptCharset := 'utf-8, *;q=0.8';
  DM_Main.RESTClient.BaseURL := Common.Params.paramBaseURL + API + sFile;
  DM_Main.RESTClient.RaiseExceptionOn500 := False;
end;

procedure TUsuarios.StartRestRequest;
begin
  StartRestClient('/dc_login.php');
  DM_Main.RESTRequest.Client := DM_Main.RESTClient;
  DM_Main.RESTRequest.Accept := DM_Main.RESTClient.Accept;
  DM_Main.RESTRequest.AcceptCharset := DM_Main.RESTClient.AcceptCharset;
  DM_Main.RESTRequest.Method := rmPOST;
end;

function TUsuarios.ValidaLogin(sUsername, sPassword: String): Boolean;
var
  oretorno: TJSONArray;
  sretorno: string;
  orow : TJSONObject;
begin
  Result  := False;
  StartRestRequest;
  DM_Main.RESTRequest.AddParameter('username', sUserName, pkGETorPOST);
  DM_Main.RESTRequest.AddParameter('password', sPassword, pkGETorPOST);
  DM_Main.RESTRequest.Execute;
  sretorno := DM_Main.RESTRequest.Response.JSONText;
  if sretorno = 'false' then
  begin
    Exit;
  end;
  oretorno := DM_Main.RESTRequest.Response.JSONValue as TJSONArray;
  orow := oretorno.Items[0] as TJSONObject;
  PopuleUsersModel(orow);
  Result := True;
end;

end.
