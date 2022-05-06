unit View.SuporteRemessa;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  System.Actions, FMX.ActnList, FMX.ListBox, FMX.Edit, FMX.EditBox, FMX.NumberBox, System.DateUtils, FMX.ComboEdit,
  Data.DB, System.Rtti, FMX.Grid.Style, FMX.ScrollBox,
  FMX.Grid, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.Grid,
  Data.Bind.DBScope, FMX.DateTimeCtrls, Controller.RESTSuportTracking, FMX.Memo, FMX.TabControl,
  FMX.Styles.Objects, System.Permissions, FMX.Media, ZXing.BarcodeFormat, ZXing.ReadResult,
  ZXing.ScanManager, FMX.StdActns, FMX.MediaLibrary.Actions, FMX.MediaLibrary, FMX.Platform;

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
    TabItem2: TTabItem;
    Button1: TButton;
    Layout1: TLayout;
    Image2: TImage;
    editParametro: TEdit;
    Image1: TImage;
    Layout2: TLayout;
    editTelefone1: TEdit;
    editTelefone3: TEdit;
    editTelefone2: TEdit;
    editEndereco: TMemo;
    TabStyleTextObject1: TTabStyleTextObject;
    Layout3: TLayout;
    Layout4: TLayout;
    imageCamera: TImage;
    actionTakePhoto: TAction;
    Button2: TButton;
    Button3: TButton;
    TakePhotoFromCameraAction: TTakePhotoFromCameraAction;
    Label1: TLabel;
    procedure imageExitMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure actionProcessarExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure actionLimparCamposExecute(Sender: TObject);
    procedure actionDetalharExecute(Sender: TObject);
    procedure actionLerBarrasExecute(Sender: TObject);
    procedure actionIniciarExecute(Sender: TObject);
    procedure actionPararExecute(Sender: TObject);
    procedure Image2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure TabControl1Change(Sender: TObject);
    procedure actionTakePhotoExecute(Sender: TObject);
    procedure TakePhotoFromCameraActionDidFinishTaking(Image: TBitmap);
  private
    { Private declarations }
    FPermissionCamera, FPermissionReadExternalStorage,
    FPermissionWriteExternalStorage: string;
    procedure CameraDidFinishTakingHandler(Image: TBitmap);
    procedure TakePhoto;
    procedure LimpaTela;
    procedure DetalhaEntregas(sAWB: string);
    function Decode(): boolean;
    function ValidaDados(): boolean;
    procedure DisplayRationale(Sender: TObject;
      const APermissions: TArray<string>; const APostRationaleProc: TProc);
    procedure TakePicturePermissionRequestResult(Sender: TObject;
      const APermissions: TArray<string>;
      const AGrantResults: TArray<TPermissionStatus>);

  public
    { Public declarations }
  end;

var
  view_SuporteRemessa: Tview_SuporteRemessa;

implementation

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}

uses {$IFDEF ANDROID}
  Androidapi.Helpers,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Os,
{$ENDIF}
DM.Main, Common.Params, Common.Notificacao, FMX.DialogService;

procedure Tview_SuporteRemessa.actionDetalharExecute(Sender: TObject);
begin
  DetalhaEntregas(Trim(editParametro.Text));
end;

procedure Tview_SuporteRemessa.actionIniciarExecute(Sender: TObject);
begin
  PermissionsService.RequestPermissions
    ([FPermissionCamera, FPermissionReadExternalStorage,
    FPermissionWriteExternalStorage], TakePicturePermissionRequestResult,
    DisplayRationale);
end;

procedure Tview_SuporteRemessa.actionLerBarrasExecute(Sender: TObject);
begin
  TabControl1.TabIndex := 1;
  imageCamera.Bitmap := nil;
end;

procedure Tview_SuporteRemessa.actionLimparCamposExecute(Sender: TObject);
begin
  LimpaTela;
  editParametro.SetFocus;
end;

procedure Tview_SuporteRemessa.actionPararExecute(Sender: TObject);
begin
  TabControl1.TabIndex := 0;
  editParametro.SetFocus;
end;

procedure Tview_SuporteRemessa.actionProcessarExecute(Sender: TObject);
begin
  if not ValidaDados() then Exit;
  DetalhaEntregas(editParametro.Text);
end;

procedure Tview_SuporteRemessa.actionTakePhotoExecute(Sender: TObject);
begin
  TakePhoto;
end;

procedure Tview_SuporteRemessa.CameraDidFinishTakingHandler(Image: TBitmap);
begin
  imageCamera.Bitmap.Assign(Image);
  if not Decode() then
    Common.Notificacao.TLoading.ToastMessage(Self, 'Código de barras inválido!', TAlignLayout.Bottom, $FFFF0000, $FFFFFFFF);
end;

function Tview_SuporteRemessa.Decode(): boolean;
var
  scanBitmap: TBitmap;
  ScanManager: TScanManager;
  rs: TReadResult;
