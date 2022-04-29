unit Controller.RESTEntregasDetalhe;

interface

uses Model.RESTEentregasDetalhe;

type
  TRESTEntregasDetalheController = class
  private
    FExtratos: RESTEntregaDetalhe;
  public
    constructor Create;
    destructor Destroy; override;
    function SearchEntregas(sentregador, sdata, scliente: String): Boolean;
  end;

implementation

{ TRESTEntregasDiaController }

constructor TRESTEntregasDetalheController.Create;
begin
  FExtratos := RESTEntregaDetalhe.Create;
end;

destructor TRESTEntregasDetalheController.Destroy;
begin
  FExtratos.Free;
  inherited;
end;

function TRESTEntregasDetalheController.SearchEntregas(sentregador, sdata, scliente: String): Boolean;
begin
  Result := FExtratos.SearchEntregas(sentregador, sdata, scliente);
end;

end.
