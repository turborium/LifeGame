unit game;

{$mode delphi}

interface

uses
  Classes, SysUtils;

type

  { TLifeGame }

  TLifeGame = class
  private
    Map: array of array of Byte;
    OldMap: array of array of Byte;
    FHeight: Integer;
    FWidth: Integer;
    function GetCells(X, Y: Integer): Boolean;
    procedure SetCells(X, Y: Integer; AValue: Boolean);
    procedure SetHeight(AValue: Integer);
    procedure SetWidth(AValue: Integer);
  public
    constructor Create(const Width, Height: Integer);
    procedure SetSize(const Width, Height: Integer);
    procedure MakeRandom;
    procedure Clear;
    procedure NextStep;
    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
    property Cells[X, Y: Integer]: Boolean read GetCells write SetCells;
  end;

implementation

{ TLifeGame }

procedure TLifeGame.SetHeight(AValue: Integer);
begin
  if FHeight = AValue then
    Exit;
  FHeight := AValue;
  SetSize(Width, Height);
end;

function TLifeGame.GetCells(X, Y: Integer): Boolean;
begin
  if (X < 0) or (X >= Width) or
     (Y < 0) or (Y >= Height) then
    Exit;
  Result := Boolean(Map[X, Y]);
end;

procedure TLifeGame.SetCells(X, Y: Integer; AValue: Boolean);
begin
  if (X < 0) or (X >= Width) or
     (Y < 0) or (Y >= Height) then
    Exit;
  Map[X, Y] := Byte(AValue);
end;

procedure TLifeGame.SetWidth(AValue: Integer);
begin
  if FWidth = AValue then
    Exit;
  FWidth := AValue;
  SetSize(Width, Height);
end;

constructor TLifeGame.Create(const Width, Height: Integer);
begin
  Inherited Create;

  SetSize(Width, Height);
end;

procedure TLifeGame.SetSize(const Width, Height: Integer);
begin
  FWidth := Width;
  FHeight := Height;

  SetLength(Map, Width, Height);
  SetLength(OldMap, Width, Height);
end;

procedure TLifeGame.MakeRandom;
var
  X, Y: Integer;
begin
  for X := 0 to Width - 1 do
    for Y := 0 to Height - 1 do
      Map[X, Y] := Random(2);
end;

procedure TLifeGame.Clear;
var
  X, Y: Integer;
begin
  for X := 0 to Width - 1 do
    for Y := 0 to Height - 1 do
      Map[X, Y] := 0;
end;

procedure TLifeGame.NextStep;

  function CalcCount(const X, Y: Integer): Byte;
  var
    Dx, Dy: Integer;
    Ax, Ay: Integer;
  begin
    Result := 0;

    for Dx := -1 to 1 do
      for Dy := -1 to 1 do
      begin
        if (Dx = 0) and (Dy = 0) then
          Continue;
        Ax := X + Dx;
        Ay := Y + Dy;
        if Ax >= Width then Ax := 0;
        if Ax < 0 then Ax := Width - 1;
        if Ay >= Height then Ay := 0;
        if Ay < 0 then Ay := Height - 1;
        Result := Result + OldMap[Ax, Ay];
      end;
  end;

var
  X, Y: Integer;
  Count: Byte;
begin
  for X := 0 to Width - 1 do
    for Y := 0 to Height - 1 do
      OldMap[X, Y] := Map[X, Y];

  for X := 0 to Width - 1 do
    for Y := 0 to Height - 1 do
    begin
      Count := CalcCount(X, Y);
      if (OldMap[X, Y] = 0) and (Count = 3) then
        Map[X, Y] := 1
      else if (OldMap[X, Y] = 1) and ((Count = 2) or (Count = 3)) then
        Map[X, Y] := 1
      else
        Map[X, Y] := 0;
    end;
end;

end.

