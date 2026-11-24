program minesweeper;
uses crt;
const
	KEY_LEFT = -75;
	KEY_RIGHT = -77;
	KEY_UP = -72;
	KEY_DOWN = -80;
	KEY_ESCAPE = 27;
	SPACE = 32; 
	KEY_X = 120;

	EDGE_LENGTH = 10;
type {global}
	MATRIX_0to1 = array [1..EDGE_LENGTH] of array [1..EDGE_LENGTH] of 0..1;

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

procedure GenerateField(var FIELD_MATRIX: MATRIX_0to1);
var
	i, j: word;
begin
	randomize;
	for i := 1 to EDGE_LENGTH do
	begin
		for j := 1 to EDGE_LENGTH do
		begin
			FIELD_MATRIX[i][j] := random(2);
		end;
	end
end; {Field}

procedure ShowEncrypted(var CX, CY: integer);
var
	i, j: integer;
begin	
	GotoXY(CX, CY);
	for i := 1 to EDGE_LENGTH do
	begin
		for j := 1 to EDGE_LENGTH do
			write('[]');
		GotoXY(CX, CY + i);
	end
end; {ShowEncrypted}

procedure NavigateCursor(var CX, CY: integer; ORIENTATION_X, ORIENTATION_Y: integer; CURRENT_PLACEHOLDER: string; var OLD_PLACEHOLDER: string);
begin
	GotoXY(CX, CY);
	write(#27'[0m'); {transparent}
	write(OLD_PLACEHOLDER);
	CX := CX + ORIENTATION_X;
	CY := CY + ORIENTATION_Y;
	GotoXY(CX, CY);
	write(#27'[41m'); {red}
	write(CURRENT_PLACEHOLDER);
	OLD_PLACEHOLDER := CURRENT_PLACEHOLDER;
	GotoXY(1, 1)
end;

procedure Navigation(OPT: integer; var CX, CY, MIN_X, MAX_X, MIN_Y, MAX_Y: integer; var FIELD_MATRIX: MATRIX_0to1; var OLD_PLACEHOLDER: string);
begin
	case OPT of
		KEY_LEFT:
		begin
			if CX > MIN_X then
				NavigateCursor(CX, CY, (-2), 0, '[]', OLD_PLACEHOLDER)
		end;
		KEY_RIGHT:
		begin
			if CX < MAX_X - 2 then
				NavigateCursor(CX, CY, 2, 0, '[]', OLD_PLACEHOLDER)
		end;
		KEY_UP:
		begin
			if CY > MIN_Y then
				NavigateCursor(CX, CY, 0, (-1), '[]', OLD_PLACEHOLDER)
		end;
		KEY_DOWN:
		begin
			if CY < MAX_Y - 1 then
				NavigateCursor(CX, CY, 0, 1, '[]', OLD_PLACEHOLDER)
		end;	
		KEY_X:
		begin
			NavigateCursor(CX, CY, 0, 0, '!!', OLD_PLACEHOLDER)
		end;
		SPACE:
		begin
			NavigateCursor(CX, CY, 0, 0, '<>', OLD_PLACEHOLDER)
		end;
		KEY_ESCAPE:
			Halt(0)
	end;
	GotoXY(EDGE_LENGTH div 2, MAX_Y + 2);
	write(FIELD_MATRIX[CY - MIN_Y + 1][(CX - MIN_X) div 2 + 1])
end; {Navigation}

var {global}
	DEFAULT_TEXT_ATTR: integer;
	FIELD_MATRIX: MATRIX_0to1;
	CX, CY, c, MIN_X, MAX_X, MIN_Y, MAX_Y: integer;
	OLD_PLACEHOLDER: string;
begin {main}
	OLD_PLACEHOLDER := '[]';
	DEFAULT_TEXT_ATTR := TextAttr;
	CX := (ScreenWidth - EDGE_LENGTH * 2) div 2;
	CY := (ScreenHeight - EDGE_LENGTH) div 2;
	MIN_X := CX;
	MAX_X := CX + (EDGE_LENGTH * 2);
	MIN_Y := CY;
	MAX_Y := CY + EDGE_LENGTH;
	clrscr;
	GenerateField(FIELD_MATRIX);
	ShowEncrypted(CX, CY);
	GotoXY(CX, CY);
	write(#27'[41m'); {red}
	write('[]');
	GotoXY(1, 1);
	while true do
	begin
		GetKey(c);
		Navigation(c, CX, CY, MIN_X, MAX_X, MIN_Y, MAX_Y, FIELD_MATRIX, OLD_PLACEHOLDER);
	end;
	TextAttr := DEFAULT_TEXT_ATTR;
	clrscr
end.
