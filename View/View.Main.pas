unit View.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  System.Actions, FMX.ActnList;

type
  Tview_Main = class(TForm)
    layoutPadrao: TLayout;
    actionListMenu: TActionList;
    actionExit: TAction;
    layoutMenu: TLayout;
    rectangleExtrato: TRectangle;
    labelExtrato: TLabel;
    actionExtratos: TAction;
    rectangleBoleto: TRectangle;
    labelBoleto: TLabel;
    actionBoletos: TAction;
    layoutTitle: TLayout;
    rectangleTitle: TRectangle;
    labelTitle: TLabel;
    imageExit: TImage;
    actionEntregasDia: TAction;
    rectangleEntregasDia: TRectangle;
    labelAcampanhamento: TLabel;
    actionSuporte: TAction;
    rectangleSuporte: TRectangle;
    Label1: TLabel;
    procedure imageExitMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure actionExitExecute(Sender: TObject);
    procedure rectangleExtratoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure rectangleExtratoMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure actionExtratosExecute(Sender: TObject);
    procedure rectangleBoletoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure rectangleBoletoMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure actionBoletosExecute(Sender: TObject);
    procedure actionEntregasDiaExecute(Sender: TObject);
    procedure rectangleEntregasDiaMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure rectangleEntregasDiaMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure actionSuporteExecute(Sender: TObject);
    procedure rectangleSuporteMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure rectangleSuporteMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
  private
    { Private declarations }
    procedure OpenFormExtratos;
    procedure OpenFormBoletos;
    procedure OpenFormEntregasDia;
    procedure OpenFormSuporte;
  public
    { Public declarations }
  end;

var
  view_Main: Tview_Main;

implementation

{$R *.fmx}

uses View.Extratos, View.Boletos, View.EntregasDia, View.SuporteRemessa, Common.Params;

procedure Tview_Main.actionBoletosExecute(Sender: TObject);
begin
  OpenFormBoletos;
end;

procedure Tview_Main.actionEntregasDiaExecute(Sender: TObject);
begin
  if Common.Params.paramUserFinance = 0 then
  begin
    ShowMessage('Usuário não tem permissão para acessar este módulo!');
    Exit;
  end;
   OpenFormEntregasDia;
end;

procedure Tview_Main.actionExitExecute(Sender: TObject);
begin
  Close;
end;

procedure Tview_Main.actionExtratosExecute(Sender: TObject);
begin
  if Common.Params.paramUserFinance = 0 then
  begin
    ShowMessage('Usuário não tem permissão para acessar este módulo!');
    Exit;
  end;
  OpenFormExtratos;
end;

procedure Tview_Main.actionSuporteExecute(Sender: TObject);
begin
  OpenFormSuporte;
end;

procedure Tview_Main.imageExitMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  actionExitExecute(Sender);
end;
procedure Tview_Main.OpenFormBoletos;
begin
  if not Assigned(view_Boletos) then
  begin
    Application.CreateForm(Tview_Boletos, view_Boletos);
  end;
  view_Boletos.Show;
end;

procedure Tview_Main.OpenFormEntregasDia;
begin
  if not Assigned(view_EntregasDia) then
  begin
    Application.CreateForm(Tview_EntregasDia, view_EntregasDia);
  end;
  view_EntregasDia.Show;
end;

procedure Tview_Main.OpenFormExtratos;
begin
  if not Assigned(view_Extratos) then
  begin
    Application.CreateForm(Tview_Extratos, view_Extratos);
  end;
  view_Extratos.Show;
end;

procedure Tview_Main.OpenFormSuporte;
begin
  if not Assigned(view_SuporteRemessa) then
  begin
    Application.CreateForm(Tview_SuporteRemessa, view_SuporteRemessa);
  end;
  view_SuporteRemessa.Show;
end;

procedure Tview_Main.rectangleBoletoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  TRectangle(Sender).Opacity := 0.8;
end;

procedure Tview_Main.rectangleBoletoMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  TRectangle(Sender).Opacity := 1;
  actionBoletosExecute(Sender);
end;

procedure Tview_Main.rectangleEntregasDiaMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  TRectangle(Sender).Opacity := 0.8;
end;

procedure Tview_Main.rectangleEntregasDiaMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  TRectangle(Sender).Opacity := 1;
  actionEntregasDiaExecute(Sender);
end;

procedure Tview_Main.rectangleExtratoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  TRectangle(Sender).Opacity := 0.8;
end;

procedure Tview_Main.rectangleExtratoMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  TRectangle(Sender).Opacity := 1;
  actionExtratosExecute(Sender);
end;

procedure Tview_Main.rectangleSuporteMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  TRectangle(Sender).Opacity := 0.8;
end;

procedure Tview_Main.rectangleSuporteMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
 TRectangle(Sender).Opacity := 1;
 actionSuporteExecute(Sender);
end;

end.
