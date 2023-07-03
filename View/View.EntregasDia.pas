unit View.EntregasDia;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  System.Actions, FMX.ActnList, FMX.ListBox, FMX.Edit, FMX.EditBox, FMX.NumberBox, System.DateUtils, FMX.ComboEdit,
  Data.DB, System.Rtti, FMX.Grid.Style, FMX.ScrollBox,
  FMX.Grid, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.Grid,
  Data.Bind.DBScope, Controller.RESTExtravios, Controller.RESTEntregasDia,
  FMX.DateTimeCtrls;

type
  Tview_EntregasDia = class(TForm)
    layoutPadrao: TLayout;
    actionListExtratos: TActionList;
    actionProcessar: TAction;
    layoutFiltro: TLayout;
    stringGridExtrato: TStringGrid;
    layoutFooter: TLayout;
    imageSearch: TImage;
    layoutTitle: TLayout;
    rectangleTitle: TRectangle;
    imageExit: TImage;
    labelTitle: TLabel;
    dateEditInicial: TDateEdit;
    labelInicial: TLabel;
    dateEditFinal: TDateEdit;
    Label1: TLabel;
    stringColumnCliente: TStringColumn;
    stringColumnTipo: TStringColumn;
    dateColumnData: TDateColumn;
    integerColumnQtde: TIntegerColumn;
    integerColumnCodCliente: TIntegerColumn;
    labelDescricao: TLabel;
    actionDetalhar: TAction;
    CornerButton1: TCornerButton;
    currencyColumnVerba: TCurrencyColumn;
    procedure imageExitMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure actionProcessarExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imageSearchMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure FormShow(Sender: TObject);
    procedure actionDetalharExecute(Sender: TObject);
   //procedure integerColumnCodClienteGesture(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
//    procedure integerColumnQtdeGesture(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
  private
    { Private declarations }
    procedure ProcessExtrato(sentregador, sdataini, sdatafim: String);
    procedure LimpaTela;
    procedure DetalhaEntregas;
    function ValidaDados(): boolean;
  public
    { Public declarations }
  end;

var
  view_EntregasDia: Tview_EntregasDia;

implementation

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}

uses DM.Main, Common.Params, View.EntregasDetalhe, Common.Notificacao;

procedure Tview_EntregasDia.actionDetalharExecute(Sender: TObject);
begin
  DetalhaEntregas;
end;

procedure Tview_EntregasDia.actionProcessarExecute(Sender: TObject);
begin
  if not ValidaDados() then Exit;
  ProcessExtrato(Common.Params.paramCodigosEntregadores, FormatDateTime('yyyy-mm-dd', dateEditInicial.Date),
    FormatDateTime('yyyy-mm-dd', dateEditFinal.Date));
end;

procedure Tview_EntregasDia.DetalhaEntregas;
var
  sEntregador, sData, sCliente, sTitulo: String;
  i: Integer;
begin
  if stringGridExtrato.RowCount = 0 then
  begin
    Common.Notificacao.TLoading.ToastMessage(Self, 'Período não listado!', TAlignLayout.Bottom, $FFFF0000, $FFFFFFFF);
    Exit;
  end;
  i := stringGridExtrato.Row;
  if stringGridExtrato.Cells[0,i].IsEmpty then
  begin
    Common.Notificacao.TLoading.ToastMessage(Self, 'Selecione uma linha!', TAlignLayout.Bottom, $FFFF0000, $FFFFFFFF);
    Exit;
  end;
  if not Assigned(view_EntregasDetalhe) then
  begin
    Application.CreateForm(Tview_EntregasDetalhe, view_EntregasDetalhe);
  end;
  sTitulo := '';
  sData := FormatDateTime('yyyy-mm-dd', StrToDateDef(stringGridExtrato.Cells[1,i],0));
  view_EntregasDetalhe.sEntregador :=  Common.Params.paramCodigosEntregadores;
  view_EntregasDetalhe.sData := sData;
  view_EntregasDetalhe.sCliente := stringGridExtrato.Cells[4,i];
  sTitulo := view_EntregasDetalhe.Caption;
  view_EntregasDetalhe.sTitulo := ' - ' + stringGridExtrato.Cells[0,i] + ' - ' + stringGridExtrato.Cells[1,i] ;
  view_EntregasDetalhe.Show;
end;

procedure Tview_EntregasDia.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LimpaTela;
end;

procedure Tview_EntregasDia.FormShow(Sender: TObject);
begin
  dateEditInicial.Date := Now;
  dateEditFinal.Date := Now;
  labelDescricao.Text := Self.Caption;
end;

procedure Tview_EntregasDia.imageExitMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  Close;
end;

procedure Tview_EntregasDia.imageSearchMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  actionProcessarExecute(Sender);
end;

procedure Tview_EntregasDia.LimpaTela;
begin
  stringGridExtrato.RowCount := 0;
end;


procedure Tview_EntregasDia.ProcessExtrato(sentregador, sdataini, sdatafim: String);
var
  FEntregas: TRESTEntregasDiaController;
  sDescricao, sQuantidade, sCliente, sCodCliente, sCodClienteOld, sVerba: String;
  sData: String;
  iTotalCliente, iTotalGeral, i, iEntregas: Integer;
  dVerba: Double;
