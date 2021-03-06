unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    TxtFX: TEdit;
    LbFx: TLabel;
    LbFxP: TLabel;
    LbAnswer: TLabel;
    BtCalcPr: TButton;
    BtNewFun: TButton;
    BtTreeAnalysis: TButton;
    BtTreePr: TButton;
    BtSimple: TButton;
    Image1: TImage;
    procedure BtCalcPrClick(Sender: TObject);
    procedure BtSimpleClick(Sender: TObject);
    procedure BtNewFunClick(Sender: TObject);
    procedure BtTreeAnalysisClick(Sender: TObject);
    procedure BtTreePrClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;
 type pstack = ^stack;
     stack = record
             info:string;
             next:pstack;
             end; //??????????? ?????

     ptree=^tree;
     tree=record
          info:string;
          left,right: ptree;
          end;
     pstack1=^stack1;
     stack1=record
            info:ptree;
            next:pstack1;
            end;//?????? ???????

var
    Form1: TForm1;
    x: pstack;
    dt:pstack1;
    t,v,tpr,tpr1:ptree;
    s,s1:String;
    i,countlevel,countdepth,lvly,radius:Integer;
    functionFX,answe: String;

implementation

{$R *.dfm}

procedure push(var x:pstack; s1:string);
var y: pstack;
begin
  New(y);
  if (y<>nil) then begin
     y^.info := s1;
     y^.next := x;
     x := y;
  end;
end;


function pop(var x:pstack): string;
begin
  pop := '#';
  if (x<>nil) then begin
     pop := x^.info;
     x := x^.next;
  end;
end;


procedure pusht(var dt:pstack1;t:ptree);
var y: pstack1;
begin
  New(y);
  y^.info := t;
  y^.next := dt;
  dt := y;
end;


function popt(var dt:pstack1): ptree;
begin
     popt := dt^.info;
     dt := dt^.next;
end;


function priority(s1: string): Integer;   //?????????
var p: Integer;
begin
  case s1[1] of
    's','c','a',
    't','l','^','&': p := 4;
    '*','/': p := 3;
    '+','-': p := 2;
    '('    : p := 1;
    else     p := 0;
  end;
  priority := p;
end;

procedure translatepost(s:string; var functionFX: String); //??????? ? ???????????
var s1: string;
begin
  x := nil;
  i := 1;
  while length(s)<>0 do begin
    if pos(' ',s)=0 then
      begin
      s1:=copy(s,1,length(s));
      delete(s,1,length(s));
      end
    else begin
         s1:=copy(s,1,pos(' ',s)-1);
         delete(s,1,pos(' ',s));
         end;
    case s1[1] of
      ')'     : begin
                 while (x^.info <> '(') do functionFX := functionFX+Pop(x)+' ';
                 Pop(x);
                 end;
      '('     : Push(x,s1[1]);
      '+','-',
      '*','/': if x=nil then Push(x,s1[1])
                 else
                  if priority(x^.info)<priority(s1[1]) then Push(x,s1[1])
                   else begin
                        while (x<>nil) and (priority(x^.info) >= priority(s1[1])) do functionFX := functionFX+Pop(x)+' ';
                        Push(x,s1[1]);
                        end;
      's','c','&',
      't','l','^','a': if x=nil then Push(x,s1)
                 else
                  if priority(x^.info)<priority(s1[1]) then Push(x,s1)
                   else begin
                        while (x<>nil) and (priority(x^.info) >= priority(s1[1])) do functionFX := functionFX+Pop(x)+' ';
                        Push(x,s1);
                        end;
    else functionFX := functionFX+s1+' ';
    end;
 end;

 while (x<>nil) do functionFX := functionFX + Pop(x)+' ';
end;

procedure stringfun(var s1,s:string); //?????? ??????
begin
 if pos(' ',s)=0 then begin
                      s1:=copy(s,1,length(s));
                      delete(s,1,length(s));
                      end
   else begin
        s1:=copy(s,1,pos(' ',s)-1);
        delete(s,1,pos(' ',s));
        end;
end;


procedure copyt( t:ptree;var v:ptree);//???????????
begin
if t<>nil then
  begin
  new(v);
  v^.info:=t^.info;
  copyt(t^.left,v^.left);
  copyt(t^.right,v^.right);
  end
  else v:=nil;
