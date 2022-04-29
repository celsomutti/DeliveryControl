unit Controller.RESTSuportTracking;

interface

uses Model.RESTSuportTracking;

type
  TRESTSuportTrackingController = class
  private
    FTracking: TRESTSuportTracking;
  public
    constructor Create;
    destructor Destroy; override;
    function SearchTracking(sValue: String): Boolean;
  end;

implementation

{ TRESTSuportTrackingController }

constructor TRESTSuportTrackingController.Create;
begin
  FTracking := TRESTSuportTracking.Create;
end;

destructor TRESTSuportTrackingController.Destroy;
begin
  FTracking.Free;
  inherited;
end;

function TRESTSuportTrackingController.SearchTracking(sValue: String): Boolean;
begin
  Result := FTracking.SearchTracking(sValue);
end;

end.
