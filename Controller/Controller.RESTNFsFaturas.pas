unit Controller.RESTNFsFaturas;

interface

uses Model.RESTNFsFaturas;

type
  TRESTNFsFaturasController = class
  private
    FFaturas: TRESTNFsFaturas;
  public
    constructor Create;
    destructor Destroy; override;
    function SalvaNfsFatura(sCadastro, sVencimento, sArquivo, sLocalizacao: String): boolean;
  end;

implementation

{ TRESTNFsFaturasController }

constructor TRESTNFsFaturasController.Create;
begin
  FFaturas := TRESTNFsFaturas.Create;
end;

destructor TRESTNFsFaturasController.Destroy;
begin
  FFaturas.Free;
  inherited;
end;

function TRESTNFsFaturasController.SalvaNFsFatura(sCadastro, sVencimento, sArquivo, sLocalizacao: String): boolean;
begin
  Result := FFaturas.SalvaNFsFatura(sCadastro, sVencimento, sArquivo, sLocalizacao);
end;

end.
