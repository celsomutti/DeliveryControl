unit View.SuporteRemessa;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  System.Actions, FMX.ActnList, FMX.ListBox, FMX.Edit, FMX.EditBox, FMX.NumberBox, System.DateUtils, FMX.ComboEdit,
  Data.DB, System.Rtti, FMX.Grid.Style, FMX.ScrollBox,
  FMX.Grid, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.Grid,
  Data.Bind.DBScope, FMX.DateTimeCtrls, Controller.RESTSuportTracking, FMX.Memo, FMX.TabControl, FMX.CodeReader;

type
  Tview_SuporteRemessa = class(TForm)
    layoutPadrao: TLayout;
    actionListExtratos: TActionList;
    actionProcessar: TAction;
    layoutFiltro: TLayout;
    layoutFooter: TLayout;
    layoutTitle: TLayout;
    rectangleTitle: TRectangle;
    imageExit: TImage;
    labelTitle: TLabel;
    labelDescricao: TLabel;
    actionDetalhar: TAction;
    actionLerBarras: TAction;
    actionLimparCampos: TAction;
    actionIniciar: TAction;
    actionParar: TAction;
    layoutBody: TLayout;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    editParametro: TEdit;
    editTelefone1: TEdit;
    editTelefone2: TEdit;
    editTelefone3: TEdit;
    editEndereco: TMemo;
    editComplemento: TMemo;
    TabItem2: TTabItem;
    codeReader: TCodeReader;
    rectangleIniciar: TRectangle;
    Label1: TLabel;
    Image2: TImage;
    procedure imageExitMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure actionProcessarExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure actionLimparCamposExecute(Sender: TObject);
    procedure actionDetalharExecute(Sender: TObject);
    procedure actionLerBarrasExecute(Sender: TObject);
    procedure actionIniciarExecute(Sender: TObject);
    procedure codeReaderStart(Sender: TObject);
    procedure codeReaderStop(Sender: TObject);
    procedure actionPararExecute(Sender: TObject);
    procedure rectangleIniciarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure rectangleIniciarMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure codeReaderCodeReady(aCode: string);
    procedure Image2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
  private
    { Private declarations }
    procedure LimpaTela;
    procedure DetalhaEntregas(sAWB: string);
    function ValidaDados(): boolean;
  public
    { Public declarations }
  end;

var
  view_SuporteRemessa: Tview_SuporteRemessa;

implementation

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}

uses DM.Main, Common.Params, Common.Notificacao;

procedure Tview_SuporteRemessa.actionDetalharExecute(Sender: TObject);
begin
  DetalhaEntregas(Trim(editParametro.Text));
end;

procedure Tview_SuporteRemessa.actionIniciarExecute(Sender: TObject);
begin
  codeReader.Start;
end;

procedure Tview_SuporteRemessa.actionLerBarrasExecute(Sender: TObject);
begin
  TabControl1.TabIndex := 1;
  actionIniciarExecute(Sender);
end;

procedure Tview_SuporteRemessa.actionLimparCamposExecute(Sender: TObject);
begin
  LimpaTela;
end;

procedure Tview_SuporteRemessa.actionPararExecute(Sender: TObject);
begin
  codeReader.Stop;
  TabControl1.TabIndex := 0;
  editParametro.SetFocus;
end;

procedure Tview_SuporteRemessa.actionProcessarExecute(Sender: TObject);
begin
  if not ValidaDados() then Exit;
  DetalhaEntregas(editParametro.Text);
end;

procedure Tview_SuporteRemessa.codeReaderCodeReady(aCode: string);
begin
  Common.Params.paramResultReadCode := aCode;
  codeReader.Stop;
  TabControl1.TabIndex := 0;
  editParametro.Text := Common.Params.paramResultReadCode;
  DetalhaEntregas(Trim(editParametro.Text));
end;

procedure Tview_SuporteRemessa.codeReaderStart(Sender: TObject);
begin
  Label1.Text := 'Parar';
end;

procedure Tview_SuporteRemessa.codeReaderStop(Sender: TObject);
begin
   Label1.Text := 'Iniciar';
end;

procedure Tview_SuporteRemessa.DetalhaEntregas(sAWB: string);
var
  i: Integer;
  FTracking : TRESTSuportTrackingController;
begin
  try
    FTracking := TRESTSuportTrackingController.Create;
    LimpaTela;
    DM_Main.memTableTracking.Active := False;
    if FTracking.SearchTracking(sAWB) then
    begin
      DM_Main.memTableTracking.First;
      editTelefone1.Text := DM_Main.memTableTrackingnum_telefone_1.AsString;
      editTelefone2.Text := DM_Main.memTableTrackingnum_telefone_2.AsString;
      editTelefone3.Text := DM_Main.memTableTrackingnum_telefone_3.AsString;
      editEndereco.Text := DM_Main.memTableTrackingdes_logradouro.AsString + ', ' + #13 +
                           DM_Main.memTableTrackingnum_logradouro.AsString + #13 +
                           DM_Main.memTableTrackingnom_bairro.AsString + #13 +
                           DM_Main.memTableTrackingnom_cidade_uf.AsString + #13 +
                           'CEP: ' + DM_Main.memTableTrackingnum_cep.AsString;
      editComplemento.Lines.Text := DM_Main.memTableTrackingdes_complemento.Text;
    end
    else
    begin
      Common.Notificacao.TLoading.ToastMessage(Self, 'Pedido não encontrado!', TAlignLayout.Bottom, $FFFF0000, $FFFFFFFF);
      Exit;
    end;
  finally
    DM_Main.memTableTracking.Active := False;
    FTracking.Free;
  end;
end;

procedure Tview_SuporteRemessa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LimpaTela;
end;

procedure Tview_SuporteRemessa.FormShow(Sender: TObject);
begin
  labelDescricao.Text := Self.Caption;
  editParametro.SetFocus;
end;

procedure Tview_SuporteRemessa.Image2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  actionProcessarExecute(Sender);
end;

procedure Tview_SuporteRemessa.imageExitMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  Close;
end;

procedure Tview_SuporteRemessa.LimpaTela;
begin
  editParametro.Text := '';
  editTelefone1.Text := '';
  editTelefone2.Text := '';
  editTelefone3.Text := '';
  editEndereco.Lines.Clear;
  editComplemento.Lines.Clear;
  editParametro.SetFocus;
end;

procedure Tview_SuporteRemessa.rectangleIniciarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  TRectangle(Sender).Opacity := 0.8;
end;

procedure Tview_SuporteRemessa.rectangleIniciarMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  TRectangle(Sender).Opacity := 1;
  if Label1.Text = 'Iniciar' then
  begin
    actionIniciarExecute(Sender);
  end
  else if Label1.Text = 'Parar' then
  begin
    actionPararExecute(Sender);
  end;
end;

Function Tview_SuporteRemessa.ValidaDados: boolean;
begin
  Result := False;
  if editParametro.Text.IsEmpty then
  begin
    Common.Notificacao.TLoading.ToastMessage(Self, 'Informe o AWB ou Número da Remessa!', TAlignLayout.Bottom, $FFFF0000, $FFFFFFFF);
    Exit;
  end;
  Result := True;
end;


end.
