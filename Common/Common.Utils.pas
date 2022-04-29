unit Common.Utils;

{
  Definicao da Classe Common.Utils
  Contem rotinas gerais para os modulos

  @autor  Ryan Bruno C Padilha (ryan.padilha@gmail.com)
  @version 0.1 (02/01/2010)

}

interface

uses SysUtils, StrUtils, IniFiles, Classes, System.DateUtils,System.MaskUtils;

type
  TUtils = class(TObject)
  private
  protected
  public
    class function Empty(texto: String): Boolean;
    class function NotEmpty(texto: String): Boolean;
    class function Sysdate(): String;
    class function CPF(num: String): Boolean;
    class function CNPJ(num: String): Boolean;
    class function SoNumero(kKey: Char): Char;
    class function ReplaceStr(const S, Srch, Replace: String): String;
    class function LeIni(sFile: String; sSecao: String; sChave: String): String;
    class function GravaIni(sFile: String; sSecao: String; sChave: String; sValor: String): Boolean;
    class function CriarIni(sFile: string): Boolean;
    class function FormataCPF(CPF: String): String;
    class function DesFormatCPF(CPF: String): String;
    class function FormataCNPJ(CNPJ: String): String;
    class function DesFormataCNPJ(CNPJ: String): String;
    class function NumeroDeLinhasTXT(lcPath: String): Integer;
    class function ENumero(sValor: String): Boolean;
    class function DataOk(Dt: String): Boolean;
    class function AsciiToInt(Caracter: Char): Integer;
    class Function Criptografa(texto:string;chave:integer):String;
    class Function DesCriptografa(texto:string;chave:integer):String;
  end;

implementation

{ TUtils }

class function TUtils.Empty(texto: String): Boolean;
begin
  if (Length(Trim(texto)) = 0) OR (Trim(texto) = '  /  /') OR
    (Trim(texto) = '.   .   /    -') OR (Trim(texto) = '.   .   -') OR
    (Trim(texto) = '  :  :  ') OR (Trim(texto) = '  :') then
    Result := True
  else
    Result := False;
end;

class function TUtils.NotEmpty(texto: String): Boolean;
begin
  if Empty(texto) then
    Result := False
  else
    Result := True;
end;

class function TUtils.Sysdate: String;
begin
  Result := DateToStr(Date);
end;

class function TUtils.CPF(num: String): Boolean;
var
  n1, n2, n3, n4, n5, n6, n7, n8, n9: Integer;
  d1, d2: Integer;
  numero, digitado, calculado: string;
begin
  numero := ReplaceStr(num, '.', '');
  numero := ReplaceStr(numero, '-', '');
  numero := ReplaceStr(numero, ' ', '');
  numero := ReplaceStr(numero, '_', '');
  numero := ReplaceStr(numero, '/', '');
  num := numero;
  if not(ENumero(num)) then
  begin
    Result := False;
    Exit;
  end;
  if num = '' then
  begin
    Result := False;
    Exit;
  end;
  if num = '11111111111' then
  begin
    Result := False;
    Exit;
  end;
  if num = '22222222222' then
  begin
    Result := False;
    Exit;
  end;
  if num = '33333333333' then
  begin
    Result := False;
    Exit;
  end;
  if num = '44444444444' then
  begin
    Result := False;
    Exit;
  end;
  if num = '55555555555' then
  begin
    Result := False;
    Exit;
  end;
  if num = '66666666666' then
  begin
    Result := False;
    Exit;
  end;
  if num = '77777777777' then
  begin
    Result := False;
    Exit;
  end;
  if num = '88888888888' then
  begin
    Result := False;
    Exit;
  end;
  if num = '99999999999' then
  begin
    Result := False;
    Exit;
  end;
  n1 := StrToInt(num[1]);
  n2 := StrToInt(num[2]);
  n3 := StrToInt(num[3]);
  n4 := StrToInt(num[4]);
  n5 := StrToInt(num[5]);
  n6 := StrToInt(num[6]);
  n7 := StrToInt(num[7]);
  n8 := StrToInt(num[8]);
  n9 := StrToInt(num[9]);
  d1 := n9 * 2 + n8 * 3 + n7 * 4 + n6 * 5 + n5 * 6 + n4 * 7 + n3 * 8 + n2 *
    9 + n1 * 10;
  d1 := 11 - (d1 mod 11);
  if d1 >= 10 then
    d1 := 0;
  d2 := d1 * 2 + n9 * 3 + n8 * 4 + n7 * 5 + n6 * 6 + n5 * 7 + n4 * 8 + n3 * 9 +
    n2 * 10 + n1 * 11;
  d2 := 11 - (d2 mod 11);
  if d2 >= 10 then
    d2 := 0;
  calculado := inttostr(d1) + inttostr(d2);
  digitado := num[10] + num[11];
  if calculado = digitado then
    Result := True
  else
    Result := False;
