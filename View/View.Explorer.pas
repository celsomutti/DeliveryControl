unit View.Explorer;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, System.IOUtils, FMX.Objects, FMX.Layouts,
  FMX.ListBox, System.Generics.Collections, Generics.Defaults,
  FMX.VirtualKeyboard, FMX.Platform;

type
  Tview_Explorer = class(TForm)
    lbl_titulo: TLabel;
    btn_cad_voltar: TSpeedButton;
    lbl_path: TLabel;
    ListBox: TListBox;
    img_folder: TImage;
    img_file: TImage;
    btn_fechar: TSpeedButton;
    Rectangle1: TRectangle;
    procedure FormShow(Sender: TObject);
    procedure MontarLista(path_tr: string; clear: boolean);
    procedure AddListItem(list: array of string; itype: string);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btn_cad_voltarClick(Sender: TObject);
    procedure btn_fecharClick(Sender: TObject);
    procedure ListBoxItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    { Private declarations }
    caminho: string;
  public
    { Public declarations }
    arquivo : string;
  end;

var
  view_Explorer: Tview_Explorer;


implementation

{$R *.fmx}

procedure Tview_Explorer.FormShow(Sender: TObject);
begin
    arquivo := '';
    caminho := System.IOUtils.TPath.GetSharedDownloadsPath;

    MontarLista(caminho, true);
end;

procedure Tview_Explorer.AddListItem(list: array of string; itype: string);
var
    c: integer;
    LItem: TListBoxItem;
    BitmapFolder, BitmapFile: TBitmap;
begin
    BitmapFolder := img_folder.Bitmap;
    BitmapFile := img_file.Bitmap;

    ListBox.BeginUpdate;

    for c := 0 to Length(list) - 1 do
    begin
        LItem := TListBoxItem.Create(ListBox);

        if itype = 'pasta' then
        begin
            if BitmapFolder <> nil then
                LItem.ItemData.Bitmap.Assign(BitmapFolder);
        end
        else
        begin
            if BitmapFile <> nil then
                LItem.ItemData.Bitmap.Assign(BitmapFile);
        end;

        LItem.Height := 40;
        LItem.ItemData.Text := ExtractFileName(list[c]);
        LItem.ItemData.Detail := list[c];
        LItem.TagString := itype;
        ListBox.AddObject(LItem);
    end;

    ListBox.EndUpdate;
end;

procedure Tview_Explorer.MontarLista(path_tr: string; clear: boolean);
var
    folders, files: TStringDynArray;
begin
    lbl_path.Text := path_tr;

    folders := TDirectory.GetDirectories(path_tr);

    TArray.Sort<String>(folders, TComparer<String>.Construct(
                      function(const Left, Right: string): Integer
                      begin
                        Result := CompareStr(AnsiLowerCase(Left), AnsiLowerCase(Right));
                      end));

    if clear then
        ListBox.Clear;

    AddListItem(folders, 'pasta');

    //----------------------------------------------

    files := TDirectory.GetFiles(path_tr);

    TArray.Sort<String>(files, TComparer<String>.Construct(
                      function(const Left, Right: string): Integer
                      begin
                        Result := CompareStr(AnsiLowerCase(Left), AnsiLowerCase(Right));
                      end));

    AddListItem(files, 'arquivo');

    ListBox.ScrollToItem(ListBox.ItemByIndex(0));
end;

procedure Tview_Explorer.btn_cad_voltarClick(Sender: TObject);
begin
    // Fecha a tela...
    if (caminho = '') or (caminho = '/') then
    begin
        arquivo := '';
        close;
    end;

    caminho := ExtractFileDir(caminho);

    MontarLista(caminho, True);
end;

procedure Tview_Explorer.btn_fecharClick(Sender: TObject);
begin
    arquivo := '';
    close;
end;

procedure Tview_Explorer.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
{$IFDEF ANDROID}
var
        FService : IFMXVirtualKeyboardService;
{$ENDIF}
begin
    {$IFDEF ANDROID}
    if (Key = vkHardwareBack) then
    begin
        TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));

        if (FService <> nil) and NOT (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then
        begin
            // Botao back pressionado e teclado NAO visivel...
            btn_cad_voltarClick(Self);
            Key := 0;
        end;
    end;
    {$ENDIF}
end;

procedure Tview_Explorer.ListBoxItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
    if Item.TagString = 'pasta' then // Clicou sobre uma pasta...
    begin
        caminho := Item.ItemData.Detail;

        if TDirectory.Exists(caminho) then
            MontarLista(caminho, True)
        else
        begin
            ListBox.Items.Delete(Item.Index);
            ShowMessage('Não foi possível abrir a pasta selecionada');
        end;
    end
    else // Clicou sobre um arquivo...
    if Item.TagString = 'arquivo' then
    begin
        arquivo := Item.ItemData.Detail;
        close;
    end;
end;

end.