end;

procedure treer(functionFX:string; var t:ptree); //???????? ?????? ???????
var t1,t2:ptree;
    s1:string;
    w:ptree;
    dt: pstack1;
begin
 dt:=nil;
 while length(functionFX)<>0 do
     begin
     stringfun(s1,functionFX);
     new(t);
     case s1[1] of
      's',
      'c',
      't':begin
           new (w);
           t2:=popt(dt);
           w^.right:=t2;
           w^.left:=nil;
           w^.info:=s1;
           pusht(dt,w);
           end;
      'l': begin
           if s1[2]='o' then begin
              new (w);
                t2:=popt(dt);
                t1:=popt(dt);
                w^.right:=t2;
                w^.left:=t1;
                w^.info:=s1;
                pusht(dt,w);
           end
           else begin
                new (w);
                t2:=popt(dt);
                w^.left:=t2;
                w^.right:=nil;
                w^.info:=s1;
                pusht(dt,w);
           end;
           end;

      'x': begin
           new(w);
           w^.info:=s1;
           w^.left:=nil;
           w^.right:=nil;
           pusht(dt,w);
           end;
      '+',
      '-',
      '*',
      '/': begin
           new(w);
           t1:=popt(dt);
           t2:=popt(dt);
           w^.info:=s1;
           w^.left:=t2;
           w^.right:=t1;
           pusht(dt,w);
           end;
      '^': begin
           new(w);
           t1:=popt(dt);
           t2:=popt(dt);
           w^.info:=s1;
           w^.left:=t2;
           w^.right:=t1;
           pusht(dt,w);
           end;
      'a': begin
           new (w);
           t2:=popt(dt);
           w^.right:=t2;
           w^.left:=nil;
           w^.info:=s1;
           pusht(dt,w);
           end;
      '&': begin
           new (w);
           t2:=popt(dt);
           w^.right:=t2;
           w^.left:=nil;
           w^.info:=s1;
           pusht(dt,w);
           end;
     else  begin
           new(w);
           w^.left:=nil;
           w^.right:=nil;
           w^.info:=s1;
           pusht(dt,w);
           end;

     end;
   end;
   t:=popt(dt);
end;





