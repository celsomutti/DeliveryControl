unit View.Cadastro;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  FMX.Edit, System.Actions, FMX.ActnList, Controller.RESTCadastro;

type
  Tview_Cadastro = class(TForm)
    layoutPadrao: TLayout;
    layoutTitle: TLayout;
    rectangleTitle: TRectangle;
    labelTitle: TLabel;
    editCPFCNPJ: TEdit;
    editNome: TEdit;
    labelCadastro: TLabel;
    actionListCadastro: TActionList;
    actionLocalizar: TAction;
    editSenha: TEdit;
    imageView: TImage;
    editConfirmacaoSenha: TEdit;
    mageView2: TImage;
    actionGravar: TAction;
    actionExit: TAction;
    editEMail: TEdit;
    imageExit: TImage;
    layoutCPF: TLayout;
    imageSearch: TImage;
    layoutNome: TLayout;
    layoutEMail: TLayout;
    layoutSenha: TLayout;
    layoutConfirmacao: TLayout;
    rectangleGravar: TRectangle;
    labelGravar: TLabel;
    procedure actionExitExecute(Sender: TObject);
    procedure actionLocalizarExecute(Sender: TObject);
    procedure actionGravarExecute(Sender: TObject);
    procedure imageViewMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure mageView2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure imageExitMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure imageSearchMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure rectangleGravarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure rectangleGravarMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
  private
    { Private declarations }
  public
    { Public declarations }
    function CPFValido(sCPF: String): boolean;
    function UsuarioExiste(sCPF: String): boolean;
    function ValidaGravacao(): boolean;
    function GravaUsuario(sCPF, sUserName, sName, sPassword, sEMail: String): boolean;
    procedure LimpaTela;
  end;

var
  view_Cadastro: Tview_Cadastro;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

uses Common.Params;

procedure Tview_Cadastro.actionExitExecute(Sender: TObject);
begin
  Close;
end;

procedure Tview_Cadastro.actionGravarExecute(Sender: TObject);
begin
  if not ValidaGravacao() then
  begin
    Exit;
  end;

  MessageDlg('Confirma salvar os dados?', System.UITypes.TMsgDlgType.mtConfirmation,
  [System.UITypes.TMsgDlgBtn.mbYes, System.UITypes.TMsgDlgBtn.mbNo], 0,
  procedure (const AResult: System.UITypes.TModalResult)
  begin
    case AResult of
      mrYes:
      begin
        if not GravaUsuario(EditCPFCNPJ.Text, EditCPFCNPJ.Text, editNome.Text, editSenha.Text, editEMail.Text) then
        begin
          ShowMessage('Ocorreu um problema ao tentar gravar o cadastro! Comunique o Administrador.');
        end
        else
        begin
          ShowMessage('Cadastro realizado com sucesso! Informe o seu CPF / CNPJ e senha no Login.');
          Close;
        end;
      end;
    end;
  end);

end;

procedure Tview_Cadastro.actionLocalizarExecute(Sender: TObject);
begin
  if not CPFValido(EditCPFCNPJ.Text) then
  begin
    Exit;
  end;
  if UsuarioExiste(EditCPFCNPJ.Text) then
  begin
    Exit;
  end;
  editNome.Text := Common.Params.paramNameUser;
  editEMail.SetFocus;
end;

function Tview_Cadastro.CPFValido(sCPF: string): boolean;
var
  FCadastro: TRESTCadastroController;
begin
  try
    Result := False;
    FCadastro := TRESTCadastroController.Create;
    if not FCadastro.CPFValido(sCPF) then
    begin
      ShowMessage('CPF não cadastrado!');
      Exit;
    end;
    if not FCadastro.RetornaEntregadores(Common.Params.paramCodigoCadastro) then
    begin
      ShowMessage('Nenmhum entregador liberado para esse cadastro!');
      Exit;
    end;
    Result := True;
  finally
    FCadastro.Free;
  end;
end;

function Tview_Cadastro.GravaUsuario(sCPF, sUserName, sName, sPassword, sEMail: String): boolean;
var
  FCadastro: TRESTCadastroController;
begin
  try
    Result := False;
    FCadastro := TRESTCadastroController.Create;
    if not FCadastro.SalvaCadastro(sCPF, sUserName, sName, sPassword, sEMail) then
    begin
      Exit;
    end;
    Result := True;
  finally
    FCadastro.Free;
  end;
end;

procedure Tview_Cadastro.imageExitMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  actionExitExecute(Sender);
end;

procedure Tview_Cadastro.imageSearchMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  actionLocalizarExecute(Sender);
end;

procedure Tview_Cadastro.imageViewMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if editSenha.Password then
  begin
    editSenha.Password := False;
  end
  else
  begin
    editSenha.Password := True;
  end;
end;

procedure Tview_Cadastro.LimpaTela;
begin
  EditCPFCNPJ.Text := '';
  editNome.Text := '';
  editSenha.Text := '';
  editConfirmacaoSenha.Text := '';
end;

procedure Tview_Cadastro.mageView2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    if editConfirmacaoSenha.Password then
  begin
    editConfirmacaoSenha.Password := False;
  end
  else
  begin
    editConfirmacaoSenha.Password := True;
  end;
end;

procedure Tview_Cadastro.rectangleGravarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  TRecTangle(Sender).Opacity := 0.7;
end;

procedure Tview_Cadastro.rectangleGravarMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  TRecTangle(Sender).Opacity := 1;
  actionGravarExecute(Sender);
end;

function Tview_Cadastro.UsuarioExiste(sCPF: String): boolean;
var
  FCadastro: TRESTCadastroController;
begin
  try
    Result := True;
    FCadastro := TRESTCadastroController.Create;
    if FCadastro.UsuarioExiste(sCPF) then
    begin
      ShowMessage('CPF já está vinculado a um usuário! Cadastro cancelado.');
      Exit;
    end;
    Result := False;
  finally
    FCadastro.Free;
  end;
end;

function Tview_Cadastro.ValidaGravacao: boolean;
begin
  Result := False;
  if editCPFCNPJ.Text.IsEmpty then
  begin
    ShowMessage('Informe o CPF!');
    EditCPFCNPJ.SetFocus;
    Exit;
  end;
  if not CPFValido(EditCPFCNPJ.Text) then
  begin
    LimpaTela;
    EditCPFCNPJ.SetFocus;
    Exit;
  end
  else
  begin
    editNome.Text := Common.Params.paramNameUser;
  end;
  if UsuarioExiste(EditCPFCNPJ.Text) then
  begin
    LimpaTela;
    EditCPFCNPJ.SetFocus;
    Exit;
  end;
  if editNome.Text.IsEmpty then
  begin
    ShowMessage('Informe o Nome!');
    EditCPFCNPJ.SetFocus;
    Exit;
  end;
  if editSenha.Text.IsEmpty then
  begin
    ShowMessage('Informe a senha!');
    editSenha.SetFocus;
    Exit;
  end;
  if editConfirmacaoSenha.Text.IsEmpty then
  begin
    ShowMessage('Confirme a senha!');
    editConfirmacaoSenha.SetFocus;
    Exit;
  end;
  if not editConfirmacaoSenha.Text.Equals(editSenha.Text) then
  begin
    ShowMessage('Confirmação da senha diferente da senha informada!');
    editConfirmacaoSenha.SetFocus;
    Exit;
  end;
  Result := True;
end;

end.
