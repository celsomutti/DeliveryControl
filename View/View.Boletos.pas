unit View.Boletos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti, FMX.Grid.Style, FMX.Grid, FMX.ScrollBox, FMX.StdCtrls,
  FMX.Edit, FMX.ComboEdit, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.ListBox, System.Actions, FMX.ActnList,
  Controller.RESTPlanilhaCredito, System.DateUtils, Controller.RESTBoletos;

type
  Tview_Boletos = class(TForm)
    layoutPadrao: TLayout;
    layoutTitle: TLayout;
    rectangleTitle: TRectangle;
    imageExit: TImage;
    labelTitle: TLabel;
    layoutFiltro: TLayout;
    stringGridBoletos: TStringGrid;
    labelData: TLabel;
    buttonProcurar: TButton;
    actionListBoleto: TActionList;
    actionProcurar: TAction;
    editLinha: TEdit;
    labelCodigo: TLabel;
    actionGravar: TAction;
    buttonGravar: TButton;
    actionExit: TAction;
    labelValor: TLabel;
    labelValorValor: TLabel;
    columnLinha: TColumn;
    comboEditDatas: TComboEdit;
    Column1: TColumn;
    Column2: TColumn;
    labelSaldo: TLabel;
    labelValorSaldo: TLabel;
    layoutRodape: TLayout;
    actionSalvar: TAction;
    actionCancelar: TAction;
    buttonSAlvar: TButton;
    buttonCancelar: TButton;
    procedure actionExitExecute(Sender: TObject);
    procedure imageExitMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure FormActivate(Sender: TObject);
    procedure actionProcurarExecute(Sender: TObject);
    procedure actionGravarExecute(Sender: TObject);
    procedure actionSalvarExecute(Sender: TObject);
    procedure actionCancelarExecute(Sender: TObject);
  private
    { Private declarations }
    procedure ProcessDatas(sEntregador: String);
    procedure GetValor(sEntregador, sData: String);
    procedure MostraValorBoleto;
    procedure TrataLinha(sLinha: String);
    procedure LimpaTela;
    function SomaValorboleto(dValor: double): boolean;
    function LancamentoExiste(sLinha: String): boolean;
    function SalvaBoletos(): boolean;
  public
    { Public declarations }
  end;

var
  view_Boletos: Tview_Boletos;
  dValorBoleto: Double;
  dValorRestante: Double;
  dValorTotal: Double;

implementation

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}

uses DM.Main, Common.Params;

{ Tview_Boletos }

procedure Tview_Boletos.actionCancelarExecute(Sender: TObject);
begin
  LimpaTela;
end;

procedure Tview_Boletos.actionExitExecute(Sender: TObject);
begin
  Close;
end;

procedure Tview_Boletos.actionGravarExecute(Sender: TObject);
begin
  if dValorRestante > 0 then
  begin
    TrataLinha(editLinha.Text);
  end
  else
  begin
    ShowMessage('Não há saldo a lançar!');
  end;
end;

procedure Tview_Boletos.actionProcurarExecute(Sender: TObject);
begin
  if comboEditDatas.ItemIndex = -1 then
  begin
    ShowMessage('Selecione a data do crédito do extrato!');
    Exit;
  end;
  GetValor(Common.Params.paramCodeDelivery.ToString, comboEditDatas.Text);
end;

procedure Tview_Boletos.actionSalvarExecute(Sender: TObject);
begin
  if SalvaBoletos() then
  begin
    LimpaTela;
  end;
end;

procedure Tview_Boletos.FormActivate(Sender: TObject);
begin
  dValorBoleto := 0;
  dValorRestante := 0;
  dValorTotal := 0;
  MostraValorBoleto;
  ProcessDatas(Common.Params.paramCodeDelivery.ToString);
end;

procedure Tview_Boletos.GetValor(sEntregador, sData: String);
var
  FPlanilha: TRESTPlanilhaCreditoController;
  sValor: String;
begin
  try
    dValorBoleto := 0;
    MostraValorBoleto;
    stringGridBoletos.RowCount := 0;
    FPlanilha := TRESTPlanilhaCreditoController.Create;
    sValor := FPlanilha.SearchValorBoleto(sEntregador, sData);
    sValor := StringReplace(sValor,',','', [rfReplaceAll]);
    sValor := StringReplace(sValor,'.',',', [rfReplaceAll]);
    dValorBoleto := StrToFloatDef(sValor,0);
    dValorRestante := StrToFloatDef(sValor,0);
    labelValorValor.Text := FormatFloat('###,##0.00;-###,##0.00', dValorBoleto);
    labelValorSaldo.Text := FormatFloat('###,##0.00;-###,##0.00', dValorRestante);
  finally
    FPlanilha.Free;
  end;
end;

procedure Tview_Boletos.imageExitMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  actionExitExecute(Sender);
end;

function Tview_Boletos.LancamentoExiste(sLinha: String): boolean;
var
  i: Integer;
  bFlag : Boolean;
begin
  bFlag := False;
  for i := 0 to Pred(stringGridBoletos.RowCount) do
  begin
    if stringGridBoletos.Cells[0,i].Equals(sLinha) then
    begin
      bFlag := True;
      Break;
    end;
  end;
  Result := bFlag;
end;

procedure Tview_Boletos.LimpaTela;
begin
  comboEditDatas.Items.Clear;
  stringGridBoletos.RowCount := 0;
  editLinha.Text := '';
  actionSalvar.Enabled := False;
  actionCancelar.Enabled := False;
