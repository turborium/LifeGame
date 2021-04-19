unit UnitMain;

{$mode delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, ComCtrls, SpinEx, Game;

type

  { TFormMain }

  TFormMain = class(TForm)
    ButtonClear: TButton;
    ButtonRandom: TButton;
    ButtonRun: TBitBtn;
    ButtonNextStep: TBitBtn;
    ButtonStop: TBitBtn;
    GroupBoxSize: TGroupBox;
    GroupBoxControl: TGroupBox;
    GroupBoxDelay: TGroupBox;
    GroupBoxEdit: TGroupBox;
    ImageList: TImageList;
    LabelWidth: TLabel;
    LabelHeight: TLabel;
    PaintBoxDisp: TPaintBox;
    PanelControl: TPanel;
    ScrollBoxDisp: TScrollBox;
    EditWidth: TSpinEditEx;
    EditHeight: TSpinEditEx;
    TimerGame: TTimer;
    TrackBarDelay: TTrackBar;
    procedure ButtonClearClick(Sender: TObject);
    procedure ButtonNextStepClick(Sender: TObject);
    procedure ButtonRandomClick(Sender: TObject);
    procedure ButtonRunClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure EditHeightChange(Sender: TObject);
    procedure EditWidthChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBoxDispMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBoxDispPaint(Sender: TObject);
    procedure TimerGameTimer(Sender: TObject);
    procedure TrackBarDelayChange(Sender: TObject);
  private
    Game: TLifeGame;
    procedure Run;
    procedure Stop;
    procedure ResizeGame;
  public

  end;

var
  FormMain: TFormMain;

implementation

{$R *.lfm}

const
  CellWidth = 16;
  DefaultGameWidth = 40;
  DefaultGameHeight = 30;
  DefaultDelay = 400;

{ TFormMain }

procedure TFormMain.PaintBoxDispPaint(Sender: TObject);
var
  X, Y: Integer;
begin
  PaintBoxDisp.Canvas.Pen.Color := clGray;
  for Y := 0 to Game.Height - 1 do
  begin
    for X := 0 to Game.Width - 1 do
    begin
      if Game.Cells[X, Y] then
        PaintBoxDisp.Canvas.Brush.Color := clRed
      else
        PaintBoxDisp.Canvas.Brush.Color := clWhite;
      PaintBoxDisp.Canvas.Rectangle(
        X * CellWidth, Y * CellWidth,
        X * CellWidth + CellWidth + 1, Y * CellWidth + CellWidth + 1
      );
    end;
  end;
end;

procedure TFormMain.TimerGameTimer(Sender: TObject);
begin
  Game.NextStep;
  PaintBoxDisp.Invalidate;
end;

procedure TFormMain.TrackBarDelayChange(Sender: TObject);
begin
  TimerGame.Interval := TrackBarDelay.Position;
end;

procedure TFormMain.Run;
begin
  TimerGame.Enabled := True;
  ButtonNextStep.Enabled := False;
  ButtonRun.Enabled := False;
  ButtonStop.Enabled := True;
end;

procedure TFormMain.Stop;
begin
  TimerGame.Enabled := False;
  ButtonNextStep.Enabled := True;
  ButtonRun.Enabled := True;
  ButtonStop.Enabled := False;
end;

procedure TFormMain.ResizeGame;
begin
  PaintBoxDisp.Width := Game.Width * CellWidth + 1;
  PaintBoxDisp.Height := Game.Height * CellWidth + 1;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  Game := TLifeGame.Create(DefaultGameWidth, DefaultGameHeight);

  EditWidth.Value := Game.Width;
  EditHeight.Value := Game.Height;

  TrackBarDelay.Position := DefaultDelay;
  TimerGame.Interval := DefaultDelay;

  ResizeGame;
  Stop;
end;

procedure TFormMain.ButtonNextStepClick(Sender: TObject);
begin
  Game.NextStep;
  PaintBoxDisp.Invalidate;
end;

procedure TFormMain.ButtonRandomClick(Sender: TObject);
begin
  Game.MakeRandom;
  PaintBoxDisp.Invalidate;
end;

procedure TFormMain.ButtonClearClick(Sender: TObject);
begin
  Game.Clear;
  PaintBoxDisp.Invalidate;
end;

procedure TFormMain.ButtonRunClick(Sender: TObject);
begin
  Run;
end;

procedure TFormMain.ButtonStopClick(Sender: TObject);
begin
  Stop;
end;

procedure TFormMain.EditHeightChange(Sender: TObject);
begin
  Game.Height := EditHeight.Value;
  ResizeGame;
end;

procedure TFormMain.EditWidthChange(Sender: TObject);
begin
  Game.Width := EditWidth.Value;
  ResizeGame;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  Game.Free;
end;

procedure TFormMain.PaintBoxDispMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  CellX, CellY: Integer;
begin
  CellX := X div CellWidth;
  CellY := Y div CellWidth;

  if Game.Cells[CellX, CellY] then
    Game.Cells[CellX, CellY] := False
  else
    Game.Cells[CellX, CellY] := True;

  PaintBoxDisp.Invalidate;
end;

end.