procedure treep (t:ptree;var tpr:ptree); //?????? ???????????
var v1,v2,w1,w2,h1,h2,a1,a2:ptree;
begin
new (tpr);
case t^.info[1] of
 '+',
 '-': begin
      tpr^.info:=t^.info;
      treep(t^.left,tpr^.left);
      treep(t^.right,tpr^.right);
      end;
 'x': begin
      tpr^.info:='1';
      tpr^.left:=nil;
      tpr^.right:=nil;
      end;
 '*': begin
      tpr^.info:='+';
      new(v1);
      new(v2);
      tpr^.left:=v1;
      tpr^.right:=v2;
      v1^.info:='*';
      v2^.info:='*';
      treep(t^.left,v1^.left);
      copyt(t^.right,v1^.right);
      copyt(t^.left,v2^.left);
      treep(t^.right,v2^.right);
      end;
 '/': begin
      tpr^.info:='/';
      new(v1);
      new(v2);
      tpr^.left:=v1;
      tpr^.right:=v2;
      v1^.info:='-';
      v2^.info:='*';
      new(w1);
      new(w2);
      v1^.left:=w1;
      v1^.right:=w2;
      w1^.info:='*';
      w2^.info:='*';
      treep(t^.left,w1^.left);
      copyt(t^.right,w1^.right);

      copyt(t^.left,w2^.left);
      treep(t^.right,w2^.right);

      copyt(t^.right,v2^.left);
      copyt(t^.right,v2^.right);
      end;
 's': begin
      tpr^.info:='*';
      new(v1);
      tpr^.right:=v1;
      v1^.info:='cos';
      copyt(t^.right,v1^.right);
      v1^.left:=nil;
      treep(v1^.right,tpr^.left)
      end;
 'c': begin
      if t^.info[2]='o' then begin
         tpr^.info:='*';
         new(v1);
         tpr^.right:=v1;
         v1^.info:='*';
         new(w1);
         new(w2);
         v1^.left:=w1;
         v1^.right:=w2;
         w2^.info:='-1';
         w2^.right:=nil;
         w2^.left:=nil;
         w1^.info:='sin';
         copyt(t^.right,w1^.right);
         w1^.left:=nil;
         treep(w1^.right,tpr^.left);
      end
      else if t^.info[2]='t' then begin
      tpr^.info:='*';
      treep(t^.right,tpr^.right);
      new(v1);
      tpr^.left:=v1;
      v1^.info:='/';

      new(w1);
      new(w2);
      v1^.left:=w1;
      v1^.right:=w2;
      w1^.info:='-1';
      w1^.left:=nil;
      w1^.right:=nil;
      w2^.info:='^';
      new(h2);
      new (h1);
      w2^.right:=h2;
      h2^.info:='2';
      h2^.left:=nil;
      h2^.right:=nil;
      w2^.left:=h1;
      h1^.info:='sin';
      h1^.left:=nil;
      copyt(t^.right,h1^.right)
      end;
      end;
 't': begin
      tpr^.info:='*';
      treep(t^.right,tpr^.right);
      new(v1);
      tpr^.left:=v1;
      v1^.info:='/';

      new(w1);
      new(w2);
      v1^.left:=w1;
      v1^.right:=w2;
      w1^.info:='1';
      w1^.left:=nil;
      w1^.right:=nil;
      w2^.info:='^';
      new(h2);
      new (h1);
      w2^.right:=h2;
      h2^.info:='2';
      h2^.left:=nil;
      h2^.right:=nil;
      w2^.left:=h1;
      h1^.info:='cos';
      h1^.left:=nil;
      copyt(t^.right,h1^.right)
      end;
 'l': begin
      if t^.info[2]='n' then begin
         tpr^.info:='*';
         new(v1);
         tpr^.left:=v1;
         v1^.info:='/';
         new(w1);
         v1^.left:=w1;
         w1^.info:='1';
         w1^.left:=nil;
         w1^.right:=nil;

         copyt(t^.left,v1^.right);
         treep(v1^.right,tpr^.right);
      end
      else if t^.info[2]='o' then begin
           tpr^.info:='*';
           new(v1);
           tpr^.left:=v1;
           v1^.info:='/';
           new(w1);
           new(w2);
           v1^.left:=w1;
           v1^.right:=w2;
           w1^.info:='1';
           w1^.left:=nil;
           w1^.right:=nil;
           w2^.info:='*';
           copyt(t^.right,w2^.left);
           new(h1);
           w2^.right:=h1;
           h1^.info:='ln';

           copyt(t^.left,h1^.right);
           treep(t^.right,tpr^.right);
      end;
      end;
 '^': begin
      if (t^.right^.info<>'x') and (t^.right^.left=nil) and (t^.right^.right=nil) then begin
         tpr^.info:='*';
         new(v1);
         tpr^.left:=v1;
         v1^.info:='*';

         new(w1);
         new(w2);
         v1^.left:=w1;
         v1^.right:=w2;

         copyt(t^.right,v1^.left);
         w1^.left:=nil;
         w1^.right:=nil;
         w2^.info:='^';
         copyt(t^.left,w2^.left);
         new(h1);
         w2^.right:=h1;
         h1^.info:='-';
         copyt(t^.right,h1^.left);
         new(h2);
         h1^.right:=h2;
         h2^.info:='1';

         treep(t^.left,tpr^.right);
      end
      else if (t^.left^.info<>'x') and (t^.left^.left=nil) and (t^.left^.right=nil) then begin
           tpr^.info:='*';
           new(v1);
           tpr^.left:=v1;
           v1^.info:='*';
           copyt(t,v1^.left);
           new(v2);
           v1^.right:=v2;
           v2^.info:='ln';
           v2^.left:=nil;

           copyt(t^.left,v2^.right);
           treep(t^.right,tpr^.right);
      end
      else begin
          tpr^.info:='+';
          new(v1);
          new(v2);
          tpr^.left:=v1;
          tpr^.right:=v2;

          v1^.info:='*';
          new(w1);
          v1^.left:=w1;
          w1^.info:='*';
          copyt(t^.right,w1^.left);
          new(w2);
          w1^.right:=w2;
          w2^.info:='^';
          copyt(t^.left,w2^.left);
          new(h1);
          w2^.right:=h1;
          h1^.info:='-';
          copyt(t^.right,h1^.left);
          new(h2);
          h1^.right:=h2;
          h2^.info:='1';

          treep(t^.left,v1^.right);

          v2^.info:='*';
          new(a1);
          new(a2);
          v2^.left:=a1;
          v2^.right:=a2;

          a1^.info:='*';
          copyt(t,a1^.left);
          treep(t^.right,a1^.right);

          a2^.info:='ln';
          copyt(t^.left,a2^.right);
         end;
      end;
   '&': begin
        tpr^.info:='*';
        treep(t^.right,tpr^.right);

        new(v1);
        tpr^.left:=v1;
        v1^.info:='/';
        new(w1);
        new(w2);
        v1^.left:=w1;
        v1^.right:=w2;
        w1^.info:='1';
        w2^.info:='*';
        new(h1);
        new(h2);
        w2^.left:=h1;
        w2^.right:=h2;
        h1^.info:='2';
        h2^.info:='&';
        copyt(t^.right,h2^.right);
        end;
   'a': begin
       if t^.info[5]='i' then begin
          tpr^.info:='*';
          new(v1);
          tpr^.left:=v1;
          v1^.info:='/';
          new(v2);
          v1^.left:=v2;
          v2^.info:='1';
          new(w1);
          v1^.right:=w1;
          w1^.info:='&';
          new(w2);
          w1^.right:=w2;
          w2^.info:='-';
          new(h1);
          w2^.left:=h1;
          h1^.info:='1';
          new(h2);
          w2^.right:=h2;
          h2^.info:='^';
          new(a1);
          h2^.right:=a1;
          a1^.info:='2';

          copyt(t^.right,h2^.left);
          treep(t^.right,tpr^.right);
       end
       else if t^.info[5]='o' then begin
            tpr^.info:='*';
            new(v1);
            tpr^.left:=v1;
            v1^.info:='/';
            new(v2);
            v1^.left:=v2;
            v2^.info:='-1';
            new(w1);
            v1^.right:=w1;
            w1^.info:='&';
            new(w2);
            w1^.right:=w2;
            w2^.info:='-';
            new(h1);
            w2^.left:=h1;
            h1^.info:='1';
            new(h2);
            w2^.right:=h2;
            h2^.info:='^';
            new(a1);
            h2^.right:=a1;
            a1^.info:='2';

            copyt(t^.right,h2^.left);
            treep(t^.right,tpr^.right);
          end
       else if t^.info[5]='g' then begin
            tpr^.info:='*';
            treep(t^.right,tpr^.right);

            new(v1);
            tpr^.left:=v1;
            v1^.info:='/';
            new(w1);
            new(w2);
            v1^.left:=w1;
            v1^.right:=w2;
            w1^.info:='1';
            w2^.info:='+';
            new(h1);
            new(h2);
            w2^.left:=h1;
            w2^.right:=h2;
            h1^.info:='1';
            h2^.info:='^';
            new(a1);
            h2^.right:=a1;
            a1^.info:='2';
            copyt(t^.right,h2^.left);
       end
       else if t^.info[5]='t' then begin
            tpr^.info:='*';
            treep(t^.right,tpr^.right);

            new(v1);
            tpr^.left:=v1;
            v1^.info:='/';
            new(w1);
            new(w2);
            v1^.left:=w1;
            v1^.right:=w2;
            w1^.info:='-1';
            w2^.info:='+';
            new(h1);
            new(h2);
            w2^.left:=h1;
            w2^.right:=h2;
            h1^.info:='1';
            h2^.info:='^';
            new(a1);
            h2^.right:=a1;
            a1^.info:='2';
            copyt(t^.right,h2^.left);
       end
       end
 else begin
      tpr^.left:=nil;
      tpr^.right:=nil;
      tpr^.info:='0';
      end;
 end;
