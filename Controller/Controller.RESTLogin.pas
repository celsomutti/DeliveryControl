unit Controller.RESTLogin;

interface

uses Model.RESTLogin;

type
  TRESTLoginController = class
  private
    FLogin: TRESTLogin;
  public
    constructor Create;
    destructor Destroy; override;
    function UsuarioAtivo(sUsername: String): boolean;
    function ValidaLogin(sUsername: String; sPassword: String): Boolean;
  end;

implementation

{ TRESTLoginController }

constructor TRESTLoginController.Create;
begin
  FLogin := TRESTLogin.Create;
end;

destructor TRESTLoginController.Destroy;
begin
  FLogin.Free;
  inherited;
end;

function TRESTLoginController.UsuarioAtivo(sUsername: String): boolean;
begin
  Result := FLogin.UsuarioAtivo(sUsername);
end;

function TRESTLoginController.ValidaLogin(sUsername, sPassword: String): Boolean;
begin
  Result := FLogin.ValidaLogin(sUsername, sPassword);
end;

end.
