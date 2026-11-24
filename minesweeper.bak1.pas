program minesweeper; {15 states of the cell}
uses crt;
const
	KEY_LEFT = -75;
	KEY_RIGHT = -77;
	KEY_UP = -72;
	KEY_DOWN = -80;
	KEY_ESCAPE = 27;
	SPACE = 32; 
	KEY_X = 120;

	EDGE_LENGTH = 9;
type
	Cell = Record 
		Exploded, Mined, FlaggedMistaken, Flagged, Hidden: boolean;
		Digit: 0..8;
	end;
	Field = array [1..EDGE_LENGTH] of array [1..EDGE_LENGTH] of Cell;
var
	SaveTextAttr: integer;
	MineField: Field;
	Left_Edge: integer;
	Up_Edge: integer;
	c: integer;

procedure GetKey(var CODE: integer);
var
	c: char;
begin
	c := ReadKey;
	if c = #0 then
	begin
		c := ReadKey;
		CODE := -ord(c)
	end
else
	CODE := ord(c)
end;

procedure GotoXY_F(X, Y: integer);
begin
	GotoXY((X - 1) * 2 + Left_Edge, Y + Up_Edge - 1)
end;

function RandomBoolean(): boolean;
var
	res: integer;
begin
	res := random(2);
	if res = 0 then
		RandomBoolean := False
	else
		RandomBoolean := True
end;

procedure Init();
begin
	SaveTextAttr := TextAttr;
	Left_Edge := (ScreenWidth - EDGE_LENGTH * 2) div 2 + 1;
	Up_Edge := (ScreenHeight - EDGE_LENGTH) div 2 + 1;

end;

procedure SetField(var g_MineField: Field; S: boolean);
var
	x, y: integer;
begin
	for y := 1 to EDGE_LENGTH do
		for x := 1 to EDGE_LENGTH do
		begin
			if S then
			begin
				MineField[y][x].Mined := RandomBoolean;
				MineField[y][x].Hidden := True;
				MineField[y][x].FlaggedMistaken := False;
				MineField[y][x].Flagged := False;
				MineField[y][x].Exploded := False
			end;
			
		end;
end;

procedure FieldUpdate(var g_MineField: Field);
var
	x, y: integer;
begin
	for y := 1 to EDGE_LENGTH do 
		for x := 1 to EDGE_LENGTH do
		begin
			GotoXY_F(x, y);
			if MineField[y][x].Hidden then
				write('[]');
			else
				{Write here amount of mines in the 3x3 field around the cell}
		end;	
	GotoXY(1, 1)
end;
	
begin
	SetField(MineField, True);
	while true do
	begin
		clrscr;
		Init;
		randomize;
		SetField(MineField, False)
		FieldUpdate(MineField);
		GetKey(c);
		if c = KEY_ESCAPE then
			halt(0)
	end;
	TextAttr := SaveTextAttr;
	clrscr;
end.