end;

procedure Tview_Boletos.MostraValorBoleto;
begin
  labelValorValor.Text := FormatFloat('###,##0.00;-###,##0.00', dValorBoleto);
end;

procedure Tview_Boletos.ProcessDatas(sEntregador: String);
var
  FPlanilha: TRESTPlanilhaCreditoController;
  sData: String;
begin
  try
    FPlanilha := TRESTPlanilhaCreditoController.Create;
    comboEditDatas.Items.Clear;
    if FPlanilha.SearchDatas(sEntregador) then
    begin
      DM_Main.memTableDatasCreditos.First;
      while not DM_Main.memTableDatasCreditos.Eof do
      begin
        sData := Copy(DM_Main.memTableDatasCreditosdat_credito.AsString, 9, 2) + '/' +
                 Copy(DM_Main.memTableDatasCreditosdat_credito.AsString, 6, 2) + '/' +
                 Copy(DM_Main.memTableDatasCreditosdat_credito.AsString, 1, 4);
        comboEditDatas.Items.Add(sData);
        DM_Main.memTableDatasCreditos.Next;
      end;
    end;
  finally
    DM_Main.memTableDatasCreditos.Close;
    FPlanilha.Free;
  end;
end;

function Tview_Boletos.SalvaBoletos: boolean;
var
  FBoletos : TRESTBoletosController;
  FPlanilha : TRESTPlanilhaCreditoController;
  i: Integer;
  sExtrato, sData, sLinha, sValor, sEntregador, sUserName: String;
begin
  try
    Result := False;
    FBoletos := TRESTBoletosController.Create;
    FPlanilha := TRESTPlanilhaCreditoController.Create;
    if stringGridBoletos.RowCount = 0 then
    begin
      Exit;
    end;
    sExtrato := Common.Params.paramNumeroExtrato;
    sEntregador := Common.Params.paramCodeDelivery.ToString;
    sUserName := Common.Params.paramUserName;
    if not FPlanilha.SalvaStatusBoleto(sExtrato) then
    begin
      ShowMessage('Erro ao salvar o status do extrato ' + sExtrato + ' no banco de dados!');
      Exit;
    end;
    for i := 0 to Pred(stringGridBoletos.RowCount) do
    begin
      sData := FormatDateTime('yyyy-mm-dd', StrToDate(stringGridBoletos.Cells[1,i]));
      sLinha := stringGridBoletos.Cells[0,i];
      sValor := StringReplace(stringGridBoletos.Cells[2,i],'.','', [rfReplaceAll]);
      sValor := StringReplace(sValor,',','.', [rfReplaceAll]);
      if not FBoletos.SalvaBoleto(sExtrato, sData, sLinha, sValor, sEntregador, sUserName) then
      begin
        ShowMessage('Erro ao salvar o boleto ' + sLinha + ' no banco de dados!');
      end;
    end;
    Result := True;
    LimpaTela;
  finally
    FBoletos.Free;
    FPlanilha.Free;
  end;
end;

function Tview_Boletos.SomaValorboleto(dValor: double): boolean;
begin
  Result := False;
  if dValor > dValorRestante then
  begin
    ShowMessage('Valor do boleto informado maior que o saldo!');
    Exit;
  end;
  dValorRestante := dValorRestante - dValor;
  if dValorRestante > 0 then
  begin
    actionSalvar.Enabled := False;
    actionCancelar.Enabled := True;
  end
  else
  begin
    actionSalvar.Enabled := True;
    actionCancelar.Enabled := True;
  end;
  dValorTotal := dValorTotal + dValor;
  Result := True;
end;

procedure Tview_Boletos.TrataLinha(sLinha: String);
var
  sAgencia, sConta, sValor, sVencimento: String;
  dValor: Double;
  dateVencimento: TDate;
  i: Integer;
begin
  if sLinha.IsEmpty then
  begin
    ShowMessage('Informe a linha digitável!');
    Exit;
  end;
  sLinha := StringReplace(sLinha,'.','',[rfReplaceAll]);
  sLinha := StringReplace(sLinha,' ','',[rfReplaceAll]);
  if LancamentoExiste(sLinha) then
  begin
    ShowMessage('Boleto já foi lançado!');
    Exit;
  end;
  sAgencia := '0000';
  sConta := '000000';
  sVencimento := Copy(sLinha,34,4);
  sValor := Copy(sLinha,38,10);
  dValor := StrtoIntDef(sValor, 0) / 100;
  dateVencimento := IncDay(StrToDateTime('07/10/1997') + StrToIntDef(sVencimento,0)) - 1;
  if not SomaValorboleto(dValor) then
  begin
    Exit;
  end;
  i := stringGridBoletos.RowCount;
  Inc(i ,1);
  stringGridBoletos.RowCount := i;
  stringGridBoletos.Cells[0,Pred(i)] := sLinha;
  stringGridBoletos.Cells[1,Pred(i)] := FormatDateTime('dd/mm/yyyy', dateVencimento);
  stringGridBoletos.Cells[2,Pred(i)] := FormatFloat('###,##0.00;-###,##0.00', dValor);
  labelValorSaldo.Text := FormatFloat('###,##0.00;-###,##0.00', dValorRestante);
  editLinha.Text := '';
  editLinha.SetFocus;
end;

end.


