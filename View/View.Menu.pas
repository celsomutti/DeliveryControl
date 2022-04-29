unit View.Menu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.TabControl, FMX.ListBox, System.Actions, FMX.ActnList;

type
  Tview_Menu = class(TForm)
    layoutTitle: TLayout;
    rectangleTitle: TRectangle;
    labelTitle: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  view_Menu: Tview_Menu;

implementation

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}

end.
