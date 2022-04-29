unit View.SuporteReadCode;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  System.Actions, FMX.ActnList, FMX.ListBox, FMX.Edit, FMX.EditBox, FMX.NumberBox, System.DateUtils, FMX.ComboEdit,
  Data.DB, System.Rtti, FMX.Grid.Style, FMX.ScrollBox,
  FMX.Grid, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.Grid,
  Data.Bind.DBScope, Controller.RESTExtravios, Controller.RESTEntregasDia,
  FMX.DateTimeCtrls, FMX.CodeReader;

type
  Tview_SuporteReadCode = class(TForm)
    layoutPadrao: TLayout;
    layoutFiltro: TLayout;
    layoutFooter: TLayout;
    layoutTitle: TLayout;
    rectangleTitle: TRectangle;
    imageExit: TImage;
    labelTitle: TLabel;
    labelDescricao: TLabel;
    editParameterRead: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    actionList: TActionList;
    actionStart: TAction;
    actionStop: TAction;
    codeReader: TCodeReader;
    procedure imageExitMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure FormShow(Sender: TObject);
    procedure actionStartExecute(Sender: TObject);
    procedure actionStopExecute(Sender: TObject);
    procedure codeReaderStart(Sender: TObject);
    procedure codeReaderStop(Sender: TObject);
    procedure codeReaderCodeReady(aCode: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  view_SuporteReadCode: Tview_SuporteReadCode;

implementation

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}

uses DM.Main, Common.Params, Common.Notificacao;

procedure Tview_SuporteReadCode.actionStartExecute(Sender: TObject);
begin
  codeReader.Start;
end;

procedure Tview_SuporteReadCode.actionStopExecute(Sender: TObject);
begin
  codeReader.Stop;
end;

procedure Tview_SuporteReadCode.codeReaderCodeReady(aCode: string);
begin
  Common.Params.paramResultReadCode := codeReader.Text;
  Close;
end;

procedure Tview_SuporteReadCode.codeReaderStart(Sender: TObject);
begin
  actionStart.Enabled := False;
  actionStop.Enabled := True;
end;

procedure Tview_SuporteReadCode.codeReaderStop(Sender: TObject);
begin
  actionStart.Enabled := True;
  actionStop.Enabled := False;
end;

procedure Tview_SuporteReadCode.FormShow(Sender: TObject);
begin
  labelDescricao.Text := Self.Caption;
end;

procedure Tview_SuporteReadCode.imageExitMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  Close;
end;

end.