end;

class function TUtils.CNPJ(num: String): Boolean;
var
  n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12: Integer;
  d1, d2: Integer;
  numero, digitado, calculado: string;
begin
  numero := ReplaceStr(num, '.', '');
  numero := ReplaceStr(numero, '-', '');
  numero := ReplaceStr(numero, '/', '');
  numero := ReplaceStr(numero, ' ', '');
  numero := ReplaceStr(numero, '_', '');
  num := numero;
  if not(ENumero(num)) then
  begin
    Result := False;
    Exit;
  end;
  if num = '' then
  begin
    Result := False;
    Exit;
  end;
  if num = '11111111111111' then
  begin
    Result := False;
    Exit;
  end;
  if num = '22222222222222' then
  begin
    Result := False;
    Exit;
  end;
  if num = '33333333333333' then
  begin
    Result := False;
    Exit;
  end;
  if num = '44444444444444' then
  begin
    Result := False;
    Exit;
  end;
  if num = '55555555555555' then
  begin
    Result := False;
    Exit;
  end;
  if num = '66666666666666' then
  begin
    Result := False;
    Exit;
  end;
  if num = '77777777777777' then
  begin
    Result := False;
    Exit;
  end;
  if num = '88888888888888' then
  begin
    Result := False;
    Exit;
  end;
  if num = '99999999999999' then
  begin
    Result := False;
    Exit;
  end;
  n1 := StrToInt(num[1]);
  n2 := StrToInt(num[2]);
  n3 := StrToInt(num[3]);
  n4 := StrToInt(num[4]);
  n5 := StrToInt(num[5]);
  n6 := StrToInt(num[6]);
  n7 := StrToInt(num[7]);
  n8 := StrToInt(num[8]);
  n9 := StrToInt(num[9]);
  n10 := StrToInt(num[10]);
  n11 := StrToInt(num[11]);
  n12 := StrToInt(num[12]);
  d1 := n12 * 2 + n11 * 3 + n10 * 4 + n9 * 5 + n8 * 6 + n7 * 7 + n6 * 8 + n5 * 9
    + n4 * 2 + n3 * 3 + n2 * 4 + n1 * 5;
  d1 := 11 - (d1 mod 11);
  if d1 >= 10 then
    d1 := 0;
  d2 := d1 * 2 + n12 * 3 + n11 * 4 + n10 * 5 + n9 * 6 + n8 * 7 + n7 * 8 + n6 * 9
    + n5 * 2 + n4 * 3 + n3 * 4 + n2 * 5 + n1 * 6;
  d2 := 11 - (d2 mod 11);
  if d2 >= 10 then
    d2 := 0;
  calculado := inttostr(d1) + inttostr(d2);
  digitado := num[13] + num[14];
  if calculado = digitado then
    Result := True
  else
    Result := False;
end;

class function TUtils.ReplaceStr(const S, Srch, Replace: string): string;
var
  i: Integer;
  Source: string;
begin
  Source := S;
  Result := '';
  repeat
    i := Pos(Srch, Source);
    if i > 0 then
    begin
      Result := Result + Copy(Source, 1, i - 1) + Replace;
      Source := Copy(Source, i + Length(Srch), MaxInt);
    end
    else
      Result := Result + Source;
  until i <= 0;
end;

class function TUtils.SoNumero(kKey: Char): Char;
begin
  if not(kKey in ['0' .. '9', Chr(8)]) then
    Result := #0
  else
    Result := kKey;
end;

class function TUtils.LeIni(sFile: String; sSecao: String;
  sChave: String): String;
var
  Ini: TIniFile;
  sMess: String;
Begin
  Result := '';
  Ini := TIniFile.Create(sFile);
  try
    Result := Ini.ReadString(sSecao, sChave, '');
    Ini.Free;
  except
    on e: Exception do
    begin
      sMess := e.Message;
      Ini.Free;
    end;
  end;
end;

class function TUtils.GravaIni(sFile: String; sSecao: String; sChave: String;
  sValor: String): Boolean;
var
  Ini: TIniFile;
  sMess: String;
begin
  Result := False;
  Ini := TIniFile.Create(sFile);
  try
    Ini.WriteString(sSecao, sChave, sValor);
    Result := True;
    Ini.Free;
  except
    on e: Exception do
    begin
      sMess := e.Message;
      Ini.Free;
    end;
  end;
