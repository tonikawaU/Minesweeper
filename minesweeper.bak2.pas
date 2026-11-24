program minesweeper;
uses crt;

const
	KEY_LEFT = -75;
	KEY_RIGHT = -77;
	KEY_UP = -72;
	KEY_DOWN = -80;
	KEY_ESCAPE = 27;
	KEY_X = 120;
	KEY_SPACE = 32;
	
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
	CX, CY: integer; { позиция курсора в клетках поля }

procedure GetKey(var CODE: integer);
var
	k: char;
begin
	k := ReadKey;
	if k = #0 then
	begin
		k := ReadKey;
		CODE := -ord(k)
	end
	else
		CODE := ord(k)
end;

procedure GotoXY_F(X, Y: integer);
begin
	GotoXY((X - 1) * 2 + Left_Edge, Y + Up_Edge - 1)
end;

function RandomBoolean(): boolean;
begin
	RandomBoolean := random(2) = 1
end;

procedure Init();
begin
	SaveTextAttr := TextAttr;
	Left_Edge := (ScreenWidth - EDGE_LENGTH * 2) div 2 + 1;
	Up_Edge := (ScreenHeight - EDGE_LENGTH) div 2 + 1;
	CX := 1;
	CY := 1
end;

{ Только данные, ничего не рисует }
procedure SetField(var F: Field);
var
	x, y: integer;
begin
	for y := 1 to EDGE_LENGTH do
		for x := 1 to EDGE_LENGTH do
		begin
			F[y][x].Mined := RandomBoolean;
			F[y][x].Hidden := True;
			F[y][x].FlaggedMistaken := False;
			F[y][x].Flagged := False;
			F[y][x].Exploded := False;
			F[y][x].Digit := 0
		end
end;

{ Только рисует, данные не меняет }
procedure FieldUpdate(var F: Field);
var
	x, y: integer;
begin
	for y := 1 to EDGE_LENGTH do
		for x := 1 to EDGE_LENGTH do
		begin
			GotoXY_F(x, y);
			if (x = CX) and (y = CY) then
			begin
				TextBackground(LightGray);
				TextColor(Black)
			end;
			if F[y][x].Flagged then
				write('|''')
				
			else if F[y][x].Hidden then
				write('[]')
			
			else
				write('  ');
			TextAttr := SaveTextAttr
		end;
	GotoXY(1, 1)
end;

{ Только меняет CX и CY, экран не трогает }
procedure Navigation(OPTION: integer; var g_CX, g_CY: integer);
begin
	case OPTION of
		KEY_LEFT:
			if g_CX > 1 then
				g_CX := g_CX - 1;
		KEY_RIGHT:
			if g_CX < EDGE_LENGTH then
				g_CX := g_CX + 1;
		KEY_UP:
			if g_CY > 1 then
				g_CY := g_CY - 1;
		KEY_DOWN:
			if g_CY < EDGE_LENGTH then
				g_CY := g_CY + 1
	end
end;

procedure Keys(OPTION, x, y: integer; var F: Field);

begin
	case OPTION of 
		KEY_X:
			if not F[y][x].Flagged then
				F[y][x].Hidden := False;
		KEY_SPACE:
			if F[y][x].Hidden then
				F[y][x].Flagged := not F[y][x].Flagged	
	end
end;

begin
	Init;
	randomize;
	SetField(MineField);
	clrscr;
	repeat
		FieldUpdate(MineField);
		GetKey(c);
		Navigation(c, CX, CY);
		Keys(c, CX, CY, MineField)
	until c = KEY_ESCAPE;
	TextAttr := SaveTextAttr;
	clrscr
end.
