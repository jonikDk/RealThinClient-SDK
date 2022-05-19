{
  @html(<b>)
  Gateway Constants (Legacy)
  @html(</b>)
  - Copyright 2004-2019 (c) Teppi Technology (https://rtc.teppi.net)
  @html(<br><br>)

  This is a LEGACY unit, which means that continued use of this unit is discouraged.
  If you are using this unit, please keep in mind that there will be NO MORE UPDATES 
  released for this unit and that THERE IS NO SUPPORT AVAILABLE for using this UNIT.
  
  Global parameters required by the Gateway and Gate Client components.
}
unit rtcGateConst;

{$INCLUDE rtcDefs.inc}

interface

uses
  SysUtils,
  Classes,

  rtcTypes,
  rtcSystem,
  rtcThrPool,
  rtcLog,

  rtcInfo,
  rtcConn;

type
  TGateUID = RtcIntPtr;
  TAppRunTime = int64;

  ERtcOutOfBounds = class(Exception);

const
  // GetAppRunTime Timer "ticks per second"
  RUN_TIMER_PRECISION = 1000;
  // Number of GetAppRunTime "ticks per day"
  RUN_TIMER_DAY_LENGTH = 24*60*60*RUN_TIMER_PRECISION;

var
  { Should the Gateway check if a User who is being added to a
    User Group has registered the Owner of that Group as his Friend ?

    If this value is FALSE, any User logged in to the Gateway could add any number
    of other Users to his User Group(s) and then use the Gateway to dispatch large
    amounts of data to all those Users, without asking for permission from the Users.

    When this value is TRUE, before a User can add another User to his User Group,
    the user who is being added to the Group has to add the Group Owner as his Friend,
    preventing hackers from adding random Users to their Groups and flooding the Gateway. }
  GATECHECK_FRIEND4GROUPS:boolean=True;

  LOG_GATEWAY_TIMEOUTS : boolean = {$IFDEF RTC_DEBUG} True {$ELSE} False {$ENDIF};
  LOG_GATEWAY_ERRORS : boolean = {$IFDEF RTC_DEBUG} True {$ELSE} False {$ENDIF};
  LOG_GATEWAY_STATUS : boolean = {$IFDEF RTC_DEBUG} True {$ELSE} False {$ENDIF};

  LOG_GATECLIENT_TIMEOUTS : boolean = {$IFDEF RTC_DEBUG} True {$ELSE} False {$ENDIF};
  LOG_GATECLIENT_EXITS : boolean = {$IFDEF RTC_DEBUG} True {$ELSE} False {$ENDIF};

  // Ping check interval in milliseconds
  PING_INTERVAL_inMS:Cardinal = 100;
  // Clean-up check interval in milliseconds
  CLEAN_INTERVAL_inMS:Cardinal = 1000;

  // Size of a PING packet in Bytes
  PING_PACKET_SIZE:byte=6;
  // Send PING interval in AppRunTime ticks
  SENDPING_INTERVAL:TAppRunTime = 10 * RUN_TIMER_PRECISION;

  // Maximum time (in Ping check intervals, default = seconds)
  // to force a delay between Gate Client reconnect attempts
  MAX_GATECLIENT_RECONNECT_WAIT:integer = 3;

  // Gate Account Manager lock on recently deactivated Group IDs
  // in "AppRunTime" ticks, default = 120 seconds (2 minutes)
  GATEACCMAN_GROUPID_LOCK:TAppRunTime = 120 * RUN_TIMER_PRECISION;

  // Number of seconds for the last "AuthCode" generated by
  // the Gate Account Manager to stay valid (in "AppRunTime" ticks)
  // Default value = 180 seconds (3 minutes)
  GATEACCMAN_AUTHCODE_VALID:TAppRunTime = 180 * RUN_TIMER_PRECISION;

  // Number of digits to use for "AuthCode" (default = 9),
  // automatically generated by the Gate Account Manager
  GATEACCMAN_AUTHCODE_DIGITS:byte = 9;

  // Default size for the Output Stream, if not explicitly set by Client (2 GB)
  DEF_OUTSTREAM_SIZE:Cardinal = Cardinal(2000)*1000*1000;

  // Default limit for the max number of Active Users on the Gateway.
  // 100.000 users = 10% of available User IDs
  DEF_GATEWAY_ACTIVEUSER_LIMIT:integer=100000;

  // Default limit for the max number of Total Users on the Gateway
  // 200.000 users = 20% of available User IDs
  DEF_GATEWAY_TOTALUSER_LIMIT:integer=200000;

  // Maximum time Gate Client components can wait for their internal
  // connection components to get released before force-destroying them.
  CLIENTRELEASE_MAXWAIT:integer=30;

  // To make sure Threads will NOT be blocked infinitely while waiting for a
  // signal to continue reading when using the WinInet or WinSock API (bocking),
  // the "TRtcHtpGateClient" component will be manually checking its internal
  // state at least once every "CLIENT_WAITFOR_CHECKSTATE" milliseconds.
  CLIENT_WAITFOR_CHECKSTATE:integer=100;
  
  // Force an immediate Client re-connect attempt in case of any connection problems?
  CLIENT_FORCED_RECONNECT:boolean=FALSE;

  // Connection Timeout values ...
  CLIENTCONNECT_TIMEOUT:TAppRunTime     =  30 * RUN_TIMER_PRECISION;  // 0:30 to Connect
  CLIENTCHECKLOGIN_TIMEOUT:TAppRunTime  =  60 * RUN_TIMER_PRECISION;  // 1:00 to Log in
  CLIENTCHECKLOGOUT_TIMEOUT:TAppRunTime = 180 * RUN_TIMER_PRECISION; // 3:00 inactive timeout for Log out

  CLIENTCHECKIN_TIMEOUT:TAppRunTime     = 35 * RUN_TIMER_PRECISION; // 0:35 for incoming packets
  CLIENTCHECKOUT_TIMEOUT:TAppRunTime    = 35 * RUN_TIMER_PRECISION; // 0:35 for outgoing packets
  CLIENTCHECKMAXIN_TIMEOUT:TAppRunTime  = 45 * RUN_TIMER_PRECISION; // 0:45 max in packets
  CLIENTCHECKMAXOUT_TIMEOUT:TAppRunTime = 45 * RUN_TIMER_PRECISION; // 0:45 max out packets
  CLIENTCHECKRECV_TIMEOUT:TAppRunTime   = 60 * RUN_TIMER_PRECISION; // 1:00 receive timeout
  CLIENTCHECKSEND_TIMEOUT:TAppRunTime   = 60 * RUN_TIMER_PRECISION; // 1:00 send timeout

  GATECHECKOPEN_TIMEOUT:TAppRunTime     = 20 * RUN_TIMER_PRECISION; // 0:20 to open connection
  GATECHECKIN_TIMEOUT:TAppRunTime       = 25 * RUN_TIMER_PRECISION; // 0:25 for incoming packets
  GATECHECKOUT_TIMEOUT:TAppRunTime      = 25 * RUN_TIMER_PRECISION; // 0:25 for outgoing packets
  GATECHECKMAXIN_TIMEOUT:TAppRunTime    = 35 * RUN_TIMER_PRECISION; // 0:35 max in packets
  GATECHECKMAXOUT_TIMEOUT:TAppRunTime   = 35 * RUN_TIMER_PRECISION; // 0:35 max out packets
  GATECHECKRECV_TIMEOUT:TAppRunTime     = 50 * RUN_TIMER_PRECISION; // 0:50 receive timeout
  GATECHECKSEND_TIMEOUT:TAppRunTime     = 50 * RUN_TIMER_PRECISION; // 0:50 send timeout

  GATECHECKCLOSE_TIMEOUT:TAppRunTime    = 300 * RUN_TIMER_PRECISION; // 5:00 inactive timeout to close a connection
  GATECHECKLOGOUT_TIMEOUT:TAppRunTime   = 360 * RUN_TIMER_PRECISION; // 6:00 inactive timeout for Log out
  GATECHECKDONE_TIMEOUT:TAppRunTime     = 600 * RUN_TIMER_PRECISION; // 10:00 inactive timeout for Removal

  // Use BIG Private Keys for Gateway Accounts ?
  GATEACCOUNT_BIGKEY:boolean=True;
  // Random Seed size for Gateway Accounts
  GATEACCOUNT_RANDSEED:integer=32;
  // Use BIG Keys for Public Account Manager IDs ?
  GATEID_BIGKEY:boolean=False;
  // Random Seed size for Public Account Manager IDs
  GATEID_RANDSEED:integer=64;
  // RSA Key strength for Private Gateway Accounts (96 octets = 768 bits)
  GATEACCOUNT_PRIVATE_RSAKEY_SIZE:integer=96;
  // RSA Key strength for temporary Public Gateway Accounts (64 octets = 512 bits)
  GATEACCOUNT_PUBLIC_RSAKEY_SIZE:integer=64;

var
  GATE_LOG:String='GATE';

  GATE_OK_CODE:integer=200;

  GATE_ERROR_CODE:integer=409;
  GATE_ERROR_TEXT:RtcString='Conflict';

  GATE_FATALERROR_CODE:integer=412;
  GATE_FATALERROR_TEXT:RtcString='Precondition Failed';

  // $s, $p, $l, $i, $o, $ir & $or URIs are used by the Gateway
  GATEURI_STATUS:RtcString='$s';
  GATEURI_PING:RtcString='$p';
  GATEURI_LOGIN:RtcString='$l';
  GATEURI_INPUT:RtcString='$i';
  GATEURI_OUTPUT:RtcString='$o';
  GATEURI_INPUTRESET:RtcString='$ir';
  GATEURI_OUTPUTRESET:RtcString='$or';

const
  MinLowID=TGateUID(1);
  MinHigID=TGateUID(111111);
  MaxHigID=TGateUID(999999);

  CntLowIDs=MinHigID-MinLowID;
  CntHigIDs=MaxHigID-MinHigID;

  MinUserID = MinLowID;
  MaxUserID = MaxHigID;

  errNoUID = 0;
  errBadUID = MaxUserID+1;
  errBadCRC = MaxUserID+2;

  GroupIDMask=Cardinal($FFF);
  UserIDShift=12;
  UserIDMask =Cardinal($FFFFF) shl UserIDShift;

  MinInternalUserID = MinUserID shl UserIDShift;
  MaxInternalUserID = MaxUSerID shl UserIDShift;

  MinGID=1;
  MaxGID=GroupIDMask;

  MinInternalUserGroupID = MinInternalUserID + MinGID;
  MaxInternalUserGroupID = MaxInternalUserID + MaxGID;

  // Client -> Gateway
  Cmd_SendData            = $F0;
  Cmd_AddUserToGroup      = $E1;
  Cmd_RemoveUserFromGroup = $D2;
  Cmd_RemoveGroup         = $C3;

  // Gateway -> Client
  Cmd_SendAll             = $F0;
  Cmd_SendFirst           = $E1;
  Cmd_SendMore            = $D2;
  Cmd_SendLast            = $C3;

  Cmd_Send_AllG           = $FC;
  Cmd_Send_FirstG         = $ED;
  Cmd_Send_MoreG          = $DE;
  Cmd_Send_LastG          = $CF;

  // Client <=> Gateway
  Cmd_UserIn              = $B4;
  Cmd_UserOut             = $A5;
  Cmd_UserOn              = $96;
  Cmd_UserOff             = $87;
  Cmd_FriendAdd           = $78;
  Cmd_FriendRemove        = $69;

  // Client -> Gateway
  Cmd_RemoveFriends       = $5A;
  Cmd_Subscribe           = $4B;
  Cmd_UnSubscribe         = $3C;

  // Gateway -> Client
  Cmd_UserBeFriend        = $5A;
  Cmd_UserUnFriend        = $4B;
  Cmd_UserReady           = $3C;
  Cmd_UserNotReady        = $2D;

function Int2Bytes(UID:Cardinal):RtcByteArray;
function Bytes2Int(const BAR:RtcByteArray; loc:integer=0):Cardinal;

// in: UID (Cardinal = 32-bits) + Cmd (8 bits)
// out: 6 bytes = UID (4 bytes, high to low order) + Cmd (1 byte) + CRC (1 byte)
function crcGateCmd2Bytes(Cmd:byte; UID:Cardinal):RtcByteArray;
// raises exception if CRC check fails
function crcBytes2GateCmd(var Cmd:byte; const BAR:RtcByteArray; loc:integer=0):Cardinal;

// in: UID (1 .. 999999)
// out: 4 bytes = UID (3 bytes, high to low order) + CRC (1 byte)
function crcGateID2Bytes(UID:Cardinal):RtcByteArray;
{ Returns the UserID if everything is OK, or ...
    - "errNoUID" if byte size missmatch
    - "errBadUID" if received UID out of range
    - "errBadCRC" if CRC check fails }
function crcBytes2GateID(const BAR:RtcByteArray; loc:integer=0):Cardinal;

function Word2Bytes(UID:Word):RtcByteArray;
function Bytes2Word(const BAR:RtcByteArray; loc:integer=0):Word;

function crcInt2Bytes(UID:Cardinal):RtcByteArray;
function crcBytes2Int(const BAR:RtcByteArray; loc:integer=0):Cardinal;

function OneByte2Bytes(UID:Byte):RtcByteArray;
function Bytes2OneByte(const BAR:RtcByteArray; loc:integer=0):Byte;

function GetAppRunTime:TAppRunTime;

{ Set connection timeouts based on global GATE TIMEOUT values.
  Used internally by TRtcHttpGateClient components. }
procedure SetupConnectionTimeouts(Sender:TRtcConnection);

implementation

var
  AppStartTime:TAppRunTime;

procedure SetupConnectionTimeouts(Sender:TRtcConnection);
  begin
  if Sender is TRtcClient then
    begin
    Sender.TimeoutsOfAPI.ResolveTimeout :=CLIENTCONNECT_TIMEOUT div RUN_TIMER_PRECISION;
    Sender.TimeoutsOfAPI.ConnectTimeout :=CLIENTCONNECT_TIMEOUT div RUN_TIMER_PRECISION;

    Sender.TimeoutsOfAPI.ResponseTimeout:=CLIENTCHECKRECV_TIMEOUT div RUN_TIMER_PRECISION;
    Sender.TimeoutsOfAPI.ReceiveTimeout :=CLIENTCHECKRECV_TIMEOUT div RUN_TIMER_PRECISION;

    Sender.TimeoutsOfAPI.SendTimeout:=CLIENTCHECKSEND_TIMEOUT div RUN_TIMER_PRECISION;
    end;
  end;

function GetAppRunTime:TAppRunTime;
  begin
  Result:=GetTickTime64-AppStartTime;
  end;

var
  BitCRC:array[0..$FF] of byte;

procedure CalcBitCRC;
  var
    a:byte;
  function CRC1(a:byte):byte;
    var
      i,l,p:byte;
    begin
    l:=2;p:=0;
    Result:=1;
    for i:=0 to 7 do
      begin
      if p=(a and 1) then
        Inc(Result,l)
      else
        Inc(Result);
      Inc(l);
      p:=a and 1;
      a:=a shr 1;
      end;
    end;
  function CRC2(a:byte):byte;
    var
      l:byte;
    begin
    l:=2;
    Result:=1;
    while a>0 do
      begin
      if a and 1=1 then
        Inc(Result,l)
      else
        Inc(Result);
      Inc(l);
      a:=a shr 1;
      end;
    end;
  function CRC(a:byte):byte;
    var
      c,d,e:word;
    begin
    c:=CRC1(a) xor CRC2(a);
    d:=CRC1(a)  +  CRC2(a);
    e:=CRC1(a)  *  CRC2(a);
    Result:=(c mod 51) + (d mod 51) + (e mod 51);
    Result:=Result mod 51;
    end;
  begin
  for a:=0 to $FF do
    BitCRC[a]:=1+CRC(a);
  end;

function crcGateCmd2Bytes(Cmd:byte; UID:Cardinal):RtcByteArray;
  var
    a,b,c,d,e,crc:byte;
  begin
  SetLength(Result,6);

  a:=((UID shr 24) and $FF) xor Cmd;
  b:=((UID shr 16) and $FF) xor Cmd;
  c:=((UID shr 8) and $FF) xor Cmd;
  d:=(UID and $FF) xor Cmd;
  e:=Cmd xor a xor b xor c xor d;

  crc:=BitCrc[a]+BitCrc[b]+BitCrc[c]+BitCrc[d]+BitCrc[e];
  crc:=crc xor BitCrc[a xor b xor c xor d xor e];
  crc:=crc xor BitCrc[crc] xor $FF;

  Result[0]:=a xor crc;
  Result[1]:=b xor crc;
  Result[2]:=c xor crc;
  Result[3]:=d xor crc;
  Result[4]:=e xor crc;
  Result[5]:=crc;
  end;

function crcBytes2GateCmd(var Cmd:byte; const BAR:RtcByteArray; loc:integer=0):Cardinal;
  var
    a,b,c,d,e,f,crc:byte;
  begin
  if (loc<0) or (loc+5>=length(BAR)) then
    raise ERtcOutOfBounds.Create('crcBytes2GateCmd: LOC ('+IntToStr(loc)+') out of ByteArray bounds ('+IntToStr(length(BAR))+')');
  f:=BAR[loc+5];
  a:=BAR[loc] xor f;
  b:=BAR[loc+1] xor f;
  c:=BAR[loc+2] xor f;
  d:=BAR[loc+3] xor f;
  e:=BAR[loc+4] xor f;

  crc:=BitCrc[a]+BitCrc[b]+BitCrc[c]+BitCrc[d]+BitCrc[e];
  crc:=crc xor BitCrc[a xor b xor c xor d xor e];
  crc:=crc xor BitCrc[crc] xor $FF;

  if crc<>f then
    raise ERtcOutOfBounds.Create('crcBytes2GateCmd: CRC Error at LOC ('+IntToStr(loc)+') in ByteArray ('+IntToStr(length(BAR))+')');
  e:=e xor a xor b xor c xor d;
  a:=a xor e;
  b:=b xor e;
  c:=c xor e;
  d:=d xor e;

  Result:=d or (c shl 8) or (b shl 16) or (a shl 24);
  Cmd:=e;
  end;

function crcGateID2Bytes(UID:Cardinal):RtcByteArray;
  var
    a,b,c,crc:byte;
  begin
  SetLength(Result,4);
  a:=(UID shr 16) and $FF;
  b:=(UID shr 8) and $FF;
  c:=UID and $FF;

  crc:=BitCrc[a]+BitCrc[b]+BitCrc[c];
  crc:=crc xor BitCrc[a xor b xor c];
  crc:=crc xor BitCrc[crc] xor $FF;

  Result[0]:=a xor crc;
  Result[1]:=b xor crc;
  Result[2]:=c xor crc;
  Result[3]:=crc;
  end;

function crcBytes2GateID(const BAR:RtcByteArray; loc:integer=0):Cardinal;
  var
    a,b,c,d,crc:byte;
  begin
  if (loc<0) or (loc+3>=length(BAR)) then
    Result:=errNoUID
  else
    begin
    d:=BAR[loc+3];
    a:=BAR[loc] xor d;
    b:=BAR[loc+1] xor d;
    c:=BAR[loc+2] xor d;

    crc:=BitCrc[a]+BitCrc[b]+BitCrc[c];
    crc:=crc xor BitCrc[a xor b xor c];
    crc:=crc xor BitCrc[crc] xor $FF;

    if crc<>d then
      Result:=errBadCRC
    else
      begin
      Result:=c or (b shl 8) or (a shl 16);
      if (Result<MinUserID) or (Result>MaxUserID) then
        Result:=errBadUID;
      end;
    end;
  end;

function crcInt2Bytes(UID:Cardinal):RtcByteArray;
  var
    a,b,c,crc:byte;
  begin
  if UID>$FFFFFF then
    raise ERtcOutOfBounds.Create('crcInt2Bytes: Value ('+IntToStr(UID)+') exceeds allowed range ($FFFFFF).');
  SetLength(Result,4);
  c:=UID and $FF;
  b:=(UID shr 8) and $FF;
  a:=(UID shr 16) and $FF;

  crc:=BitCrc[a]+BitCrc[b]+BitCrc[c];
  crc:=crc xor BitCrc[a xor b xor c];
  crc:=crc xor BitCrc[crc] xor $FF;

  Result[0]:=a xor crc;
  Result[1]:=b xor crc;
  Result[2]:=c xor crc;
  Result[3]:=crc;
  end;

function crcBytes2Int(const BAR:RtcByteArray; loc:integer=0):Cardinal;
  var
    a,b,c,d,crc:byte;
  begin
  if (loc<0) or (loc+3>=length(BAR)) then
    raise ERtcOutOfBounds.Create('crcBytes2Int: LOC ('+IntToStr(loc)+') out of ByteArray bounds ('+IntToStr(length(BAR))+')');
  d:=BAR[loc+3];
  c:=BAR[loc] xor d;
  b:=BAR[loc+1] xor d;
  a:=BAR[loc+2] xor d;

  crc:=BitCrc[a]+BitCrc[b]+BitCrc[c];
  crc:=crc xor BitCrc[a xor b xor c];
  crc:=crc xor BitCrc[crc] xor $FF;

  if d<>crc then
    raise ERtcOutOfBounds.Create('crcBytes2Int: CRC Error at LOC ('+IntToStr(loc)+') in ByteArray ('+IntToStr(length(BAR))+')');

  Result:=a or (b shl 8) or (c shl 16);
  end;

function Int2Bytes(UID:Cardinal):RtcByteArray;
  begin
  SetLength(Result,4);
  Result[3]:=UID and $FF;
  Result[2]:=(UID shr 8) and $FF;
  Result[1]:=(UID shr 16) and $FF;
  Result[0]:=(UID shr 24) and $FF;
  end;

function Bytes2Int(const BAR:RtcByteArray; loc:integer=0):Cardinal;
  begin
  if (loc<0) or (loc+3>=length(BAR)) then
    raise ERtcOutOfBounds.Create('Bytes2Int: LOC ('+IntToStr(loc)+') out of ByteArray bounds ('+IntToStr(length(BAR))+')');
  Result:=BAR[loc+3] or
         (BAR[loc+2] shl 8) or
         (BAR[loc+1] shl 16) or
         (BAR[loc+0] shl 24);
  end;

function Word2Bytes(UID:Word):RtcByteArray;
  begin
  SetLength(Result,2);
  Result[1]:=UID and $FF;
  Result[0]:=(UID shr 8) and $FF;
  end;

function Bytes2Word(const BAR:RtcByteArray; loc:integer=0):Word;
  begin
  if (loc<0) or (loc+1>=length(BAR)) then
    raise ERtcOutOfBounds.Create('Bytes2Word: LOC ('+IntToStr(loc)+') out of ByteArray bounds ('+IntToStr(length(BAR))+')');
  Result:=BAR[loc+1] or
         (BAR[loc+0] shl 8);
  end;

function OneByte2Bytes(UID:Byte):RtcByteArray;
  begin
  SetLength(Result,1);
  Result[0]:=UID;
  end;

function Bytes2OneByte(const BAR:RtcByteArray; loc:integer=0):Byte;
  begin
  if (loc<0) or (loc>=length(BAR)) then
    raise ERtcOutOfBounds.Create('Bytes2Byte: LOC ('+IntToStr(loc)+') out of ByteArray bounds ('+IntToStr(length(BAR))+')');
  Result:=BAR[loc];
  end;

initialization
{$IFDEF RTC_DEBUG} StartLog; {$ENDIF}
AppStartTime:=GetTickTime64;
CalcBitCRC;
finalization
{$IFDEF RTC_DEBUG} Log('rtcGateConst Finalizing ...','DEBUG');{$ENDIF}
CloseThreadPool;
{$IFDEF RTC_DEBUG} Log('rtcGateConst Finalized.','DEBUG');{$ENDIF}
end.