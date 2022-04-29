unit Controller.RESTEntregasDia;

interface

uses Model.RESTEentregasDia;

type
  TRESTEntregasDiaController = class
  private
    FExtratos: RESTEntregasDia;
  public
    constructor Create;
    destructor Destroy; override;
    function SearchEntregas(sentregador, sdataini, sdatafim: String): Boolean;
  end;

implementation

{ TRESTEntregasDiaController }

constructor TRESTEntregasDiaController.Create;
begin
  FExtratos := RESTEntregasDia.Create;
end;

destructor TRESTEntregasDiaController.Destroy;
begin
  FExtratos.Free;
  inherited;
end;

function TRESTEntregasDiaController.SearchEntregas(sentregador, sdataini, sdatafim: String): Boolean;
begin
  Result := FExtratos.SearchEntregas(sEntregador, sdataini, sdatafim);
end;

end.
