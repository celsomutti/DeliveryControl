unit Controller.RESTEntregas;

interface

uses Model.RESTEentregas;

type
  TRESTEntregassController = class
  private
    FExtratos: RESTEntregas;
  public
    constructor Create;
    destructor Destroy; override;
    function SearchEntregas(sentregador, sdataini, sdatafim: String): Boolean;
  end;

implementation

{ TRESTEntregassController }

constructor TRESTEntregassController.Create;
begin
  FExtratos := RESTEntregas.Create;
end;

destructor TRESTEntregassController.Destroy;
begin
  FExtratos.Free;
  inherited;
end;

function TRESTEntregassController.SearchEntregas(sentregador, sdataini, sdatafim: String): Boolean;
begin
  Result := FExtratos.SearchEntregas(sEntregador, sdataini, sdatafim);
end;

end.