begin
  try
    FEntregas := TRESTEntregasDiaController.Create;
    stringGridExtrato.RowCount := 0;
    if FEntregas.SearchEntregas(sentregador, sdataini, sdatafim) then
    begin
      DM_Main.memTableEntregasDia.First;
      iTotalCliente := 0;
      iTotalGeral := 0;
      i := 0;
      iEntregas := 0;
      sCodCliente := '';
      sCodClienteOld := '';
      while not DM_Main.memTableEntregasDia.Eof do
      begin
        sCodCliente := DM_Main.memTableEntregasDiacod_cliente.AsString;
        sCliente := DM_Main.memTableEntregasDianom_cliente.AsString;
        sData := Copy(DM_Main.memTableEntregasDiadat_baixa.AsString,9,2) + '/' +
                 Copy(DM_Main.memTableEntregasDiadat_baixa.AsString,6,2) + '/' +
                 Copy(DM_Main.memTableEntregasDiadat_baixa.AsString,1,4);
        if sCodClienteOld <> sCodCliente then
        begin
          sCodClienteOld := DM_Main.memTableEntregasDiacod_cliente.AsString;
          if iTotalCliente > 0 then
          begin
            stringGridExtrato.RowCount := (stringGridExtrato.RowCount + 1);
            i := Pred(stringGridExtrato.RowCount);
            stringGridExtrato.Cells[1,i] := 'Tot. Cliente';
            stringGridExtrato.Cells[3,i] := FormatFloat('###,##0;(###,##0)', iTotalCliente);
          end;
          iTotalCliente := 0;
        end;
        sDescricao := '';
        sQuantidade := '';
        sVerba := '';
        {if Trim(sCodcliente) = '1' then
        begin
          sCliente := 'TFO';
        end
        else if Trim(sCodcliente) = '4' then
        begin
          sCliente := 'DIRECT';
        end
        else if Trim(sCodcliente) = '5' then
        begin
          sCliente := 'RODOÊ';
        end
        else if Trim(sCodcliente) = '6' then
        begin
          sCliente := 'COMPLOG';
        end
        else if Trim(sCodcliente) = '7' then
        begin
          sCliente := 'REDE FORTE';
        end
        else if Trim(sCodcliente) = '8'then
        begin
          sCliente := 'MANDAÊ';
        end;    }
        iEntregas := StrToIntDef(DM_Main.memTableEntregasDiaqtd_entregas.AsString, 0);
        dVerba := StrToFloatDef(DM_Main.memTableEntregasDiaval_verba.AsString, 0);
        sQuantidade := FormatFloat('#,##0;(#,##0)', iEntregas);
        sVerba := FormatFloat('#,##0.00;(#,##0.00)', dVerba);
        if DM_Main.memTableEntregasdes_tipo.AsString = '' then
        begin
          sDescricao := 'ENTREGA';
        end;
        stringGridExtrato.RowCount := (stringGridExtrato.RowCount + 1);
        i := Pred(stringGridExtrato.RowCount);
        stringGridExtrato.Cells[0,i] := sCliente;
        stringGridExtrato.Cells[1,i] := sData;
        stringGridExtrato.Cells[2,i] := sDescricao;
        stringGridExtrato.Cells[3,i] := sVerba;
        stringGridExtrato.Cells[4,i] := sQuantidade;
        iTotalCliente := iTotalCliente + iEntregas;
        iTotalGeral := iTotalGeral + iEntregas;
        DM_Main.memTableEntregasDia.Next;
      end;
      if iTotalCliente > 0 then
      begin
        stringGridExtrato.RowCount := (stringGridExtrato.RowCount + 1);
        i := Pred(stringGridExtrato.RowCount);
        stringGridExtrato.Cells[1,i] := 'Tot. Cliente';
        stringGridExtrato.Cells[3,i] := FormatFloat('###,##0;(###,##0)', iTotalCliente);
      end;
      if iTotalGeral > 0 then
      begin
        stringGridExtrato.RowCount := (stringGridExtrato.RowCount + 1);
        i := Pred(stringGridExtrato.RowCount);
        stringGridExtrato.Cells[1,i] := 'Tot. Geral';
        stringGridExtrato.Cells[3,i] := FormatFloat('###,##0;(###,##0)', iTotalGeral);
      end;
      iTotalCliente := 0;
      iTotalGeral := 0;
    end;
  finally
    DM_Main.memTableEntregasDia.Close;
    FEntregas.Free;
  end;
end;

function Tview_EntregasDia.ValidaDados: boolean;
begin
  Result := False;
  if dateEditInicial.Text = '' then
  begin
    ShowMessage('Informe a data inicial do período.');
    Exit;
  end;
  if dateEditFinal.Text = '' then
  begin
    ShowMessage('Informe a data final do período.');
    Exit;
  end;
  if dateEditInicial.Date > dateEditFinal.Date then
  begin
    ShowMessage('Período inválido.');
    Exit;
  end;
  if DaysBetween(dateEditInicial.Date,dateEditFinal.Date) > 16 then
  begin
    ShowMessage('Período não pode ser maior que 16 dias.');
    Exit;
  end;
  Result := True;
end;


end.