end;

procedure print5 (x:ptree); //?????????
begin
        if x^.left<>nil then begin
           answe:=answe+'(';
           print5(x^.left);
           answe:=answe+')';
        end;
        answe:=answe+x^.info;
        if x^.right<>nil then begin
           answe:=answe+'(';
           print5(x^.right);
           answe:=answe+')';
        end;
Form1.LbAnswer.Caption:=answe;
end;


procedure WritelnTree(x:ptree;xmin,xmax,y,countlevel:integer);//?????? ??????
begin
  if x <> nil then
  begin
  if x^.left<>nil then
   begin
   form1.image1.Canvas.MoveTo((xmax-xmin) div 2 + xmin+radius div 2,y);
   form1.image1.Canvas.LineTo(((xmax+xmin) div 2 + xmin)div 2,lvly*countlevel);
   end;

  if x^.right<>nil then
   begin
   form1.image1.Canvas.MoveTo((xmax-xmin) div 2+xmin+radius div 2,y);
   form1.image1.Canvas.LineTo(((xmax+xmin) div 2 + xmax) div 2,lvly*countlevel);
   end;

  form1.image1.Canvas.Ellipse((xmax-xmin) div 2+xmin-radius div 4,y-radius div 4,(xmax-xmin) div 2+xmin+radius,y+radius);
  form1.image1.Canvas.textout((xmax-xmin) div 2+xmin,y,x^.info);
  WritelnTree(x^.left,xmin,(xmax+xmin) div 2,lvly*countlevel,countlevel+1);
  WritelnTree(x^.right,(xmax+xmin) div 2,xmax,lvly*countlevel,countlevel+1);
  end;