end;

class function TUtils.CriarIni(sFile: string): Boolean;
var
  Ini: TIniFile;
  sMess: String;
begin
  Result := False;
  Ini := TIniFile.Create(sFile);
  try
    Ini.WriteString('Database', 'Catalog', '');
    Ini.WriteString('Database', 'Database', '.\Database\DBSGE2.FDB');
    Ini.WriteString('Database', 'HostName', '');
    Ini.WriteString('Database', 'Port', '0');
    Ini.WriteString('Database', 'Protocol', 'firebird-2.1');
    Ini.Free;
    Result := True;
  except
    on e: Exception do
    begin
      sMess := e.Message;
      Ini.Free;
    end;
  end;
end;

// Esta funcao informa Cpf neste formato: 999.999.999-99
class function TUtils.FormataCPF(CPF: String): String;
{var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(CPF) do
  begin
    if CPF[i] in ['0' .. '9'] then
      Result := Result + CPF[i];
  end;
  if Length(Result) <> 11 then
    Exit
  else
    Result := Copy(Result, 1, 3) + '.' + Copy(Result, 4, 3) + '.' +
      Copy(Result, 7, 3) + '-' + Copy(Result, 10, 2);}
begin
    Delete(CPF,ansipos('.',CPF),1);  //Remove ponto .
    Delete(CPF,ansipos('.',CPF),1);
    Delete(CPF,ansipos('-',CPF),1); //Remove traço -
    Delete(CPF,ansipos('/',CPF),1); //Remove barra /
    Result:=FormatmaskText('000\.000\.000\-00;0;',CPF); // Formata os numero
end;

// Esta funcao informa CNPJ neste formato: 99.999.999/9999-99
class function TUtils.FormataCNPJ(CNPJ: String): String;
{var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(CNPJ) do
  begin
    if CNPJ[i] in ['0' .. '9'] then
      Result := Result + CNPJ[i];
  end;
  if Length(Result) <> 14 then
    Exit
  else
    Result := Copy(Result, 1, 2) + '.' + Copy(Result, 3, 3) + '.' +
      Copy(Result, 6, 3) + '/' + Copy(Result, 9, 4) + '-' + Copy(Result, 13, 4);
end;}
begin
  Delete(CNPJ,ansipos('.',CNPJ),1);  //Remove ponto .
  Delete(CNPJ,ansipos('.',CNPJ),1);
  Delete(CNPJ,ansipos('-',CNPJ),1); //Remove traço -
  Delete(CNPJ,ansipos('/',CNPJ),1); //Remove barra /
  Result:=FormatmaskText('00\.000\.000\/0000\-00;0;',CNPJ);
end;


class function TUtils.NumeroDeLinhasTXT(lcPath: String): Integer;
Var
  aList: TStringList;
Begin
  Result := 0;
  // Verifico se o arquivo está onde foi passado pelo parâmetro
  if FileExists(lcPath) then
  Begin
    // Crio a lista que receberá o arquivo
    aList := TStringList.Create;
    Try
      // Carrego o arquivo para dentro da lista
      aList.LoadFromFile(lcPath);
      // Retorno o número de linhas que o arquivo contem
      Result := aList.Count;
    Finally
      // Destruo o objeto
      FreeAndNil(aList);
    End;
  End
  Else
  Begin
    // Caso eu não encontre o arquivo retorno 0.
    Result := 0;
  End;
End;

class function TUtils.ENumero(sValor: String): Boolean;
var
  i, iRet: Integer;
  D: Double;
begin
  Result := False;
  Val(sValor, i, iRet);
  if iRet <> 0 then
  begin
    Val(sValor, D, iRet);
    if iRet <> 0 then
    begin
      Exit;
    end;
  end;
  Result := True;
end;

{ ===============================
  Desenvolvida Por :  Ricardo S. Belardinuci
  e-mail :  ri-taqua@ig.com.br
  ===============================

  função verifica se a data é válida,
  inclusive se for ano bisexto ela valida o 29/02,
  caso contrário, ela retorna false; }

class function TUtils.DataOk(Dt: String): Boolean;
var
  Dia, Mes: Byte;
  Ano: Integer;
  function AnoBissesto(Year: Integer): Boolean;
  begin
    AnoBissesto := (Ano mod 4 = 0) and (Ano mod 100 <> 0) or (Ano Mod 400 = 0);
  end;

