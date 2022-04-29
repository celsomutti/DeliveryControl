unit Controller.RESTBoletos;

interface

uses Model.RESTBoletos;

type
  TRESTBoletosController = class
  private
    FBoletos: TRESTBoletos;
  public
    constructor Create;
    destructor Destroy; override;
    function SalvaBoleto(sExtrato, sData, sLinha, sValor, sEntregador, sUserName: String): boolean;
    function BoletoExiste(sLinha: String): boolean;
    function ListaBoletos(sentregador: String): Boolean;
    function BaixaBoleto(sLinha, sUserName: String): boolean;
  end;

implementation

{ TRESTBoletosController }

function TRESTBoletosController.BaixaBoleto(sLinha, sUserName: String): boolean;
begin
  Result := FBoletos.BaixaBoleto(sLinha, sUserName);
end;

function TRESTBoletosController.BoletoExiste(sLinha: String): boolean;
begin
  Result := FBoletos.BoletoExiste(sLinha);
end;

constructor TRESTBoletosController.Create;
begin
  FBoletos := TRESTBoletos.Create;
end;

destructor TRESTBoletosController.Destroy;
begin
  FBoletos.Free;
  inherited;
end;

function TRESTBoletosController.ListaBoletos(sentregador: String): Boolean;
begin
  Result := FBoletos.ListaBoletos(sentregador);
end;

function TRESTBoletosController.SalvaBoleto(sExtrato, sData, sLinha, sValor, sEntregador, sUserName: String): boolean;
begin
  Result := FBoletos.SalvaBoleto(sExtrato, sData, sLinha, sValor, sEntregador, sUserName);
end;

end.