begin
  try
    Result := False;
    scanBitmap := TBitmap.Create();
    scanBitmap.Assign(imageCamera.Bitmap);
    rs := nil;
    ScanManager := TScanManager.Create(TBarcodeFormat.Auto, nil);
    rs := ScanManager.Scan(scanBitmap);
    if (rs <> nil) then
    begin
      Common.Params.paramResultReadCode := rs.text;
      editParametro.Text := Common.Params.paramResultReadCode;
      TabControl1.TabIndex := 0;
      DetalhaEntregas(Common.Params.paramResultReadCode);
    end
    else
    begin
      Exit;
    end;
    Result := True;
  finally
    ScanManager.Free;
  end;
end;

procedure Tview_SuporteRemessa.DetalhaEntregas(sAWB: string);
var
  i: Integer;
  FTracking : TRESTSuportTrackingController;
begin
  try
    Beep;
    FTracking := TRESTSuportTrackingController.Create;
    LimpaTela;
    DM_Main.memTableTracking.Active := False;
    if FTracking.SearchTracking(sAWB) then
    begin
      DM_Main.memTableTracking.First;
      editTelefone1.Text := DM_Main.memTableTrackingnum_telefone_1.AsString;
      editTelefone2.Text := DM_Main.memTableTrackingnum_telefone_2.AsString;
      editTelefone3.Text := DM_Main.memTableTrackingnum_telefone_3.AsString;
      editEndereco.Text := DM_Main.memTableTrackingdes_logradouro.AsString + ', ' +
                           DM_Main.memTableTrackingnum_logradouro.AsString + #13 +
                           DM_Main.memTableTrackingnom_bairro.AsString + #13 +
                           DM_Main.memTableTrackingnom_cidade_uf.AsString + #13 +
                           'CEP: ' + DM_Main.memTableTrackingnum_cep.AsString;
     TabStyleTextObject1.Text := DM_Main.memTableTrackingdes_complemento.Text;
    end;
    if DM_Main.memTableTrackingnum_logradouro.AsString.IsEmpty then
    begin
      Common.Notificacao.TLoading.ToastMessage(Self, 'Pedido não encontrado!', TAlignLayout.Bottom, $FFFF0000, $FFFFFFFF);
      Exit;
    end;
  finally
    DM_Main.memTableTracking.Active := False;
    FTracking.Free;
  end;
end;

procedure Tview_SuporteRemessa.DisplayRationale(Sender: TObject; const APermissions: TArray<string>;
  const APostRationaleProc: TProc);
var
  I: Integer;
  RationaleMsg: string;
begin
  for I := 0 to High(APermissions) do
  begin
    if APermissions[I] = FPermissionCamera then
      RationaleMsg := RationaleMsg +
        'O aplicativo precisa acessar a câmera para ler o código de barras' + SLineBreak +
        SLineBreak
    else if APermissions[I] = FPermissionReadExternalStorage then
      RationaleMsg := RationaleMsg +
        'O aplicativo precisa ler um arquivo de imagem do seu dispositivo';
  end;

  // Show an explanation to the user *asynchronously* - don't block this thread waiting for the user's response!
  // After the user sees the explanation, invoke the post-rationale routine to request the permissions
  TDialogService.ShowMessage(RationaleMsg,
    procedure(const AResult: TModalResult)
    begin
      APostRationaleProc;
    end)
end;

procedure Tview_SuporteRemessa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LimpaTela;
end;

procedure Tview_SuporteRemessa.FormCreate(Sender: TObject);
begin
{$IFDEF ANDROID}
  FPermissionCamera := JStringToString(TJManifest_permission.JavaClass.CAMERA);
  FPermissionReadExternalStorage :=
    JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
  FPermissionWriteExternalStorage :=
    JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
{$ENDIF}
end;

procedure Tview_SuporteRemessa.FormShow(Sender: TObject);
begin
  labelDescricao.Text := Self.Caption;
  editParametro.SetFocus;
end;

procedure Tview_SuporteRemessa.Image1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  actionLerBarrasExecute(Sender);
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
  TabStyleTextObject1.Text := '';
end;

procedure Tview_SuporteRemessa.TabControl1Change(Sender: TObject);
begin
  actionIniciarExecute(Sender);
end;

procedure Tview_SuporteRemessa.TakePhoto;
var
  LCameraService: IFMXCameraService;
  LParams: TParamsPhotoQuery;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXCameraService, LCameraService) then
  begin
    LParams.RequiredResolution := TSize.Create(1024, 1024);
    LParams.Editable := False;
    LParams.NeedSaveToAlbum := False;
    LParams.OnDidFinishTaking := CameraDidFinishTakingHandler;
    LParams.OnDidCancelTaking := nil;
    LCameraService.TakePhoto(nil, LParams);
  end;
end;

procedure Tview_SuporteRemessa.TakePhotoFromCameraActionDidFinishTaking(Image: TBitmap);
begin
  CameraDidFinishTakingHandler(Image);
end;

procedure Tview_SuporteRemessa.TakePicturePermissionRequestResult(Sender: TObject; const APermissions: TArray<string>;
  const AGrantResults: TArray<TPermissionStatus>);
begin
  if (Length(AGrantResults) = 3) and
    (AGrantResults[0] = TPermissionStatus.Granted) and
    (AGrantResults[1] = TPermissionStatus.Granted) and
    (AGrantResults[2] = TPermissionStatus.Granted) then
    begin
      //TakePhoto;
    end
  else
    TDialogService.ShowMessage
      ('Não é possível visualizar o código porque as permissões necessárias não são todas concedidas')
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

