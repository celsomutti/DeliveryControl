unit Controller.Usuarios;

interface

uses Model.Usuarios;

  Type
    TUsuariosController = class
    private
      FUsers : TUsuarios;
      constructor Create;
      destructor Destroy; override;
    public
      property Users: TUsuarios read FUsers write FUsers;
      function ValidaLogin(sUsername: String; sPassword: String): Boolean;
    end;

implementation

{ TUsuariosController }

constructor TUsuariosController.Create;
begin
  FUsers := TUsuarios.Create();
end;

destructor TUsuariosController.Destroy;
begin
  FUsers.Free;
  inherited;
end;

function TUsuariosController.ValidaLogin(sUsername, sPassword: String): Boolean;
begin
  Result := FUsers.ValidaLogin(sUsername,sPassword);
end;

end.
