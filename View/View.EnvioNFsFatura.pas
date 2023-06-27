unit View.EnvioNFsFatura;

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
  ZXing.ScanManager, FMX.StdActns, FMX.MediaLibrary.Actions, FMX.MediaLibrary, FMX.Platform,
  System.IOUtils, System.Threading, u99Permissions, Controller.RESTNFsFaturas, Androidapi.Helpers, FMX.Helpers.Android,
  Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.Net, Androidapi.JNI.JavaTypes, Androidapi.JNI.provider,
  Androidapi.JNI.App, AndroidAPI.jNI.OS, Androidapi.JNIBridge, IdUri, FMX.Platform.Android,
  ScBridge, ScSSHClient, ScSFTPClient;

  type
  Tview_EnvioNfsFatura = class(TForm)
    layoutPadrao: TLayout;
    actionListExtratos: TActionList;
    actionProcessar: TAction;
    layoutFiltro: TLayout;
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
    TabItem2: TTabItem;
    Layout3: TLayout;
    Layout4: TLayout;
    imageCamera: TImage;
    actionTakePhoto: TAction;
    TakePhotoFromCameraAction: TTakePhotoFromCameraAction;
    actionEnviarNFs: TAction;
    layoutVencimento: TLayout;
    dataVencimento: TDateEdit;
    Label1: TLabel;
    AniIndicator1: TAniIndicator;
    TakePhotoFromLibraryAction: TTakePhotoFromLibraryAction;
    actionProcurarFoto: TAction;
    imageOtherfiles: TImage;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    actionFechar: TAction;
    labelAviso: TLabel;
    ScSFTPClient: TScSFTPClient;
    ScSSHClient: TScSSHClient;
    ScFileStorage: TScFileStorage;
    procedure FormShow(Sender: TObject);
    procedure actionLerBarrasExecute(Sender: TObject);
    procedure actionPararExecute(Sender: TObject);
    procedure actionEnviarNFsExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TakePhotoFromCameraActionDidFinishTaking(Image: TBitmap);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TakePhotoFromLibraryActionDidFinishTaking(Image: TBitmap);
    procedure actionTakePhotoExecute(Sender: TObject);
    procedure actionProcurarFotoExecute(Sender: TObject);
    procedure imageExitClick(Sender: TObject);
    procedure imageExitMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure actionFecharExecute(Sender: TObject);
    procedure imageCameraClick(Sender: TObject);
    procedure ScSSHClientServerKeyValidate(Sender: TObject;
      NewServerKey: TScKey; var Accept: Boolean);
  private
    { Private declarations }
    permissao : T99Permissions;
    procedure PreparaArquivo;
    procedure SendFile(sFile: string);
    procedure TrataPermissao(Sender: TObject);
    procedure TrataPermissaoErro(Sender: TObject);
    function SalvaNFsFatura(): boolean;
    function GetFileUri(aFile: String): JNet_Uri;
    procedure OpenDPDF(sFile: string);
  public
    { Public declarations }
  end;

  type
  JFileProvider = interface;
  JFileProviderClass = interface(JContentProviderClass)
    ['{33A87969-5731-4791-90F6-3AD22F2BB822}']
    {class} function getUriForFile(context: JContext; authority: JString; _file: JFile): Jnet_Uri; cdecl;
    {class} function init: JFileProvider; cdecl;
  end;

  [JavaSignature('android/support/v4/content/FileProvider')]
  JFileProvider = interface(JContentProvider)
    ['{12F5DD38-A3CE-4D2E-9F68-24933C9D221B}']
    procedure attachInfo(context: JContext; info: JProviderInfo); cdecl;
    function delete(uri: Jnet_Uri; selection: JString; selectionArgs: TJavaObjectArray<JString>): Integer; cdecl;
    function getType(uri: Jnet_Uri): JString; cdecl;
    function insert(uri: Jnet_Uri; values: JContentValues): Jnet_Uri; cdecl;
    function onCreate: Boolean; cdecl;
    function openFile(uri: Jnet_Uri; mode: JString): JParcelFileDescriptor; cdecl;
    function query(uri: Jnet_Uri; projection: TJavaObjectArray<JString>; selection: JString; selectionArgs: TJavaObjectArray<JString>;
      sortOrder: JString): JCursor; cdecl;
    function update(uri: Jnet_Uri; values: JContentValues; selection: JString; selectionArgs: TJavaObjectArray<JString>): Integer; cdecl;
  end;

  TJFileProvider = class(TJavaGenericImport<JFileProviderClass, JFileProvider>)
  end;

var
  view_EnvioNfsFatura: Tview_EnvioNfsFatura;
  sFileName: string;
  sFile: string;
  sOtherFile: String;
  iTypeFile : integer;

implementation

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}

uses

DM.Main, Common.Params, Common.Notificacao, FMX.DialogService, View.Explorer;