end;


procedure upr0(var tpr1:ptree);
begin
if  (tpr1^.left<>nil) and  (tpr1^.right<>nil) then begin
if (tpr1^.left^.left<>nil) and (tpr1^.left^.right<>nil)  then upr0(tpr1^.left);
if (tpr1^.right^.left<>nil) and (tpr1^.right^.right<>nil) then upr0(tpr1^.right);


   if (tpr1^.left^.info='0') or (tpr1^.right^.info='0') then  begin
   if tpr1^.info = '*' then
   begin
   tpr1^.info:='0';
   tpr1^.left:=nil;
   tpr1^.right:=nil;
   end;
   end;
end;
end;


procedure upr1(var tpr1:ptree);
begin
if  (tpr1^.left<>nil) and  (tpr1^.right<>nil) then begin
if (tpr1^.left^.left<>nil) and (tpr1^.left^.right<>nil)  then upr1(tpr1^.left);
if (tpr1^.right^.left<>nil) and (tpr1^.right^.right<>nil) then upr1(tpr1^.right);

if (tpr1^.left^.info='1') then
   begin
   if tpr1^.info = '*' then
    begin
    tpr1:=tpr1^.right;
    end;
   end
else
 if (tpr1^.right^.info='1') then
   if tpr1^.info = '*' then
   begin
   tpr1:=tpr1^.left;
   end;
 end;
end;

procedure uprp0(var tpr1:ptree);
var qw1,qw2,pt:integer;
begin
if  (tpr1^.left<>nil) and  (tpr1^.right<>nil) then begin
if (tpr1^.left^.left<>nil) and (tpr1^.left^.right<>nil)  then uprp0(tpr1^.left);
if (tpr1^.right^.left<>nil) and (tpr1^.right^.right<>nil) then uprp0(tpr1^.right);
if (tpr1^.left^.left=nil) and  (tpr1^.left^.right=nil) and (tpr1^.right^.left=nil) and (tpr1^.right^.right=nil) then

  if tpr1^.info = '+' then  begin

   if (tpr1^.left^.info<>'x') and (tpr1^.right^.info<>'x') then
   begin
   val(tpr1^.right^.info,qw1,pt);
   val(tpr1^.left^.info,qw2,pt);
   str(qw1+qw2,tpr1^.info);
   tpr1^.left:=nil;
   tpr1^.right:=nil;
   end;
   end;
   end;
end;


procedure uprr0(var tpr1:ptree);
var qw1,qw2,pt:integer;
begin
if  (tpr1^.left<>nil) and  (tpr1^.right<>nil) then begin
if (tpr1^.left^.left<>nil) and (tpr1^.left^.right<>nil)  then uprp0(tpr1^.left);
if (tpr1^.right^.left<>nil) and (tpr1^.right^.right<>nil) then uprp0(tpr1^.right);
if (tpr1^.left^.left=nil) and  (tpr1^.left^.right=nil) and (tpr1^.right^.left=nil) and (tpr1^.right^.right=nil) then

  if tpr1^.info = '-' then  begin

   if (tpr1^.left^.info<>'x') and (tpr1^.right^.info<>'x') then
   begin
   val(tpr1^.right^.info,qw1,pt);
   val(tpr1^.left^.info,qw2,pt);
   str(qw2-qw1,tpr1^.info);
   tpr1^.left:=nil;
   tpr1^.right:=nil;
   end;
   end;
   end;
