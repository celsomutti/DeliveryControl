unit Controller.RESTPlanilhaCredito;

interface

uses Model.RESTPlanilhaCredito;

type
  TRESTPlanilhaCreditoController = class
  private
    FPlanilha: TRESTPlanilhaCredito;
  public
    constructor Create;
    destructor Destroy; override;
    function SearchDatas(sEntregador: String): Boolean;
    function SearchValorBoleto(sentregador, sData: String): String;
    function SalvaStatusBoleto(sExtrato: String): boolean;
  end;

implementation

{ TRESTPlanilhaCreditoController }

constructor TRESTPlanilhaCreditoController.Create;
begin
  FPlanilha := TRESTPlanilhaCredito.Create;
end;

destructor TRESTPlanilhaCreditoController.Destroy;
begin
  FPlanilha.Free;
  inherited;
end;

function TRESTPlanilhaCreditoController.SalvaStatusBoleto(sExtrato: String): boolean;
begin
  Result := FPlanilha.SalvaStatusBoleto(sExtrato);
end;

function TRESTPlanilhaCreditoController.SearchDatas(sEntregador: String): Boolean;
begin
  Result := FPlanilha.SearchDatas(sEntregador);
end;

function TRESTPlanilhaCreditoController.SearchValorBoleto(sentregador, sData: String): String;
begin
  Result := FPlanilha.SearchValorBoleto(sentregador, sData);
end;

end.
