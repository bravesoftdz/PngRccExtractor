unit UMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,

  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Generics.Collections,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.ControlList,
  Vcl.VirtualImage,

  SynEdit;

const
  PngASCI_Header: Array[0..7] of AnsiChar = (#137, #80, #78, #71, #13, #10, #26, #10);  // in HEX: 89 50 4E 47 0D 0A 1A 0A // in Decoded Text: ‰PNG....
  PngASCI_Footer: Array[0..7] of AnsiChar = (#73, #69, #78, #68, #174, #66, #96, #130); // in HEX: 49 45 4E 44 AE 42 60 82 // in Decoded Text: IEND®B`‚

  PngHEX_Header: array[0..7] of Byte = ($89, $50, $4E, $47, $0D, $0A, $1A, $0A);
  PngHEX_Footer: array[0..7] of Byte = ($49, $45, $4E, $44, $AE, $42, $60, $82);
  PngHeader = '89504E470D0A1A0A'; //'89504E470D0A1A0A'; // '‰PNG';
  PngFooter = '49454E44AE426082'; //'49454E44AE426082'; // 'IEND®B`‚';

type
  TFrmMain = class(TForm)
    SynEdt_HEX: TSynEdit;
    Btn_Load: TButton;
    Lbl_ExtractProgress: TLabel;
    ProgsBar_Extract: TProgressBar;
    ProgsBar_Divider: TProgressBar;
    Btn_Extract: TButton;
    LV_PNG_List: TListView;
    Pnl_Images: TPanel;
    CtrlList_Pngs: TControlList;
    Lbl_Detail: TLabel;
    Virt_Img_Png: TVirtualImage;
    Lbl_Title: TLabel;
    Btn_Copy: TButton;
    procedure Btn_CopyClick(Sender: TObject);
    procedure Btn_LoadClick(Sender: TObject);
    procedure Btn_ExtractClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

uses
  System.IOUtils,
  System.RegularExpressions,
  System.Threading,
  Vcl.Imaging.pngimage,
  Vcl.Clipbrd;

{$R *.dfm}

procedure FileViewHex(AMemo: TSynEdit; FileName: string);// use SynEdit instead of TMemo
const
  MaxLineLength = 16 * 2; // each byte displayed with 2 characters plus a space
  BufferSize = 4096;
var
  DataFile: File;
  Buffer: array[1..BufferSize] of byte;
  BytesRead, I: integer;
  HexByte, Line: string;
begin
  AssignFile(DataFile, FileName);
  Reset(DataFile, 1);
  AMemo.Clear;
  while not Eof(DataFile) do begin
    BlockRead(DataFile, Buffer, BufferSize, BytesRead);
    Line := '';
    for I := 1 to BytesRead do begin
      HexByte := IntToHex(Buffer[I], 1); //IntToHex(Buffer[I], 1); // convert a byte to hexadecimal & if you want load Data as string without converssion use(TEncoding.Default.GetString(Buffer[I])); //
      // Add leading 0 if result is shorter than 2, easier to read...
      if Length(HexByte) < 2 then HexByte := '0' + HexByte;
      Line := Line + HexByte;// + ' ';
      if Length(Line) >= MaxLineLength then begin
        AMemo.Lines.Add(Line);
        Line := '';
      end;
    end;
  end;
  // If not already added, add last line to TMemo
  if Length(Line) > 0 then AMemo.Lines.Add(Line);
  CloseFile(DataFile);
end;

procedure HexStrToBinFile(aHexStr, aFN: string); //: string;
var
  FStream: TMemoryStream;
begin
  FStream := nil;
  FStream := TMemoryStream.Create;//(aFileName, fmCreate);
  try
    FStream.Size := Length(aHexStr) div 2;
    if FStream.Size > 0 then
    begin
      HexToBin(PChar(aHexStr), FStream.Memory, FStream.Size);
      FStream.Position := 0;
      FStream.SaveToFile(aFN)
//      Result := FStream;
    end;
  finally
    FStream.Free;
  end;
end;

function Get_PngList(Stream: TSynEdit; PngList: TListView): Boolean;
var
  Matches: TMatchCollection;
  Match: TMatch;
  I: Integer;
  S:string;
  Item: TListItem;
begin
  Result := (Stream.Lines.Text <> '');
  if False then Exit;

  // join All Lines into One Line...
  for I := 0 to Stream.Lines.Count -1 do
  begin
    S := S + Stream.Lines[I];
  end;
  // Delete any Space..
  Trim(S); //  S := StringReplace(Trim(S), ' ', '', [rfReplaceAll]);

  I := 1;
  Matches := TRegEx.Matches(S, PngHeader+ '(.*?)' +PngFooter); //, [roMultiLine]'PngHeader+'.*?'+PngFooter
  for Match in Matches do
  begin
    if Match.Success then
    begin
      Item := PngList.Items.Add;
      Item.Caption := I.ToString;
      Item.SubItems.Add(Match.Value);
      Inc(I);
    end;
  end;
end;

procedure TFrmMain.Btn_ExtractClick(Sender: TObject);
var
  FileN, HexStr: string;
begin
  FileN := TDirectory.GetCurrentDirectory + '\Png List';
  if not FileExists(FileN) then
  begin
    TDirectory.CreateDirectory(FileN);
  end;

  TTAsk.Run(
    procedure
    var
      I: Integer;
      ErrMsg: string;
    begin
      LV_PNG_List.Items.BeginUpdate;
      ProgsBar_Extract.Max := LV_PNG_List.Items.Count;
      for I := 0 to LV_PNG_List.Items.Count -1 do
      begin
        HexStr := LV_PNG_List.Items[I].SubItems[0];
        try
          HexStrToBinFile(HexStr, FileN +'\'+I.ToString + '.png');
          Lbl_ExtractProgress.Caption := 'Prgoress: Png(' +I.ToString+ ')';
          ProgsBar_Extract.Position := I +1;
        Except
          on E: Exception do
            ErrMsg := E.Message;
        end;
      end;
      LV_PNG_List.Items.EndUpdate;

      TThread.Synchronize(nil,
        procedure
        begin
          if not (ErrMsg.Trim = '') then
            raise Exception.Create('Exctract Error: '+ ErrMsg);
        end);
    end);
end;

procedure TFrmMain.Btn_LoadClick(Sender: TObject);
var
  DlgOpen: TOpenDialog;
  FS: TFile;
begin
  SynEdt_HEX.ClearAll;
  LV_PNG_List.Clear;
  Btn_Extract.Enabled := False;

  DlgOpen := TOpenDialog.Create(Self);
  DlgOpen.Filter := 'RCC FILE |*.rcc';
  DlgOpen.InitialDir := TDirectory.GetCurrentDirectory;
  try
    if DlgOpen.Execute then
    begin
      try
        FileViewHex(SynEdt_HEX, DlgOpen.filename);
        Btn_Extract.Enabled := Get_PngList(SynEdt_HEX, LV_PNG_List);
      except
        on E:Exception do
        raise Exception.Create('Error Message: ' + E.Message);
      end;
    end;
  finally
    DlgOpen.Free;
  end;
end;

procedure TFrmMain.Btn_CopyClick(Sender: TObject);
begin
  SynEdt_HEX.SelectAll;
  SynEdt_HEX.CopyToClipboard;
end;

end.