end;

procedure depth (x:ptree; var  countdepth:integer);
var l,r:integer;
begin
 if x=nil then countdepth:=0
 else
   begin
   depth(x^.left,l);
   depth(x^.right,r);
   if l>r then countdepth:=l+1
   else countdepth:=r+1
   end;
end;

procedure selectingtheradiusandfont (countdepth:integer);
begin
if (countdepth>=1) and (countdepth<4) then
  begin
  form1.image1.Canvas.Font.Size:=18;
  radius:=40;
  end
else if (countdepth>=4) and (countdepth<6) then
      begin
      form1.image1.Canvas.Font.Size:=14;
      radius:=32;
      end
      else
       begin
       form1.image1.Canvas.Font.Size:=9;
       radius:=17;
       end;
end;

procedure TForm1.BtCalcPrClick(Sender: TObject);
begin
image1.Canvas.Brush.Color:=clGradientInactiveCaption;
image1.Canvas.FillRect(rect(0,0,image1.Width,image1.height));
LbFxP.Visible:=true;
LbAnswer.Visible:=true;
BtTreeAnalysis.Enabled:=true;
BtTreePr.Enabled:=true;
BtSimple.Enabled:=true;
BtNewFun.Enabled:=true;
functionFX:='';
if TxtFX.Text <> '??????? ???????' then
  begin
  translatepost(TxtFX.Text,functionFX);
  treer(functionFX,t);
  treep(t,tpr);
  copyt(tpr,tpr1);
  print5(tpr);
  end
else
 begin
 LbFxP.Visible:=false;
 LbAnswer.Visible:=false;
 BtTreeAnalysis.Enabled:=false;
 BtTreePr.Enabled:=false;
 BtSimple.Enabled:=false;
 BtNewFun.Enabled:=false;

 end;

end;

procedure TForm1.BtNewFunClick(Sender: TObject);
begin
image1.Canvas.Brush.Color:=clGradientInactiveCaption;
image1.Canvas.FillRect(rect(0,0,image1.Width,image1.height));
LbFxP.Visible:=false;
LbAnswer.Visible:=false;
BtTreeAnalysis.Enabled:=false;
BtTreePr.Enabled:=false;
BtSimple.Enabled:=false;
BtNewFun.Enabled:=false;
functionFX:='';
answe:='';
TxtFX.Text:='??????? ???????';
end;

procedure TForm1.BtSimpleClick(Sender: TObject);
begin
image1.Canvas.Brush.Color:=clGradientInactiveCaption;
image1.Canvas.FillRect(rect(0,0,image1.Width,image1.height));
LbAnswer.caption:='';
 upr0(tpr1);
 upr1(tpr1);
 uprp0(tpr1);
 uprr0(tpr1);
  while  tpr<>tpr1 do
   begin
   upr0(tpr1);
   upr1(tpr1);
   uprp0(tpr1);
   uprr0(tpr1);
   tpr:=tpr1;
   end;
 tpr:=tpr1;
answe:='';
print5(tpr)
end;

procedure TForm1.BtTreeAnalysisClick(Sender: TObject);
begin
depth(t,countdepth);
selectingtheradiusandfont(countdepth);
lvly:=image1.Width div countdepth-30;
image1.Canvas.Brush.Color:=clGradientInactiveCaption;
image1.Canvas.FillRect(rect(0,0,image1.Width,image1.height));
WritelnTree(t,0,image1.Width,15,1);
end;


procedure TForm1.BtTreePrClick(Sender: TObject);
begin
depth(tpr,countdepth);
selectingtheradiusandfont (countdepth);
lvly:=image1.Width div countdepth-30;
image1.Canvas.Brush.Color:=clGradientInactiveCaption;
image1.Canvas.FillRect(rect(0,0,image1.Width,image1.height));
WritelnTree(tpr,0,image1.Width,15,1);
end;

end.
