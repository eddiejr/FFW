unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    Timer1: TTimer;
    Button4: TButton;
    ListBox1: TListBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    FHandle: HWND;
    FMethod: Byte;

    function _FindWindow: Boolean;
    procedure ValidateForeground;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function ForceForegroundWindow1(hwnd: THandle): Boolean;
{
found here:
http://delphi.newswhat.com/geoxml/forumhistorythread?groupname=borland.public.delphi.rtl.win32&messageid=501_3f8aac4b@newsgroups.borland.com
}
const
  SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;
  SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;
var
  ForegroundThreadID: DWORD;
  ThisThreadID: DWORD;
  timeout: DWORD;
begin
  if IsIconic(hwnd) then ShowWindow(hwnd, SW_RESTORE);
  if GetForegroundWindow = hwnd then Result := true
  else begin
    // Windows 98/2000 doesn't want to foreground a window when some other
    // window has keyboard focus

    if ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion > 4)) or
       ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and ((Win32MajorVersion > 4) or
                                                          ((Win32MajorVersion = 4) and (Win32MinorVersion > 0)))) then begin
      // Code from Karl E. Peterson, www.mvps.org/vb/sample.htm
      // Converted to Delphi by Ray Lischner
      // Published in The Delphi Magazine 55, page 16

      Result := false;
      ForegroundThreadID := GetWindowThreadProcessID(GetForegroundWindow,nil);
      ThisThreadID := GetWindowThreadPRocessId(hwnd,nil);
      if AttachThreadInput(ThisThreadID, ForegroundThreadID, true) then
      begin
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hwnd);
        AttachThreadInput(ThisThreadID, ForegroundThreadID, false);  // bingo
        Result := (GetForegroundWindow = hwnd);
      end;
      if not Result then begin
        // Code by Daniel P. Stasinski

        SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0), SPIF_SENDCHANGE);
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hWnd);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(timeout), SPIF_SENDCHANGE);
      end;
    end
    else begin
      BringWindowToTop(hwnd); // IE 5.5 related hack
      SetForegroundWindow(hwnd);
    end;

    Result := (GetForegroundWindow = hwnd);
  end;
end; { ForceForegroundWindow }

procedure ForceForegroundWindow2(Handle: HWND);
begin
  SetWindowPos(Handle, HWND_NOTOPMOST,0,0,0,0, SWP_NOMOVE or SWP_NOSIZE);
  SetWindowPos(Handle, HWND_TOPMOST,0,0,0,0, SWP_NOMOVE or SWP_NOSIZE);
  SetWindowPos(Handle, HWND_NOTOPMOST,0,0,0,0, SWP_SHOWWINDOW or SWP_NOMOVE or SWP_NOSIZE);
end;

procedure ForceForegroundWindow3(Handle: HWND);
var
  Input: TInput;
begin
  ZeroMemory(@Input, SizeOf(Input));
  SendInput(1, Input, SizeOf(Input)); // don't send anyting actually to another app..
  SetForegroundWindow(Handle);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ListBox1.AddItem('Method 1', nil);

  if _FindWindow then
  begin
    ForceForegroundWindow1(FHandle);

    ValidateForeground;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ListBox1.AddItem('Method 2', nil);

  if _FindWindow then
  begin
    ForceForegroundWindow2(FHandle);

    ValidateForeground;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  ListBox1.AddItem('Method 3', nil);

  if _FindWindow then
  begin
    ForceForegroundWindow3(FHandle);

    ValidateForeground;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if not Timer1.Enabled then
  begin
    Button4.Caption := 'Stop Timer';
    Timer1.Enabled := True;
  end
  else
  begin
    Button4.Caption := 'Start Timer';
    Timer1.Enabled := False;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  case FMethod of
    1: Button1.Click;
    2: Button2.Click;
    3: Button3.Click;
  end;

  Inc(FMethod);

  if FMethod = 4 then
    FMethod := 1;
end;

procedure TForm1.ValidateForeground;
begin
  if FHandle = GetForegroundWindow then
    ListBox1.AddItem('   The window is focused', nil)
  else
    ListBox1.AddItem('   The window is not focused', nil);

  ListBox1.ItemIndex := ListBox1.Count - 1;
end;

function TForm1._FindWindow: Boolean;
begin
  Result := False;

  if Edit1.Text <> '' then
  begin
    ListBox1.AddItem(Format('   Finding window: "%s"...', [Edit1.Text]), nil);
    FHandle := FindWindow(nil, PChar(Edit1.Text));

    Result := (FHandle <> 0);

    if Result then
      ListBox1.AddItem(Format('   Window founded with handle: %d', [FHandle]), nil)
    else
      ListBox1.AddItem('   Window not found', nil);
  end
  else
    ListBox1.AddItem('   Window name not defined', nil);
end;

end.