begin
  Result := False;
  if Length(Trim(Dt)) = 8 then
  begin
    Dia := StrToIntDef(Copy(Dt, 1, 2), 0);
    Mes := StrToIntDef(Copy(Dt, 4, 2), 0);
    Ano := StrToInt(Copy(Dt, 7, 2));
    if ((Mes in [1, 3, 5, 7, 8, 10, 12]) and (Dia in [1 .. 31])) or
      ((Mes in [4, 6, 9, 11]) and (Dia in [1 .. 30])) or
      ((Mes = 2) and (AnoBissesto(Ano)) and (Dia in [1 .. 29])) or
      ((Mes = 2) and (not AnoBissesto(Ano)) and (Dia in [1 .. 28])) then
      Result := True;
  end
  else if Length(Trim(Dt)) = 10 then
  begin
    Dia := StrToIntDef(Copy(Dt, 1, 2), 0);
    Mes := StrToIntDef(Copy(Dt, 4, 2), 0);
    Ano := StrToInt(Copy(Dt, 7, 4));
    if ((Mes in [1, 3, 5, 7, 8, 10, 12]) and (Dia in [1 .. 31])) or
      ((Mes in [4, 6, 9, 11]) and (Dia in [1 .. 30])) or
      ((Mes = 2) and (AnoBissesto(Ano)) and (Dia in [1 .. 29])) or
      ((Mes = 2) and (not AnoBissesto(Ano)) and (Dia in [1 .. 28])) then
      Result := True;
  end;

end;

{ ///////////////////////////////////////////////////////////////////////
  Observações:
  pode ser chamada no evento OnChange do componente que recebe a data
  notem também que existe uma função interna na função principal, é assim mesmo pessoal

  exemplo de chamada da função:

  procedure TFormAjustarEntrada.DataEditChange(Sender: TObject);
  begin
  if DataOk(EditData.Text) then
  Comando ...

  //Obs no lugar de um edit pode ser também um dbedit( aí é só passar no //parametro:     if DataOk(DBEditData.Text) then

  end;

  dúvidas mande e-mail.
  não esqueçam de avaliar, se não como vou saber se está sendo útil né?
  Falo pessoal!!!!!!

  /////////////////////////////////////////////////////////////////////// }


{Abaixo seguem 3 funcoes, a primeira retorna o código ASCII de cada caracter, a segunda Criptografa uma string
 e a terceira descriptografa. Voce pode sempre mudar a chave como preferir.
 Espero ter sido de ajuda - M C Zanetti}

//funcao que retorno o código ASCII dos caracteres
class function TUtils.AsciiToInt(Caracter: Char): Integer;
var
  i: Integer;
begin
  i := 32;
  while i < 255 do begin
    if Chr(i) = Caracter then
      Break;
    i := i + 1;
  end;
  Result := i;
end;


{ Esta funcao tem como objetivo criptografar uma string utilizando o código ASCII de cada caracter e
somando a esse código o valor da CHAVE}

class Function TUtils.Criptografa(texto:string;chave:integer):String;
var
  cont:integer;
  retorno:string;
begin
  if (trim(texto)=EmptyStr) or (chave=0) then begin
    result:=texto;
  end else begin
    retorno:='';
    for cont:=1 to length(texto) do begin
      retorno:=retorno+chr(asciitoint(texto[cont])+chave);
    end;
    result:=retorno;
  end;
end;


{Esta funcao é semelhante a funcao de Criptografia mais com o objetivo de descriptografar a string }

class Function TUtils.DesCriptografa(texto:string;chave:integer):String;
var
  cont:integer;
  retorno:string;
begin
  if (trim(texto)=EmptyStr) or (chave=0) then begin
    result:=texto;
  end else begin
    retorno:='';
    for cont:=1 to length(texto) do begin
      retorno:=retorno+chr(asciitoint(texto[cont])-chave);
    end;
    result:=retorno;
  end;
end;


class function TUtils.DesFormataCNPJ(CNPJ: String): String;
begin
  Delete(CNPJ,ansipos('.',CNPJ),1);  //Remove ponto .
  Delete(CNPJ,ansipos('.',CNPJ),1);
  Delete(CNPJ,ansipos('-',CNPJ),1); //Remove traço -
  Delete(CNPJ,ansipos('/',CNPJ),1); //Remove barra /
  Result := CNPJ;
end;

class function TUtils.DesFormatCPF(CPF: String): String;
begin
  Delete(CPF,ansipos('.',CPF),1);  //Remove ponto .
  Delete(CPF,ansipos('.',CPF),1);
  Delete(CPF,ansipos('-',CPF),1); //Remove traço -
  Delete(CPF,ansipos('/',CPF),1); //Remove barra /
  Result := CPF;
end;

end.