procedure Tview_EnvioNfsFatura.actionEnviarNFsExecute(Sender: TObject);
begin
  PreparaArquivo;
end;


procedure Tview_EnvioNfsFatura.actionFecharExecute(Sender: TObject);
begin
  Close;
end;

procedure Tview_EnvioNfsFatura.actionLerBarrasExecute(Sender: TObject);
begin
  TabControl1.TabIndex := 1;
  imageCamera.Bitmap := nil;
end;

procedure Tview_EnvioNfsFatura.actionPararExecute(Sender: TObject);
begin
  imageOtherFiles.Visible := False;
  imageCamera.Bitmap := nil;
end;

procedure Tview_EnvioNfsFatura.actionProcurarFotoExecute(Sender: TObject);
begin
  permissao.ReadWriteFiles(TrataPermissao, TrataPermissaoErro);
end;

procedure Tview_EnvioNfsFatura.actionTakePhotoExecute(Sender: TObject);
begin
  permissao.Camera(TakePhotoFromCameraAction, TrataPermissaoErro);
end;

procedure Tview_EnvioNfsFatura.TakePhotoFromCameraActionDidFinishTaking(Image: TBitmap);
begin
  imageCamera.Bitmap.Assign(Image);
end;

procedure Tview_EnvioNfsFatura.TakePhotoFromLibraryActionDidFinishTaking(Image: TBitmap);
begin
  imageCamera.Bitmap.Assign(Image);
end;

procedure Tview_EnvioNfsFatura.FormActivate(Sender: TObject);
begin
  permissao := T99Permissions.Create;
  imageOtherFiles.Visible := False;
  dataVencimento.Date := Now();
end;

procedure Tview_EnvioNfsFatura.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  actionParar.Execute;
end;

procedure Tview_EnvioNfsFatura.FormShow(Sender: TObject);
begin
  labelDescricao.Text := Self.Caption;
  iTypeFile := 0;
end;

function Tview_EnvioNfsFatura.GetFileUri(aFile: String): JNet_Uri;
var
  FileAtt      : JFile;
  Auth         : JString;
  PackageName  : String;
begin
  PackageName := JStringToString(SharedActivityContext.getPackageName);
  FileAtt     := TJFile.JavaClass.init(StringToJString(aFile));
  Auth        := StringToJString(Packagename+'.fileprovider');
  Result      := TJFileProvider.JavaClass.getUriForFile(TAndroidHelper.Context, Auth, FileAtt);
end;

procedure Tview_EnvioNfsFatura.imageCameraClick(Sender: TObject);
begin
  if iTypeFile = 1 then
    OpenDPDF(sOtherFile);
end;

procedure Tview_EnvioNfsFatura.imageExitClick(Sender: TObject);
begin
  action
end;

procedure Tview_EnvioNfsFatura.imageExitMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  actionFechar.Execute;
end;

procedure Tview_EnvioNfsFatura.OpenDPDF(sFile: string);
var
  Str    : TStringStream;
  path   : String;
  Intent : JIntent;
  URI    : JNet_Uri;

  SPathDocs : string;
begin
//  SPathDocs := System.IOUtils.TPath.GetDocumentsPath + PathDelim;
//  Path := System.IOUtils.TPath.GetSharedDocumentsPath + PathDelim + 'tmp' + PathDelim;
//
//  if Not TDirectory.Exists(Path) then
//    TDirectory.CreateDirectory(Path);
//
//  if Switch1.IsChecked then
//  begin
//    SFile := 'Motorola_One.pdf';
//
//    TFile.Copy(SPathDocs + SFile, Path + SFile, True);
//  end
//  else
//  begin
//    SFile := 'printid.pdf';
//    Str  := TStringStream.Create;
//    Http.Get('https://www.controlid.com.br/userguide/printid.pdf', Str);
//
//    Str.Position := 0;
//    Str.SaveToFile(Path + SFile);
//    Str.DisposeOf;
//  end;

  Intent := TJIntent.JavaClass.init(TJintent.JavaClass.ACTION_VIEW);
  Uri    := GetFileURI(SFile);
  Intent.setDataAndType(Uri, StringToJString('application/pdf'));
  Intent.setFlags(TJintent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION);
  TAndroidHelper.Activity.startActivity(Intent);
end;

procedure Tview_EnvioNfsFatura.PreparaArquivo;
var
  sData : string;
begin
  if dataVencimento.IsEmpty then
  begin
    TDialogService.ShowMessage('Informe uma data de vencimento válida!');
    Exit;
  end;
  if iTypeFile = 0 then
  begin
    sData := FormatDateTime('yyyy-mm-dd', dataVencimento.Date);
    sFileName := sData + '_' + Common.Params.paramCodigoCadastro.ToString + 'fatura.jpg';
    sFile := System.IOUtils.TPath.GetSharedPicturesPath + System.SysUtils.PathDelim + sFileName;
    imageCamera.Bitmap.SaveToFile(sFile);
  end
  else
  begin
    sFile := sOtherFile;
    sFileName := ExtractFileName(sOtherFile);
  end;
  SendFile(sFile);
  SalvaNFsFatura;
