program matrix;

const chars: string = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ{}|:<>?!@#$%^&*()_+~[]\;,./';
  screenw = 80; screenh = 25;

type cell = record
  ch: char;
  attr: byte;
end;

var vidmem: array [1..screenh, 1..screenw] of cell absolute $B800:0000;

function KeyPressed: boolean; assembler;
asm
  mov ax, $100
  int $16
  mov al, False
  jz @1
  inc al
@1:
end;

function ReadKey: char; assembler;
asm
  mov ah, $07
  int $21
end;

procedure Sleep(ms: word); assembler;
asm
  mov ax, 1000
  mul ms
  mov cx, dx
  mov dx, ax
  mov ah, $86
  int $15
end;

function RandRange(lo, hi: integer): integer;
begin RandRange := lo + Random(hi)
end;

function RandChar: char;
begin RandChar := chars[RandRange(1, Length(chars))]
end;

procedure DoCol(col: integer);
var i, j: integer;
begin i := 1;
  while (i < screenh) and (vidmem[i, col].attr = 0) do Inc(i);

  if i = screenh then
    vidmem[RandRange(1, 10), col].attr := 2
  else begin
    j := i;
    while (j < screenh) and (vidmem[j, col].attr <> 0) do Inc(j);
    vidmem[j - 1, col].attr := 2;
    vidmem[j, col].attr := 15;
  end;

  if (j - i > RandRange(2, 5)) or (i > 20) then vidmem[i, col].attr := 0;
end;

procedure Tick;
var col, i: integer;
begin for col := 1 to screenw do DoCol(col)
end;

var i, j: integer;
begin
  for i := 1 to screenh do
    for j := 1 to screenw do begin
      vidmem[i, j].ch := RandChar;
      vidmem[i, j].attr := 0;
    end;

  for i := 1 to screenw do vidmem[RandRange(1, screenh), i].attr := 2;

  while True do begin
    for i := 1 to screenw do DoCol(i);
    Sleep(50);
    if KeyPressed then break
  end
end.