unit View.Login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Edit, FMX.Ani, System.ImageList, FMX.ImgList, System.Actions, FMX.ActnList,
  Common.Notificacao, Controller.RESTLogin, Controller.RESTBoletos, Controller.RESTCadastro,
  Androidapi.Helpers, Androidapi.JNI.JavaTypes, Androidapi.JNI.GraphicsContentViewText;

type
  Tview_Login = class(TForm)
    layoutLogo: TLayout;
    imageLogo: TImage;
    layoutFormLogin: TLayout;
    rectangleUserName: TRectangle;
    layoutUserName: TLayout;
    imageUser: TImage;
    layoutPassword: TLayout;
    rectanglePassword: TRectangle;
    imagePassword: TImage;
    actionListLogin: TActionList;
    actionAcessar: TAction;
    imageView: TImage;
    layoutPadrao: TLayout;
    actionCadastro: TAction;
    SpeedButtonCadastro: TSpeedButton;
    editUserName: TEdit;
    editPassword: TEdit;
    layoutTitle: TLayout;
    rectangleTitle: TRectangle;
    labelTitle: TLabel;
    rectangleAccept: TRectangle;
    labelAcessar: TLabel;
    Layout1: TLayout;
    labelVersao: TLabel;
    procedure imageViewClick(Sender: TObject);
    procedure actionAcessarExecute(Sender: TObject);
    procedure actionCadastroExecute(Sender: TObject);
    procedure rectangleAcceptMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure rectangleAcceptMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    function ValidaLogin(sUsername: String; sPassword: String): Boolean;
    procedure OpenFormMain;
    procedure OpenFormCadastro;
    procedure OpenListaBoletos;
    procedure MostraVersao;
    function BoletosAbertos(sentregador: string): Boolean;
    function CPFValido(scpf: String): boolean;
  public
    { Public declarations }
  end;

var
  view_Login: Tview_Login;

implementation
{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

uses View.Main, Common.Params, View.Cadastro, View.BaixaBoletos;

{$R *.NmXhdpiPh.fmx ANDROID}

procedure Tview_Login.actionAcessarExecute(Sender: TObject);
begin
  if ValidaLogin(editUserName.Text, editPassword.Text) then
  begin
    if not CPFValido(editUserName.Text) then
    begin
      Exit;
    end;
    {if BoletosAbertos(Common.Params.paramCodeDelivery.ToString) then
    begin
      OpenListaBoletos;
    end
    else
    begin
      OpenFormMain;
    end;}
    OpenFormMain;
  end;
end;

procedure Tview_Login.actionCadastroExecute(Sender: TObject);
begin
  OpenFormCadastro;
end;

function Tview_Login.BoletosAbertos(sentregador: string): Boolean;
var
  FBoletos: TRESTBoletosController;
begin
  try
    Result := True;
    FBoletos := TRESTBoletosController.Create;
    if FBoletos.ListaBoletos(sEntregador) then
    begin
      Exit;
    end;
    Result := False;
  finally
    FBoletos.Free;
  end;
end;

function Tview_Login.CPFValido(scpf: String): boolean;
var
  FCadastro: TRESTCadastroController;
begin
  try
    Result := False;
    FCadastro := TRESTCadastroController.Create;
    if not FCadastro.CPFValido(sCPF) then
    begin
      ShowMessage('CPF não está vinculado a nenhum cadastro ativo! Cadastro cancelado.');
      Exit;
    end;
    if not FCadastro.RetornaEntregadores(Common.Params.paramCodigoCadastro) then
    begin
      ShowMessage('Nenhum código de entregador liberado foi encontrado! Cadastro cancelado.');
      Exit;
    end;
    Result := True;
  finally
    FCadastro.Free;
  end;
end;

procedure Tview_Login.FormActivate(Sender: TObject);
begin
  MostraVersao;
end;

procedure Tview_Login.imageViewClick(Sender: TObject);
begin
  if editPassword.Password then
  begin
    editPassword.Password := False;
  end
  else
  begin
    editPassword.Password := True;
  end;
end;

procedure Tview_Login.MostraVersao;
var
  PkgInfo: JPackageInfo;
  sVersao : String;
begin
  PkgInfo := SharedActivity.getPackageManager.getPackageInfo(SharedActivity.getPackageName,0);
  sVersao := JStringToString(PkgInfo.versionName);
  labelVersao.Text := 'Versão ' + sVersao;
end;

procedure Tview_Login.OpenFormCadastro;
begin
  if Not Assigned(view_Cadastro) then
  begin
    Application.CreateForm(Tview_Cadastro, view_Cadastro);
  end;
  view_Cadastro.Show;
end;

procedure Tview_Login.OpenFormMain;
begin
  if Not Assigned(view_Main) then
  begin
    Application.CreateForm(Tview_Main, view_Main);
  end;
  view_Main.Show;
  Application.MainForm := view_Main;
  view_Login.Hide;
end;

procedure Tview_Login.OpenListaBoletos;
begin
  if Not Assigned(view_BaixaBoletos) then
  begin
    Application.CreateForm(Tview_BaixaBoletos, view_BaixaBoletos);
  end;
  view_BaixaBoletos.Show;
end;

procedure Tview_Login.rectangleAcceptMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  TRectangle(Sender).Opacity := 0.7;
end;

procedure Tview_Login.rectangleAcceptMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  TRectangle(Sender).Opacity := 1;
  actionAcessarExecute(Sender);
end;

function Tview_Login.ValidaLogin(sUsername, sPassword: String): Boolean;
var
  FUser : TRESTLoginController;
begin

  try
    Result := False;
    FUser := TRESTLoginController.Create();
    if not FUser.ValidaLogin(sUsername, sPassword) then
    begin
      Common.Notificacao.TLoading.ToastMessage(Self, 'Usuário ou senha inválidos!', TAlignLayout.Bottom, $FFFF0000, $FFFFFFFF);
      Exit;
    end;
    if not FUser.UsuarioAtivo(sUsername) then
    begin
      Common.Notificacao.TLoading.ToastMessage(Self, 'Usuário INATIVO!', TAlignLayout.Bottom, $FFFF0000, $FFFFFFFF);
      Exit;
    end;
    Common.Params.paramUserName := editUserName.Text;
    Result := True;
  finally
    FUser.Free;
  end;
end;

end.