end;

function Tview_EnvioNfsFatura.SalvaNFsFatura: boolean;
var
  FFaturas : TRESTNFsFaturasController;
  sCadastro, sVencimento, sArquivo, sLocalizacao: String;
begin
  try
    Result := False;
    FFaturas := TRESTNFsFaturasController.Create;
    sCadastro := Common.Params.paramCodigoCadastro.ToString;
    sVencimento := FormatDateTime('yyyy-mm-dd', dataVencimento.Date);
    sArquivo := sFileName;
    sLocalizacao := '/var/www/html/financeiro/nfs_faturas/';
    if not FFaturas.SalvaNfsFatura(sCadastro, sVencimento, sArquivo, sLocalizacao) then
    begin
      ShowMessage('Erro ao salvar a NFs / Fatura no banco de dados!');
    end;
    Result := True;
  finally
    FFaturas.DisposeOf;
  end;end;

procedure Tview_EnvioNfsFatura.ScSSHClientServerKeyValidate(Sender: TObject;
  NewServerKey: TScKey; var Accept: Boolean);
begin
  Accept := True;
end;

procedure Tview_EnvioNfsFatura.SendFile(sFile: string);
var
  Task: ITask;
  url: string;
begin
  AniIndicator1.Enabled := True;
  AniIndicator1.Visible := True;
  labelAviso.Visible := True;
  Task := TTask.Create(
    procedure
    begin
      try
        if TTask.CurrentTask.Status <> TTaskStatus.Canceled then
        begin
          TThread.Queue(TThread.CurrentThread,
            procedure
            begin
              try
                ScSSHClient.Connect;
                ScSFTPClient.Initialize;
                ScSFTPClient.UploadFile(sFile,'/var/www/html/financeiro/nfs_faturas/' + sFileName, True);
                ScSSHClient.Disconnect;
                TDialogService.ShowMessage('Arquivo enviado!');
              finally
               // turn off aniindicator
                AniIndicator1.Enabled := False;
                AniIndicator1.Visible := False;
                labelAviso.Visible := False;
              end;
            end);
        end;
      except
        TThread.Queue(TThread.CurrentThread,
          procedure
          begin
            AniIndicator1.Enabled := False;
            AniIndicator1.Visible := False;
            labelAviso.Visible := False;
          end);
      end;
    end);
  Task.Start;
end;

procedure Tview_EnvioNfsFatura.TrataPermissao(Sender: TObject);
begin
    iTypeFile := 0;
    //imageOtherFiles.Visible := False;
    imageCamera.Visible := True;
    if not Assigned(view_Explorer) then
    begin
      Application.CreateForm(Tview_Explorer, view_Explorer);
    end;
    view_Explorer.ShowModal(procedure(ModalResult: TModalResult)
    begin
        if Pos('.jpg', view_Explorer.arquivo) > 0 then
            ImageCamera.Bitmap.LoadFromFile(view_Explorer.arquivo)
        else if Pos('.jpeg', view_Explorer.arquivo) > 0 then
            ImageCamera.Bitmap.LoadFromFile(view_Explorer.arquivo)
        else if Pos('.jpe', view_Explorer.arquivo) > 0 then
            ImageCamera.Bitmap.LoadFromFile(view_Explorer.arquivo)
        else if Pos('.jfif', view_Explorer.arquivo) > 0 then
            ImageCamera.Bitmap.LoadFromFile(view_Explorer.arquivo)
        else if Pos('.gif', view_Explorer.arquivo) > 0 then
            ImageCamera.Bitmap.LoadFromFile(view_Explorer.arquivo)
        else if Pos('.tiff', view_Explorer.arquivo) > 0 then
            ImageCamera.Bitmap.LoadFromFile(view_Explorer.arquivo)
        else if Pos('.png', view_Explorer.arquivo) > 0 then
            ImageCamera.Bitmap.LoadFromFile(view_Explorer.arquivo)
        else if Pos('.pdf', view_Explorer.arquivo) > 0 then
          begin
            sOtherFile := view_Explorer.arquivo;
            ImageCamera.Bitmap.Assign(imageOtherFiles.Bitmap);
            iTypeFile := 1;
            showmessage('Arquivo Carregado. Clique na imagem para abrir o arquivo PDF');
          end;
    end);
end;


procedure Tview_EnvioNfsFatura.TrataPermissaoErro(Sender: TObject);
begin
  showmessage('Você não possui permissão');
end;

// ---------------------------------------------------------------------------------------



end.

