unit MIRROR;

interface

var
zl:string;
i,j:integer;
var datei1, datei2:text;
var filename:string;
face:array[1..4]of string;

procedure spiegeln(var zl:string);

implementation

procedure spiegeln(var zl:string);
begin
if (copy(zl,1,6)='vertex') or (copy(zl,1,6)='Vertex') then
if pos('-',zl)=8 then
delete(zl,8,1)
else
insert('-',zl,8);

if (copy(zl,1,4)='face') or (copy(zl,1,4)='Face') then
begin
delete(zl,1,5);

repeat;
if pos(' ',zl)=1 then delete (zl,1,1);
face[1]:=concat(face[1],copy(zl,1,1));
delete(zl,1,1);
until pos(',',zl)=1;

delete(zl,1,1);
repeat;
if pos(' ',zl)=1 then delete (zl,1,1);
face[2]:=concat(face[2],copy(zl,1,1));
delete(zl,1,1);
until pos(',',zl)=1;

delete(zl,1,1);
repeat;
if pos(' ',zl)=1 then delete (zl,1,1);
face[3]:=concat(face[3],copy(zl,1,1));
delete(zl,1,1);
until (pos(',',zl)=1) or (length(zl)=0);
delete(zl,1,1);
repeat;
if pos(' ',zl)=1 then delete (zl,1,1);
face[4]:=concat(face[4],copy(zl,1,1));
delete(zl,1,1);
until length(zl)=0;
if face[4]='' then
zl:=concat('face ',face[3],',',face[2],',',face[1])
else
zl:=concat('face ',face[4],',',face[3],',',face[2],',',face[1]);
end;

end;

end.
