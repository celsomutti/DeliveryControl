unit Controller.RESTCadastro;

interface

uses Model.RESTCadastro;

type
  TRESTCadastroController = class
  private
    FCadastro: TRESTCadastro;
  public
    constructor Create;
    destructor Destroy; override;
    function SalvaCadastro(sCpfCnpj, sUserName, sName, sPassword, sEmail: String): boolean;
    function UsuarioExiste(sCPF: String): Boolean;
    function CPFValido(sCPF: string): boolean;
    function RetornaEntregadores(iCadastro: integer): Boolean;
  end;

implementation

{ TRESTCadastroController }

function TRESTCadastroController.CPFValido(sCPF: string): boolean;
begin
  Result := FCadastro.CPFValido(sCPF);
end;

constructor TRESTCadastroController.Create;
begin
  FCadastro := TRESTCadastro.Create;
end;

destructor TRESTCadastroController.Destroy;
begin
  FCadastro.Free;
  inherited;
end;


function TRESTCadastroController.RetornaEntregadores(iCadastro: integer): Boolean;
begin
  Result := FCadastro.RetornaEntregadores(iCadastro);
end;

function TRESTCadastroController.SalvaCadastro(sCpfCnpj, sUserName, sName, sPassword, sEmail: String): boolean;
begin
  Result := FCadastro.SalvaCadastro(sCpfCnpj, sUserName, sName, sPassword, sEmail);
end;

function TRESTCadastroController.UsuarioExiste(sCPF: String): Boolean;
begin
  Result := FCadastro.UsuarioExiste(sCPF);
end;

end.
