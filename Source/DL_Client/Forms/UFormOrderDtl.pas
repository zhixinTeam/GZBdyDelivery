{*******************************************************************************
����: fendou116688@163.com 2016/10/31
����: �ɹ���ϸ����
*******************************************************************************}
unit UFormOrderDtl;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UFormBase, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxLayoutControl, cxCheckBox,
  cxLabel, StdCtrls, cxMaskEdit, cxDropDownEdit, cxMCListBox, cxMemo,
  cxTextEdit, cxButtonEdit;

type
  TfFormOrderDtl = class(TBaseForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    EditMemo: TcxMemo;
    dxLayoutControl1Item4: TdxLayoutItem;
    BtnOK: TButton;
    dxLayoutControl1Item10: TdxLayoutItem;
    BtnExit: TButton;
    dxLayoutControl1Item11: TdxLayoutItem;
    dxLayoutControl1Group5: TdxLayoutGroup;
    EditPValue: TcxTextEdit;
    dxLayoutControl1Item1: TdxLayoutItem;
    EditMValue: TcxTextEdit;
    dxLayoutControl1Item2: TdxLayoutItem;
    dxLayoutControl1Group3: TdxLayoutGroup;
    EditProID: TcxButtonEdit;
    dxLayoutControl1Item3: TdxLayoutItem;
    dxLayoutControl1Group2: TdxLayoutGroup;
    EditProName: TcxTextEdit;
    dxLayoutControl1Item5: TdxLayoutItem;
    dxLayoutControl1Group4: TdxLayoutGroup;
    EditStock: TcxButtonEdit;
    dxLayoutControl1Item6: TdxLayoutItem;
    EditStockName: TcxTextEdit;
    dxLayoutControl1Item7: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayoutControl1Item9: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayoutControl1Item12: TdxLayoutItem;
    EditCheck: TcxCheckBox;
    dxLayoutControl1Item8: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditStockKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FOrderID,FDetailID: string;
    //���ݱ�ʶ
    procedure InitFormData(const nID: string);
    //��������
    function SetData(Sender: TObject; const nData: string): Boolean;
    //�������
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, UFormCtrl, UAdjustForm, USysBusiness,
  USysGrid, USysDB, USysConst;

var
  gForm: TfFormOrderDtl = nil;
  //ȫ��ʹ��

class function TfFormOrderDtl.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  case nP.FCommand of
   cCmd_EditData:
    with TfFormOrderDtl.Create(Application) do
    begin
      FDetailID := nP.FParamA;
      FOrderID  := nP.FParamB;
      Caption := '�ɹ������� - �޸�';

      InitFormData(FDetailID);
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_ViewData:
    begin
      if not Assigned(gForm) then
      begin
        gForm := TfFormOrderDtl.Create(Application);
        with gForm do
        begin
          Caption := '�ɹ������� - �鿴';
          FormStyle := fsStayOnTop;

          BtnOK.Visible := False;
        end;
      end;

      with gForm  do
      begin
        FDetailID := nP.FParamA;
        FOrderID  := nP.FParamB;
        InitFormData(FDetailID);
        if not Showing then Show;
      end;
    end;
   cCmd_FormClose:
    begin
      if Assigned(gForm) then FreeAndNil(gForm);
    end;
  end; 
end;

class function TfFormOrderDtl.FormID: integer;
begin
  Result := cFI_FormOrderDtl;
end;

//------------------------------------------------------------------------------
procedure TfFormOrderDtl.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
  finally
    nIni.Free;
  end;

  ResetHintAllForm(Self, 'O', sTable_Order);
  ResetHintAllForm(Self, 'D', sTable_OrderDtl);
  //���ñ�����
end;

procedure TfFormOrderDtl.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
  finally
    nIni.Free;
  end;

  gForm := nil;
  Action := caFree;
  ReleaseCtrlData(Self);
end;

procedure TfFormOrderDtl.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfFormOrderDtl.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key = VK_ESCAPE then
  begin
    Key := 0; Close;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ��������
function TfFormOrderDtl.SetData(Sender: TObject; const nData: string): Boolean;
begin
  Result := False;
end;

//Date: 2009-6-2
//Parm: ��Ӧ�̱��
//Desc: ����nID��Ӧ�̵���Ϣ������
procedure TfFormOrderDtl.InitFormData(const nID: string);
var nStr: string;
begin
  if nID <> '' then
  begin
    nStr := 'Select * From %s Where D_ID=''%s''';
    nStr := Format(nStr, [sTable_OrderDtl, nID]);
    LoadDataToForm(FDM.QuerySQL(nStr), Self, sTable_OrderDtl);

    nStr := 'Select * From %s Where O_ID=''%s''';
    nStr := Format(nStr, [sTable_Order, FOrderID]);
    LoadDataToForm(FDM.QueryTemp(nStr), Self, sTable_Order);
  end;
end;

//Desc: ��������
procedure TfFormOrderDtl.BtnOKClick(Sender: TObject);
var nSQL: string;
begin
  FDM.ADOConn.BeginTrans;
  try
    nSQL := MakeSQLByForm(Self, sTable_OrderDtl, SF('D_ID', FDetailID), False);
    FDM.ExecuteSQL(nSQL);

    nSQL := MakeSQLByStr([SF('P_CusID', EditProID.Text),
            SF('P_CusName', EditProName.Text),
            SF('P_MID', EditStock.Text),
            SF('P_MName', EditStockName.Text),
            SF('P_Truck', EditTruck.Text),
            SF('P_PValue', StrToFloatDef(EditPValue.Text, 0), sfVal),
            SF('P_MValue', StrToFloatDef(EditMValue.Text, 0), sfVal)
            ], sTable_PoundLog, SF('P_Order', FDetailID), False);
    FDM.ExecuteSQL(nSQL);
    //���°���

    nSQL := MakeSQLByForm(Self, sTable_Order, SF('O_ID', FOrderID), False);
    FDM.ExecuteSQL(nSQL);

    FDM.ADOConn.CommitTrans;
    ModalResult := mrOK;
    ShowMsg('�����ѱ���', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('���ݱ���ʧ��', 'δ֪ԭ��');
  end;
end;

procedure TfFormOrderDtl.EditStockKeyPress(Sender: TObject; var Key: Char);
var nP: TFormCommandParam;
begin
  inherited;
  if Key = Char(VK_RETURN) then
  begin
    Key := #0;

    if Sender = EditStock then
    begin
      CreateBaseFormItem(cFI_FormGetMeterail, '', @nP);
      if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOk) then Exit;

      EditStock.Text := nP.FParamB;
      EditStockName.Text := nP.FParamC;
    end

    else if Sender = EditProID then
    begin
      CreateBaseFormItem(cFI_FormGetProvider, '', @nP);
      if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOk) then Exit;

      EditProID.Text := nP.FParamB;
      EditProName.Text := nP.FParamC;
    end

    else if Sender = EditTruck then
    begin
      CreateBaseFormItem(cFI_FormGetTruck, '', @nP);
      if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOk) then Exit;

      EditTruck.Text := nP.FParamB;
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormOrderDtl, TfFormOrderDtl.FormID);
end.