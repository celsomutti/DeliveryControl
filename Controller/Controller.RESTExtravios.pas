unit Controller.RESTExtravios;

interface

uses Model.RESTExtravios;

type
  TRESTExtraviossController = class
  private
    FExtratos: TRESTExtravios;
  public
    constructor Create;
    destructor Destroy; override;
    function SearchExtraviosEntregador(sentregador: String): Boolean;
    function SearchExtraviosExtrato(sextrato: String): Boolean;
  end;

implementation

{ TRESTExtraviossController }

constructor TRESTExtraviossController.Create;
begin
  FExtratos := TRESTExtravios.Create;
end;

destructor TRESTExtraviossController.Destroy;
begin
  FExtratos.Free;
  inherited;
end;

function TRESTExtraviossController.SearchExtraviosEntregador(sentregador: String): Boolean;
begin
  Result :=  FExtratos.SearchExtraviosEntregador(sentregador);
end;

function TRESTExtraviossController.SearchExtraviosExtrato(sextrato: String): Boolean;
begin
  Result := FExtratos.SearchExtraviosExtrato(sextrato);
end;

end.
