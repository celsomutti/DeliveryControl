unit Model.Users;

interface

uses  System.SysUtils, System.Classes, REST.Types, REST.Client, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

  type
    TUsers = class
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    memTableUsers: TFDMemTable;
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
      procedure StartRestClient;
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
  API = '/API/dc';

implementation

{ TUsers }

procedure TUsers.StartRestClient;
begin
  RESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  RESTClient.AcceptCharset := 'utf-8, *;q=0.8';
  RESTClient.BaseURL := 'http://www.rjsmart.com.br' + API;
  RESTClient.RaiseExceptionOn500 := False;
end;

function TUsers.ValidaLogin(sUsername, sPassword: String): Boolean;
begin
  StartRestClient;

end;

end.
